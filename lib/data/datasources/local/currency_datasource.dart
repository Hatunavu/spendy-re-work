import 'package:devicelocale/devicelocale.dart';
import 'package:spendy_re_work/data/model/__mock__/currencies.dart';
import 'package:spendy_re_work/data/model/currency_model.dart';

class CurrencyDataSource {
  // void updateCurrentCurrency(Currency newCurrency) {
  //   currentCurrency = newCurrency;
  //   _currencyController.add(currentCurrency);
  // }

  Future<List<CurrencyModel>> getCurrencies() async {
    final currencies = <CurrencyModel>[];
    final mapRes = currenciesMap.map((item) {
      return CurrencyModel.fromJson(item);
    }).toList();
    currencies.addAll(mapRes);
    return currencies;
  }

  Future<String?> getCurrentDeviceLocale() async {
    try {
      //final deviceLocale = await Devicelocale.preferredLanguages;
      return Devicelocale.currentLocale;
    } catch (e) {
      rethrow;
    }
  }

// void setCurrentCurrency(User user) {
//   if (listLocalCurrency != null && listLocalCurrency.isNotEmpty) {
//     for (final Currency currency in listLocalCurrency) {
//       if (user.idCurrency == currency.id) {
//         currentCurrency = currency;
//         _currencyController.add(currency);
//       }
//     }
//   }
}
