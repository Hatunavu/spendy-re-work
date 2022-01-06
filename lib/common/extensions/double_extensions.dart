import 'package:intl/intl.dart';
import 'package:spendy_re_work/domain/entities/currency_entity.dart';

extension DoubleExtension on double {
  String formatCurrency(
    CurrencyEntity currency, {
    int digit = 0,
    bool showSymbol = true,
  }) {
    final formatter = NumberFormat.currency(
      locale: 'vi',
      symbol: showSymbol ? currency.code : '',
      decimalDigits: digit,
    );
    return formatter.format(this);
  }

  double get compactDouble => (this * 10).ceil() / 10;
}
