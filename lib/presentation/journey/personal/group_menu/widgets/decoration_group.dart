import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class DecorationGroup extends StatelessWidget {
  final String nameGroup;
  final String? debt;
  final int? countParticipants;
  const DecorationGroup({Key? key, required this.nameGroup, this.debt, this.countParticipants})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            height: 92.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.sp),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                colors: <Color>[Color(0xff8770FD), Color(0xffFF77A0)],
              ),
            ),
          ),
        ),
        ClipRRect(
            borderRadius: BorderRadius.circular(12.sp),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 21.w).copyWith(top: 16.h, bottom: 20.h),
                  height: 92.h,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.4)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: countParticipants == 0
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nameGroup,
                              style: ThemeText.getDefaultTextTheme()
                                  .priceStyle
                                  .copyWith(color: AppColor.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            countParticipants == 0
                                ? const SizedBox.shrink()
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Debts',
                                        style: ThemeText.getDefaultTextTheme()
                                            .textField
                                            .copyWith(color: AppColor.white),
                                      ),
                                      Icon(
                                        Icons.navigate_next,
                                        size: 20.sp,
                                        color: AppColor.white,
                                      )
                                    ],
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          countParticipants == 0
                              ? const SizedBox.shrink()
                              : Row(children: [
                                  SvgPicture.asset(IconConstants.icGroup2),
                                  SizedBox(width: 7.w),
                                  Text('$countParticipants people',
                                      style: ThemeText.getDefaultTextTheme()
                                          .textField
                                          .copyWith(color: AppColor.white))
                                ]),
                          SvgPicture.asset(
                            IconConstants.icChart,
                          ),
                        ],
                      ),
                    ],
                  )),
            ))
      ],
    );
  }
}
