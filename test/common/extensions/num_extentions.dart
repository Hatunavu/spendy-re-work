import 'package:flutter_test/flutter_test.dart';

import 'package:spendy_re_work/common/extensions/num_extensions.dart';

void main(){
  group('ceilForInt()', (){
    final tNumber = 210;
    final expectNumber = 250;

    test('should return int number is ceiled from original int number', (){
      final result = tNumber.ceilForInt();
      expect(result, expectNumber);
    });
  });


  group('formatMoneyWithChar()', (){
    final tNumber = 24560000;
    final expectNumber = "24.6 M";

    test('should return String format of number with char', (){
      final result = tNumber.formatMoneyWithChar();
      expect(result, expectNumber);
      expect(300000000.toInt().formatMoneyWithChar(), '300 M');
    });
  });
}