import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class GoalPageConstants {
  static const String moneyFormKey = 'create-goal-money-form-key';

  static final paddingBottom = 28.h;
  static final paddingHorizontal = 26.w;
  static final paddingTop = 8.h;
  static final paddingLeftContent = 14.w;
  static final topAddGoalPadding = 16.h;
  static final paddingBottomList = 32.h;
  static final paddingTop18 = 18.h;

  static const String textHintMoney = '0';
  static const String textDefaultCurrency = 'đ';

  static String textMonths = translate('label.months');
  static String textAddGoal = translate('label.add_a_goal');
  static String textGoal = translate('label.goal');
  static String textCreateGoal = translate('label.create_a_goal');
  static String textEditGoal = translate('label.edit_a_goal');
  static String textCategory = translate('label.category');
  static String textHintGoalName = translate('label.goal_name');
  static String textHintNote = translate('label.type_here');
  static String textPerMonth = translate('label.per_month');
  static String textAchieved = translate('label.goal_achieved');
  static String txtGoalDuration = translate('label.goal_duration');
  static String txtExpiredDate = translate('label.expired_date');
  static String textBtnSave = translate('label.save');
  static String textBtnDelete = translate('label.delete');
  static String textError = translate('error_message.an_error_occurred');
  static String addFirstGoal = translate('label.add_the_first_goal');
  static String goal = translate('label.goal_lower');
  static const double scaleSwitch = 0.6;

  static final double fz_15sp = 15.sp;
  static final double fz_18sp = 18.sp;
  static const heightAppBar = Size.fromHeight(90);
}
