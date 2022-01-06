import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/enums/goal_duration_type.dart';

const Map<String, GoalDurationType> goalDurationTypeMap = {
  'week': GoalDurationType.aWeek,
  'two_weeks': GoalDurationType.twoWeeks,
  'month': GoalDurationType.aMonth,
  'three_months': GoalDurationType.threeMonths,
  'six_months': GoalDurationType.sixMonths,
  'year': GoalDurationType.aYear,
  'two_years': GoalDurationType.twoYears,
  'three_years': GoalDurationType.threeYears,
  'fire_years': GoalDurationType.fiveYears,
};

const Map<GoalDurationType, String> keyGoalDurationTypeMap = {
  GoalDurationType.aWeek: 'week',
  GoalDurationType.twoWeeks: 'two_weeks',
  GoalDurationType.aMonth: 'month',
  GoalDurationType.threeMonths: 'three_months',
  GoalDurationType.sixMonths: 'six_months',
  GoalDurationType.aYear: 'year',
  GoalDurationType.twoYears: 'two_years',
  GoalDurationType.threeYears: 'three_years',
  GoalDurationType.fiveYears: 'fire_years',
};

Map<GoalDurationType, String> valueGoalDurationTypeMap = {
  GoalDurationType.aWeek: translate('label.a_week'),
  GoalDurationType.twoWeeks: translate('label.two_weeks'),
  GoalDurationType.aMonth: translate('label.a_month'),
  GoalDurationType.threeMonths: translate('label.three_months'),
  GoalDurationType.sixMonths: translate('label.six_months'),
  GoalDurationType.aYear: translate('label.a_year'),
  GoalDurationType.twoYears: translate('label.two_years'),
  GoalDurationType.threeYears: translate('label.three_years'),
  GoalDurationType.fiveYears: translate('label.five_years'),
};

const Map<GoalDurationType, double> intValueGoalDurationTypeMap = {
  GoalDurationType.aWeek: 0.25,
  GoalDurationType.twoWeeks: 0.5,
  GoalDurationType.aMonth: 1,
  GoalDurationType.threeMonths: 3,
  GoalDurationType.sixMonths: 6,
  GoalDurationType.aYear: 12,
  GoalDurationType.twoYears: 24,
  GoalDurationType.threeYears: 36,
  GoalDurationType.fiveYears: 60,
};
