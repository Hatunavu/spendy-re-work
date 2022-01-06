import 'package:spendy_re_work/domain/entities/expense/participant_expense_entity.dart';

class ParticipantExpenseModel extends ParticipantExpenseEntity {
  ParticipantExpenseModel({String? id, String? name, int? amount})
      : super(
          id: id!,
          name: name!,
          amount: amount!,
        );

  factory ParticipantExpenseModel.normal() => ParticipantExpenseModel(
        id: '',
        name: '',
        amount: 0,
      );

  factory ParticipantExpenseModel.fromJson(Map<String, dynamic> json) =>
      ParticipantExpenseModel(
          id: json['id'], name: json['name'], amount: json['amount']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'amount': amount,
      };
}
