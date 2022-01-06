import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

import '../transaction_recent_constants.dart';

class LoadingGroupWidget extends StatelessWidget {
  final _groupItemHeight = TransactionRecentConstants.groupItemHeight;

  LoadingGroupWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: 3,
      itemBuilder: (context, index, _) {
        return Shimmer.fromColors(
          baseColor: AppColor.shimmerBase,
          highlightColor: AppColor.shimmerHighlight,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 9.w),
            height: _groupItemHeight,
            decoration:
                BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.sp)),
          ),
        );
      },
      options: CarouselOptions(
        enableInfiniteScroll: false,
        height: _groupItemHeight,
      ),
    );
  }
}
