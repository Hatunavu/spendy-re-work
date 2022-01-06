import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_recent/transaction_recent_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';

class GroupHomeItem extends StatelessWidget {
  final String nameGroup;
  final String? debt;
  final int? countParticipants;
  final double height;
  final int totalAmount;
  GroupHomeItem(
      {Key? key,
      required this.nameGroup,
      this.debt,
      this.countParticipants,
      required this.height,
      required this.totalAmount})
      : super(key: key);

  final _containerHeight = TransactionRecentConstants.groupItemHeight;
  final _minItemHeight = TransactionRecentConstants.minGroupItemHeight;

  @override
  Widget build(BuildContext context) {
    final _opacity = (height / _containerHeight).clamp(0, 1).toDouble();
    return SizedBox(
      height: _containerHeight,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              height: _containerHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.sp),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  colors: <Color>[Color(0xff8770FD), Color(0xffFF77A0)],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.sp),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w)
                      .copyWith(top: 13.h),
                  height: _containerHeight,
                  decoration:
                      BoxDecoration(color: Colors.white.withOpacity(0.4)),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              nameGroup,
                              style: ThemeText.getDefaultTextTheme()
                                  .priceStyle
                                  .copyWith(color: AppColor.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            totalAmount != 0
                                ? '-${totalAmount.toString().formatStringToCurrency()}'
                                : '0'.formatStringToCurrency(),
                            style: ThemeText.getDefaultTextTheme()
                                .priceStyle
                                .copyWith(color: AppColor.white),
                          )
                        ],
                      ),
                      Positioned(
                        bottom: 15.h,
                        left: 0,
                        right: 0,
                        child: Visibility(
                          visible: height > _minItemHeight,
                          child: Opacity(
                            opacity: _opacity,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Debts',
                                        style: ThemeText.getDefaultTextTheme()
                                            .textField
                                            .copyWith(
                                                color: AppColor.white,
                                                fontSize: 15.sp),
                                      ),
                                      Icon(
                                        Icons.navigate_next,
                                        size: 23.sp,
                                        color: AppColor.white,
                                      )
                                    ],
                                  ),
                                ),
                                SvgPicture.asset(
                                  IconConstants.icChart,
                                ),
                                SizedBox(width: 5.w)
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
