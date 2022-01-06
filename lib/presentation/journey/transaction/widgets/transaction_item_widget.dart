import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/category_icon_map.dart';
import 'package:spendy_re_work/common/constants/category_name_map.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/enums/slide_state.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_list/transaction_list_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_list/widgets/category_icon_widget.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_list/widgets/transaction_item_content_widget.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_list/widgets/transaction_item_options_widget.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';

class TransactionItemWidget extends StatelessWidget {
  final ExpenseEntity? expense;
  final ExpenseEntity? selectExpense;
  final Function() onTap;
  final Function(ExpenseEntity) openSlide;
  final Function() closeSlide;
  final bool? showLineBottom;
  final Function() editOnPressed;
  final Function() deleteOnPressed;
  final int? spendTime;
  final SlideState? slideState;
  final String? strSpendTime;
  final bool? showHours;

  TransactionItemWidget({
    Key? key,
    this.expense,
    this.selectExpense,
    required this.onTap,
    required this.openSlide,
    required this.closeSlide,
    this.showLineBottom,
    this.spendTime,
    this.slideState,
    this.strSpendTime = '',
    this.showHours,
    required this.editOnPressed,
    required this.deleteOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (details.delta.dx <= 0) {
          openSlide(expense!);
        }
        if (details.delta.dx >= 0) {
          closeSlide();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: LayoutConstants.dimen_26),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: LayoutConstants.dimen_48.w,
              padding: EdgeInsets.only(right: LayoutConstants.dimen_26.w),
              child: Row(
                children: [
                  CategoryIconWidget(
                    iconPath: categoryIconMap[expense!.category]!,
                    expense: expense!,
                    selectExpense: selectExpense!,
                    slideState: slideState!,
                  ),
                  Expanded(
                      child: TransactionItemContentWidget(
                    showTime: showHours,
                    categoryName:
                        CategoryCommon.categoryNameMap[expense!.category],
                    payerNumbers: 0,
                    note: expense!.note,
                    // isPersonal: expense!.group == 'PERSONAL',
                    strSpend: '-${expense!.amount.toString()}',
                    spendTime: spendTime,
                    strSpendTime: strSpendTime,
                  )),
                  TransactionItemOptionsWidget(
                    expense: expense,
                    selectExpense: selectExpense,
                    editOnPressed: editOnPressed,
                    deleteOnPressed: deleteOnPressed,
                    slideState: slideState,
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: TransactionListConstants.iconSpacing,
                ),
                Expanded(
                    child: Visibility(
                  visible: showLineBottom ?? false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical:
                            TransactionListConstants.dividerPaddingVertical),
                    child: const Divider(
                      color: AppColor.lineColor,
                      thickness: 1,
                      height: 0,
                    ),
                  ),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
