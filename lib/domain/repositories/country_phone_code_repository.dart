abstract class CountryPhoneCodeRepository {
  Future<bool> saveDefaultPhoneCode(String phoneCode);
  Future<String> getDefaultPhoneCode();
}
