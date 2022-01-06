import 'package:spendy_re_work/common/constants/shared_preference_keys_constants.dart';
import 'package:spendy_re_work/common/constants/string_constants.dart';
import 'package:spendy_re_work/common/local_preferences/local_preferences.dart';

class CountryPhoneCodeDataSource {
  final LocalPreferences localPreferences;

  CountryPhoneCodeDataSource(this.localPreferences);

  Future<String> getDefaultPhoneCode() async {
    return await localPreferences.get(SharedPreferenceKeys.defaultPhoneCode) ??
        defaultPhoneCodeConstant;
  }

  Future<bool> saveDefaultPhoneCode(String phoneCode) async {
    return localPreferences.set(
        SharedPreferenceKeys.defaultPhoneCode, phoneCode);
  }
}
