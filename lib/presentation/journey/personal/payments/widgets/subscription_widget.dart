import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class SubscriptionWidget extends StatelessWidget {
  final String title;
  final String image;
  final String hint;
  final int? index;
  const SubscriptionWidget(
      {Key? key,
      required this.title,
      required this.image,
      required this.hint,
      this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: index == 0 ? 48.h : 28.h,
            ),
            SvgPicture.asset(
              image,
              width: 58.w,
            ),
            SizedBox(
              height: index == 0 ? 24.h : 15.h,
            ),
            Column(
              children: [
                Text(title,
                    style: ThemeText.getDefaultTextTheme().bodyText1!.copyWith(
                        color: AppColor.lightPurple,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 5.h),
                Text(
                  hint,
                  textAlign: TextAlign.center,
                  style: ThemeText.getDefaultTextTheme().caption!.copyWith(
                        color: AppColor.grey,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ],
        ));
  }
}
