import 'package:spendy_re_work/data/model/expense/participant_expense_model.dart';

class ParticipantExpenseEntity {
  String? id;
  String? name;
  int? amount;

  ParticipantExpenseEntity({this.id, this.name, this.amount});

  factory ParticipantExpenseEntity.normal() => ParticipantExpenseEntity(
        id: '',
        amount: 0,
      );

  ParticipantExpenseModel toModel() => ParticipantExpenseModel(
        id: id,
        name: name,
        amount: amount,
      );
}
