import 'package:spendy_re_work/data/datasources/local/country_phone_code_datasource.dart';
import 'package:spendy_re_work/domain/repositories/country_phone_code_repository.dart';

class CountryPhoneCodeRepositoryImpl extends CountryPhoneCodeRepository {
  final CountryPhoneCodeDataSource countryPhoneCodeDataSource;

  CountryPhoneCodeRepositoryImpl({required this.countryPhoneCodeDataSource});

  @override
  Future<String> getDefaultPhoneCode() async =>
      countryPhoneCodeDataSource.getDefaultPhoneCode();

  @override
  Future<bool> saveDefaultPhoneCode(String phoneCode) async {
    return countryPhoneCodeDataSource.saveDefaultPhoneCode(phoneCode);
  }
}
