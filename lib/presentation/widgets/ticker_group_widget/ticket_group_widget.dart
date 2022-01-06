import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';

class TicketGroupWidget extends StatelessWidget {
  final Widget child;
  const TicketGroupWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 21.w)
              .copyWith(top: 16.h, bottom: 20.h),
          width: double.infinity,
          height: 92.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.sp),
              gradient: const LinearGradient(colors: [
                AppColor.cornflowerBlue,
                AppColor.pinkGrey,
              ])),
          child: child,
        ),
        Container(
            width: double.infinity,
            height: 92.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.sp),
              color: AppColor.white.withOpacity(0.4),
            )),
      ],
    );
  }
}
