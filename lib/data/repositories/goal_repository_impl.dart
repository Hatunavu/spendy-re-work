import 'package:spendy_re_work/data/datasources/local/goal_local_data_source.dart';
import 'package:spendy_re_work/data/datasources/remote/goal_remote_datasource.dart';
import 'package:spendy_re_work/data/model/goal_model.dart';
import 'package:spendy_re_work/domain/entities/goal_entity.dart';
import 'package:spendy_re_work/domain/repositories/goal_repository.dart';

class GoalRepositoryImpl implements GoalRepository {
  final GoalRemoteDataSource goalRemoteDataSource;
  final GoalLocalDataSource goalLocalDataSource;

  GoalRepositoryImpl(
      {required this.goalRemoteDataSource, required this.goalLocalDataSource});

  @override
  Future<String?> createGoal({String? uid, GoalEntity? goalEntity}) {
    final GoalModel goalModel = goalEntity!.toModel();
    return goalRemoteDataSource.createGoal(uid: uid, goal: goalModel);
  }

  @override
  Future<GoalEntity> getGoalById({required String uid, String? id}) =>
      goalRemoteDataSource.getGoalById(uid, id!);

  @override
  Future<bool> updateGoal(
      {required String uid, required GoalEntity goalEntity}) {
    final GoalModel goalModel = goalEntity.toModel();
    return goalRemoteDataSource.updateGoal(uid: uid, goal: goalModel);
  }

  @override
  Future<bool> removeGoal({required String uid, required String goalId}) =>
      goalRemoteDataSource.removeGoal(uid: uid, goalID: goalId);

  @override
  Stream listenGoalsRequest({required String uid}) =>
      goalRemoteDataSource.listenToExpensesRealTime(uid: uid);

  @override
  void loadMoreGoalData({required String uid}) =>
      goalRemoteDataSource.requestMoreData(uid: uid);

  @override
  bool createGoalOffline({String? uid, GoalEntity? goalEntity}) {
    final GoalModel goalModel = goalEntity!.toModel();
    return goalLocalDataSource.createGoal(uid: uid, goal: goalModel);
  }

  @override
  bool updateGoalOffline({String? uid, GoalEntity? goalEntity}) {
    final GoalModel goalModel = goalEntity!.toModel();
    return goalLocalDataSource.updateGoal(uid: uid, goal: goalModel);
  }

  @override
  void clear() => goalRemoteDataSource.clear();
}
