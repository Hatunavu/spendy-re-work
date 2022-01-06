import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class NewExpenseConstants {
  static const String groupParticipantsKey = 'group_participant_key';
  static const String expenseParticipantsKey = 'expense_paricipant_key';
  static const Size heightAppbar = Size.fromHeight(105);

  static EdgeInsetsGeometry appbarPaddingIOS =
      const EdgeInsets.fromLTRB(26, 0, 26, 8);
  static EdgeInsetsGeometry appbarPaddingAndroid =
      const EdgeInsets.fromLTRB(26, 8, 26, 8);
  static TextStyle spentHintStyle = ThemeText.getDefaultTextTheme()
      .hint
      .copyWith(fontSize: 36.sp, color: AppColor.white38);
  static TextStyle spentStyle = ThemeText.getDefaultTextTheme()
      .hint
      .copyWith(fontSize: 36.sp, color: AppColor.white);

  static const maxLengthMountField = 17;

  static final double fzHintText = 15.sp;
  static final double fzTitleText = 22.sp;
  static final double fzCaption = 15.sp;

  static double newExpensePaddingHorizontal = 26.w;
  static double newExpensePaddingVertical = 16.w;
  static double categoryPaddingTop = 16.5.w;
  static const double categoryIconWidth = 17;
  static const double categoryIconHeight = 15;
  static double categoryTagPaddingHorizontal = 20.w;
  static double categoryTagPaddingVertical = 5.h;
  static const double categoryTagSpacing = 8;
  static const double categoriesListSpacing = 16;

  static SizedBox expenseFormSpacing = SizedBox(height: 16.h);
  static const double expenseFormIconHeight = 19;
  static const double expenseFormIconWidth = 17;

  static double addPhotoElementOptionPaddingVertical = 16.h;

  static double bottomSpace = 35.h;
  static double saveButtonPaddingVertical = 35.h;

  static String personalExpenseTitle = translate('label.new_expense');
  static String editPersonalExpenseTitle = translate('label.edit_expense');
  static String categoriesTitle = translate('label.category');
  static String noteHintText = translate('label.type_here');
  static String categoryTodayTitle = translate('label.today');
  static String whoPaidTitle = translate('label.who_paid?');
  static String forWhoTitle = translate('label.for_who?');
  static String shareSpendSelectAllTitle = translate('label.selected_all');
  static String shareSpendDeselectAllTitle = translate('label.deselected_all');
  static String categoryYesterdayTitle = translate('label.yesterday');
  static String categoryTodayContent = translate('label.today?');
  static String categoryYesterdayContent = translate('label.yesterday?');
  static String takePhotoTitle = translate('label.take_photo');
  static String addParticipantTitle = translate('label.add_participant');
  static String expensePhotosBottomSheetHeader =
      translate('label.expense_photos');
  static String expenseDataTxt = translate('label.expense_date');
  static String addPhotosBottomSheetCancelButtonTitle =
      translate('label.cancel');
  static String addGalleryOptionTitle = translate('label.gallery');
  static String addCameraOptionTitle = translate('label.camera');
  static String saveButtonTitle = translate('label.save');
  static String nextButtonTitle = translate('label.next');
  static String participantNameHint = translate('label.participant_name');
  static String textError = translate('error_message.an_error_occurred');
  static String noInternet = translate('error_message.no_internet');
  static String mes = translate('error_message.no_internet');
  static String personalCost = translate('label.personal_cost');
  static const List<Color> categoryColors = [
    AppColor.amberAccent,
    AppColor.deepPurpleCFD1F8,
    AppColor.blueC0E7FE,
    AppColor.indigoC0D5EC,
    AppColor.cyanBAE5E5,
    AppColor.pinkF2C8DC,
    AppColor.redAccentF5D3D4,
    AppColor.orangeF2D8C2,
    AppColor.greenCDF5DE,
    AppColor.red100,
    AppColor.purpleDACAF8,
  ];
  static const List<Color> categoryTextColor = [
    AppColor.amber,
    AppColor.deepPurple,
    AppColor.blue,
    AppColor.indigo,
    AppColor.cyan,
    AppColor.pink,
    AppColor.redAccent,
    AppColor.orange,
    AppColor.green,
    AppColor.red500,
    AppColor.purple,
  ];

  static TextStyle shareSpendTitle = ThemeText.getDefaultTextTheme()
      .subtitle1!
      .copyWith(fontSize: 20.sp, letterSpacing: 0);
}
