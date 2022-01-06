import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class OwnerWidget extends StatelessWidget {
  const OwnerWidget({
    Key? key,
    required this.name,
  }) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: false,
      initialValue: '$name (${translate('label.me')})',
      style: ThemeText.getDefaultTextTheme().hint.copyWith(
            fontSize: 15.sp,
            color: AppColor.darkBlue,
            fontWeight: FontWeight.w400,
          ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        suffix: Text(
          translate('group.owner'),
          style: ThemeText.getDefaultTextTheme().hint.copyWith(
                fontSize: 15.sp,
                color: AppColor.darkBlue,
                fontWeight: FontWeight.w400,
              ),
        ),
        isCollapsed: true,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: AppColor.lightGrey),
        ),
        disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: AppColor.lightGrey),
        ),
      ),
    );
  }
}
