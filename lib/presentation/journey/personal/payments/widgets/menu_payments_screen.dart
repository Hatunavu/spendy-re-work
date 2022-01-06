import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/string_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class MenuPayments extends StatelessWidget {
  MenuPayments({
    Key? key,
  }) : super(key: key);
  final _lengthPayment = menuPayments.length;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        primary: false,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          return InkWell(
            splashColor: AppColor.transparent,
            highlightColor: AppColor.transparent,
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    menuPayments[index],
                    style: ThemeText.getDefaultTextTheme().titleMenuPayments,
                  ),
                  SvgPicture.asset(IconConstants.icRightArrow)
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, index) {
          return const Divider(
            height: 0,
          );
        },
        itemCount: _lengthPayment);
  }
}
