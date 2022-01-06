import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';

abstract class ShowExpenseImageEvent extends Equatable {}

class ShowExpenseImageInitialEvent extends ShowExpenseImageEvent {
  final ExpenseEntity expense;

  ShowExpenseImageInitialEvent({required this.expense});

  @override
  List<Object> get props => [expense];
}
