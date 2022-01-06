import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';

void main() {
  group("Test String Extensions", () {
    test('Should format int to currency', () {
      expect("1000000".formatStringToCurrency(), "\$ 1,000,000");
    });

    test('Should format currency to int', () {
      expect("\$ 1,000,000".formatCurrencyToString(), '1000000');
    });

    test('Should convert string to color', () {
      expect('123456'.toColor(), Color(0xff123456));
    });
  });
}