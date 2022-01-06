import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';
import 'package:spendy_re_work/common/utils/age_date_time.dart';
import 'package:spendy_re_work/common/utils/date_time_utils.dart';

void main() {
  group("DateTime extensions", () {
    test("Should set next day", () {
      expect(DateTime.now().tomorrow, DateTime(2020, 11, 12));
      expect(DateTime(2020, 2, 28).tomorrow, DateTime(2020, 2, 29));
      expect(DateTime(2019, 2, 28).tomorrow, DateTime(2019, 3, 1));
      expect(DateTime(2019, 1, 31).tomorrow, DateTime(2019, 2, 1));
      expect(DateTime(2019, 4, 30).tomorrow, DateTime(2019, 5, 1));
      expect(DateTime(2019, 12, 31).tomorrow, DateTime(2020, 1, 1));
    });

    test("Should test previous day", () {
      expect(DateTime.now().yesterday, DateTime(2020, 11, 10));
      expect(DateTime(2020, 3, 1).yesterday, DateTime(2020, 2, 29));
      expect(DateTime(2019, 3, 1).yesterday, DateTime(2019, 2, 28));
      expect(DateTime(2019, 2, 1).yesterday, DateTime(2019, 1, 31));
      expect(DateTime(2019, 5, 1).yesterday, DateTime(2019, 4, 30));
      expect(DateTime(2020, 1, 1).yesterday, DateTime(2019, 12, 31));
    });

    test('should return datetime after add any month', () {
      expect(DateTime.now().addMonth(value: 9), DateTime(2021, 08, 24));
    });

    test('should return datetime after add any day', () {
      expect(DateTime.now().addDay(value: 270), DateTime(2021, 08, 24));
    });

    test('should return difference day from now', () {
      expect(DateTime.now().differenceDay(input: DateTime(2020, 11, 26)), 1);
    });

    test('should return String of Date time', () {
      expect(DateTime.now().toStringDefault, "24/11/2020");
    });

    test('should return text month and number year', () {
      expect(DateTime.now().formatDateMMMyyyy, "Nov, 2020");
    });

    test('should return text month and number day, number year', () {
      expect(DateTime.now().formatDateTextMonth, 'Today');
      expect(DateTime(2020, 10, 29).formatDateTextMonth, '29 Oct 2020');
    });

    test('should return week number from date', () {
      expect(DateTime(2021, 01, 21).weekOfYear, 3);
    });

    test('should return week number from date', () {
      expect(DateTime(2021, 01, 21).weekOfYear, 3);
    });

    test('test age', () {
      DateTime birthday = DateTime(2020, 12, 21);
      DateTime today = DateTime.now();

      double month;
      AgeDuration  age;

      // Find out your age
      age = Age.dateDifference(
          fromDate: birthday, toDate: today, includeToDate: false);
      month = Age.dateDifferenceDoubleMonth(
          fromDate: birthday, toDate: today, includeToDate: false);
      print('Your age is $age'); // Your age is Years: , Months: , Days:
      print('Your month is $month');
    });
  });
}
