import 'package:spendy_re_work/common/constants/regex_constants.dart';

enum TypeValidator { empty, phone, password, email }

bool phoneNumberValidator(String value) =>
    value.isNotEmpty; //&&value != null &&;
// RegExp(RegexConstants.validPhoneRegex).hasMatch(
//     value.trim().replaceAll(RegexConstants.hasSpaceCharacter, ''));

bool passwordValidator(String value) =>
    //value != null &&
    RegExp(RegexConstants.hasLowerCaseRegex).hasMatch(value.trim()) &&
    RegExp(RegexConstants.hasUpperCaseRegex).hasMatch(value.trim()) &&
    RegExp(RegexConstants.hasDigitRegex).hasMatch(value.trim()) &&
    value.length >= 9;

bool countryCodeValidator(String phoneCode, String value) =>
    //value != null &&
    RegexConstants.phoneNumberCountryCodeRegex(phoneCode).hasMatch(
      value,
    );

bool emailValidator(String currentValue) =>
    //currentValue != null &&
    RegExp(RegexConstants.simpleEmailValidate).hasMatch(currentValue);

bool allNumericValidator(dynamic currentValue) =>
    //currentValue != null &&
    currentValue.isNotEmpty &&
    RegExp(RegexConstants.hasOnlyDigitRegex).hasMatch(currentValue);
