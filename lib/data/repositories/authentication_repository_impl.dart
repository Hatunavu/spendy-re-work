import 'package:firebase_auth/firebase_auth.dart';
import 'package:spendy_re_work/common/exceptions/network_exception.dart';
import 'package:spendy_re_work/common/network/network_info.dart';
import 'package:spendy_re_work/data/datasources/local/auth_local_datasource.dart';
import 'package:spendy_re_work/data/datasources/remote/auth_firebase_remote_datasource.dart';
import 'package:spendy_re_work/data/datasources/remote/user_remote_datasource.dart';
import 'package:spendy_re_work/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final NetworkInfo networkInfo;
  final FirebaseAuthRemoteDataSource authDataSource;
  final UserRemoteDataSource userRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthenticationRepositoryImpl(
      {required this.authDataSource,
      required this.networkInfo,
      required this.authLocalDataSource,
      required this.userRemoteDataSource});

  @override
  Future<void> verifyPhoneNumber(
      {String? phone,
      int? forceResendingToken,
      Duration timeout = const Duration(seconds: 30),
      Function(AuthCredential credential)? completed,
      Function(FirebaseAuthException exception)? failed,
      Function(String verificationId, [int? forceResendingToken])? codeSent,
      Function(String verifyId)? codeTimeOut}) async {
    await authDataSource.verifyPhoneNumber(
        codeSent: codeSent!,
        codeTimeOut: codeTimeOut,
        forceResendingToken: forceResendingToken,
        completed: completed,
        failed: failed,
        phone: phone,
        timeout: timeout);
  }

  @override
  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    if (await networkInfo.isConnected) {
      return authDataSource.signInWithCredential(credential);
    } else {
      throw NoInternetException();
    }
  }

  @override
  Future<AuthCredential> verifyOTP(
      String verificationId, String otpCode) async {
    if (await networkInfo.isConnected) {
      return authDataSource.verifyOTP(verificationId, otpCode);
    } else {
      throw NoInternetException();
    }
  }

  @override
  Future<void> firebaseLogOut() async {
    if (await networkInfo.isConnected) {
      await authDataSource.logOutFirebase();
    } else {
      throw NoInternetException();
    }
  }

  @override
  Future<bool> getPinCodeState() => authLocalDataSource.getShowAuthPIN();

  @override
  Future<void> removePinCodeState() => authLocalDataSource.removeAuthPINState();

  @override
  Future<void> savePinCodeState(bool isShowing) =>
      authLocalDataSource.saveAuthPINState(isShowing);

  @override
  String getUid() => authDataSource.getUid();

  @override
  Future<bool> getFirstLogin() => authLocalDataSource.getFirstLogin();

  @override
  Future<void> removeFirstLogin() => authLocalDataSource.removeFirstLogin();

  @override
  Future<void> saveFirstLogin(bool firstLogin) =>
      authLocalDataSource.saveFirstLogin(firstLogin);
}
