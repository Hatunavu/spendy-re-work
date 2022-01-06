import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/image_data_state.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/photo_entity.dart';
import 'package:spendy_re_work/domain/usecases/transaction_use_case.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_detail_bloc/transaction_detail_event.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_detail_bloc/transaction_detail_state.dart';

class TransactionDetailBloc
    extends Bloc<TransactionDetailEvent, TransactionDetailState> {
  final TransactionUseCase transactionUseCase;
  final AuthenticationBloc authenticationBloc;

  String? uid;

  TransactionDetailBloc(
      {required this.transactionUseCase, required this.authenticationBloc})
      : super(TransactionDetailInitialState(
          expense: ExpenseEntity.normal(),
          imageDataState: ImageDataState.none,
        )) {
    uid = authenticationBloc.userEntity.uid;
  }

  @override
  Stream<TransactionDetailState> mapEventToState(
      TransactionDetailEvent event) async* {
    if (event is TransactionDetailInitialEvent) {
      yield* _mapTransactionDetailInitialEventToState(event);
    }
  }

  Stream<TransactionDetailState> _mapTransactionDetailInitialEventToState(
      TransactionDetailInitialEvent event) async* {
    final currentState = state;
    if (currentState is TransactionDetailInitialState) {
      yield currentState.copyWith(
        imageDataState: ImageDataState.loading,
        expense: event.expense,
      );

      final List<PhotoEntity> photoList = await transactionUseCase.getPhotos(
          uid ?? '', event.groupId, event.expense.id ?? '');
      final expense = event.expense.copyWith(photos: photoList);
      yield currentState.copyWith(
        imageDataState: ImageDataState.success,
        expense: expense,
      );
    }
  }
}
