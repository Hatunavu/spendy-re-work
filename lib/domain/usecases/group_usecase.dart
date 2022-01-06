import 'package:spendy_re_work/domain/entities/participant_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/domain/repositories/group_repository.dart';

class GroupUseCase {
  final GroupRepository groupRepository;

  GroupUseCase({required this.groupRepository});

  Future<List<GroupEntity>> getDataGroup(String uid,
      {List<GroupEntity> defaultGroup = const []}) {
    return groupRepository.getDataList(uid, defaultGroup: defaultGroup);
  }

  Future<void> deleteGroups(String uid, String id) async {
    await groupRepository.deleteGroups(uid, id);
  }

  Future<void> addGroups(
      String uid, GroupEntity dataGroup, List participants) async {
    return groupRepository.addGroups(uid, dataGroup, participants);
  }

  Stream getGroups(String uid) {
    return groupRepository.getGroups(uid);
  }

  Future<String> getNameGroup(String uid, String groupID) {
    return groupRepository.getNameGroup(uid, groupID);
  }

  Future<void> updateGroup(String uid, String groupID, GroupEntity groupEntity,
      List dataParticipants, List dataParticipantDeleted) async {
    await groupRepository.updateGroup(uid, groupID, groupEntity.toModel(),
        dataParticipants, dataParticipantDeleted);
  }

  Future<void> updateTotalAmount(
      String uid, String groupID, int newAmount) async {
    await groupRepository.updateTotalAmount(uid, groupID, newAmount);
  }

  Future<List<ParticipantEntity>> getDataParticipantList(
    String uid,
    String groupID,
  ) =>
      groupRepository.getDataParticipantList(
        uid,
        groupID,
      );

  Future createDefaultGroup(String uid, List<GroupEntity> groups) async {
    await groupRepository.createDefaultGroup(uid, groups);
  }

  Future<List<GroupEntity>> getAllGroup(String uid) =>
      groupRepository.getAllGroups(uid);

  Future<List<GroupEntity>> searchGroupWithName(
      String uid, String keyword) async {
    final groups = await getAllGroup(uid);
    final _result = <GroupEntity>[];
    for (final group in groups) {
      if (group.name.toLowerCase().contains(keyword.toLowerCase())) {
        _result.add(group);
      }
    }
    return _result;
  }
}
