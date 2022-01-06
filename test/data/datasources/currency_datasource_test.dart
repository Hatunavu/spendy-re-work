import 'package:flutter_test/flutter_test.dart';
import 'package:spendy_re_work/data/datasources/local/currency_datasource.dart';
import 'package:spendy_re_work/data/model/currency_model.dart';

void main() {
  group("Currency Data Source", () {
    test("Should get all currencies data", () async {
      final CurrencyDataSource currencyDataSource = CurrencyDataSource();
      final List<CurrencyModel> currencies = await currencyDataSource.getCurrencies();
      expect(currencies[0].isoCode, 'USD');
    });
  });
}
