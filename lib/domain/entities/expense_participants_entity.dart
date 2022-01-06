import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';

class ExpenseParticipantsEntity {
  List<ParticipantInTransactionEntity>? forWhos;
  List<ParticipantInTransactionEntity>? whoPaids;

  ExpenseParticipantsEntity({this.forWhos, this.whoPaids});
}
