import 'package:spendy_re_work/common/constants/shared_preference_keys_constants.dart';
import 'package:spendy_re_work/common/local_preferences/local_preferences.dart';

class AuthLocalDataSource {
  final LocalPreferences localPreferences;

  AuthLocalDataSource({required this.localPreferences});

  // PIN AUTHENTICATION STATE
  Future<bool> getShowAuthPIN() async {
    return await localPreferences.get(SharedPreferenceKeys.pinCodeState) ??
        false;
  }

  Future<bool> saveAuthPINState(bool isShow) async {
    return localPreferences.set(SharedPreferenceKeys.pinCodeState, isShow);
  }

  Future<void> removeAuthPINState() async {
    await localPreferences.remove(SharedPreferenceKeys.pinCodeState);
  }

  // First Login
  Future<void> saveFirstLogin(bool firstLogin) async {
    await localPreferences.set(SharedPreferenceKeys.firstLogin, firstLogin);
  }

  Future<bool> getFirstLogin() async {
    final bool? flag =
        await localPreferences.get(SharedPreferenceKeys.firstLogin);
    return flag ?? false;
  }

  Future<void> removeFirstLogin() async {
    await localPreferences.remove(SharedPreferenceKeys.firstLogin);
  }
}
