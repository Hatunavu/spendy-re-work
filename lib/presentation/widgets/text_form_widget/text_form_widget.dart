import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class TextFormWidget extends StatelessWidget {
  final TextEditingController controller;
  final TextStyle? hintStyle;
  final String? hintText;
  final Function(String)? onChange;
  final Function(String)? onSubmitted;
  final TextAlign? textAlign;

  TextFormWidget({
    Key? key,
    required this.controller,
    required this.hintText,
    this.hintStyle,
    this.onChange,
    this.onSubmitted,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: AppColor.primaryColor,
      style: ThemeText.getDefaultTextTheme().caption,
      textAlign: textAlign!,
      keyboardType: TextInputType.visiblePassword,
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: hintText,
          hintStyle: hintStyle ?? ThemeText.getDefaultTextTheme().hint,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none),
      onChanged: onChange,
      onFieldSubmitted: onSubmitted,
    );
  }
}
