import 'package:spendy_re_work/data/model/user/setting_model.dart';
import 'package:spendy_re_work/domain/entities/user/security_entity.dart';

class SettingEntity {
  final bool? notification;
  final SecurityEntity? security;

  SettingEntity({this.notification, this.security});

  SettingModel toModel() {
    final securityModel = security?.toModel();
    return SettingModel(notification, securityModel);
  }

  @override
  String toString() {
    return 'SettingEntity{notification: $notification, security: $security}';
  }
}
