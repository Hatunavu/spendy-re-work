import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
//import 'package:spendy_re_work/presentation/journey/transaction/new_expense/widgets/new_expense_active_button_widget.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/state_widget/create_first_item_button.dart';
import 'package:spendy_re_work/presentation/widgets/state_widget/state_widget_constants.dart';

class EmptyDataWidget extends StatelessWidget {
  final String? titleButton;
  final Function()? onPressButton;

  const EmptyDataWidget({Key? key, this.titleButton, this.onPressButton})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              IconConstants.emptyDataIcon,
              width: 100.w,
              height: 130.h,
            ),
            Text(
              StateWidgetConstants.emptyDataContent,
              style: ThemeText.getDefaultTextTheme().bodyText1!.copyWith(
                  fontSize: 16.sp,
                  letterSpacing: -0.36,
                  color: AppColor.primaryAccentColor),
            ),
            Visibility(
              visible: onPressButton != null,
              child: CreateFirstItemButton(
                titleButton: titleButton,
                onPressButton: onPressButton,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowEmptyDataWidget extends StatelessWidget {
  const ShowEmptyDataWidget({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          IconConstants.emptyDataIcon,
          width: 100.w,
          height: 130.h,
        ),
        Text(
          title ?? StateWidgetConstants.emptyDataContent,
          style: ThemeText.getDefaultTextTheme().bodyText1!.copyWith(
              fontSize: 16.sp,
              letterSpacing: -0.36,
              color: AppColor.primaryAccentColor),
        ),
      ],
    );
  }
}
