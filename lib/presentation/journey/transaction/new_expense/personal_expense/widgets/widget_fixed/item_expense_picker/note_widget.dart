import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/new_expense_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class NoteWidget extends StatelessWidget {
  final TextEditingController controller;
  const NoteWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: ThemeText.getDefaultTextTheme().textMenu,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 14.h),
          hintText: NewExpenseConstants.noteHintText,
          prefixIcon: Image.asset(
            IconConstants.noteIcon,
            alignment: Alignment.centerLeft,
          ),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(width: 0, color: AppColor.lightGrey)),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(width: 0, color: AppColor.lightGrey)),
          prefixIconConstraints: BoxConstraints(
            minWidth: 34.w,
            minHeight: 34.w,
          ),
          hintStyle: ThemeText.getDefaultTextTheme()
              .textMenu
              .copyWith(color: AppColor.grey)),
    );
  }
}
