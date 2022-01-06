import 'package:spendy_re_work/domain/entities/app_default_entity/payment_entity.dart';

class AppDefaultEntity {
  final String? version;
  final List<PaymentEntity>? payments;

  AppDefaultEntity({this.version, this.payments});
}
