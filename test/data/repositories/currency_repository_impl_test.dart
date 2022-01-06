import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:spendy_re_work/common/injector/injector_config.dart';
import 'package:spendy_re_work/data/model/currency_model.dart';

import 'package:spendy_re_work/data/repositories/currency_repositpry_impl.dart';

void main() {
  group("Currency Repository", () {
    test("Get all currencies", () async {
      InjectorConfig.setup();
      final KiwiContainer container = KiwiContainer();
      final CurrencyRepositoryImpl currencyRepositoryImpl = container.resolve<CurrencyRepositoryImpl>();
      final List<CurrencyModel> currencies = await currencyRepositoryImpl.getAllCurrencies();

      expect(currencies[0].isoCode, 'USD');
    });
  });
}