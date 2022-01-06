import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/enums/slide_state.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_list/transaction_list_constants.dart';

class CategoryIconWidget extends StatelessWidget {
  final String iconPath;
  final ExpenseEntity selectExpense;
  final ExpenseEntity expense;
  final SlideState slideState;

  const CategoryIconWidget({
    Key? key,
    required this.iconPath,
    required this.expense,
    required this.selectExpense,
    required this.slideState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: expense == selectExpense && slideState == SlideState.openSlide
          ? 0
          : TransactionListConstants.iconSpacing,
      height: LayoutConstants.dimen_48.w,
      child: Padding(
        padding: const EdgeInsets.only(right: LayoutConstants.dimen_15),
        child: SizedBox(
            child: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: AssetImage(
            iconPath,
          ),
        )),
      ),
    );
  }
}
