import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/common/utils/screen_utils.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';

class ExpenseSkeletonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        left: LayoutConstants.dimen_26.w,
        right: LayoutConstants.dimen_26.w,
        bottom: LayoutConstants.dimen_16.h,
        top: LayoutConstants.dimen_16.h,
      ),
      itemBuilder: (context, index) {
        return _buildShimmerItem(context);
      },
      itemCount: 10,
      separatorBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
          child: Container(
            height: 1,
            color: AppColor.shimmerLine,
          ),
        );
      },
    );
  }

  Widget _buildShimmerItem(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth,
      color: AppColor.white,
      child: Shimmer.fromColors(
        baseColor: AppColor.shimmerBase,
        highlightColor: AppColor.shimmerHighlight,
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.white,
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 20,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      shape: BoxShape.rectangle,
                      color: AppColor.white),
                ),
                const SizedBox(height: 5),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 20,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      shape: BoxShape.rectangle,
                      color: AppColor.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
