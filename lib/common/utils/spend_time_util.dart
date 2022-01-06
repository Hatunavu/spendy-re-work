import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';

int getTimeSpend(int selectTimeMilli, DateTime currentTime) {
  final int currentTimeMilli = currentTime.millisecondsSinceEpoch;
  final int currentStartTImeMilli = currentTime.intYmd;
  return selectTimeMilli + (currentTimeMilli - currentStartTImeMilli);
}
