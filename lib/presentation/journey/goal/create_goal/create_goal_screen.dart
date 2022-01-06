import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/enums/goal_duration_type.dart';
import 'package:spendy_re_work/common/utils/device_dimension_utils.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/entities/goal_detail_entity.dart';
import 'package:spendy_re_work/domain/entities/goal_entity.dart';
import 'package:spendy_re_work/presentation/journey/goal/create_goal/create_goal_constants.dart';
import 'package:spendy_re_work/presentation/journey/goal/create_goal/widgets/date_selection.dart';
import 'package:spendy_re_work/presentation/journey/goal/create_goal/widgets/goal_achieved_switch.dart';
import 'package:spendy_re_work/presentation/journey/goal/create_goal/widgets/goal_name_field.dart';
import 'package:spendy_re_work/presentation/journey/goal/create_goal/widgets/money_field.dart';
import 'package:spendy_re_work/presentation/journey/goal/create_goal/widgets/note_field.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/new_expense_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/widgets/categories_list_widget.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/widgets/new_expense_active_button_widget.dart';
import 'package:spendy_re_work/presentation/widgets/base_scaffold/base_scaffold.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/alert_dialog/alert_dialog.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/loader_dialog/loader_wallet_dialog.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/alert_flare_widgets/error_flare_widget.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/loader/loading_flare_widget.dart';

import '../goal_list/goal_page_constants.dart';
import 'create_goal_bloc/create_goal_bloc.dart';

class CreateAGoalScreen extends StatelessWidget {
  final bool isEdit;
  final GoalEntity? oldGoal;

  final _goalNameCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _moneyCtrl = TextEditingController();

  final _dateTimeCtrl = TextEditingController();

  CreateAGoalScreen({this.isEdit = false, this.oldGoal});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      context,
      leading: true,
      appBarTitle: isEdit
          ? GoalPageConstants.textEditGoal
          : GoalPageConstants.textCreateGoal,
      body: BlocConsumer<CreateGoalBloc, CreateGoalState>(
        listener: (context, state) {
          if (state is CreateGoalSuccess) {
            _handlingCreateAGoalSuccess(context, state);
          } else if (state is CreateGoalFailed) {
            _handlingFailed(context);
          }
          // } else if (state is CreateGoalInitializedData &&
          //     state.crudState == DataState.loading) {
          //   LoaderWalletDialog.getInstance().show(context, enableBack: false);
          // }
        },
        builder: (context, state) {
          if (state is CreateGoalInitializedData) {
            return Container(
              height: DeviceDimension.getDeviceHeight(context),
              child: Padding(
                padding: EdgeInsets.only(top: CreateGoalConstants.paddingTop18),
                child: Stack(
                  children: [
                    _buildBodySuccess(context, state),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _saveButtonWidget(context, state.isValidate!),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is CreateGoalLoadDataFailed) {
            return FailedFlareWidget(
              callback: () => Navigator.pop(context),
              actionText: 'Back',
            );
          }
          return FlareLoadingWidget();
        },
      ),
    );
  }

  Widget _buildBodySuccess(
    BuildContext context,
    CreateGoalInitializedData state,
  ) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CategoriesListWidget(
            categories: state.categories!,
            onTapCategoryTags: (value) => _selectCategory(context, value),
            selectCategory: state.category,
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: LayoutConstants.dimen_8, left: LayoutConstants.dimen_26),
            child: Column(
              children: [
                // CateGoryTagsWidget(state),
                GoalNameFieldWidget(
                  controller: _goalNameCtrl,
                  initText: state.nameGoal,
                ),
                MoneyTextFieldWidget(
                  amountPerMonth: state.amountPerMonth!,
                  currencyEntity: state.currencyEntity!,
                  controller: _moneyCtrl,
                  initText: state.money,
                ),
                DateSelectionWidget(
                  date: state.date!,
                  controller: _dateTimeCtrl,
                  amountOfTime: state.amountOfTime,
                  currentDurationType: state.durationType!,
                  onSelectDateDone: (value) => _onSelectDate(context, value),
                  onSelectDurationDone: (value) =>
                      _onSelectDurationDone(context, value),
                ),
                NoteTextFieldWidget(
                  controller: _noteCtrl,
                  initText: state.note,
                  onChangeNote: (value) => _onChangeNote(context, value),
                ),
                Visibility(
                    visible: isEdit,
                    child: GoalAchievedSwitchWidget(state.isGoalAchieved)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _saveButtonWidget(BuildContext context, bool validate) {
    //bool isTyping = MediaQuery.of(context).viewInsets.bottom != 0;
    return NewExpenseActiveButtonWidget(
      title: NewExpenseConstants.saveButtonTitle,
      onPressed: validate ? () => _onPressedSave(context) : null,
    );
  }

  void _onPressedSave(BuildContext context) {
    BlocProvider.of<CreateGoalBloc>(context)
        .add(OnPressedSaveEvent(isEdit: isEdit));
  }

  void _handlingCreateAGoalSuccess(
      BuildContext context, CreateGoalSuccess state) {
    LoaderWalletDialog.getInstance().hide(context);
    Navigator.pop<GoalDetailEntity>(
        context, GoalDetailEntity(state.categoryEntity, state.goalEntity));
  }

  void _handlingFailed(BuildContext context) {
    LoaderWalletDialog.getInstance().hide(context);
    AlertDialogSpendy.showDialogOneAction(
      context,
      GoalPageConstants.textError,
      'OK',
    );
  }

  void _selectCategory(BuildContext context, CategoryEntity value) {
    BlocProvider.of<CreateGoalBloc>(context).add(CategoryChangeEvent(value));
  }

  void _onSelectDurationDone(BuildContext context, GoalDurationType value) {
    BlocProvider.of<CreateGoalBloc>(context)
        .add(GoalDurationChangeEvent(value));
  }

  void _onSelectDate(BuildContext context, DateTime value) {
    BlocProvider.of<CreateGoalBloc>(context).add(SelectDateEvent(date: value));
  }

  void _onChangeNote(BuildContext context, String value) =>
      BlocProvider.of<CreateGoalBloc>(context).add(NoteTextChangeEvent(value));
}
