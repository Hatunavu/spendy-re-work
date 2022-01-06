import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class InputGroupNameWidget extends StatefulWidget {
  InputGroupNameWidget({
    Key? key,
    required this.onChangedValue,
    this.initNameGroup,
  }) : super(key: key);

  final Function(String) onChangedValue;
  final String? initNameGroup;
  @override
  State<InputGroupNameWidget> createState() => _InputGroupNameWidgetState();
}

class _InputGroupNameWidgetState extends State<InputGroupNameWidget> {
  final GlobalKey<FormState> _groupNameKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    _focusNode.addListener(handleFocusListener);
    _controller.text = widget.initNameGroup ?? '';
    super.initState();
  }

  @override
  void didUpdateWidget(covariant InputGroupNameWidget oldWidget) {
    if (oldWidget.initNameGroup != widget.initNameGroup) {
      _controller.text = widget.initNameGroup ?? '';
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _focusNode.removeListener(handleFocusListener);
    _controller.removeListener(() => widget.onChangedValue(_controller.text));
    super.dispose();
  }

  void handleFocusListener() {
    if (!_focusNode.hasFocus) {
      if (_groupNameKey.currentState?.validate() ?? false) {
        _groupNameKey.currentState?.save();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _groupNameKey,
      child: TextFormField(
        controller: _controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return translate('error_message.error_input');
          } else if (value.length < 2) {
            return translate('error_message.error_length_text');
          }
          return null;
        },
        onChanged: (value) => widget.onChangedValue(value),
        focusNode: _focusNode,
        style: TextStyle(
          fontSize: 15.sp,
          color: AppColor.darkBlue,
          fontWeight: FontWeight.w400,
        ),
        maxLength: 100,
        decoration: InputDecoration(
          suffix: GestureDetector(
            onTap: () {
              _controller
                ..clear()
                ..text = '';
              widget.onChangedValue('');
            },
            child: SvgPicture.asset(
              IconConstants.icClear,
              width: 15.w,
              height: 15.w,
            ),
          ),
          contentPadding: EdgeInsets.only(bottom: 6.h, top: 12.h),
          isCollapsed: true,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: AppColor.lightGrey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: AppColor.lightGrey),
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: AppColor.red),
          ),
          hintText: translate('group.hint'),
          hintStyle: ThemeText.getDefaultTextTheme().hint.copyWith(
                fontSize: 15.sp,
                color: AppColor.lightGrey,
                fontWeight: FontWeight.w400,
              ),
          errorStyle: ThemeText.getDefaultTextTheme()
              .hint
              .copyWith(fontSize: 12.sp, color: AppColor.red, height: 0.8),
          counterStyle: ThemeText.getDefaultTextTheme()
              .hint
              .copyWith(fontSize: 12.sp, color: AppColor.grey, height: 0.8),
        ),
      ),
    );
  }
}
