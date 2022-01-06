import 'dart:math';

part 'strings_en_us.dart';
part 'strings_zh_cn.dart';
part 'strings_pt_br.dart';
part 'strings_id.dart';
part 'strings_ar_eg.dart';
part 'strings_es.dart';
part 'strings_ro.dart';
part 'strings_bn.dart';
part 'strings_bs.dart';
part 'strings_ar.dart';
part 'strings_jp.dart';
part 'strings_ru.dart';
part 'strings_de.dart';
part 'strings_ko.dart';
part 'strings_it.dart';
part 'strings_hu.dart';
part 'strings_hr.dart';
part 'strings_uk.dart';
part 'strings_tr.dart';
part 'strings_vi.dart';
part 'strings_fr.dart';
part 'strings_sr_cyr.dart';
part 'strings_sr_lat.dart';
part 'strings_nl.dart';

abstract class _StringsI18n {
  const _StringsI18n();

  /// Get the done widget text
  String getDoneText();

  /// Get the cancel widget text
  String getCancelText();

  /// Get the name of month
  List<String> getMonths();

  /// Get the short name of month
  List<String> getMonthsShort();

  /// Get the full name of week
  List<String> getWeeksFull();

  /// Get the short name of week
  List<String> getWeeksShort();
}

enum DateTimePickerLocale {
  /// English (EN) United States
  enUS,

  /// Chinese (ZH) Simplified
  zhCn,

  /// Portuguese (PT) Brazil
  ptBr,

  /// Indonesia (ID)
  id,

  /// Spanish (ES)
  es,

  /// Turkish (TR)
  tr,

  /// French (FR)
  fr,

  /// Romanian (RO)
  ro,

  /// Bengali (BN)
  bn,

  /// Bosnian (BS)
  bs,

  /// Arabic (ar)
  ar,

  /// Arabic (ar) Egypt
  arEg,

  /// Japanese (JP)
  jp,

  /// Russian (RU)
  ru,

  /// German (DE)
  de,

  /// Korea (KO)
  ko,

  /// Italian (IT)
  it,

  /// Hungarian (HU)
  hu,

  /// Croatian (HR)
  hr,

  /// Ukrainian (UK)
  uk,

  /// Vietnamese (VN)
  vi,

  /// Serbia (sr) Cyrillic
  srCyrl,

  /// Serbia (sr) Latin
  srLatn,

  /// Dutch (NL)
  nl,
}

/// Default value of date locale
const DateTimePickerLocale dateTimePickerLocaleDefault =
    DateTimePickerLocale.enUS;

const Map<DateTimePickerLocale, _StringsI18n> datePickerI18n = {
  DateTimePickerLocale.enUS: _StringsEnUs(),
  DateTimePickerLocale.zhCn: _StringsZhCn(),
  DateTimePickerLocale.ptBr: _StringsPtBr(),
  DateTimePickerLocale.id: _StringsId(),
  DateTimePickerLocale.arEg: _StringsArEg(),
  DateTimePickerLocale.es: _StringsEs(),
  DateTimePickerLocale.fr: _StringsFr(),
  DateTimePickerLocale.ro: _StringsRo(),
  DateTimePickerLocale.bn: _StringsBn(),
  DateTimePickerLocale.bs: _StringsBs(),
  DateTimePickerLocale.ar: _StringsAr(),
  DateTimePickerLocale.jp: _StringsJp(),
  DateTimePickerLocale.ru: _StringsRu(),
  DateTimePickerLocale.de: _StringsDe(),
  DateTimePickerLocale.ko: _StringsKo(),
  DateTimePickerLocale.it: _StringsIt(),
  DateTimePickerLocale.hu: _StringsHu(),
  DateTimePickerLocale.hr: _StringsHr(),
  DateTimePickerLocale.uk: _StringsUk(),
  DateTimePickerLocale.tr: _StringsTr(),
  DateTimePickerLocale.vi: _StringsVn(),
  DateTimePickerLocale.srCyrl: _StringsSrCyrillic(),
  DateTimePickerLocale.srLatn: _StringsSrLatin(),
  DateTimePickerLocale.nl: _StringsNl(),
};

class DatePickerI18n {
  /// Get done button text
  static String getLocaleDone(DateTimePickerLocale locale) {
    final _StringsI18n? i18n =
        datePickerI18n[locale] ?? datePickerI18n[dateTimePickerLocaleDefault];
    return i18n!.getDoneText();
    // ??
    // datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT].getDoneText();
  }

  /// Get cancel button text
  static String getLocaleCancel(DateTimePickerLocale locale) {
    final _StringsI18n? i18n =
        datePickerI18n[locale] ?? datePickerI18n[dateTimePickerLocaleDefault];
    return i18n!.getCancelText();
    // ??
    // datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT].getCancelText();
  }

  /// Get locale month array
  static List<String> getLocaleMonths(DateTimePickerLocale locale,
      [bool isFull = true]) {
    final _StringsI18n? i18n =
        datePickerI18n[locale] ?? datePickerI18n[dateTimePickerLocaleDefault];

    if (isFull) {
      final List<String>? months = i18n!.getMonths();
      if (months!.isNotEmpty) {
        return months;
      }
      return datePickerI18n[dateTimePickerLocaleDefault]!.getMonths();
    }

    final List<String> months = i18n!.getMonthsShort();
    if ( //months != null &&
        months.isNotEmpty && months.length == 12) {
      return months;
    }
    return datePickerI18n[dateTimePickerLocaleDefault]!.getMonthsShort();
  }

  /// Get locale week array
  static List<String> getLocaleWeeks(DateTimePickerLocale locale,
      [bool isFull = true]) {
    final _StringsI18n? i18n =
        datePickerI18n[locale] ?? datePickerI18n[dateTimePickerLocaleDefault];
    if (isFull) {
      final List<String> weeks = i18n!.getWeeksFull();
      if ( //eeks != null &&
          weeks.isNotEmpty) {
        return weeks;
      }
      return datePickerI18n[dateTimePickerLocaleDefault]!.getWeeksFull();
    }

    final List<String> weeks = i18n!.getWeeksShort();
    if ( //weeks != null &&
        weeks.isNotEmpty) {
      return weeks;
    }

    final List<String> fullWeeks = i18n.getWeeksFull();
    if ( //fullWeeks != null &&
        fullWeeks.isNotEmpty) {
      return fullWeeks
          .map((item) => item.substring(0, min(3, item.length)))
          .toList();
    }
    return datePickerI18n[dateTimePickerLocaleDefault]!.getWeeksShort();
  }
}
