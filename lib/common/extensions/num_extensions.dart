import 'dart:math';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/constants/currency_format_constants.dart';

extension NumExtension on num {
  String formatSimpleCurrency() {
    return CurrencyFormatConstants.formatWithoutDot.format(this);
  }

  String get toStandardized {
    if (this < 10 && -10 < this) {
      return '0$this';
    }
    return toString();
  }

  /// 1 - 4 -> 5 ; 6 - 9 -> 10
  /// 1 101 -> 1 500 ; 1 600 -> 2 000
  /// 11 100 -> 15 000;
  ///
  num ceilForInt() {
    try {
      if (this <= 5) {
        return this;
      }
      final length = toString().length;
      final numberDived = pow(10, length).toInt();
      final numberAfterDiv = this / numberDived;

      if (length == 2 && this % 5 == 0) {
        return this;
      }

      final sNumberDived = numberAfterDiv.toString();

      if (sNumberDived.length == 3) {
        return this;
      }
      if (sNumberDived.length > 3) {
        final secondNumberAfterDot = int.parse(sNumberDived[3]);
        if (secondNumberAfterDot < 5) {
          final newSNumberDived =
              sNumberDived.replaceRange(3, sNumberDived.length, '5');

          final intNumberCeil =
              (double.parse(newSNumberDived) * numberDived).toInt();

          return intNumberCeil;
        } else if (secondNumberAfterDot == 5 &&
            (this % (numberDived / 10) == 0 ||
                this % (numberDived / 100) == 0)) {
          return this;
        }
      } else {
        final intNumberCeil = numberAfterDiv.ceil();
        return intNumberCeil * numberDived;
      }
      final intNumberCeil = (numberAfterDiv * 10).ceil() * (numberDived ~/ 10);

      return intNumberCeil;
    } catch (e) {
      throw Exception('NumExtension - ceilForInt - Error: $e');
    }
  }

  /// 1000 - 999 999 -> 1k - 999K
  /// 1 000 000 - 999 999 999 -> 1M - 999M
  /// 1 000 000 000 - 999 999 999 999 -> 1B - 999B
  String formatMoneyWithChar() {
    final int number = toInt();
    final length = number.toString().length;
    if (length >= 1 && length <= 3) {
      return '$number';
    }

    int numberDiv;
    String character;

    if (length >= 4 && length <= 6) {
      numberDiv = 1000;
      character = 'K';
    } else if (length >= 7 && length <= 9) {
      numberDiv = 1000000;
      character = 'M';
    } else if (length >= 10) {
      numberDiv = 1000000000;
      character = 'B';
    } else {
      throw Exception('Not yet define format of $this');
    }

    final numberDived = ((this / numberDiv * 10).ceil()) / 10;

    return '${numberDived % 1 == 0 ? this ~/ numberDiv : (this / numberDiv).toStringAsFixed(1)}$character';
  }

  DateTime get toDateTimeFromMilliseconds {
    return DateTime.fromMillisecondsSinceEpoch(this as int);
  }

  String get timerNotification {
    double timer = (DateTime.now().millisecondsSinceEpoch - this) / 1000;
    // second
    if (timer < 60) {
      return '${timer.floor()} ${translate('label.seconds_ago')}';
    } else {
      // minutes
      timer = timer / 60;
      if (timer < 60) {
        return '${timer.floor()} ${translate('label.minutes_ago')}';
      } else {
        // hours
        timer = timer / 60;
        if (timer < 24) {
          return '${timer.floor()} ${translate('label.hours_ago')}';
        } else {
          // days
          timer = timer / 24;
          if (timer < 30) {
            return '${timer.floor()} ${translate('label.days_ago')}';
          } else {
            timer = timer / 30;
            if (timer < 12) {
              return '${timer.floor()} ${translate('label.months_ago')}';
            } else {
              timer = timer / 12;
              return '${timer.floor()} ${translate('label.years_ago')}';
            }
          }
        }
      }
    }
  }
}

String convertNumberWithComma(int number) {
  final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  final String Function(Match) mathFunc = (Match match) => '${match[1]},';
  return number.toString().replaceAllMapped(reg, mathFunc);
}
