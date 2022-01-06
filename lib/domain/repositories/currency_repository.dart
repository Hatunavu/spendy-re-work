import 'package:spendy_re_work/data/model/currency_model.dart';

abstract class CurrencyRepository {
  Future<List<CurrencyModel>> getAllCurrencies();

  Future<String?> getCurrentDeviceLocale();
}
