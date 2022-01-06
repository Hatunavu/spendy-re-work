import 'package:spendy_re_work/common/constants/goal_contants.dart';
import 'package:spendy_re_work/common/enums/goal_duration_type.dart';
import 'package:spendy_re_work/domain/entities/goal_entity.dart';
import 'package:spendy_re_work/domain/repositories/category_repository.dart';
import 'package:spendy_re_work/domain/repositories/goal_repository.dart';
import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';

const monthMillisecond = 2629800000;

class GoalUseCase {
  final GoalRepository goalRepository;
  final CategoryRepository? categoryRepository;

  bool _hasMore = true;

  bool get hasMore => _hasMore;

  GoalUseCase({required this.goalRepository, this.categoryRepository});

  Future<bool> updateGoal({String? uid, GoalEntity? goal}) =>
      goalRepository.updateGoal(uid: uid!, goalEntity: goal!);

  Future<bool> removeGoal({String? uid, String? goalID}) =>
      goalRepository.removeGoal(uid: uid!, goalId: goalID!);

  Future<String?> createGoal({String? uid, GoalEntity? goal}) =>
      goalRepository.createGoal(uid: uid!, goalEntity: goal!);

  void initLoad() {
    _hasMore = true;
  }

  int getAmountPerMonth({int? amount, GoalDurationType? durationType}) {
    final double months = intValueGoalDurationTypeMap[durationType]!;
    if (months <= 1) {
      return amount!;
    }
    return (amount! / months).round();
  }

  int? getExpiredDate({int? date, GoalDurationType? durationType}) {
    final DateTime startDate = DateTime.fromMillisecondsSinceEpoch(date!);
    switch (durationType) {
      case GoalDurationType.aWeek:
        return startDate
            .copyWith(day: startDate.day + 7)
            .millisecondsSinceEpoch;
      case GoalDurationType.twoWeeks:
        return startDate
            .copyWith(day: startDate.day + 14)
            .millisecondsSinceEpoch;
      case GoalDurationType.aMonth:
        return startDate
            .copyWith(month: startDate.month + 1)
            .millisecondsSinceEpoch;
      case GoalDurationType.threeMonths:
        return startDate
            .copyWith(month: startDate.month + 3)
            .millisecondsSinceEpoch;
      case GoalDurationType.sixMonths:
        return startDate
            .copyWith(month: startDate.month + 6)
            .millisecondsSinceEpoch;
      case GoalDurationType.aYear:
        return startDate
            .copyWith(year: startDate.year + 1)
            .millisecondsSinceEpoch;
      case GoalDurationType.twoYears:
        return startDate
            .copyWith(year: startDate.year + 2)
            .millisecondsSinceEpoch;
      case GoalDurationType.threeYears:
        return startDate
            .copyWith(year: startDate.year + 3)
            .millisecondsSinceEpoch;
      case GoalDurationType.fiveYears:
        return startDate
            .copyWith(year: startDate.year + 5)
            .millisecondsSinceEpoch;
      default:
        break;
    }
  }

  GoalDurationType? getGoalDurationType({int? date, int? expiredDate}) {
    final int intDuration = ((expiredDate! - date!) / monthMillisecond).round();
    GoalDurationType? durationType;
    intValueGoalDurationTypeMap.forEach((key, value) {
      if (value == intDuration) {
        durationType = key;
      }
    });
    return durationType;
  }

  bool checkAchieved({int? today, int? expiredDate}) => today! >= expiredDate!;

  Stream listenGoalsRequest({String? uid}) =>
      goalRepository.listenGoalsRequest(uid: uid!);

  double getPercentProgress(
      {int? date, int? today, GoalDurationType? durationType}) {
    final int currentProgress = today! - date!;
    final int intDurationType =
        (monthMillisecond * intValueGoalDurationTypeMap[durationType]!).round();
    if (currentProgress > intDurationType) {
      return 1;
    } else {
      return currentProgress / intDurationType;
    }
  }

  void loadMoreGoals({String? uid}) =>
      goalRepository.loadMoreGoalData(uid: uid!);

  bool createGoalOffline({String? uid, GoalEntity? goalEntity}) =>
      goalRepository.createGoalOffline(uid: uid, goalEntity: goalEntity);

  bool updateGoalOffline({String? uid, GoalEntity? goalEntity}) =>
      goalRepository.updateGoalOffline(uid: uid, goalEntity: goalEntity);
  Future<GoalEntity> getGoalById(String uid, String id) =>
      goalRepository.getGoalById(uid: uid, id: id);
  void clear() => goalRepository.clear();
}
