import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_constants.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_option/bloc/filter_bloc.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_option/bloc/filter_event.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_option/bloc/filter_state.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_option/widgets/expense_range_option_widget.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_option/widgets/filter_option_squad_widget.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_option/widgets/group_button_widget.dart';
import 'package:spendy_re_work/presentation/widgets/base_scaffold/base_scaffold.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/loader_dialog/loader_wallet_dialog.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/loader/loading_flare_widget.dart';

class FilterScreen extends StatefulWidget {
  final GroupEntity? group;

  const FilterScreen({Key? key, this.group}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late FilterBloc _filterBloc;

  @override
  void initState() {
    _filterBloc = BlocProvider.of<FilterBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FilterBloc, FilterState>(listener: (context, state) {
      if (state is FilterLoadingState) {
        LoaderWalletDialog.getInstance().show(context);
      } else if (state is FilterInitialState) {
        LoaderWalletDialog.getInstance().hide(context);
      } else if (state is ApplyFilterState) {
        // Navigator.pop(context, state.filterMap);
        Navigator.of(context).pushReplacementNamed(RouteList.filterResult,
            arguments: {
              KeyConstants.filterKey: state.filter,
              KeyConstants.groupKey: widget.group
            });
      }
    }, builder: (context, state) {
      return BaseScaffold(
        context,
        appBarTitle: FilterConstants.filterScreenTitle,
        leading: true,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _bodyWidget(context, state),
            GroupButtonWidget(
              selectOptionTypeNumbers: state is FilterInitialState
                  ? state.selectOptionTypeNumbers
                  : 0,
              isActiveButton: _isActiveApplyButton(state),
              onPressedApplyButton: () => _onPressApplyButton(context),
              onPressedResetButton: () => _resetOption(context),
            )
          ],
        ),
      );
    });
  }

  Widget _bodyWidget(BuildContext context, FilterState state) {
    if (state is FilterInitialState) {
      return Padding(
        padding: EdgeInsets.only(
          left: LayoutConstants.dimen_26,
          right: LayoutConstants.dimen_26,
          top: FilterConstants.paddingTop18,
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: FilterOptionSquadWidget(
                optionName: FilterConstants.categoryOptionName,
                optionIconPath: IconConstants.categoryIcon,
                optionItemList: state.categoryNameList,
                selectOption: state.selectCategory ?? '',
                onSelectOptionTag: (selectOption, active) => _onSelectOption(
                    context,
                    selectOption: selectOption,
                    active: active,
                    optionKey: KeyConstants.categoryFilterOptionKey),
                needAddMore: false,
                showDeleteButton: state.isShowDeleteSelectCategory,
                onPressDeleteButton: () => _resetOption(
                  context,
                ),
                onTapAddMore: () {},
              ),
            ),
            SliverToBoxAdapter(
              child: FilterOptionSquadWidget(
                optionName: FilterConstants.timeOptionName,
                optionIconPath: IconConstants.timerIcon,
                optionItemList: state.monthList,
                selectOption: state.selectMonth ?? '',
                onSelectOptionTag: (selectOption, active) => _onSelectOption(
                    context,
                    selectOption: selectOption,
                    active: active,
                    optionKey: KeyConstants.monthFilterOptionKey),
                needAddMore: true,
                showDeleteButton: state.isShowDeleteSelectMonth,
                onPressDeleteButton: () => _resetOption(context,
                    optionKey: KeyConstants.monthFilterOptionKey),
                isShowMore: state.isShowMore,
                onTapAddMore: () => _onTapAddMore(context,
                    optionKey: KeyConstants.monthFilterOptionKey),
              ),
            ),

            /// JUST PERSONAL
            // SliverToBoxAdapter(
            //   child: FilterOptionSquadWidget(
            //     optionName: FilterConstants.groupTypeOptionName,
            //     optionIconPath: IconConstants.groupIcon,
            //     optionItemList: groupParticipantMap.keys.toList(),
            //     selectOptionList: state.selectGroupParticipantList ?? [],
            //     onSelectOptionTag: (selectOption, active) => _onSelectOption(
            //         context,
            //         selectOption: selectOption,
            //         active: active,
            //         optionKey: KeyConstants.groupFilterOptionKey),
            //     showDeleteButton: state.isShowDeleteSelectGroup,
            //     onPressDeleteButton: () => _resetOption(context,
            //         optionKey: KeyConstants.groupFilterOptionKey),
            //   ),
            // ),
            SliverToBoxAdapter(
              child: ExpenseRangeOptionWidget(
                lowerRange: state.startExpenseRange!,
                upperRange: state.endExpenseRange!,
                useActionButton: state.iShowDeselectedExpenseRange,
                onChangeRange: (startRange, endRange) =>
                    _onChangeRange(context, startRange, endRange),
                onTapActionButton: () => _resetOption(context,
                    optionKey: KeyConstants.expenseRangeFilterOptionKey),
                onChangeEnd: (startRange, endRange) => _onChangeRange(
                    context, startRange, endRange,
                    infinity: true),
                spendRangeInfinity: state.spendRangeInfinity,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: FilterConstants.spacingBottom,
              ),
            ),
          ],
        ),
      );
    } else if (state is FilterLoadingState) {
      return FlareLoadingWidget(
        marginBottom: true,
      );
    } else {
      return const SizedBox();
    }
  }

  void _onSelectOption(BuildContext context,
      {String? selectOption, bool? active, String? optionKey}) {
    _filterBloc.add(SelectFilterEvent(
        selectOption: selectOption!, active: active!, optionKey: optionKey!));
  }

  void _onChangeRange(BuildContext context, double startRange, double endRange,
      {bool infinity = false}) {
    _filterBloc.add(SelectFilterEvent(
      startRange: startRange,
      endRange: endRange,
      optionKey: KeyConstants.expenseRangeFilterOptionKey,
      spendRangeInfinity: infinity,
    ));
  }

  bool _isActiveApplyButton(FilterState state) {
    if (state is FilterInitialState) {
      return state.isActiveButton;
    }
    return false;
  }

  void _onPressApplyButton(BuildContext context) {
    _filterBloc.add(ApplyFilterEvent());
  }

  void _resetOption(BuildContext context, {String? optionKey}) {
    _filterBloc.add(ResetFilterEvent(optionKey: optionKey));
  }

  void _onTapAddMore(BuildContext context, {String? optionKey}) {
    if (optionKey == KeyConstants.monthFilterOptionKey) {
      _filterBloc.add(AddMoreSpendTimerEvent(
          languageCode: Localizations.localeOf(context).languageCode));
    }
  }
}
