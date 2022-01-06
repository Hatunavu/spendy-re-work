import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/enums/slide_state.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/usecases/expense_usecase.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_blocs/transaction_event.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_ux_bloc/transaction_ux_state.dart';

class TransactionUxBloc extends Bloc<TransactionEvent, TransactionUxState> {
  final ExpenseUseCase expenseUseCase;

  TransactionUxBloc({required this.expenseUseCase})
      : super(TransactionInitialState());

  @override
  Stream<TransactionUxState> mapEventToState(TransactionEvent event) async* {
    switch (event.runtimeType) {
      case OpenSlideEvent:
        yield* _mapOpenSlideEventToState(event as OpenSlideEvent);
        break;
      case CloseSlideEvent:
        yield* _mapCloseSlideEventToState();
        break;
    }
  }

  Stream<TransactionUxState> _mapOpenSlideEventToState(
      OpenSlideEvent event) async* {
    final currentState = state;
    if (currentState is TransactionInitialState) {
      yield currentState.update(
          slideState: SlideState.openSlide, selectExpense: event.selectExpense);
    }
  }

  Stream<TransactionUxState> _mapCloseSlideEventToState() async* {
    final currentState = state;

    if (currentState is TransactionInitialState) {
      yield currentState.update(
          slideState: SlideState.closeSlide,
          selectExpense: ExpenseEntity.normal());
    }
  }
}
