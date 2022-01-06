import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
import 'package:spendy_re_work/domain/entities/transaction_entity.dart';

import 'category_entity.dart';
import 'expense/expense_detail_entity.dart';

class ReportExpenseEntity extends ExpenseDetailEntity {
  ParticipantInTransactionEntity? forWho;
  ParticipantInTransactionEntity? whoPaid;

  ReportExpenseEntity(
      {this.forWho,
      this.whoPaid,
      CategoryEntity? categoryEntity,
      TransactionEntity? transactionEntity})
      : super(
            categoryEntity: categoryEntity,
            transactionEntity: transactionEntity);
}
