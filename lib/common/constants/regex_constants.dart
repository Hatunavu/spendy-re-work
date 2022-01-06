class RegexConstants {
  static const String hasSpaceOrCommaCharacter = r'[\s|,|.]';
  static const String hasDigitRegex = r'[0-9]';
  static const String hasLowerCaseRegex = r'[a-z]';
  static const String hasUpperCaseRegex = r'[A-Z]';
  static const String alphabetRegex = r'[a-zA-Z]';
  static const String validPhoneBook =
      r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]';
  static const String validPhoneRegex =
      r'^[0-9]{9,17}$'; //Phone number should be in range 8 to 17 chars
  static const String hasSpaceCharacter =
      r' '; //Phone number should be in range 3 to 15 chars
  static const String validEmailRegex =
      r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'; // I got Regex pattern from this https://stackoverflow.com/a/50663835
  static const String hasOnlyDigitRegex = r'^[0-9]*$';
  static const String hasOnlyAlphabetsRegex = r'^[a-zA-Z]*$';
  static const String hasOnlyAlphabetsAndNumbersRegex = r'^[a-zA-Z0-9]*$';
  static const String hasOnlyAlphanumericWithAtLeastOneAlphabetRegex =
      r'^\d*[a-zA-Z][a-zA-Z0-9]*$';
  static const String hasSpecialCharacterRegex = r'[\W_]';
  static const String hexcolor = r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$';
  static const String numericRegex = r'^-?[0-9]+$';
  static const String checkSpecialCharForPhoneNumber = '[-()\\s]';

  static RegExp phoneNumberCountryCodeRegex(String phoneCode) {
    final code = phoneCode.replaceAll('+', '');
    return RegExp(r'^(0|\+*' + code + r')');
  }

  static const String phoneNumberCompanyRegex =
      r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[\s\ 0-9]*$';
  static const String checkContactNameWithLastIndex = r'\((\d+).$';
  static const String phonePrefix = r'(0|\+62)';
  static const String eKTPRegex = r'^[0-9]{16}$';
  static const String pipeline = r'|';
  static const String simpleEmailValidate = r'@{1}\w+\.+';
  static const String onlyDateRegex =
      r'(^(((0[1-9]|1[0-9]|2[0-8])([\-]|[\.])(0[1-9]|1[012]))|((29|30|31)([\-]|[\.])(0[13578]|1[02]))|((29|30)([\-]|[\.])(0[4,6,9]|11)))([\-]|[\.])(19|[2-9][0-9])\d\d$)|(^29([\-]|[\.])02([\-]|[\.])(19|[2-9][0-9])(00|04|08|12|16|20|24|28|32|36|40|44|48|52|56|60|64|68|72|76|80|84|88|92|96)$)';
}
