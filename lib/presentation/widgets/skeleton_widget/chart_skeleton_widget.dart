import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:spendy_re_work/common/utils/screen_utils.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';

class ChartSkeletonWidget extends StatelessWidget {
  final double height;

  ChartSkeletonWidget(this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth,
      color: AppColor.white,
      child: Shimmer.fromColors(
        baseColor: AppColor.shimmerBase,
        highlightColor: AppColor.shimmerHighlight,
        child: Container(
          height: height,
          decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.all(Radius.circular(24.0))),
        ),
      ),
    );
  }
}
