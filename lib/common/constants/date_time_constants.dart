class DateTimeConstants {
  static const String datePattern = 'dd/MM/yyyy';
  static final DateTime maxDateTime = DateTime(2100, 01, 01);
  static final DateTime minDateTime = DateTime(1970, 01, 01);
  // Data Values
  /// (Indonesian: Waktu Indonesia Barat | English: Western Indonesian Time)
  static const int westernIndonesianTimeZoneOffset = 7;
  static const String westernIndonesianTimeZoneIdentifier = 'WIB';

  static const int oneMinuteInSecs = 60;

  static const wibTimeZoneOffsetDuration =
      Duration(hours: DateTimeConstants.westernIndonesianTimeZoneOffset);

  static const String monday = 'monday';
  static const String tuesday = 'tuesday';
  static const String wednesday = 'wednesday';
  static const String thursday = 'thursday';
  static const String friday = 'friday';
  static const String saturday = 'saturday';
  static const String sunday = 'sunday';

  // Language References
  static const mondayLanguageReference = 'common.dayName.monday';
  static const tuesdayLanguageReference = 'common.dayName.tuesday';
  static const wednesdayLanguageReference = 'common.dayName.wednesday';
  static const thursdayLanguageReference = 'common.dayName.thursday';
  static const fridayLanguageReference = 'common.dayName.friday';
  static const saturdayLanguageReference = 'common.dayName.saturday';
  static const sundayLanguageReference = 'common.dayName.sunday';
}
