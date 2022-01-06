class SettleDebtModel {
  String payerName;
  String payeeName;
  double debtAmount;

  SettleDebtModel(
      {required this.payerName,
      required this.payeeName,
      required this.debtAmount});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['payeeName'] = payeeName;
    data['payerName'] = payerName;

    data['debtAmount'] = debtAmount;
    return data;
  }
}
