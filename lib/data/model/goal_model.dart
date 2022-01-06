import 'package:spendy_re_work/domain/entities/goal_entity.dart';

class GoalModel extends GoalEntity {
  GoalModel({
    String? id,
    String? name,
    String? duration,
    String? isoCode,
    int? date,
    int? expiredDate,
    String? category,
    int? amount,
    int? amountPerMonth,
    String? remarks,
    bool? achieved,
    int? createAt,
    int? lastUpdate,
    String? progressColor,
  }) : super(
          id: id,
          name: name,
          isoCode: isoCode,
          date: date,
          expiredDate: expiredDate,
          duration: duration,
          category: category,
          amount: amount,
          amountPerMonth: amountPerMonth,
          remarks: remarks,
          achieved: achieved,
          createAt: createAt,
          lastUpdate: lastUpdate,
          progressColor: progressColor,
        );

  factory GoalModel.fromJson(
          {required Map<String, dynamic> json, String? id}) =>
      GoalModel(
        id: id,
        name: json['name'],
        isoCode: json['iso_code'],
        date: json['date'],
        expiredDate: json['expired_date'],
        duration: json['duration'],
        category: json['category'],
        amount: json['amount'],
        amountPerMonth: json['amount_per_month'],
        remarks: json['remarks'],
        achieved: json['achieved'],
        createAt: json['create_at'],
        lastUpdate: json['last_update'],
        progressColor: json['progress_color'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date,
        'iso_code': isoCode,
        'expired_date': expiredDate,
        'category': category,
        'amount': amount,
        'amount_per_month': amountPerMonth,
        'duration': duration,
        'remarks': remarks,
        'achieved': achieved,
        'create_at': createAt,
        'last_update': lastUpdate,
        'progress_color': progressColor ?? '',
      };
}
