import 'package:spendy_re_work/domain/entities/goal_entity.dart';

abstract class GoalRepository {
  Future<String?> createGoal(
      {required String uid, required GoalEntity goalEntity});

  Future<GoalEntity> getGoalById({required String uid, String id});

  Future<bool> updateGoal(
      {required String uid, required GoalEntity goalEntity});

  Future<bool> removeGoal({required String uid, required String goalId});

  Stream listenGoalsRequest({required String uid});

  void loadMoreGoalData({required String uid});
  bool createGoalOffline({String? uid, GoalEntity? goalEntity});
  bool updateGoalOffline({String? uid, GoalEntity? goalEntity});
  void clear();
}
