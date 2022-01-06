import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationRepository {
  Future<bool> getPinCodeState();

  Future<void> savePinCodeState(bool isShowing);

  Future<void> removePinCodeState();

  Future<bool> getFirstLogin();

  Future<void> saveFirstLogin(bool firstLogin);

  Future<void> removeFirstLogin();

  Future<void> verifyPhoneNumber(
      {String? phone,
      Duration timeout = const Duration(seconds: 30),
      int? forceResendingToken,
      Function(AuthCredential credential)? completed,
      Function(FirebaseAuthException exception)? failed,
      Function(String verificationId, [int? forceResendingToken])? codeSent,
      Function(String verifyId)? codeTimeOut});

  Future<AuthCredential> verifyOTP(String verificationId, String otpCode);

  Future<UserCredential> signInWithCredential(AuthCredential credential);

  Future<void> firebaseLogOut();

  String getUid();
}
