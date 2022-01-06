import 'package:spendy_re_work/common/constants/image_data_state.dart';
import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';

abstract class ShowExpenseImageState extends Equatable {}

class ShowExpenseImageInitialState extends ShowExpenseImageState {
  final ExpenseEntity expense;
  final ImageDataState imageDataState;

  ShowExpenseImageInitialState({
    required this.expense,
    required this.imageDataState,
  });

  ShowExpenseImageInitialState copyWith(
          {ExpenseEntity? expense, ImageDataState? imageDataState}) =>
      ShowExpenseImageInitialState(
          expense: expense ?? this.expense,
          imageDataState: imageDataState ?? this.imageDataState);

  @override
  List<Object> get props => [expense, imageDataState];
}
