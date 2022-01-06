import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';

class ParticipantInTransactionModel extends ParticipantInTransactionEntity {
  ParticipantInTransactionModel({
    String? uid,
    required String name,
    int? amount,
    int? updateAt,
    required bool isSelected,
  }) : super(
          uid: uid,
          name: name,
          amount: amount,
          updateAt: updateAt,
          isSelected: isSelected,
        );

  factory ParticipantInTransactionModel.fromJson(Map<String, dynamic> json) =>
      ParticipantInTransactionModel(
          uid: json['uid'],
          name: json['name'],
          amount: json['amount'],
          isSelected: json['amount'] != null,
          updateAt: json['update_at']);

  Map<String, dynamic> toJson() {
    return {'uid': id, 'name': name, 'amount': amount, 'update_at': updateAt};
  }
}
