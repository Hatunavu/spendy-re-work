import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_recent/widgets/transaction_item_widget.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';

class TransactionOfDateListWidget extends StatelessWidget {
  final List<ExpenseEntity> expenseList;
  final Function(ExpenseEntity) onEdit;
  final Function(ExpenseEntity) onDelete;

  const TransactionOfDateListWidget(
      {Key? key,
      required this.expenseList,
      required this.onDelete,
      required this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: expenseList.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final _transaction = expenseList[index];
        return TransactionItemWidget(
            transaction: _transaction,
            timeFormat: TransactionTimeFormat.time,
            editTransaction: () => onEdit(_transaction),
            deleteTransaction: () => onDelete(_transaction));
      },
      separatorBuilder: (context, int index) {
        return Divider(
          color: AppColor.lineColor,
          height: 0,
          thickness: 1,
          indent: 89.w,
          endIndent: 15.w,
        );
      },
    );
  }
}
