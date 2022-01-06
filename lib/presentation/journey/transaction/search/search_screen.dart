import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/enums/data_state.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/common/utils/date_time_utils.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_detail_bloc/transaction_detail_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_detail_bloc/transaction_detail_event.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_detail_bloc/transaction_detail_state.dart';
import 'package:spendy_re_work/presentation/journey/transaction/search/bloc/search_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/search/bloc/search_state.dart';
import 'package:spendy_re_work/presentation/journey/transaction/search/search_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/search/widgets/app_bar_search.dart';
import 'package:spendy_re_work/presentation/journey/transaction/search/widgets/search_recently_widget.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_list/transaction_list_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_list/widgets/transaction_of_date_list_widget.dart';
import 'package:spendy_re_work/presentation/journey/transaction/widgets/transaction_detail_dialog/transaction_detail_dialog_widget.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/delete_dialog/delete_dialog_widget.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/loader/loader_screen.dart';
import 'package:spendy_re_work/presentation/widgets/no_internet_widget/no_internet_widget.dart';
import 'package:spendy_re_work/presentation/widgets/skeleton_widget/default_skeleton_widget.dart';
import 'package:spendy_re_work/presentation/widgets/skeleton_widget/expense_skeleton_widget.dart';
import 'package:spendy_re_work/presentation/widgets/state_widget/empty_data_widget.dart';

import 'bloc/search_event.dart';

class SearchScreen extends StatefulWidget {
  final GroupEntity? group;

  const SearchScreen({Key? key, this.group}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  ScrollController? _scrollController;
  late SearchBloc _searchBloc;

  @override
  void initState() {
    _scrollController = ScrollController();
    _searchBloc = BlocProvider.of<SearchBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchBloc, SearchState>(listener: (context, state) {
      if (state.clearSearchField!) {
        _searchController.clear();
      }
    }, builder: (context, state) {
      if (state.isLoading!) {
        return Stack(
          children: [
            Container(
              color: AppColor.white,
            ),
            Visibility(
                visible: state.isLoading!,
                child: LoaderScreen(
                  textColor: AppColor.white,
                ))
          ],
        );
      } else {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColor.white,
              appBar: AppbarSearchWidget(
                searchController: _searchController,
                categoryNameList: state.categoryNameMap!.values.toList(),
                onChanged: (value) => _onChanged(context, value),
                onSubmitted: (value) => _onSubmitted(context, value),
                showCleanButton: state.showButtonClear!,
                onCleanText: () => _onCleanText(context),
                onSuggestionSelected: (value) {},
              ),
              body: Padding(
                padding: EdgeInsets.only(top: SearchConstants.paddingTop),
                child: _bodyWidget(context, state),
              ),
            ),
            Visibility(
                visible: state.isLoading!,
                child: LoaderScreen(
                  textColor: AppColor.white,
                ))
          ],
        );
      }
    });
  }

  Widget _bodyWidget(BuildContext context, SearchState state) {
    if (state.searchSuccess!) {
      if (state.searchResultMap == null ||
          state.searchResultMap!.isEmpty ||
          state.searchResultMap!.length == 0) {
        return const EmptyDataWidget();
      }
      if (state.dataState == DataState.loading) {
        return ExpenseSkeletonWidget();
      }
      return _searchResultWidget(state);
    } else if (state.isLoading!) {
      return DefaultSkeletonWidget();
    } else if (!state.internetConnected!) {
      return NoInternetWidget();
    }
    return SearchRecentlyWidget(
      expenseList: state.recentlyList ?? [],
      onTapTransactionItem: (value, int) =>
          _onTapTransactionItem(context, value, int, true),
      openSlideTransactionItem: (value) =>
          _openSlideTransactionItem(context, value),
      closeSlide: () => _closeSlideTransactionItem(context),
      editOnPressed: () => _editOnPressed(state.selectedExpense!),
      deleteOnPressed: () => _deleteOnPressed(context, state.selectedExpense!),
      selectExpense: state.selectedExpense!,
      slideState: state.slideState!,
    );
  }

  Widget _searchResultWidget(SearchState state) {
    return ListView.builder(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        itemCount: state.searchResultMap?.length,
        itemBuilder: (context, index) {
          final int startDay = state.searchResultMap!.keys.toList()[index];
          final String strDate = DateTimeUtils.formatDateTextMonth(
              DateTime.fromMillisecondsSinceEpoch(startDay),
              languageCode: Localizations.localeOf(context).languageCode);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: LayoutConstants.dimen_26,
                  bottom:
                      TransactionListConstants.spaceBetweenDateAndTransaction,
                ),
                child: Text(
                  '$strDate',
                  style: ThemeText.getDefaultTextTheme().textHint.copyWith(
                      color: AppColor.dateTimeTitleColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              TransactionOfDateListWidget(
                onEdit: _editOnPressed,
                onDelete: _onDelete,
                expenseList: state.searchResultMap?[startDay] ?? [],
              ),
            ],
          );
        });
  }

  void _onSubmitted(BuildContext context, String value) {
    if (value.isEmpty) {
      FocusNode().unfocus();
    } else {
      _searchBloc.add(SearchExpenseEvent(keyWord: value));
    }
  }

  void _onChanged(BuildContext context, String value) {
    _closeSlideTransactionItem(context);
    if (value.isEmpty) {
      _searchBloc.add(SearchInitialEvent(group: widget.group));
    } else {
      _searchBloc.add(TypingSearchFromEvent(keyWord: value));
    }
  }

  void _onCleanText(BuildContext context) {
    _closeSlideTransactionItem(context);
    _searchBloc.add(CleanTextEvent());
  }

  void _onTapTransactionItem(
      BuildContext context, ExpenseEntity value, int index, bool isRecent) {
    _closeSlideTransactionItem(context);
    _updateSearchRecently(context, value);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (dialogContext) => BlocProvider.value(
              value: _searchBloc
                ..add(GetExpenseDetailEvent(
                    expense: value, index: index, isRecent: isRecent)),
              child: BlocProvider(
                create: (_) => Injector.resolve<TransactionDetailBloc>()
                  ..add(TransactionDetailInitialEvent(value, '')),
                child:
                    BlocBuilder<TransactionDetailBloc, TransactionDetailState>(
                  builder: (detailContext, state) {
                    if (state is TransactionDetailInitialState) {
                      return TransactionDetailDialogWidget(
                        expense: state.expense,
                        onShowMorePicture: () =>
                            _onShowMorePicture(dialogContext, value),
                        deleteOnPressed: () {
                          Navigator.of(dialogContext).pop();
                          _deleteOnPressed(context, value);
                        },
                        imageDataState: state.imageDataState,
                        onBack: () {},
                        editOnPressed: () {
                          Navigator.of(dialogContext).pop();
                          _editOnPressed(value);
                        },
                      );
                    }
                    return const EmptyDataWidget();
                  },
                ),
              ),
            ));
  }

  void _openSlideTransactionItem(BuildContext context, ExpenseEntity value) {
    _searchBloc
        .add(OpenSlideSearchTransactionItemEvent(selectExpenseDetail: value));
  }

  void _closeSlideTransactionItem(BuildContext context) {
    _searchBloc.add(CloseSlideSearchTransactionItemEvent());
  }

  void _editOnPressed(ExpenseEntity selectExpDetail) {
    _closeSlideTransactionItem(context);
    _updateSearchRecently(context, selectExpDetail);
    Navigator.pushNamed(context, RouteList.personalExpense, arguments: {
      KeyConstants.routeKey: RouteList.search,
      KeyConstants.editExpenseKey: true,
      KeyConstants.expenseDetailKey: selectExpDetail,
    });
  }

  void _deleteOnPressed(
      BuildContext context, ExpenseEntity selectExpenseDetail) {
    _closeSlideTransactionItem(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (dialogContext) => DeleteDialogWidget(
            typeNameItem: SearchConstants.transaction,
            onPressedYes: () => _onDelete(selectExpenseDetail),
            onPressedNo: () {
              Navigator.of(dialogContext).pop();
            }));
  }

  void _onDelete(ExpenseEntity selectExpenseDetail) {
    _searchBloc.add(DeleteExpenseSearchEvent(
        expenseDetail: selectExpenseDetail, keyWord: _searchController.text));
    Navigator.of(context).pop();
  }

  void _onShowMorePicture(BuildContext dialogContext, ExpenseEntity expense) {
    Navigator.of(dialogContext).pop();
    Navigator.pushNamed(dialogContext, RouteList.showImage,
        arguments: {KeyConstants.expenseKey: expense});
  }

  void _updateSearchRecently(BuildContext context, ExpenseEntity expDetail) {
    _searchBloc.add(UpdateSearchRecentlyEvent(expDetail));
  }
}
