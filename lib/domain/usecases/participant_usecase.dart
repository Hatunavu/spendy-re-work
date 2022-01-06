import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendy_re_work/data/model/participant_in_transaction_model.dart';
import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
import 'package:spendy_re_work/domain/repositories/participant_repository.dart';

class ParticipantUseCase {
  final ParticipantRepository participantRepository;

  ParticipantUseCase({required this.participantRepository});

  ///----------------- OLD VERSION -----------------///

  /// ===== CREATE =====
  Future<List<String>> addParticipantList(
      List<ParticipantInTransactionEntity> participantEntities) async {
    List<DocumentReference> refs = [];
    final List<ParticipantInTransactionModel> participantModels =
        toModel(participantEntities);
    refs = await participantRepository.addParticipantList(participantModels);
    final List<String> refsId = await _getRefId(refs);
    return refsId;
  }

  /// map list participant entity to list name participant
  Future<List<String>> mapListNameParticipant(
      List<ParticipantInTransactionEntity> participantEntities) async {
    final List<String> list = [];
    for (final element in participantEntities) {
      list.add(element.name);
    }
    return list;
  }

  /// ===== UPDATE =====
  Future<List<String>> updateParticipantList(
      {Map<String, String>? partIdMap,
      List<ParticipantInTransactionEntity>? currentPartEntities,
      Map<String, ParticipantInTransactionEntity>? oldPartEntityMap}) async {
    // Update Old Participant
    for (final String name in partIdMap!.keys.toList()) {
      final String id = partIdMap[name]!;
      oldPartEntityMap![name]!.id = id;
    }
    final List<ParticipantInTransactionModel> oldParticipantModels =
        toModel(oldPartEntityMap!.values.toList());
    await participantRepository.updateParticipantList(oldParticipantModels);

    // Add New Participant
    final List<ParticipantInTransactionEntity> newParticipantEntities = [];
    for (int index = oldPartEntityMap.length;
        index < currentPartEntities!.length;
        index++) {
      newParticipantEntities.add(currentPartEntities[index]);
    }
    final List<String> newParticipantIds =
        await addParticipantList(newParticipantEntities);
    final List<String> allPartIds = partIdMap.values.toList()
      ..addAll(newParticipantIds);
    return allPartIds;
  }

  /// ===== GET =====
  Future<ParticipantInTransactionEntity> getParticipantById(String id) =>
      participantRepository.getParticipantById(id);

  Future<List<ParticipantInTransactionEntity>> getParticipantListById(
      List<String> participantIds) async {
    final List<ParticipantInTransactionEntity> participantEntities = [];
    for (final String id in participantIds) {
      final ParticipantInTransactionEntity participantInTransactionEntity =
          await getParticipantById(id);
      participantEntities.add(participantInTransactionEntity);
    }
    return participantEntities;
  }

  /// ===== DELETE =====

  Future<void> deleteParticipantList(List<String> participantIds) =>
      participantRepository.deleteParticipant(participantIds);

  /// ===== OTHER =====
  Future<Map<String, ParticipantInTransactionEntity>> convertListToMap(
      List<ParticipantInTransactionEntity>? participantEntities) async {
    final Map<String, ParticipantInTransactionEntity>
        participantInTransactionEntityMap = {};
    if (participantEntities != null && participantEntities.isNotEmpty) {
      for (final ParticipantInTransactionEntity participantInTransactionEntity
          in participantEntities) {
        participantInTransactionEntityMap[participantInTransactionEntity.name] =
            participantInTransactionEntity;
      }
    }
    return participantInTransactionEntityMap;
  }

  List<ParticipantInTransactionModel> toModel(
      List<ParticipantInTransactionEntity> partEntities) {
    final List<ParticipantInTransactionModel> partModels = [];

    for (final participant in partEntities) {
      partModels.add(participant.toParticipantInTransactionModel());
    }
    return partModels;
  }

  Future<List<String>> _getRefId(List<DocumentReference> refs) async {
    final List<String> refIds = [];
    for (final DocumentReference ref in refs) {
      refIds.add(ref.id);
    }
    return refIds;
  }

  // Future<bool> checkPersonalExpense({
  //   Map<String, ParticipantInTransactionEntity>? whoPaidMap,
  //   Map<String, ParticipantInTransactionEntity>? forWhoMap,
  //   UserEntity? user,
  // }) async {
  //   final bool isPersonalWhoPaid =
  //       await _isUser(participants: whoPaidMap!.values.toList(), user: user!);
  //   final bool isPersonalForWho =
  //       await _isUser(participants: forWhoMap!.values.toList(), user: user);
  //   if (isPersonalWhoPaid && isPersonalForWho) {
  //     return true;
  //   }
  //   return false;
  // }

  // Future<bool> _isUser({
  //   List<ParticipantInTransactionEntity>? participants,
  //   UserEntity? user,
  // }) async {
  //   bool isPersonal = false;
  //   final List<ParticipantInTransactionEntity> participantPaidList =
  //       await _getParticipantPaidList(participants: participants!);
  //   if (participantPaidList.isNotEmpty &&
  //       participantPaidList.length == 1 &&
  //       participantPaidList[0].name == user!.fullName) {
  //     isPersonal = true;
  //   }
  //   return isPersonal;
  // }

  // Future<List<ParticipantInTransactionEntity>> _getParticipantPaidList({
  //   List<ParticipantInTransactionEntity>? participants,
  // }) async {
  //   final List<ParticipantInTransactionEntity> participantPaidList = [];
  //   for (final ParticipantInTransactionEntity participant in participants!) {
  //     if (participant.isPaid) {
  //       participantPaidList.add(participant);
  //     }
  //   }
  //   return participantPaidList;
  // }

  /// Key: part name
  /// Value: part id
  Future<Map<String, String>> getParticipantIdMap(
      List<ParticipantInTransactionEntity> participants) async {
    final Map<String, String> partIdMap = {};
    for (final ParticipantInTransactionEntity part in participants) {
      partIdMap[part.name] = part.id!;
    }
    return partIdMap;
  }

  // Future<int> getForWhoGroup(
  //     List<ParticipantInTransactionEntity> partEntities) async {
  //   int group = 0;
  //   for (final ParticipantInTransactionEntity partEntity in partEntities) {
  //     if (partEntity.isPaid) {
  //       group++;
  //     }
  //   }
  //   return group;
  // }
}
