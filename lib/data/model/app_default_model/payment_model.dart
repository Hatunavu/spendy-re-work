import 'package:spendy_re_work/domain/entities/app_default_entity/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  PaymentModel({
    final int? type,
    final String? name,
    final int? amount,
    final String? currency,
    final String? description,
    final String? hint,
    final bool? subscription,
  }) : super(
          type: type,
          name: name,
          amount: amount,
          currency: currency,
          description: description,
          hint: hint,
          subscription: subscription,
        );
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      type: json['type'],
      name: json['name'],
      amount: json['amount'],
      currency: json['currency'],
      description: json['description'],
      hint: json['hint'],
      subscription: json['subscription'],
    );
  }
}
