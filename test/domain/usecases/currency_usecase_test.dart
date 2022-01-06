import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';

import 'package:spendy_re_work/common/injector/injector_config.dart';
import 'package:spendy_re_work/domain/usecases/currency_usecase.dart';

void main() {
  group("Currency Use Case", () {
    test("Get all currencies", () async {
      InjectorConfig.setup();
      final KiwiContainer container = KiwiContainer();
      final CurrencyUseCase currencyUseCase =
          container.resolve<CurrencyUseCase>();
      await currencyUseCase.getAllCurrencies();

      expect(currencyUseCase.currencies[0].isoCode, 'USD');
    });
  });
}
