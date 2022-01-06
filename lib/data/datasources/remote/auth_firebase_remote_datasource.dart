import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AuthCredential> verifyOTP(
      String verificationId, String otpCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otpCode);
      return credential;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    try {
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyPhoneNumber(
      {String? phone,
      int? forceResendingToken,
      Duration timeout = const Duration(seconds: 30),
      Function(AuthCredential credential)? completed,
      Function(FirebaseAuthException exception)? failed,
      Function(String verificationId, int? forceResendingToken)? codeSent,
      Function(String verifyId)? codeTimeOut}) async {
    assert(phone != null && failed != null && codeSent != null,
        'phone,failed and code is sent must not be null');
    await _auth.verifyPhoneNumber(
        phoneNumber: phone!,
        forceResendingToken: forceResendingToken,
        timeout: timeout,
        verificationCompleted:
            completed ?? (PhoneAuthCredential phoneAuthCredential) {},
        verificationFailed: failed!,
        codeSent: codeSent!,
        codeAutoRetrievalTimeout: codeTimeOut ?? (String verificationId) {});
  }

  Future<void> logOutFirebase() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Check logged in
  String getUid() {
    if (_auth.currentUser != null) {
      return _auth.currentUser!.uid;
    }
    return '';
  }
}
