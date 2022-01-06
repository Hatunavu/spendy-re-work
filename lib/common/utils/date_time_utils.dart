import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';

class DateTimeUtils {
  static int? getMaxDateOfMonth(DateTime? dateTime) {
    if (dateTime != null) {
      return DateTime(dateTime.year, dateTime.month + 1, 0).day;
    }
  }

  static String formatDateTextMonth(DateTime date, {String? languageCode}) {
    if (date.isSameDay(DateTime.now())) {
      return translate('label.today');
    } else if (date.isSameDay(DateTime.now().yesterday)) {
      return translate('label.yesterday');
    }
    return DateFormat('dd MMMM yyyy', languageCode).format(date);
  }

  static String formatHours(DateTime date, {String? languageCode}) {
    return DateFormat('HH:mm', languageCode).format(date);
  }

  static String getStringDate(
      BuildContext context, DateTime dateTime, String pattern) {
    final languageCode = Localizations.localeOf(context).languageCode;

    final formatter = DateFormat(pattern, languageCode);
    final String formatted = formatter.format(dateTime);
    return formatted;
  }
}
