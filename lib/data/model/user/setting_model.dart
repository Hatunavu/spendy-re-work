import 'package:spendy_re_work/data/model/user/security_model.dart';
import 'package:spendy_re_work/domain/entities/user/setting_entity.dart';

class SettingModel extends SettingEntity {
  SettingModel(bool? notification, SecurityModel? security)
      : super(notification: notification, security: security);

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return SettingModel(
      json['notification'],
      SecurityModel.fromJson(
        json['security'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'notification': notification, 'security': security?.toModel().toJson()};
  }
}
