import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/journey/login/profile/profile_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/button_widget/button_widget_constants.dart';

class GetStartButton extends StatelessWidget {
  final bool isActive;
  final Function() onPressed;

  GetStartButton({Key? key, required this.isActive, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isActive ? onPressed : null,
      child: Container(
        width: MediaQuery.of(context).size.width * 2 / 3,
        height: ButtonWidgetConstants.buttonHeight,
        decoration: BoxDecoration(
            color: isActive ? AppColor.primaryColor : AppColor.white,
            borderRadius: BorderRadius.circular(
                ButtonWidgetConstants.roundedButtonRadius),
            border: Border.all(
                color: isActive
                    ? AppColor.primaryColor
                    : AppColor.textHideColor.withAlpha(50),
                width: 2)),
        alignment: Alignment.center,
        child: Text(ProfileConstants.createTitleBtn,
            style: ThemeText.getDefaultTextTheme().button?.copyWith(
                color: isActive ? AppColor.white : AppColor.textHideColor)),
      ),
    );
  }
}
