import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/enums/data_state.dart';
import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_constants.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_result/bloc/filter_result_bloc.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_result/bloc/filter_result_state.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_result/bloc/fliter_result_event.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_result/widgets/filter_tags_widget.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_detail_bloc/transaction_detail_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_detail_bloc/transaction_detail_event.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_detail_bloc/transaction_detail_state.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_list/transaction_list_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/widgets/transaction_detail_dialog/transaction_detail_dialog_widget.dart';
import 'package:spendy_re_work/presentation/journey/transaction/widgets/transaction_item_widget.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/base_scaffold/base_scaffold.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/delete_dialog/delete_dialog_widget.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/loader/load_more/load_more_widget.dart';
import 'package:spendy_re_work/presentation/widgets/skeleton_widget/expense_skeleton_widget.dart';
import 'package:spendy_re_work/presentation/widgets/state_widget/empty_data_widget.dart';

class FilterResultScreen extends StatefulWidget {
  final GroupEntity? group;

  const FilterResultScreen({Key? key, this.group}) : super(key: key);
  @override
  _FilterResultScreenState createState() => _FilterResultScreenState();
}

class _FilterResultScreenState extends State<FilterResultScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late FilterResultBloc _filterResultBloc;

  @override
  void initState() {
    super.initState();
    _filterResultBloc = BlocProvider.of<FilterResultBloc>(context);
    _scrollController.addListener(() {
      _closeSlideTransactionItem(context);
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _scrollEndList(context);
      }
    });
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
            size: 24,
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
      body: _bodyWidget(context),
    );
  }

  void _scrollEndList(BuildContext context) {
    // _filterResultBloc.add(LoadMoreEvent());
  }

  void _pushToSearchScreen(BuildContext context) {
    _closeSlideTransactionItem(context);
    Navigator.pushNamed(context, RouteList.search);
  }

  void _pushToFilterScreen(BuildContext context) {
    Navigator.of(context).pop();
  }

  Widget _bodyWidget(BuildContext context) {
    return BlocBuilder<FilterResultBloc, FilterResultState>(
        builder: (context, state) {
      if (state is FilterResultInitialState) {
        if (state.dataState == DataState.loading) {
          return ExpenseSkeletonWidget();
        } else if (state.dataState == DataState.success) {
          return Column(
            children: [
              Visibility(
                visible: //state.tagMap != null &&
                    state.tagMap.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: LayoutConstants.dimen_26,
                    right: LayoutConstants.dimen_26,
                  ),
                  child: FilterTagsWidget(
                    tagMap: state.tagMap,
                    removeTag: (value) => _onRemoveTag(context, value),
                  ),
                ),
              ),
              Visibility(
                visible: !state.tagMap.isNotEmpty,
                child: const SizedBox(
                  height: TransactionListConstants
                      .spaceBetweenSearchAndTransactionList,
                ),
              ),
              Expanded(child: _transactionList(context, state)),
            ],
          );
        }
        return const EmptyDataWidget();
      } else {
        return const EmptyDataWidget();
      }
    });
  }

  Widget _transactionList(
      BuildContext context, FilterResultInitialState state) {
    if (state.expenseList.isNotEmpty) {
      return CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        controller: _scrollController,
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return TransactionItemWidget(
              showHours: true,
              slideState: state.slideState,
              expense: state.expenseList[index],
              selectExpense: state.selectExpense!,
              onTap: () => _onTapTransactionItem(
                  context, state.expenseList[index], index),
              openSlide: (expense) =>
                  _openSlideTransactionItem(context, expense),
              closeSlide: () => _closeSlideTransactionItem(context),
              showLineBottom: index < state.expenseList.length,
              deleteOnPressed: () =>
                  _deleteOnPressed(context, state.selectExpense!),
              editOnPressed: () =>
                  _editOnPressed(context, state.selectExpense!),
              spendTime: state.expenseList[index].spendTime,
              strSpendTime: DateTime.fromMillisecondsSinceEpoch(
                      state.expenseList[index].spendTime)
                  .formatDateTextMonth,
            );
          }, childCount: state.expenseList.length)),
          SliverToBoxAdapter(
            child: state.dataState == DataState.loadingMore
                ? FlareLoadMoreWidget()
                : const SizedBox(height: 20),
          ),
        ],
      );
    }
    return const EmptyDataWidget();
  }

  void _onRemoveTag(BuildContext context, String key) {
    _filterResultBloc.add(RemoveTagEvent(key: key));
  }

  void _onTapTransactionItem(
      BuildContext context, ExpenseEntity expense, int index) {
    showDialog(
        context: context,
        builder: (dialogContext) => BlocProvider(
            create: (_) => Injector.resolve<TransactionDetailBloc>()
              ..add(TransactionDetailInitialEvent(expense, '')),
            child: BlocBuilder<TransactionDetailBloc, TransactionDetailState>(
                builder: (detailContext, state) {
              if (state is TransactionDetailInitialState) {
                return TransactionDetailDialogWidget(
                  expense: state.expense,
                  onShowMorePicture: () =>
                      _onShowMorePicture(dialogContext, expense),
                  deleteOnPressed: () {
                    Navigator.of(dialogContext).pop();
                    _deleteOnPressed(context, expense);
                  },
                  imageDataState: state.imageDataState,
                  onBack: () {},
                  editOnPressed: () {
                    Navigator.of(dialogContext).pop();
                    _editOnPressed(context, expense);
                  },
                );
              }
              return const EmptyDataWidget();
            })));
  }

  void _openSlideTransactionItem(BuildContext context, ExpenseEntity value) {
    _filterResultBloc.add(OpenSlideEvent(selectExpense: value));
  }

  void _closeSlideTransactionItem(BuildContext context) {
    _filterResultBloc.add(CloseSlideEvent());
  }

  void _editOnPressed(BuildContext context, ExpenseEntity selectExpense) {
    _closeSlideTransactionItem(context);
    Navigator.pushNamed(context, RouteList.personalExpense, arguments: {
      KeyConstants.routeKey: RouteList.home,
      KeyConstants.editExpenseKey: true,
      KeyConstants.expenseKey: selectExpense,
      KeyConstants.groupKey: widget.group
    });
  }

  void _deleteOnPressed(BuildContext context, ExpenseEntity selectExpense) {
    _closeSlideTransactionItem(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (dialogContext) => DeleteDialogWidget(
            typeNameItem: FilterConstants.transaction,
            onPressedYes: () => _onDelete(context, selectExpense),
            onPressedNo: () {
              Navigator.of(dialogContext).pop();
            }));
  }

  void _onDelete(BuildContext context, ExpenseEntity selectExpense) {
    _filterResultBloc.add(DeleteExpenseEvent(expense: selectExpense));
    Navigator.of(context).pop();
  }

  void _onShowMorePicture(BuildContext dialogContext, ExpenseEntity expense) {
    Navigator.of(dialogContext).pop();
    Navigator.pushNamed(dialogContext, RouteList.showImage,
        arguments: {KeyConstants.expenseKey: expense});
  }
}
