import 'package:spendy_re_work/data/datasources/remote/group_remote_datasource.dart';
import 'package:spendy_re_work/domain/entities/participant_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/domain/repositories/group_repository.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource groupRemoteDataSource;

  GroupRepositoryImpl({required this.groupRemoteDataSource});

  @override
  Future<List<GroupEntity>> getDataList(String uid,
      {List<GroupEntity> defaultGroup = const []}) {
    final groups =
        defaultGroup.map((groupEntity) => groupEntity.toModel()).toList();
    return groupRemoteDataSource.groupDefault(uid, defaultGroup: groups);
  }

  @override
  Future<void> deleteGroups(String uid, String id) async {
    await groupRemoteDataSource.deleteGroups(uid, id);
  }

  @override
  Future<void> addGroups(String uid, GroupEntity dataGroup, List participants) {
    return groupRemoteDataSource.addGroups(
        uid, dataGroup.toModel(), participants);
  }

  @override
  Stream getGroups(String uid) {
    return groupRemoteDataSource.getGroups(uid);
  }

  @override
  Future<String> getNameGroup(String uid, String groupID) {
    return groupRemoteDataSource.getNameGroup(uid, groupID);
  }

  @override
  Future<void> updateGroup(String uid, String groupID, GroupEntity groupEntity,
      List dataParticipants, List dataParticipantsDeleted) async {
    await groupRemoteDataSource.updateGroup(
        uid, groupID, groupEntity.toModel(), dataParticipants,
        participantDeleted: dataParticipantsDeleted);
  }

  @override
  Future<void> updateTotalAmount(
      String uid, String groupID, int newAmount) async {
    await groupRemoteDataSource.updateTotalAmount(uid, groupID, newAmount);
  }

  @override
  Future<List<ParticipantEntity>> getDataParticipantList(
    String uid,
    String groupID,
  ) =>
      groupRemoteDataSource.getParticipants(
        uid,
        groupID,
      );

  @override
  Future createDefaultGroup(String uid, List<GroupEntity> groups) async {
    await groupRemoteDataSource.createDefaultGroup(uid, groups);
  }

  @override
  Future<List<GroupEntity>> getAllGroups(String uid) =>
      groupRemoteDataSource.getAllGroup(uid);
}
