import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/utils/date_time_utils.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_blocs/transaction_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_blocs/transaction_event.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_blocs/transaction_state.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_list/transaction_list_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_list/widgets/transaction_of_date_list_widget.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/base_scaffold/base_scaffold.dart';
import 'package:spendy_re_work/presentation/widgets/skeleton_widget/expense_skeleton_widget.dart';

class TransactionListScreen extends StatefulWidget {
  final GroupEntity? group;

  const TransactionListScreen({Key? key, this.group}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TransactionBloc _transactionBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _scrollEndList(context);
      }
    });
    _transactionBloc = BlocProvider.of<TransactionBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      context,
      key: _scaffoldKey,
      leading: true,
      appBarTitle: TransactionListConstants.appBarTitle,
      actionAppbar: [
        GestureDetector(
          onTap: () => _pushToSearchScreen(context),
          child: const Icon(
            CupertinoIcons.search,
            size: TransactionListConstants.searchIconSize,
            color: AppColor.primaryDarkColor,
          ),
        ),
        GestureDetector(
          onTap: () => _pushToFilterScreen(context),
          child: Image.asset(
            IconConstants.filterIcon,
            height: TransactionListConstants.actionIconButtonSize,
            width: TransactionListConstants.actionIconButtonSize,
          ),
        )
      ],
      body: Padding(
        padding: EdgeInsets.only(top: TransactionListConstants.paddingTop18),
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoadingState) {
              return ExpenseSkeletonWidget();
            }
            return ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: state.expenseOfDayMap?.length,
                itemBuilder: (context, index) {
                  final int startDay =
                      state.expenseOfDayMap!.keys.toList()[index];
                  final String strDate = DateTimeUtils.formatDateTextMonth(
                      DateTime.fromMillisecondsSinceEpoch(startDay),
                      languageCode:
                          Localizations.localeOf(context).languageCode);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: LayoutConstants.dimen_26,
                          bottom: TransactionListConstants
                              .spaceBetweenDateAndTransaction,
                        ),
                        child: Text(
                          '$strDate',
                          style: ThemeText.getDefaultTextTheme()
                              .textHint
                              .copyWith(
                                  color: AppColor.dateTimeTitleColor,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                      TransactionOfDateListWidget(
                        onEdit: _editTransaction,
                        onDelete: _onDelete,
                        expenseList: state.expenseOfDayMap?[startDay] ?? [],
                      ),
                    ],
                  );
                });
          },
        ),
      ),
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
    _transactionBloc.add(
        DeleteExpenseEvent(expense: expense, groupId: widget.group?.id ?? ''));
  }

  Future<void> _pushToFilterScreen(BuildContext context) async {
    await Navigator.pushNamed(context, RouteList.filter,
        arguments: {KeyConstants.groupKey: widget.group});
  }

  void _pushToSearchScreen(BuildContext context) {
    Navigator.pushNamed(context, RouteList.search,
        arguments: {KeyConstants.groupKey: widget.group});
  }

  void _scrollEndList(BuildContext context) {
    _transactionBloc.add(LoadMoreEvent(widget.group!));
  }
}
