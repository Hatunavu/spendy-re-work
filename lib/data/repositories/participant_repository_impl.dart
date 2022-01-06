import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendy_re_work/data/datasources/remote/participant_datasource.dart';
import 'package:spendy_re_work/data/model/participant_in_transaction_model.dart';
import 'package:spendy_re_work/domain/entities/filter/date_filter_entity.dart';
import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
import 'package:spendy_re_work/domain/repositories/participant_repository.dart';

class ParticipantRepositoryImpl extends ParticipantRepository {
  ///----------------- OLD VERSION -----------------///
  final ParticipantDataSource participantDataSource;

  ParticipantRepositoryImpl({required this.participantDataSource});

  @override
  Future<List<DocumentReference>> addParticipantList(
          List<ParticipantInTransactionModel> participants) =>
      participantDataSource.addParticipantList(participants);

  @override
  Future<Map<String, ParticipantInTransactionModel>> getParticipantsByNameUser(
          String nameUser) =>
      participantDataSource.getParticipantsByNameUser(nameUser);

  @override
  Future<void> deleteParticipant(List<String> participantIds) =>
      participantDataSource.deleteParticipant(participantIds);

  @override
  Future<ParticipantInTransactionEntity> getParticipantById(String id) =>
      participantDataSource.getParticipantById(id);

  @override
  Future<void> updateParticipantList(
          List<ParticipantInTransactionModel> participantList) =>
      participantDataSource.updateParticipantList(participantList);

  @override
  Future<List<ParticipantInTransactionModel>>
      getListParticipantBetweenSpendTime(
          {String? uid, DateFilter? monthFilter}) {
    throw UnimplementedError();
  }
}
