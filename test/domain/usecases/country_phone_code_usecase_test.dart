import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:spendy_re_work/domain/repositories/__mocks__/country_phone_code_repository_mock.dart';

import 'package:spendy_re_work/domain/usecases/country_phone_code_usecase.dart';

void main() {
  MockCountryPhoneCodeRepository codeRepository;
  CountryPhoneCodeUseCase countryPhoneCodeUseCase;

  setUp(() {
    codeRepository = MockCountryPhoneCodeRepository();
    countryPhoneCodeUseCase =
        CountryPhoneCodeUseCase(codeRepository: codeRepository);
  });

  final tPhoneCode = '+84';

  test('should return string of default phone code', () async {
    when(codeRepository.getDefaultPhoneCode())
        .thenAnswer((_) async => tPhoneCode);
    final actual = await countryPhoneCodeUseCase.getDefaultPhoneCode();

    verify(codeRepository.getDefaultPhoneCode());
    expect(actual, tPhoneCode);
  });

  test('should call save default phone code method', () async {
    await countryPhoneCodeUseCase.saveDefaultPhoneCode(tPhoneCode);

    verify(codeRepository.saveDefaultPhoneCode(tPhoneCode));
  });
}
