import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/enums/slide_state.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/widgets/transaction_detail_dialog/transaction_detail_dialog_constants.dart';

class TransactionItemOptionsWidget extends StatelessWidget {
  final ExpenseEntity? selectExpense;
  final ExpenseEntity? expense;
  final Function() editOnPressed;
  final Function() deleteOnPressed;
  final SlideState? slideState;

  const TransactionItemOptionsWidget({
    Key? key,
    this.selectExpense,
    this.expense,
    this.slideState,
    required this.editOnPressed,
    required this.deleteOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: selectExpense != null &&
              expense!.updateAt == selectExpense!.updateAt &&
              slideState == SlideState.openSlide
          ? 70.w
          : 0,
      height: 30.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Spacer(),
          Expanded(
              child: _optionItemWidget(
            context,
            iconPath: IconConstants.editIcon,
            onTap: editOnPressed,
          )),
          Expanded(
            child: _optionItemWidget(
              context,
              iconPath: IconConstants.deleteIcon,
              onTap: deleteOnPressed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionItemWidget(context,
      {String? iconPath, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.centerRight,
        child: Image.asset(
          iconPath!,
          height: TransactionDetailDialogConstants.iconSize,
          width: TransactionDetailDialogConstants.iconSize,
        ),
      ),
    );
  }
}
