import 'dart:io';
import 'package:intl/intl.dart';
import 'package:spendy_re_work/common/extensions/string_validator_extensions.dart';
import 'package:spendy_re_work/domain/entities/currency_entity.dart';
import 'package:spendy_re_work/domain/repositories/currency_repository.dart';

/// @Singleton
class CurrencyUseCase {
  final CurrencyRepository currencyRepository;

  List<CurrencyEntity> currencies = [];
  Map<String, Set<CurrencyEntity>> mapAlphaBet = {};
  CurrencyEntity? _currency;

  CurrencyUseCase({required this.currencyRepository});

  Future<List<CurrencyEntity>> getAllCurrencies() =>
      currencyRepository.getAllCurrencies();

  Future<CurrencyEntity> getCurrentCurrency() async {
    mapAlphaBet = await _getCurrencyAlphaBet();
    return _currency!;
  }

  String _getDeviceCurrencyName() {
    final format = NumberFormat.simpleCurrency(locale: Platform.localeName);
    return format.currencyName!;
  }

  CurrencyEntity setDefaultCurrency({String? isoCode}) {
    String tempIso = isoCode ?? '';
    if (tempIso.isNullOrEmpty) {
      tempIso = _getDeviceCurrencyName();
    }
    _currency = currencies
        .where((element) => element.isoCode!.contains(tempIso))
        .toList()[0];
    return _currency!;
  }

  Future<Map<String, Set<CurrencyEntity>>> _getCurrencyAlphaBet() async {
    if (currencies.isEmpty) {
      currencies = await currencyRepository.getAllCurrencies();
    }
    if (_currency == null) {
      setDefaultCurrency();
    }

    mapAlphaBet['popular'] = currencies.sublist(0, 8).toSet();
    for (final CurrencyEntity currency in currencies) {
      final firstCharacter = currency.name![0];
      if (mapAlphaBet[firstCharacter] == null) {
        mapAlphaBet[firstCharacter] = {};
      }
      mapAlphaBet[firstCharacter]!.add(currency);
    }
    return mapAlphaBet;
  }

  CurrencyEntity? get currency => _currency;

  void cleanCurrency() {
    _currency = null;
  }

  Future<CurrencyEntity> getCurrency(
      {List<CurrencyEntity>? currencies, String? isoCode}) async {
    for (final CurrencyEntity currency in currencies!) {
      if (currency.isoCode == isoCode) {
        return currency;
      }
    }
    return currencies[0];
  }
}
