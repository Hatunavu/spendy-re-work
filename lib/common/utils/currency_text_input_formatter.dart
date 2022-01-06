import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:spendy_re_work/common/constants/string_constants.dart';
import 'package:spendy_re_work/common/extensions/string_validator_extensions.dart';

/// The `symbol` argument is used to symbol of NumberFormat.
/// Put '\$' for symbol
///
/// The `locale` argument is used to locale of NumberFormat.
/// Put 'en' or 'es' for locale
///
/// The `decimalDigits` argument is used to decimalDigits of NumberFormat.
/// Defaults `decimalDigits` is 2.
class CurrencyTextInputFormatter extends TextInputFormatter {
  CurrencyTextInputFormatter({
    this.symbol = '',
    this.locale,
    this.decimalDigits = 2,
  });

  final String symbol;
  final String? locale;
  final int decimalDigits;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newString;

    final format = NumberFormat.currency(
        locale: locale,
        decimalDigits: decimalDigits,
        symbol: '$symbol$spaceCharacterFormat');
    final groupSEPSymbols = format.symbols.GROUP_SEP;

    String newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    final String oldText = oldValue.text.replaceAll(RegExp('[^0-9]'), '');

//    print('>> rawOldText: $rawOldText');
//    print('>> rawNewText: $rawNewText');
//
//    print('oldText: $oldText');
//    print('newText: $newText');
//    print('>>> ${_checkNumberValidator(rawNewText)}');

    final String valueAfterReplace = newValue.text
        .replaceAll(symbol, '')
        .replaceAll(spaceCharacterFormat, '');

    // replace
    // when text no change and the text is money format
    if (newText == oldText &&
        _checkMoneyNumberValid(valueAfterReplace, groupSEPSymbols) &&
        valueAfterReplace.replaceAll(groupSEPSymbols, '').isAllNumeric) {
      newText = newText.substring(0, newText.length - 1);
    }

    if (newText.contains('-')) {
      newText = newText.replaceAll('-', '');
    }

    if (newText.length == 0 && oldText.length == 1) {
      // delete the remaining character
      newString = '';
    } else {
      dynamic newInt = int.parse(newText);
      if (decimalDigits > 0) {
        newInt /= pow(10, decimalDigits);
      }
      newString = format.format(newInt).trim();
    }

//    print('newString: $newString');
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }

  // Check that the input string is in the correct money format
  // ->
  // eg: 1234  | 12,345 | 123,456 | 123,4567 | 12,345,678 | 123,456,789
  bool _checkMoneyNumberValid(String rawNewText, String groupSEPSymbols) {
    if (rawNewText.endsWith(groupSEPSymbols)) {
      return false;
    }

    final arr = rawNewText.split(groupSEPSymbols);

    for (int i = 0; i < arr.length; i++) {
      if (i == 0) {
        if (!(arr[i].length >= 1 && arr[i].length <= 4)) {
          return false;
        }
      } else if (i == arr.length - 1) {
        if (arr[i].length < 3 && arr[i].length > 4) {
          return false;
        }
      } else {
        if (arr[i].length != 3) {
          return false;
        }
      }
    }
    return true;
  }
}
