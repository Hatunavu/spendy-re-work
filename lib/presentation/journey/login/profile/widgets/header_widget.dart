import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/journey/login/login_constants.dart';
import 'package:spendy_re_work/presentation/journey/login/profile/profile_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: LoginConstants.paddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            ProfileConstants.titleNewAccount,
            style: ThemeText.getDefaultTextTheme().bodyText2!.copyWith(
                  letterSpacing: -0.74,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            ProfileConstants.header,
            textAlign: TextAlign.center,
            style: ThemeText.getDefaultTextTheme().overline?.copyWith(
                  fontSize: 16,
                  color: AppColor.textColor,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
