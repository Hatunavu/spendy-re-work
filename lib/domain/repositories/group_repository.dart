import 'package:spendy_re_work/domain/entities/participant_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';

abstract class GroupRepository {
  Future<List<GroupEntity>> getDataList(String uid,
      {List<GroupEntity> defaultGroup = const []});
  Future<void> deleteGroups(String uid, String id);
  Future<void> addGroups(String uid, GroupEntity dataGroup, List participants);

  Stream getGroups(String uid);
  Future<String> getNameGroup(String uid, String groupID);
  Future<void> updateGroup(String uid, String groupID, GroupEntity groupEntity,
      List dataParticipants, List dataParticipantsDeleted);
  Future<void> updateTotalAmount(String uid, String groupID, int newAmount);
  Future<List<ParticipantEntity>> getDataParticipantList(
    String uid,
    String groupID,
  );
  Future createDefaultGroup(String uid, List<GroupEntity> groups);

  Future<List<GroupEntity>> getAllGroups(String uid);
}
