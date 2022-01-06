import 'package:spendy_re_work/data/model/user/security_model.dart';
import 'package:spendy_re_work/data/model/user/setting_model.dart';
import 'package:spendy_re_work/domain/entities/user/user_entity.dart';

class UserModel extends UserEntity {
  UserModel(
      {String? uid,
      String? phoneNumber,
      String? fullName,
      String? isoCode,
      String? avatar,
      int? createAt,
      int? lastUpdate,
      bool? rateApp,
      SettingModel? setting})
      : super(
            uid: uid,
            phoneNumber: phoneNumber,
            fullName: fullName,
            avatar: avatar,
            isoCode: isoCode,
            createAt: createAt,
            lastUpdate: lastUpdate,
            rateApp: rateApp ?? false,
            setting: setting);

  factory UserModel.createNewUser({
    String? isoCode,
    String? uid,
    String? phoneNumber,
  }) =>
      UserModel(
        uid: uid,
        fullName: '',
        avatar: '',
        phoneNumber: phoneNumber,
        isoCode: isoCode,
        rateApp: false,
        createAt: DateTime.now().millisecondsSinceEpoch,
        lastUpdate: DateTime.now().millisecondsSinceEpoch,
        setting: SettingModel(
          false,
          SecurityModel(false, false, ''),
        ),
      );

  UserModel.fromJson(Map<String, dynamic> json, String uid) {
    uid = json['uid'];
    phoneNumber = json['phone_number'];
    fullName = json['full_name'] ?? '';
    avatar = json['avatar'] ?? '';
    isoCode = json['iso_code'];
    createAt = json['create_at'];
    lastUpdate = json['last_update'];
    rateApp = json['rate_app'];
    setting = SettingModel.fromJson(json['setting']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['uid'] = uid;
    data['phone_number'] = phoneNumber;
    data['full_name'] = fullName;
    data['avatar'] = avatar;
    data['iso_code'] = isoCode;
    data['create_at'] = createAt;
    data['last_update'] = lastUpdate;
    data['rate_app'] = rateApp;
    data['setting'] = setting?.toModel().toJson();
    return data;
  }
}
