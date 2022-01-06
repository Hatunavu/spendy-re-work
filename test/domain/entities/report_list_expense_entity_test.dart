import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toMapWithKeyMonth', () {
    final dateSelected = DateTime.now();
    var test = LinkedHashMap<int, int>();
    test[12] = 0;
    test[1] = 0;
    test[2] = 0;
    test[3] = 0;
    test[4] = 0;
    test[5] = 0;
    test[6] = 0;
    test[7] = 0;
    test[8] = 0;
    test[9] = 0;
    test[10] = 0;
    test[11] = 15;

    var map = LinkedHashMap<int, int>();
    for (int i = 12; i >0; i--) {
      debugPrint('date: ${dateSelected.subMonth(value: i).toString()}');
      debugPrint('key: ${dateSelected.subMonth(value: i).month.toString()}');
      map[dateSelected.subMonth(value: i).month] = 0;
    }

    for (int i = 5; i >0; i--) {
        map[11] +=3;
    }

    debugPrint('test: ${test.toString()}');
    debugPrint('map: ${map.toString()}');
    expect(map, test);
  });
}
