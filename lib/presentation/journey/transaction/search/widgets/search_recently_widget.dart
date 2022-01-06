import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/enums/slide_state.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/search/search_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/widgets/transaction_item_widget.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/state_widget/empty_data_widget.dart';

class SearchRecentlyWidget extends StatelessWidget {
  final List<ExpenseEntity> expenseList;
  final ExpenseEntity selectExpense;
  final SlideState slideState;
  final Function(ExpenseEntity, int) onTapTransactionItem;
  final Function(ExpenseEntity) openSlideTransactionItem;
  final Function() closeSlide;
  final Function() deleteOnPressed;
  final Function() editOnPressed;

  const SearchRecentlyWidget({
    Key? key,
    required this.expenseList,
    required this.selectExpense,
    required this.onTapTransactionItem,
    required this.openSlideTransactionItem,
    required this.slideState,
    required this.closeSlide,
    required this.deleteOnPressed,
    required this.editOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: LayoutConstants.paddingHorizontal,
              bottom: SearchConstants.spacingTitleAndContent),
          child: Text(
            SearchConstants.recentlyTitle,
            style: ThemeText.getDefaultTextTheme().captionSemiBold,
          ),
        ),
        Expanded(child: _contentWidget()),
      ],
    );
  }

  Widget _contentWidget() {
    if (expenseList.isEmpty) {
      return const EmptyDataWidget();
    } else {
      return ListView.builder(
        itemCount: expenseList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              TransactionItemWidget(
                slideState: slideState,
                expense: expenseList[index],
                selectExpense: selectExpense,
                onTap: () => onTapTransactionItem(expenseList[index], index),
                openSlide: openSlideTransactionItem,
                closeSlide: closeSlide,
                showLineBottom: index < expenseList.length - 1,
                deleteOnPressed: deleteOnPressed,
                editOnPressed: editOnPressed,
              ),
            ],
          );
        },
      );
    }
  }
}
