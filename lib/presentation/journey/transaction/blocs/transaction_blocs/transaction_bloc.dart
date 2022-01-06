import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/image_data_state.dart';
import 'package:spendy_re_work/common/enums/slide_state.dart';
import 'package:spendy_re_work/common/enums/data_state.dart';
import 'package:spendy_re_work/common/utils/internet_util.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/photo_entity.dart';
import 'package:spendy_re_work/domain/entities/user/user_entity.dart';
import 'package:spendy_re_work/domain/usecases/expense_usecase.dart';
import 'package:spendy_re_work/domain/usecases/group_usecase.dart';
import 'package:spendy_re_work/domain/usecases/noti_usecase.dart';
import 'package:spendy_re_work/domain/usecases/transaction_use_case.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/bloc/group_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/bloc/group_event.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_blocs/transaction_event.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_blocs/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionUseCase transactionUseCase;
  final ExpenseUseCase expenseUseCase;
  final AuthenticationBloc authenticationBloc;
  final NotificationUseCase notificationUseCase;
  final GroupUseCase groupUseCase;
  final GroupBloc groupBloc;
  List<ExpenseEntity>? _expenseList = [];

  TransactionBloc(
      {required this.expenseUseCase,
      required this.transactionUseCase,
      required this.authenticationBloc,
      required this.notificationUseCase,
      required this.groupUseCase,
      required this.groupBloc})
      : super(
          TransactionInitialState(
            dataState: DataState.none,
            slideState: SlideState.none,
            selectExpense: ExpenseEntity.normal(),
            expenseOfDayMap: const {},
            expenseRecentOfDayMap: const {},
            expenseList: const [],
          ),
        );

  void _listenExpensesRealTime(TransactionInitialEvent event) {
    final UserEntity user = authenticationBloc.userEntity;
    _resetBlocData();
    transactionUseCase
        .listenTransactionsRealTime(uid: user.uid!, groupId: event.group.id!)
        .listen((transactions) {
      add(ListenToExpensesRealTimeEvent(expenseList: transactions));
    });
  }

  void _resetBlocData() {
    _expenseList = [];
  }

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    switch (event.runtimeType) {
      case TransactionInitialEvent:
        {
          _listenExpensesRealTime(event as TransactionInitialEvent);
        }
        break;
      case ListenToExpensesRealTimeEvent:
        yield* _mapListenToExpensesRealTimeEventToState(
            event as ListenToExpensesRealTimeEvent);
        break;
      case OpenSlideEvent:
        yield* _mapOpenSlideEventToState(event as OpenSlideEvent);
        break;
      case CloseSlideEvent:
        yield* _mapCloseSlideEventToState();
        break;
      case DeleteExpenseEvent:
        yield* _mapDeleteExpenseEventToState(event as DeleteExpenseEvent);
        break;
      case UpdateExpenseEvent:
        yield* _mapUpdateExpenseEventToState(event as UpdateExpenseEvent);
        break;
      case ShowTransactionDetailEvent:
        yield* _mapShowTransactionDetailEventToState(
            event as ShowTransactionDetailEvent);
        break;
      case LoadMoreEvent:
        {
          final currentState = state;
          if (currentState is TransactionInitialState) {
            yield currentState.update(
              dataState: DataState.loadingMore,
            );
          }
          final user = authenticationBloc.userEntity;
          transactionUseCase.requestMoreTransactions(
            uid: user.uid!,
            groupId: (event as LoadMoreEvent).group.id!,
          );
        }
        break;
      case ClearTransactionEvent:
        yield* _mapClearTransactionEventToState(event as ClearTransactionEvent);
        break;
    }
  }

  Stream<TransactionState> _mapClearTransactionEventToState(
      ClearTransactionEvent event) async* {
    _resetBlocData();
    transactionUseCase.clearTransactionData();
    yield TransactionInitialState(
        dataState: DataState.none,
        slideState: SlideState.none,
        selectExpense: ExpenseEntity.normal(),
        expenseOfDayMap: const {},
        expenseRecentOfDayMap: const {},
        expenseList: const []);
    authenticationBloc.add(LoggedOut());
  }

  Stream<TransactionState> _mapListenToExpensesRealTimeEventToState(
      ListenToExpensesRealTimeEvent event) async* {
    final currentState = state;
    if (currentState is TransactionInitialState) {
      if (currentState.dataState != DataState.loadingMore) {
        yield currentState.update(
          dataState: DataState.loading,
        );
      }
      _expenseList = [];
      _expenseList!.addAll(event.expenseList);
      final Map<int, List<ExpenseEntity>> expenseOfDayMap =
          await transactionUseCase.getExpenseByDayMapWithAds(_expenseList!);
      yield currentState.update(
        expenseOfDayMap: expenseOfDayMap,
        expenseList: _expenseList,
        dataState: DataState.success,
        slideState: SlideState.none,
        imageDataState: ImageDataState.none,
      );
    }
  }

  Stream<TransactionState> _mapOpenSlideEventToState(
      OpenSlideEvent event) async* {
    final currentState = state;
    if (currentState is TransactionInitialState) {
      yield currentState.update(
          slideState: SlideState.openSlide, selectExpense: event.selectExpense);
    }
  }

  Stream<TransactionState> _mapCloseSlideEventToState() async* {
    final currentState = state;

    if (currentState is TransactionInitialState) {
      yield currentState.update(
          slideState: SlideState.closeSlide,
          selectExpense: ExpenseEntity.normal());
    }
  }

  Stream<TransactionState> _mapDeleteExpenseEventToState(
      DeleteExpenseEvent event) async* {
    final connectivityResult = await InternetUtil.checkInternetConnection();
    final currentState = state;
    if (currentState is TransactionInitialState) {
      yield currentState.update(dataState: DataState.none);
    }
    final UserEntity user = authenticationBloc.userEntity;
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      await transactionUseCase.deleteTransactionById(
          uid: user.uid!,
          groupId: event.groupId,
          transactionId: event.expense.id!);
      // await expenseUseCase.deleteExpense(user.uid!, event.expense);
      await groupUseCase.updateTotalAmount(
          user.uid!, event.groupId, -event.expense.amount);
      groupBloc.add(GroupRefreshEvent());
    } else {
      await expenseUseCase.deleteExpenseOffline(
          uid: user.uid, expense: event.expense);
    }
  }

  Stream<TransactionState> _mapUpdateExpenseEventToState(
      UpdateExpenseEvent event) async* {}

  Stream<TransactionState> _mapShowTransactionDetailEventToState(
      ShowTransactionDetailEvent event) async* {
    final currentState = state;
    if (currentState is TransactionInitialState) {
      yield currentState.update(
        imageDataState: ImageDataState.loading,
        slideState: SlideState.closeSlide,
        selectExpense: event.selectExpense,
      );

      final List<PhotoEntity> photoList =
          await expenseUseCase.getImageUriRecentList(event.selectExpense);
      event.selectExpense.copyWith(photos: photoList);
      _expenseList![event.selectIndex!] = event.selectExpense;
      yield currentState.update(
        imageDataState: ImageDataState.success,
        expenseList: _expenseList,
        selectExpense: event.selectExpense,
      );
    }
  }
}
