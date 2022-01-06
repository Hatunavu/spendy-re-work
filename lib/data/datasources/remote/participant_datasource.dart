import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendy_re_work/common/constants/firebase_storage_constants.dart';
import 'package:spendy_re_work/common/firebase_setup.dart';
import 'package:spendy_re_work/data/model/participant_in_transaction_model.dart';

class ParticipantDataSource {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final SetupFirebaseDatabase setupFirebase;

  ParticipantDataSource({required this.setupFirebase});

  /// ===== CREATE =====
  Future<List<DocumentReference>> addParticipantList(
      List<ParticipantInTransactionModel> participants) async {
    final List<DocumentReference> references = [];
    try {
      for (final ParticipantInTransactionModel participant in participants) {
        final DocumentReference reference = await _fireStore
            .collection(FirebaseStorageConstants.participantCollection)
            .add(participant.toJson());
        references.add(reference);
      }
    } catch (e) {
      throw FirebaseException(
          plugin: 'Spendy',
          message:
              'TransactionRemoteDataSource - addParticipantList - error: ${e.toString()}');
    }
    return references;
  }

  Future<void> updateParticipantList(
      List<ParticipantInTransactionModel> participants) async {
    try {
      for (final ParticipantInTransactionModel participant in participants) {
        await _fireStore
            .collection(FirebaseStorageConstants.participantCollection)
            .doc(participant.id)
            .update(participant.toJson());
      }
    } catch (e) {
      throw FirebaseException(
          plugin: 'Spendy',
          message:
              'TransactionRemoteDataSource - updateParticipantList - error: ${e.toString()}');
    }
  }

  /// ===== GET =====
  Future<Map<String, ParticipantInTransactionModel>> getParticipantsByNameUser(
      String nameUser) async {
    final Map<String, ParticipantInTransactionModel> mapParticipants = {};

    try {
      final snapshot = await _fireStore
          .collection(FirebaseStorageConstants.participantCollection)
          .where(FirebaseStorageConstants.nameField, isEqualTo: nameUser)
          .get();
      log('ParticipantDataSource - getParticipantsByNameUser - data: ${snapshot.size}');

      if (snapshot.size > 0) {
        for (final element in snapshot.docs) {
          mapParticipants[element.id] =
              ParticipantInTransactionModel.fromJson(element.data());
        }
      }
      return mapParticipants;
    } on Exception catch (e) {
      log('GoalRemoteDataSource - getGoalById - err: $e');
      throw FirebaseException(
          plugin: 'Spendy',
          message:
              'GoalRemoteDataSource - getGoalById - error: ${e.toString()}');
    }
  }

  Future<ParticipantInTransactionModel> getParticipantById(
      String partId) async {
    ParticipantInTransactionModel? participant;
    try {
      final snapshot = await _fireStore
          .collection(FirebaseStorageConstants.participantCollection)
          .doc(partId)
          .get();
      if (snapshot.exists) {
        participant = ParticipantInTransactionModel.fromJson(
            snapshot.data() as Map<String, dynamic>);
      }
    } on Exception catch (e) {
      throw FirebaseException(
          plugin: 'Spendy',
          message:
              'GoalRemoteDataSource - getParticipantById - error: ${e.toString()}');
    }
    return participant!;
  }

  /// ===== DELETE =====
  Future<void> deleteParticipant(List<String> participantIds) async {
    for (final String id in participantIds) {
      await _fireStore
          .collection(FirebaseStorageConstants.participantCollection)
          .doc(id)
          .delete();
    }
  }
}
