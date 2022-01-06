import 'package:flutter/cupertino.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/app_dialog/action_button.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/rate_app_dialog/rate_app_dialog_constants.dart';
import 'package:spendy_re_work/presentation/widgets/rate_my_app/core.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/presentation/widgets/rate_my_app/style.dart';

class RateAppDialog {
  static void showRateApp(
      {BuildContext? context,
      RateMyApp? rateMyApp,
      Function()? rate,
      VoidCallback? noThanks,
      VoidCallback? onDismissed}) {
    rateMyApp!.showStarRateDialog(
      context!,
      title: RateAppDialogConstants.rateDialogTitle,
      message: RateAppDialogConstants.rateDialogContent,
      actionsBuilder: (context, stars) {
        return [
          SizedBox(
            height: 30.h,
          ),
          Center(
              child: ActionButton(
                  title: RateAppDialogConstants.rateUs,
                  onPressed: rate!,
                  color: AppColor.primaryColor,
                  textSize: 15.sp,
                  padding: EdgeInsets.zero,
                  verticalPadding: EdgeInsets.zero)),
          SizedBox(
            height: 10.h,
          ),
          Center(
              child: ActionButton(
                  title: RateAppDialogConstants.noThanks,
                  onPressed: noThanks!,
                  color: AppColor.red,
                  textSize: 15.sp,
                  padding: EdgeInsets.zero,
                  verticalPadding: EdgeInsets.zero)),
        ];
      },
      ignoreNativeDialog: true,
      dialogStyle: DialogStyle(
        // Custom dialog styles.
        titleAlign: TextAlign.center,
        messageAlign: TextAlign.center,
        titleStyle: ThemeText.getDefaultTextTheme()
            .headline4!
            .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
        messageStyle: ThemeText.getDefaultTextTheme().caption,
        messagePadding: EdgeInsets.only(top: 20.h),
      ),
      starRatingOptions: const StarRatingOptions(initialRating: 5),
      onDismissed: onDismissed,
    );
  }
}
