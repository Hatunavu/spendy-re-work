import 'package:spendy_re_work/data/model/user/user_model.dart';
import 'package:spendy_re_work/domain/entities/user/setting_entity.dart';

class UserEntity {
  String? uid;
  String? phoneNumber;
  String? fullName;
  String? avatar;
  String? isoCode;
  int? createAt;
  int? lastUpdate;
  bool rateApp;
  SettingEntity? setting;

  UserEntity(
      {this.uid,
      this.phoneNumber,
      this.fullName,
      this.isoCode,
      this.avatar,
      this.createAt,
      this.lastUpdate,
      this.rateApp = false,
      this.setting});

  UserEntity update(
          {String? uid,
          String? phoneNumber,
          String? fullName,
          String? avatar,
          String? isoCode,
          int? createAt,
          bool? isDefault,
          int? lastUpdate,
          bool? rateApp,
          SettingEntity? setting}) =>
      UserEntity(
          uid: uid ?? this.uid,
          phoneNumber: phoneNumber ?? this.phoneNumber,
          fullName: fullName ?? this.fullName,
          avatar: avatar ?? this.avatar,
          isoCode: isoCode ?? this.isoCode,
          createAt: createAt ?? this.createAt,
          lastUpdate: lastUpdate ?? this.lastUpdate,
          rateApp: rateApp ?? this.rateApp,
          setting: setting ?? this.setting);

  UserModel toModel() {
    return UserModel(
        uid: uid,
        phoneNumber: phoneNumber,
        fullName: fullName,
        lastUpdate: lastUpdate,
        createAt: createAt,
        avatar: avatar,
        isoCode: isoCode,
        rateApp: rateApp,
        setting: setting?.toModel());
  }

  @override
  String toString() {
    return 'UserEntity{uid: $uid, phoneNumber: $phoneNumber, fullName: $fullName, avatar: $avatar, isoCode: $isoCode, createAt: $createAt, lastUpdate: $lastUpdate, rateApp: $rateApp, setting: $setting}';
  }
}
