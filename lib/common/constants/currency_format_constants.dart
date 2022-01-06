import 'package:intl/intl.dart';

class CurrencyFormatConstants {
  static final formatSimple = NumberFormat.simpleCurrency();
  static final formatWithoutDot = NumberFormat('#,##0', 'en_US');
  static final formatMoneyDot = NumberFormat('#.##0', 'en_US');
}
