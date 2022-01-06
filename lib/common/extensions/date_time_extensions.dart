import 'package:intl/intl.dart';
import 'package:spendy_re_work/common/constants/date_time_constants.dart';
import 'package:spendy_re_work/common/constants/date_time_format_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_constants.dart';

List<int> months31 = [1, 3, 5, 7, 8, 10, 12];

extension DateTimeExtensions on DateTime {
  DateTime get yesterday {
    final DateModel dateModel = DateModel(day: day, month: month, year: year);

    final bool isLeapYear = dateModel.isLeapYear();

    if (dateModel.day == 1) {
      switch (dateModel.month) {
        case 1:
          return dateModel.previousYear();
        case 3:
          if (isLeapYear) {
            return dateModel.previousLeapMonth();
          }
          return dateModel.previousMonth28();
        case 2:
        case 4:
        case 6:
        case 9:
        case 11:
          return dateModel.previousMonth31();
        default:
          return dateModel.previousDay();
      }
    } else {
      return dateModel.previousDay();
    }
  }

  bool isOldMonth(DateTime dateTime) {
    return year < dateTime.year ||
        (year == dateTime.year && month < dateTime.month);
  }

  bool isThisMonth(DateTime dateTime) {
    return year == dateTime.year && month == dateTime.month;
  }

  DateTime startOfWeek() {
    final result = subtract(Duration(days: weekday - 1));
    return DateTime(result.year, result.month, result.day);
  }

  DateTime endOfWeek() {
    final result = add(Duration(days: DateTime.daysPerWeek - weekday));
    return DateTime(result.year, result.month, result.day);
  }

  String get toStringDefault {
    final formatter = DateFormat(DateTimeConstants.datePattern);
    final String formatted = formatter.format(this);
    return formatted;
  }

  // March, 2021
  String toStringddMMMyyyy(String languageCode) {
    final formatter =
        DateFormat(DateTimeFormatConstants.timeddMMMyyyy, languageCode);
    final String formatted = formatter.format(this);
    return formatted;
  } // March, 2021

  // March, 2021
  String toStringMMMyyyy(String languageCode) {
    final formatter =
        DateFormat(DateTimeFormatConstants.timeMMMyyyy, languageCode);
    final String formatted = formatter.format(this);
    return formatted;
  } // March, 2021

  String get toStringMMM {
    final formatter = DateFormat(DateTimeFormatConstants.month);
    final String formatted = formatter.format(this);
    return formatted;
  }

  // 03 2021
  String get toStringMMyyyy {
    final formatter = DateFormat(DateTimeFormatConstants.timeMMMyyyy);
    final String formatted = formatter.format(this);
    return formatted;
  }

  DateTime addMonth({int? value}) {
    assert(value != null, 'a must not be null');
    final DateTime newDate = DateTime(year, month + value!, day);
    return newDate;
  }

  DateTime subMonth({int? value}) {
    assert(value != null, 'a must not be null');
    final DateTime newDate = DateTime(year, month - value!, day);
    return newDate;
  }

  DateTime addDay({int? value}) {
    assert(value != null, 'a must not be null');
    final newDate = DateTime(year, month, day + value!);
    return newDate;
  }

  DateTime subDay({int? value}) {
    assert(value != null, 'a must not be null');
    final newDate = DateTime(year, month, day - value!);
    return newDate;
  }

  DateTime get dateTimeYmd {
    return DateTime(year, month, day);
  }

  int get intYmd => DateTime(year, month, day).millisecondsSinceEpoch;

  DateTime get lastDayOfMonth {
    return DateTime(year, month + 1, 0);
  }

  DateTime get firstDayOfMonth {
    return DateTime(year, month, 1);
  }

  DateTime get firstDayMonthOfOneYearBefore {
    return DateTime(year, month - 11, 1);
  }

  DateTime get firstDayOfYear {
    return DateTime(year, 1, 1);
  }

  DateTime get lastDayOfYear {
    return DateTime(year + 1, 1, 1);
  }

  int differenceDay({DateTime? input}) {
    assert(input != null, 'a must not be null');
    final result = input!.difference(this).inDays;
    return result;
  }

  int get earlyMonth => DateTime(year, month, 1).millisecondsSinceEpoch;

  int? get endMonth {
    const int millisecondLastDay = 86400000 - 1;
    switch (month) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        return DateTime(year, month, 31).millisecondsSinceEpoch +
            millisecondLastDay;
      case 4:
      case 6:
      case 9:
      case 11:
        return DateTime(year, month, 30).millisecondsSinceEpoch +
            millisecondLastDay;
      case 2:
        if (year % 4 == 0 && year % 100 != 0) {
          return DateTime(year, month, 29).millisecondsSinceEpoch +
              millisecondLastDay;
        } else {
          return DateTime(year, month, 28).millisecondsSinceEpoch +
              millisecondLastDay;
        }
    }
  }

  DateTime get tomorrow {
    final DateModel dateModel = DateModel(day: day, month: month, year: year);
    final bool isLeapYear = dateModel.isLeapYear();

    switch (dateModel.day) {
      case 28:
        if (month == 2 && isLeapYear) {
          return dateModel.nextDay();
        }
        return dateModel.nextMonth();
      case 29:
        if (month == 2) {
          return dateModel.nextMonth();
        } else {
          return dateModel.nextDay();
        }
      case 30:
        if (months31.contains(month)) {
          return dateModel.nextDay();
        } else {
          return dateModel.nextMonth();
        }
      case 31:
        if (month == 12) {
          return dateModel.nextYear();
        }
        return dateModel.nextMonth();
      default:
        return dateModel.nextDay();
    }
  }

  // 01 Mar 2021
  String get formatDateTextMonth {
    if (isSameDay(DateTime.now())) {
      return 'Today';
    } else if (isSameDay(DateTime.now().yesterday)) {
      return 'Yesterday';
    }
    return DateFormat('dd MMM yyyy').format(this);
  }

  String get formatDate {
    if (dateTimeYmd == DateTime.now().dateTimeYmd) {
      return 'Today';
    } else if (yesterday == DateTime.now().yesterday) {
      return 'Yesterday';
    }
    return DateFormat('dd.MM.yyyy').format(this);
  }

  // Mar, 2021
  String formatDateMMMyyyy(String languageCode) {
    return DateFormat('MMM, yyyy', languageCode).format(this);
  }

  String get formatHours => DateFormat('HH:mm').format(this);
  String formatTransactionTime(TransactionTimeFormat type) {
    switch (type) {
      case TransactionTimeFormat.date:
        return formatDateTextMonth;
      case TransactionTimeFormat.time:
        return formatHours;
    }
  }

  DateTime get formatDMY => DateTime(year, month, day);

  /// The ISO 8601 week of year [1..53].
  ///
  /// Algorithm from https://en.wikipedia.org/wiki/ISO_week_date#Algorithms
  int get weekOfYear {
    // Add 3 to always compare with January 4th, which is always in week 1
    // Add 7 to index weeks starting with 1 instead of 0
    final woy = (ordinalDate - weekday + 10) ~/ 7;

    // If the week number equals zero, it means that the given date belongs to the preceding (week-based) year.
    if (woy == 0) {
      // The 28th of December is always in the last week of the year
      return DateTime(year - 1, 12, 28).weekOfYear;
    }

    // If the week number equals 53, one must check that the date is not actually in week 1 of the following year
    if (woy == 53 &&
        DateTime(year, 1, 1).weekday != DateTime.thursday &&
        DateTime(year, 12, 31).weekday != DateTime.thursday) {
      return 1;
    }

    return woy;
  }

  /// The ordinal date, the number of days since December 31st the previous year.
  ///
  /// January 1st has the ordinal date 1
  ///
  /// December 31st has the ordinal date 365, or 366 in leap years
  int get ordinalDate {
    const offsets = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    return offsets[month - 1] + day + (isLeapYear && month > 2 ? 1 : 0);
  }

  /// True if this date is on a leap year.
  bool get isLeapYear {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }

  int get currentTimer {
    final int year = this.year;
    final int month = this.month;
    final int day = this.day;
    final DateTime mDay = DateTime(year, month, day);
    final currentTimerMs = millisecondsSinceEpoch - mDay.millisecondsSinceEpoch;
    return currentTimerMs;
  }

  DateTime copyWith(
      {int? year,
      int? month,
      int? day,
      int? hour,
      int? minute,
      int? second,
      int? millisecond,
      int? microsecond}) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
  bool isSameDay(DateTime compareDay) {
  if (year == compareDay.year &&
      month == compareDay.month &&
      day == compareDay.day) {
    return true;
  }
  return false;
}
}

class DateModel {
  int? day;
  int? month;
  int? year;

  DateModel({this.day, this.month, required this.year});

  DateTime nextDay() {
    final int nextDay = day! + 1;
    return DateTime(year!, month!, nextDay);
  }

  DateTime previousDay() {
    final int previousDay = day! - 1;
    return DateTime(year!, month!, previousDay);
  }

  DateTime nextMonth() {
    day = 1;
    final int nextMonth = month! + 1;
    return DateTime(year!, nextMonth, day!);
  }

  DateTime previousMonth31() {
    day = 31;
    final int previousMonth31 = month! - 1;
    return DateTime(year!, previousMonth31, day!);
  }

  DateTime previousMonth30() {
    final int previousMonth30 = month! - 1;
    day = 30;
    return DateTime(year!, previousMonth30, day!);
  }

  DateTime previousLeapMonth() {
    month = 2;
    day = 29;
    return DateTime(year!, month!, day!);
  }

  DateTime previousMonth28() {
    month = 2;
    day = 28;
    return DateTime(year!, month!, day!);
  }

  DateTime nextYear() {
    day = 1;
    month = 1;
    final int nextYear = year! + 1;
    return DateTime(nextYear, month!, day!);
  }

  DateTime previousYear() {
    day = 31;
    month = 12;
    final int previousYear = year! - 1;
    return DateTime(previousYear, month!, day!);
  }

  bool isLeapYear() {
    return year! % 4 == 0 && (year! % 100 != 0 || year! % 400 == 0);
  }
}


