import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:spendy_re_work/common/constants/regex_constants.dart';
import 'package:spendy_re_work/common/constants/string_constants.dart';
import 'package:spendy_re_work/common/extensions/string_validator_extensions.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/domain/entities/currency_entity.dart';
import 'package:spendy_re_work/domain/usecases/currency_usecase.dart';

extension StringExtensions on String {
  String removeExtraCharacters() {
    final value = this;
    final int length = value.length;
    if (value.toLowerCase().contains(' (me)')) {
      return value.substring(0, length - 5);
    }
    return value;
  }

  String toSpaceSeparated() {
    final value = replaceAllMapped(RegExp(r'.{4}'), (match) => '${match.group(0)} ');
    return value;
  }

  String addPrefixPhoneNumber(String phoneCode) {
    if (isEmpty) {
      return '';
    }
    return hasPhoneNumberCountryCode(phoneCode)
        ? replaceAll(
            RegexConstants.phoneNumberCountryCodeRegex(phoneCode),
            phoneCode,
          )
        : '$phoneCode$this';
  }

  String get preparePhoneNumberString {
    const int firstSpaceCharacterIndex = 4;
    const int secondSpaceCharacterIndex = 8;

    final int newTextLength = length;
    final StringBuffer newText = StringBuffer();
    int usedSubstringIndex = 0;

    if (newTextLength >= firstSpaceCharacterIndex) {
      usedSubstringIndex = firstSpaceCharacterIndex - 1;
      newText.write('${substring(0, usedSubstringIndex)} ');
    }

    if (newTextLength >= secondSpaceCharacterIndex) {
      usedSubstringIndex = secondSpaceCharacterIndex - 1;
      const startIndex = firstSpaceCharacterIndex - 1;
      newText.write('${substring(startIndex, usedSubstringIndex)} ');
    }

    // Add the rest to new text
    if (newTextLength >= usedSubstringIndex) {
      newText.write(substring(usedSubstringIndex));
    }
    return newText.toString();
  }

  String get formatPhoneFirebase {
    //if(this != null)
    if (isNotEmpty) {
      if (this[0] == '0') {
        return substring(1);
      }
      // remove all white space in string
      return replaceAll(RegExp(r'\s+\b|\b\s'), '');
    }
    return '';
  }

  String formatPhoneNumber({String? phoneCode}) {
    final int phoneCodeLength = (phoneCode != null && phoneCode.isNotEmpty) ? phoneCode.length : 3;
    if (isEmpty) {
      return '';
    }
    // ignore: lines_longer_than_80_chars
    return '(${substring(0, phoneCodeLength)}) ${substring(phoneCodeLength, length)}';
  }

  double toPrice(CurrencyEntity currency) =>
      NumberFormat.currency(locale: currency.locale ?? 'vi').parse(this).toDouble();

  String formatStringToCurrency({
    CurrencyEntity? currencyEntity,
    bool haveSymbol = true,
  }) {
    CurrencyEntity? currency;
    final currencyUseCase = Injector.resolve<CurrencyUseCase>();
    currency = currencyEntity ?? currencyUseCase.currency;
    if (currency == null) {
      return '';
    }
    final currencyFormat = NumberFormat.currency(
      locale: currency.locale,
      decimalDigits: 0,
      symbol: haveSymbol ? '${currency.code}$spaceCharacterFormat' : '',
    );
    final dynamic newInt = int.parse(this);
    return currencyFormat.format(newInt).trim();
  }

  String formatCurrencyToString({CurrencyEntity? currencyEntity}) {
    CurrencyEntity? currency;
    final currencyUseCase = Injector.resolve<CurrencyUseCase>();
    currency = currencyEntity ?? currencyUseCase.currency;
    if (currency == null) {
      return '';
    }
    if (contains('.') || contains(',') || contains(currency.code!)) {
      return replaceAll('.', '')
          .replaceAll(',', '')
          .replaceAll(' ', '')
          .replaceAll(currency.code!, '');
    }
    return this;
  }

  Color toColor() {
    final String valueString = this; // kind of hacky..
    final int value = int.parse('0x$valueString');
    return Color(value);
  }

  String get shortenedName {
    // final convertName = this
    //         .trim()
    //         ?.split(' ')
    //         ?.map((e) => e.isNotEmpty ? e.substring(0, 1) : '')
    //         ?.toList() ??
    //     [];
    final convertName =
        trim().split(' ').map((e) => e.isNotEmpty ? e.substring(0, 1) : '').toList();
    if (convertName.length > 2) {
      return '${convertName.first}${convertName.last}'.toUpperCase();
    } else {
      return '${convertName.join('')}'.toUpperCase();
    }
  }

  String get capitalize {
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  int? get toInt {
    return int.parse(this);
  }
}
