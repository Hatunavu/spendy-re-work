import 'package:spendy_re_work/common/constants/image_data_state.dart';
import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';

abstract class TransactionDetailState extends Equatable {}

class TransactionDetailInitialState extends TransactionDetailState {
  final ExpenseEntity? expense;
  final ImageDataState? imageDataState;

  TransactionDetailInitialState({
    this.expense,
    this.imageDataState,
  });

  TransactionDetailInitialState copyWith(
          {ExpenseEntity? expense, ImageDataState? imageDataState}) =>
      TransactionDetailInitialState(
        expense: expense ?? this.expense,
        imageDataState: imageDataState ?? this.imageDataState,
      );

  @override
  List<Object?> get props => [expense, imageDataState];
}
