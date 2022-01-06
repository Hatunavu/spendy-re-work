import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_blocs/transaction_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_blocs/transaction_event.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_blocs/transaction_state.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_recent/widgets/transaction_item_widget.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/alert_flare_widgets/error_flare_widget.dart';
import 'package:spendy_re_work/presentation/widgets/skeleton_widget/expense_skeleton_widget.dart';
import 'package:spendy_re_work/presentation/widgets/state_widget/empty_data_widget.dart';

import '../transaction_recent_constants.dart';

enum GroupTransactionPageState { loading, error, loaded }

class GroupTransactionPage extends StatefulWidget {
  final GroupEntity? group;
  late final GroupTransactionPageState groupState;
  final Function(ScrollController scrollController)? onScrolled;

  GroupTransactionPage({
    Key? key,
    required this.group,
    required this.onScrolled,
  }) : super(key: key) {
    groupState = GroupTransactionPageState.loaded;
  }

  GroupTransactionPage.error({
    Key? key,
    this.group,
    this.onScrolled,
  }) : super(key: key) {
    groupState = GroupTransactionPageState.error;
  }

  GroupTransactionPage.loading({
    Key? key,
    this.group,
    this.onScrolled,
  }) : super(key: key) {
    groupState = GroupTransactionPageState.loading;
  }

  @override
  _GroupTransactionPageState createState() => _GroupTransactionPageState();
}

class _GroupTransactionPageState extends State<GroupTransactionPage>
    with AutomaticKeepAliveClientMixin {
  TransactionBloc? transactionBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    if (widget.groupState == GroupTransactionPageState.loaded &&
        widget.group != null) {
      transactionBloc = BlocProvider.of<TransactionBloc>(context)
        ..add(
          TransactionInitialEvent(widget.group!),
        );
    }
    _scrollController.addListener(() {
      widget.onScrolled?.call(_scrollController);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.groupState == GroupTransactionPageState.loading) {
      return ExpenseSkeletonWidget();
    }
    if (widget.groupState == GroupTransactionPageState.error) {
      return FailedFlareWidget(
        marginBottom: true,
        callback: () {},
      );
    }
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: LayoutConstants.paddingHorizontal),
            Expanded(
              child: Text(
                TransactionRecentConstants.transactionsTitle,
                style: ThemeText.getDefaultTextTheme().captionSemiBold.copyWith(
                    fontSize:
                        TransactionRecentConstants.fxRecentTransactionHeader),
              ),
            ),
            GestureDetector(
              onTap: _viewAll,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: LayoutConstants.paddingHorizontal,
                  vertical: 10.h,
                ),
                child: Text(
                  TransactionRecentConstants.viewAllTitle,
                  style: ThemeText.getDefaultTextTheme()
                      .caption
                      ?.copyWith(fontSize: 15.sp, color: AppColor.primaryColor),
                ),
              ),
            )
          ],
        ),
        Expanded(
          child: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (_, state) {
              if (state is TransactionLoadingState) {
                return ExpenseSkeletonWidget();
              }
              final _transactions = state.expenseList;
              if (_transactions == null || _transactions.isEmpty) {
                return const EmptyDataWidget();
              }
              return ListView.separated(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemBuilder: (_, index) {
                  final _transaction = _transactions[index];
                  return TransactionItemWidget(
                    transaction: _transaction,
                    group: widget.group,
                    editTransaction: () => _editTransaction(_transaction),
                    deleteTransaction: () => _onDelete(_transaction),
                  );
                },
                itemCount: _transactions.length,
                separatorBuilder: (_, __) => Divider(
                  color: AppColor.lineColor,
                  height: 0,
                  thickness: 1,
                  indent: 89.w,
                  endIndent: 15.w,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _editTransaction(ExpenseEntity expenseEntity) {
    Navigator.pushNamed(context, RouteList.personalExpense, arguments: {
      KeyConstants.routeKey: RouteList.home,
      KeyConstants.editExpenseKey: true,
      KeyConstants.expenseKey: expenseEntity,
      KeyConstants.groupKey: widget.group
    });
  }

  void _onDelete(ExpenseEntity expense) {
    transactionBloc?.add(
        DeleteExpenseEvent(expense: expense, groupId: widget.group?.id ?? ''));
  }

  void _viewAll() {
    Navigator.pushNamed(context, RouteList.transactionList,
        arguments: {KeyConstants.groupKey: widget.group});
  }

  @override
  bool get wantKeepAlive => true;
}
