import 'dart:ui';

import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class AlertWidgetsConstants {
  static const String textTryAgain = 'Try again';

  static final textErrorActionStyle = ThemeText.getDefaultTextTheme()
      .textLabelChart
      .copyWith(fontWeight: FontWeight.normal, color: AppColor.primaryColor);

  static final textActionPaddingTopDefault = 10.h;
}
