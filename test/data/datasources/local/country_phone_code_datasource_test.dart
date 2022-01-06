import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:spendy_re_work/common/constants/shared_preference_keys_constants.dart';

import 'package:spendy_re_work/common/local_preferences/local_preferences.dart';
import 'package:spendy_re_work/data/datasources/local/country_phone_code_datasource.dart';

void main() {
  MockLocalPreferences mockLocalPreferences;
  CountryPhoneCodeDataSource countryPhoneCodeDataSource;

  setUp(() {
    mockLocalPreferences = MockLocalPreferences();
    countryPhoneCodeDataSource =
        CountryPhoneCodeDataSource(mockLocalPreferences);
  });

  final tPhoneCode = '+84';

  test('should return default phone code from local prefs', () async {
    // arrange
    when(mockLocalPreferences.get(any)).thenReturn(tPhoneCode);

    // act
    final result = await countryPhoneCodeDataSource.getDefaultPhoneCode();

    // assert
    verify(mockLocalPreferences.get(SharedPreferenceKeys.defaultPhoneCode));
    expect(result, tPhoneCode);
  });

  test('should cache user id to local prefs', () async {
    // act
    await countryPhoneCodeDataSource.saveDefaultPhoneCode(tPhoneCode);

    // assert
    verify(mockLocalPreferences.set(
        SharedPreferenceKeys.defaultPhoneCode, tPhoneCode));
  });
}
