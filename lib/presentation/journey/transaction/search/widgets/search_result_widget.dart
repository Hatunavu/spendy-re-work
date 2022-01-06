import 'package:flutter/material.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/widgets/transaction_item_widget.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/loader/load_more/load_more_widget.dart';
import 'package:spendy_re_work/presentation/widgets/state_widget/empty_data_widget.dart';

class SearchResultWidget extends StatefulWidget {
  final List<ExpenseEntity> expenseDetailList;
  final ExpenseEntity selectExpense;
  final Function(ExpenseEntity) onTapTransactionItem;
  final Function(ExpenseEntity) openSlideTransactionItem;
  final Function() closeSlide;
  final Function() deleteOnPressed;
  final Function() editOnPressed;
  final Function() loadMoreFunc;
  final bool isLoadMore;

  SearchResultWidget({
    Key? key,
    required this.expenseDetailList,
    required this.selectExpense,
    required this.onTapTransactionItem,
    required this.openSlideTransactionItem,
    required this.closeSlide,
    required this.editOnPressed,
    required this.deleteOnPressed,
    required this.loadMoreFunc,
    this.isLoadMore = false,
  }) : super(key: key);

  @override
  _SearchResultWidgetState createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends State<SearchResultWidget> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      widget.closeSlide();
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        widget.loadMoreFunc();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.expenseDetailList.isEmpty) {
      return const EmptyDataWidget();
    }
    return CustomScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      controller: scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return TransactionItemWidget(
                // expenseDetail: widget.expenseDetailList[index],
                // selectExpense: widget.selectExpense,
                onTap: () => widget
                    .onTapTransactionItem(widget.expenseDetailList[index]),
                // openSlide: widget.openSlideTransactionItem,
                closeSlide: widget.closeSlide,
                showLineBottom: index < widget.expenseDetailList.length - 1,
                editOnPressed: widget.editOnPressed,
                deleteOnPressed: widget.deleteOnPressed,
                openSlide: (expense) {},
              );
            },
            childCount: widget.expenseDetailList.length,
          ),
        ),
        SliverToBoxAdapter(
          child: widget.isLoadMore
              ? FlareLoadMoreWidget()
              : const SizedBox(height: 20),
        )
      ],
    );
  }
}
