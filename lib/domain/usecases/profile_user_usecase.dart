import 'package:spendy_re_work/data/model/user/user_model.dart';
import 'package:spendy_re_work/domain/entities/user/security_entity.dart';
import 'package:spendy_re_work/domain/entities/user/user_entity.dart';
import 'package:spendy_re_work/domain/repositories/user_repository.dart';
import 'package:spendy_re_work/domain/usecases/authentication_usecase.dart';

class ProfileUserUseCase {
  final UserRepository userRepo;
  final AuthenticationUseCase authenticationUseCase;

  ProfileUserUseCase(
      {required this.userRepo, required this.authenticationUseCase});

  Future<UserEntity?> getUserProfile(String uid) async {
    final UserEntity? userEntity = await userRepo.getUser(uid);
    //if (userEntity != null)
    userEntity?.uid = uid;
    return userEntity;
  }

  /// If user enable Biometric Auth, PassCode must enable
  /// If user disable PassCode, Biometric Auth will disable too
  Future<SecurityEntity> mapCurrentUserSettings(
      {String? uid,
      SecurityEntity? settings,
      SecurityEntity? currentSettings}) async {
    if (currentSettings!.isPin! && !settings!.isPin! ||
        !currentSettings.isBio! && settings!.isBio!) {
      return SecurityEntity.defaultSecurity();
    }
    // else if (!currentSettings.isBio! && settings!.isBio!) {
    //   return SecurityEntity.defaultSecurity();
    // }
    else {
      return settings!;
    }
  }

  /// Check in local storage
  /// After enable/disable Pass Code Setting, passCode in Local Storage will change,
  /// so isPassCode value in this Function, is OLD Pass Code Setting
  /// If currentPassCode == false => Push to Enter Pin Code
  /// If isPassCode == false => Push to Create Pin Code
  // Future<String> pushRouteName(SecuritySettingsEntity currentUserSetting) async {
  //   bool isPassCode = await authenticationUseCase.checkHasPin();
  //   if ((isPassCode &&
  //           currentUserSetting.passCode &&
  //           currentUserSetting.biometricAuth) ||
  //       (isPassCode &&
  //           currentUserSetting.passCode &&
  //           !currentUserSetting.biometricAuth) ||
  //       (isPassCode &&
  //           !currentUserSetting.passCode &&
  //           !currentUserSetting.biometricAuth))
  //     return RouteList.enterPIN;
  //   else if ((!isPassCode &&
  //           currentUserSetting.passCode &&
  //           currentUserSetting.biometricAuth) ||
  //       (!isPassCode &&
  //           currentUserSetting.passCode &&
  //           !currentUserSetting.biometricAuth))
  //     return RouteList.createDevicePIN;
  //   return '';
  // }
  Future<void> updateProfile(UserEntity userEntity) async {
    final UserModel userModel = userEntity.toModel();
    await userRepo.updateUser(userEntity.uid!, userModel);
  }
}
