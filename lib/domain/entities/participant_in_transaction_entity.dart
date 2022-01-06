import 'package:spendy_re_work/data/model/participant_in_transaction_model.dart';
import 'package:spendy_re_work/domain/entities/participant_entity.dart';

class ParticipantInTransactionEntity extends ParticipantEntity {
  int? amount;
  bool isSelected;
  bool isEdit;
  final int? updateAt;
  ParticipantInTransactionEntity(
      {String? uid,
      required String name,
      this.amount,
      this.updateAt,
      required this.isSelected,
      this.isEdit = false})
      : super(id: uid, name: name);

  ParticipantInTransactionModel toParticipantInTransactionModel() {
    return ParticipantInTransactionModel(
        uid: id,
        name: name,
        amount: amount,
        updateAt: updateAt,
        isSelected: isSelected);
  }

  @override
  String toString() {
    return 'ParticipantInTransactionEntity(uid: $id, name: $name, amount: $amount, isSelected: $isSelected, isEdit: $isEdit, updateAt: $updateAt)\n';
  }
}
