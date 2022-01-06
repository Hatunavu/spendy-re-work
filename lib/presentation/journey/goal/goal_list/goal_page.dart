import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/enums/data_state.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/common/utils/admob_utils.dart';
import 'package:spendy_re_work/domain/entities/goal_detail_entity.dart';
import 'package:spendy_re_work/domain/entities/goal_entity.dart';
import 'package:spendy_re_work/presentation/journey/goal/goal_list/goal_list_bloc/goal_list_bloc.dart';
import 'package:spendy_re_work/presentation/journey/goal/goal_list/widgets/goal_item_widget.dart';
import 'package:spendy_re_work/presentation/journey/home/home_screen_constants.dart';
import 'package:spendy_re_work/presentation/widgets/ads_banner_widget/ads_banner_widget.dart';
import 'package:spendy_re_work/presentation/widgets/appbar/appbar_widget.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/delete_dialog/delete_dialog_widget.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/alert_flare_widgets/error_flare_widget.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/loader/load_more/load_more_widget.dart';
import 'package:spendy_re_work/presentation/widgets/seach/search_field_widget.dart';
import 'package:spendy_re_work/presentation/widgets/state_widget/empty_data_widget.dart';
import 'goal_page_constants.dart';

class GoalPage extends StatefulWidget {
  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return BlocConsumer<GoalListBloc, GoalListState>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBarWidget(
          title: GoalPageConstants.textGoal,
          actions: [
            GestureDetector(
              onTap: () => _onPressedAddGoal(context),
              child: Image.asset(
                IconConstants.createGoalIcon,
                height: 17,
                width: 17,
              ),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(top: GoalPageConstants.paddingTop18),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: LayoutConstants.dimen_26, right: LayoutConstants.dimen_26, bottom: 10.h),
                child: SearchFieldWidget(
                  onSubmitted: _onSubmitted,
                  onChanged: (value) => _onChange(context, value),
                  controller: _searchController,
                ),
              ),
              Expanded(child: _buildGoalBody(state)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalBody(GoalListState state) {
    if (state is GoalListFailure) {
      return FailedFlareWidget(
          marginBottom: true,
          callback: () {
            BlocProvider.of<GoalListBloc>(context).add(GoalListInitialEvent());
          });
    } else if (state is GoalListLoaded) {
      return _buildBody(state);
    }
    return EmptyDataWidget(
      titleButton: GoalPageConstants.addFirstGoal,
      onPressButton: !state.showButtonClear ? () => _onPressedAddGoal(context) : null,
    );
  }

  Widget _buildBody(GoalListLoaded state) {
    return state.goals?.isEmpty ?? true
        ? EmptyDataWidget(
            titleButton: GoalPageConstants.addFirstGoal,
            onPressButton: !state.showButtonClear ? () => _onPressedAddGoal(context) : null)
        : SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: GoalPageConstants.paddingTop, left: LayoutConstants.dimen_26),
                  child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: state.goals?.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            GoalItemWidget(
                              goalSelected: state.goalSelected,
                              goalCurrentSelected: state.goals![index],
                              slideState: state.slideState,
                              currency: state.currency,
                              onTapGoal: () => _onPushEditGoal(state.goals![index]),
                              closeSlide: () => _closeSlide(context),
                              openSlide: (goal) => _openSlide(context, goal),
                              deleteOnPress: () => _deleteGoal(context, state.goalSelected!),
                            ),
                            //_itemGoal(goal, state.currency),
                            Visibility(
                                visible: (index != 0 && index % 5 == 0 ||
                                        index == 3 && state.goals?.length == 5 ||
                                        index == 2 && state.goals!.length < 5) &&
                                    AdmobUtils.adShow,
                                child: _adsWidget())
                          ],
                        );
                      }),
                ),
                _loadMoreWidget(state.dataState == DataState.loadingMore),
                SizedBox(
                  height: HomeScreenConstants.pagePaddingBottom,
                ),
              ],
            ),
          );
  }

  Widget _adsWidget() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(
          top: 10.h,
          bottom: 10.h,
        ),
        child: AdsBannerWidget());
  }

  Widget _loadMoreWidget(bool isShow) {
    return Visibility(
      visible: isShow,
      child: FlareLoadMoreWidget(),
    );
  }

  Future<void> _onPressedAddGoal(BuildContext context) async {
    final result = await Navigator.pushNamed<GoalDetailEntity>(context, RouteList.addGoal,
        arguments: <String, dynamic>{});
    if (result != null) {
      // update when add a goal success
      BlocProvider.of<GoalListBloc>(context).add(AddAGoal(result));
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      BlocProvider.of<GoalListBloc>(context).add(LoadMoreGoalsEvent());
    }
  }

  Future<void> _onPushEditGoal(GoalEntity goal) async {
    final result = await Navigator.pushNamed<GoalDetailEntity>(context, RouteList.addGoal,
        arguments: {KeyConstants.editAGoalKey: goal, KeyConstants.isEditAGoalKey: true});
    if (result != null) {
      BlocProvider.of<GoalListBloc>(context).add(SearchGoalEvent(keyword: _searchController.text));
    }
  }

  @override
  bool get wantKeepAlive => true;

  void _onChange(BuildContext context, String value) {
    if (value.isNotEmpty) {
      BlocProvider.of<GoalListBloc>(context).add(SearchTypingEvent(value));
    } else {
      BlocProvider.of<GoalListBloc>(context).add(GoalListInitialEvent());
    }
  }

  void _onSubmitted(String value) {
    _searchFocus.unfocus();
  }

  void _closeSlide(BuildContext context) {
    BlocProvider.of<GoalListBloc>(context).add(CloseGoalSlideEvent());
  }

  void _openSlide(BuildContext context, GoalEntity goal) {
    BlocProvider.of<GoalListBloc>(context).add(OpenGoalSlideEvent(goal));
  }

  void _deleteGoal(BuildContext context, GoalEntity goalSelected) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (dialogContext) => DeleteDialogWidget(
            typeNameItem: GoalPageConstants.goal,
            onPressedYes: () => _onDelete(context, goalSelected),
            onPressedNo: () {
              Navigator.of(dialogContext).pop();
            }));
  }

  void _onDelete(BuildContext context, GoalEntity goal) {
    BlocProvider.of<GoalListBloc>(context).add(DeleteGoalEvent(goal));
    Navigator.of(context).pop();
  }
}
