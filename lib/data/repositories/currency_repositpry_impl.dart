import 'package:spendy_re_work/data/datasources/local/currency_datasource.dart';
import 'package:spendy_re_work/data/model/currency_model.dart';
import 'package:spendy_re_work/domain/repositories/currency_repository.dart';

class CurrencyRepositoryImpl extends CurrencyRepository {
  final CurrencyDataSource currencyDataSource;

  CurrencyRepositoryImpl({required this.currencyDataSource});
  @override
  Future<List<CurrencyModel>> getAllCurrencies() =>
      currencyDataSource.getCurrencies();

  @override
  Future<String?> getCurrentDeviceLocale() =>
      currencyDataSource.getCurrentDeviceLocale();
}
