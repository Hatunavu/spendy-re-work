import 'package:spendy_re_work/data/model/app_default_model/payment_model.dart';
import 'package:spendy_re_work/domain/entities/app_default_entity/app_default_entity.dart';

class AppDefaultModel extends AppDefaultEntity {
  AppDefaultModel({
    String? version,
    List<PaymentModel>? payments,
  }) : super(version: version, payments: payments);

  factory AppDefaultModel.fromJson(Map<String, dynamic> json) {
    return AppDefaultModel(
      version: json['min_version'],
      payments: (json['payments'] as List)
          .map((e) => PaymentModel.fromJson(e))
          .toList(),
    );
  }
}
