import 'package:spendy_re_work/domain/repositories/country_phone_code_repository.dart';

class CountryPhoneCodeUseCase {
  final CountryPhoneCodeRepository codeRepository;

  CountryPhoneCodeUseCase({required this.codeRepository});

  Future<String> getDefaultPhoneCode() async =>
      codeRepository.getDefaultPhoneCode();

  Future<bool> saveDefaultPhoneCode(String phoneCode) =>
      codeRepository.saveDefaultPhoneCode(phoneCode);
}
