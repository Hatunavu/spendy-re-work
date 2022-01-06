import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendy_re_work/common/constants/firebase_storage_constants.dart';
import 'package:spendy_re_work/common/firebase_setup.dart';
import 'package:spendy_re_work/data/model/participant_model.dart';
import 'package:spendy_re_work/data/model/user/group_model.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';

class GroupRemoteDataSource {
  GroupRemoteDataSource({required this.setupFirebase});

  final SetupFirebaseDatabase setupFirebase;

  ///----- Get Groups -----////
  final StreamController<List<GroupModel>> _getGroupsController =
      StreamController<List<GroupModel>>.broadcast();

  Future<List<GroupModel>> groupDefault(String uid,
      {final List<GroupModel> defaultGroup = const []}) async {
    final List<GroupModel> listGroups = [];
    try {
      final getDataGroups = await setupFirebase.collectionRef!
          .doc(uid)
          .collection(FirebaseStorageConstants.groupCollection)
          .get();
      if (getDataGroups.docs.isEmpty) {
        await createDefaultGroup(uid, defaultGroup);
      } else {
        for (final doc in getDataGroups.docs) {
          final groupModel = GroupModel.fromJson(doc.data(), doc.id);
          listGroups.add(groupModel);
        }
      }
    } on Exception catch (e) {
      throw FirebaseException(
          plugin: 'Spendy',
          message: 'GroupDataSource - getGroups - error: ${e.toString()}');
    }
    return listGroups;
  }

  Future<void> deleteGroups(String uid, String id) async {
    await setupFirebase.collectionRef!
        .doc(uid)
        .collection(FirebaseStorageConstants.groupCollection)
        .doc(id)
        .delete();
  }

  Future<void> addGroups(
      String uid, GroupModel groupModel, List dataParticipants) async {
    final getDataGroups = await setupFirebase.collectionRef!
        .doc(uid)
        .collection(FirebaseStorageConstants.groupCollection)
        .add(groupModel.toJson());
    final groupID = getDataGroups.id;
    for (final participant in dataParticipants) {
      await _addDataParticipants(uid, groupID, participant.toModel());
    }
  }

  Future<String> getNameGroup(String uid, String groupID) {
    return setupFirebase.collectionRef!
        .doc(uid)
        .collection(FirebaseStorageConstants.groupCollection)
        .doc(groupID)
        .get()
        .then((value) => value['name']);
  }

  Future<void> updateGroup(
      String uid, String groupID, GroupModel groupModel, List dataParticipants,
      {List participantDeleted = const []}) async {
    await setupFirebase.collectionRef!
        .doc(uid)
        .collection(FirebaseStorageConstants.groupCollection)
        .doc(groupID)
        .update(groupModel.toJson());
    if (participantDeleted.isNotEmpty) {
      await _removeDataParticipants(uid, groupID, participantDeleted);
    }
    await _updateDataParticipants(uid, groupID, dataParticipants);
  }

  Future<void> updateTotalAmount(
    String uid,
    String groupID,
    int newAmount,
  ) async {
    await setupFirebase.collectionRef!
        .doc(uid)
        .collection(FirebaseStorageConstants.groupCollection)
        .doc(groupID)
        .update({'total_amount': FieldValue.increment(newAmount)});
  }

  Future<void> _updateDataParticipants(
      String uid, String groupID, List dataParticipants) async {
    for (final dataParticipant in dataParticipants) {
      final participant = dataParticipant.toModel();
      if (participant?.id?.isNotEmpty ?? false) {
        await _setDataParticipants(uid, groupID, participant);
      } else {
        await _addDataParticipants(uid, groupID, participant);
      }
    }
  }

  Future<void> _removeDataParticipants(
      String uid, String groupID, List participantsDeleted) async {
    for (final participantDeleted in participantsDeleted) {
      await setupFirebase.collectionRef!
          .doc(uid)
          .collection(FirebaseStorageConstants.groupCollection)
          .doc(groupID)
          .collection(FirebaseStorageConstants.participantsCollection)
          .doc(participantDeleted.id)
          .delete();
    }
  }

  Future<void> _setDataParticipants(String uid, String groupID,
      ParticipantModel participantGroupModel) async {
    await setupFirebase.collectionRef!
        .doc(uid)
        .collection(FirebaseStorageConstants.groupCollection)
        .doc(groupID)
        .collection(FirebaseStorageConstants.participantsCollection)
        .doc(participantGroupModel.id)
        .set(participantGroupModel.toModel().toJson(), SetOptions(merge: true));
  }

  Future<void> _addDataParticipants(String uid, String groupID,
      ParticipantModel participantGroupModel) async {
    final ref = setupFirebase.collectionRef!
        .doc(uid)
        .collection(FirebaseStorageConstants.groupCollection)
        .doc(groupID)
        .collection(FirebaseStorageConstants.participantsCollection)
        .doc();
    await ref.set(ParticipantModel(name: participantGroupModel.name, id: ref.id)
        .toJson());
  }

  Future<void> createDefaultGroup(
      String uid, List<GroupEntity> defaultGroups) async {
    final batch = FirebaseFirestore.instance.batch();
    final collectionRef = setupFirebase.collectionRef!
        .doc(uid)
        .collection(FirebaseStorageConstants.groupCollection);
    for (final group in defaultGroups) {
      batch.set(collectionRef.doc(), group.toModel().toJson());
    }
    return batch.commit();
  }

  Future<List<ParticipantModel>> getParticipants(
    String uid,
    String groupID,
  ) async {
    final participants = <ParticipantModel>[];
    final getParticipants = await setupFirebase.collectionRef!
        .doc(uid)
        .collection(FirebaseStorageConstants.groupCollection)
        .doc(groupID)
        .collection(FirebaseStorageConstants.participantsCollection)
        .get();
    for (final participant in getParticipants.docs) {
      final participantModel =
          ParticipantModel.fromJson(participant.data(), participant.id);
      participants.add(participantModel);
    }
    return participants;
  }

  Stream getGroups(String uid) {
    _querryGetParticipantData(uid);
    return _getGroupsController.stream;
  }

  void _querryGetParticipantData(String uid) {
    setupFirebase.collectionRef!
        .doc(uid)
        .collection(FirebaseStorageConstants.groupCollection)
        .snapshots()
        .listen(
      (event) {
        final dataGroups = event.docs
            .map(
                (snapshot) => GroupModel.fromJson(snapshot.data(), snapshot.id))
            .toList();

        _getGroupsController.sink.add(dataGroups);
      },
    );
  }

  void dispose() {
    _getGroupsController.close();
  }

  Future<List<GroupModel>> getAllGroup(String uid) async {
    final groupDocs = await setupFirebase.collectionRef
        ?.doc(uid)
        .collection(FirebaseStorageConstants.groupCollection)
        .get();
    var groups = <GroupModel>[];
    if (groupDocs != null && groupDocs.docs.isNotEmpty) {
      groups = groupDocs.docs
          .map((snapshot) => GroupModel.fromJson(snapshot.data(), snapshot.id))
          .toList();
    }
    return groups;
  }
}
