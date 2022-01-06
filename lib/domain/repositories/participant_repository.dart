import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendy_re_work/data/model/participant_in_transaction_model.dart';
import 'package:spendy_re_work/domain/entities/filter/date_filter_entity.dart';
import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';

abstract class ParticipantRepository {
  ///----------------- OLD Version -----------------///
  Future<List<DocumentReference>> addParticipantList(
      List<ParticipantInTransactionModel> participants);

  Future<Map<String, ParticipantInTransactionModel>> getParticipantsByNameUser(
      String nameUser);

  Future<void> deleteParticipant(List<String> participantIds);

  Future<ParticipantInTransactionEntity> getParticipantById(String id);

  Future<void> updateParticipantList(
      List<ParticipantInTransactionModel> participantList);

  Future<List<ParticipantInTransactionEntity>>
      getListParticipantBetweenSpendTime(
          {String? uid, DateFilter? monthFilter});
}
