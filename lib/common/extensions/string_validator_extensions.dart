import 'package:spendy_re_work/common/constants/regex_constants.dart';
import 'package:spendy_re_work/common/utils/validator_utils.dart';

extension StringValidatorExtensions on String {
  bool get hasOnlyWhitespaces => trim().isEmpty && isNotEmpty;

  bool get isEmptyOrNull {
    // if (this == null) {
    //   return true;
    // }
    return isEmpty;
  }

  bool get isNotNullAndEmpty => isNotNullOrEmpty;

  bool get isNotNullOrEmpty => isNotEmpty && isNotEmpty;

  bool get isNullOrEmpty => isEmpty; //(this ?? '').isEmpty;

  bool get isPhoneNumber {
    if (isNotEmpty && isNotEmpty && this[0] == '+') {
      return phoneNumberValidator(substring(1));
    }
    return phoneNumberValidator(this);
  }

  bool get isAllNumeric => allNumericValidator(this);

  bool hasPhoneNumberCountryCode(String phoneCode) =>
      isNotEmpty &&
      RegexConstants.phoneNumberCountryCodeRegex(phoneCode).hasMatch(trim());

  bool get isEmail => isNotNullAndEmpty && emailValidator(this);

  bool get isPassword => isNotNullAndEmpty && passwordValidator(this);
}
