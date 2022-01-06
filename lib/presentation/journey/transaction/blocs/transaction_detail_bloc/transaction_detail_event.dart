import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';

abstract class TransactionDetailEvent extends Equatable {}

class TransactionDetailInitialEvent extends TransactionDetailEvent {
  final ExpenseEntity expense;
  final String groupId;

  TransactionDetailInitialEvent(this.expense, this.groupId);
  @override
  List<Object> get props => [expense, groupId];
}
