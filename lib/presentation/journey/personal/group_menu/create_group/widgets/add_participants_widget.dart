import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class AddParticipantsWidget extends StatelessWidget {
  const AddParticipantsWidget({Key? key, required this.onTap}) : super(key: key);
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Row(
          children: [
            SvgPicture.asset(IconConstants.icAddParticipants),
            SizedBox(
              width: 15.w,
            ),
            Text(
              translate('group.more'),
              style: ThemeText.getDefaultTextTheme().hint.copyWith(
                    fontSize: 15.sp,
                    color: AppColor.lightPurple,
                    fontWeight: FontWeight.w600,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
