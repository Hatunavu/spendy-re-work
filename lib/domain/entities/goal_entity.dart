import 'package:spendy_re_work/data/model/goal_model.dart';

class GoalEntity {
  String? id;
  String? name;
  String? isoCode;
  int? date;
  int? expiredDate;
  String? category;
  String? duration;
  int? amount;
  int? amountPerMonth;
  String? remarks;
  bool? achieved;
  int? createAt;
  int? lastUpdate;
  String? progressColor;
  double? percentProgress;

  GoalEntity({
    this.id,
    this.name,
    this.isoCode,
    this.date,
    this.expiredDate,
    this.category,
    this.duration,
    this.amount,
    this.amountPerMonth,
    this.remarks,
    this.achieved,
    this.createAt,
    this.lastUpdate,
    this.progressColor,
  });

  factory GoalEntity.normal() => GoalEntity(
      id: '',
      name: '',
      isoCode: '',
      date: 0,
      expiredDate: 0,
      category: '',
      duration: '',
      amount: 0,
      amountPerMonth: 0,
      remarks: '',
      achieved: false,
      createAt: 0,
      lastUpdate: 0,
      progressColor: '');

  GoalModel toModel() => GoalModel(
        id: id,
        name: name,
        isoCode: isoCode,
        date: date,
        expiredDate: expiredDate,
        category: category,
        amount: amount,
        amountPerMonth: amountPerMonth,
        remarks: remarks,
        achieved: achieved,
        createAt: createAt,
        lastUpdate: lastUpdate,
        duration: duration,
        progressColor: progressColor,
      );

  @override
  String toString() {
    return 'GoalEntity{id: $id, name: $name, isoCode: $isoCode, date: $date, expiredDate: $expiredDate, category: $category, duration: $duration, amount: $amount, amountPerMonth: $amountPerMonth, remarks: $remarks, achieved: $achieved, createAt: $createAt, lastUpdate: $lastUpdate, progressColor: $progressColor, percentProgress: $percentProgress}';
  }
}
