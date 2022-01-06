import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/image_data_state.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/photo_entity.dart';
import 'package:spendy_re_work/domain/usecases/expense_usecase.dart';
import 'package:spendy_re_work/presentation/journey/transaction/show_image/show_expense_image_bloc/show_expense_image_event.dart';
import 'package:spendy_re_work/presentation/journey/transaction/show_image/show_expense_image_bloc/show_expense_image_state.dart';

class ShowExpenseImageBloc
    extends Bloc<ShowExpenseImageInitialEvent, ShowExpenseImageState> {
  final ExpenseUseCase expenseUseCase;

  ShowExpenseImageBloc({required this.expenseUseCase})
      : super(ShowExpenseImageInitialState(
          expense: ExpenseEntity.normal(),
          imageDataState: ImageDataState.none,
        ));

  @override
  Stream<ShowExpenseImageState> mapEventToState(
      ShowExpenseImageInitialEvent event) async* {
    if (event is ShowExpenseImageInitialEvent) {
      yield* _mapShowExpenseImageInitialEventTpState(event);
    }
  }

  Stream<ShowExpenseImageState> _mapShowExpenseImageInitialEventTpState(
      ShowExpenseImageInitialEvent event) async* {
    final currentState = state;
    if (currentState is ShowExpenseImageInitialState) {
      yield currentState.copyWith(
          expense: event.expense, imageDataState: ImageDataState.loading);
      final List<PhotoEntity> photoList =
          await expenseUseCase.getImageUriList(event.expense);
      event.expense.copyWith(photos: photoList);
      yield currentState.copyWith(
          expense: event.expense, imageDataState: ImageDataState.success);
    }
  }
}
