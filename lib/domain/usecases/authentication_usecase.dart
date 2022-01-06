import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';
import 'package:spendy_re_work/domain/entities/user/user_entity.dart';
import 'package:spendy_re_work/domain/repositories/authentication_repository.dart';
import 'package:spendy_re_work/domain/repositories/currency_repository.dart';
import 'package:spendy_re_work/domain/repositories/user_repository.dart';

import '../../data/model/user/user_model.dart';

class AuthenticationUseCase {
  final AuthenticationRepository authRepo;
  final CurrencyRepository currencyRepository;
  final UserRepository userRepo;

  final LocalAuthentication auth = LocalAuthentication();

  AuthenticationUseCase({
    required this.authRepo,
    required this.userRepo,
    required this.currencyRepository,
  });

  /// ===== PIN CODE =====
  // Future<void> createPin(String pin) async {
  //   final userId = authRepo.getUid();
  //   authRepo.saveUserPIN(userId, pin);
  // }
  // Future<bool> checkHasPin() async {
  //   final userId = authRepo.getUid();
  //   if (userId == null) {
  //     return false;
  //   }
  //   return await authRepo.getUserPIN(userId) == null ? false : true;
  // }
  // Future<bool> authPin(String input) async {
  //   final userId = authRepo.getUid();
  //   final pin = await authRepo.getUserPIN(userId);
  //   return pin == input ? true : false;
  // }
  Future<bool> pinAuthIsShowing() async => authRepo.getPinCodeState();

  Future<void> savePinAuthState(bool isShowing) => authRepo.savePinCodeState(isShowing);

  Future<void> removePinAuthState() => authRepo.removePinCodeState();

  /// ===== LOGIN - LOGOUT ======
  Future<void> logOut() async {
    await authRepo.removePinCodeState();
    await authRepo.firebaseLogOut();
  }

  // verify phone number is called before verify OTP
  // include completed callback function to handle
  Future verifyPhoneNumber(
      {String? phone,
      Duration timeout = const Duration(seconds: 30),
      int? forceResendingToken,
      Function(AuthCredential credential)? completed,
      Function(FirebaseAuthException exception)? failed,
      Function(String verificationId, [int? forceResendingToken])? codeSent,
      Function(String verifyId)? codeTimeOut}) async {
    await authRepo.verifyPhoneNumber(
        phone: phone,
        forceResendingToken: forceResendingToken,
        codeSent: codeSent,
        codeTimeOut: codeTimeOut,
        completed: completed,
        failed: failed,
        timeout: timeout);
  }

  // return UserEntity
  // if UserEntity is null -> failed
  Future<UserEntity?> verifyOTP(String verificationId, String otpCode, String phoneCode) async {
    // verify otp
    final AuthCredential? authCredential = await authRepo.verifyOTP(verificationId, otpCode);
    if (authCredential != null) {
      return signIn(authCredential, phoneCode);
    }
    return null;
  }

  // this function is called only when verifyOTP is successful
  Future<UserEntity?> signIn(AuthCredential authCredential, String phoneCode) async {
    // sign in with credential /// return user data
    final UserCredential userCredential = await authRepo.signInWithCredential(authCredential);
    final User? user = userCredential.user;
    if (user != null) {
      return _getUserProfile(user, phoneCode);
    }
    return null;
  }

  Future<UserEntity?> _getUserProfile(User user, String phoneCode) async {
    // get user profile from uid
    UserEntity? userEntity = await userRepo.getUser(user.uid);
    if (userEntity == null) {
      // create new user
      userEntity = await _createNewUser(user.uid, user.phoneNumber!, phoneCode);
      await userRepo.addUserToFirebase(user.uid, userEntity.toModel());
      return userEntity;
    }
    return userEntity;
  }

  Future<UserModel> _createNewUser(String uid, String phoneNumber, String phoneCode) async {
    final isoCode = (await currencyRepository.getAllCurrencies())[1].isoCode; // VND
    return UserModel.createNewUser(
      uid: uid,
      phoneNumber: phoneNumber.formatPhoneNumber(phoneCode: phoneCode),
      isoCode: isoCode,
    );
  }

  /// BIOMETRIC AUTHENTICATION
  Future<bool?> checkBiometrics() => auth.canCheckBiometrics;

  Future<BiometricType> getAvailableBiometrics() async {
    List<BiometricType>? availableBiometrics;
    availableBiometrics = await auth.getAvailableBiometrics();
    return availableBiometrics[0];
  }

  Future<bool> authenticate() => auth.authenticate(
      localizedReason: 'Scan your fingerprint or face id to authenticate',
      useErrorDialogs: true,
      stickyAuth: true);

  // Future<bool> checkBioAuth(String uid) async {
  //   final SecuritySettingsEntity setting = await userSettingsUseCase.getSecuritySettings(uid);
  //   return setting.biometricAuth;
  // }
  String getUid() => authRepo.getUid();

  Future<bool> getFirstLogin() => authRepo.getFirstLogin();

  Future<void> saveFirstLogin(bool firstLogin) => authRepo.saveFirstLogin(firstLogin);

  Future<void> deleteFirstLogin() => authRepo.removeFirstLogin();
}
