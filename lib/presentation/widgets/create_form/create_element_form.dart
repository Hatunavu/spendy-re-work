import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/presentation/widgets/create_form/create_element_form_constants.dart';

class CreateElementFormWidget extends StatelessWidget {
  final String iconPath;
  final Widget? child;
  final bool showLineTop;
  final bool showLineBottom;
  final Function()? formOnPressed;
  final bool fittedWhenHasFormOnPress;

  const CreateElementFormWidget({
    Key? key,
    required this.iconPath,
    this.child,
    this.formOnPressed,
    this.fittedWhenHasFormOnPress = false,
    this.showLineTop = false,
    this.showLineBottom = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: formOnPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Visibility(
            visible: showLineTop,
            child: Padding(
              padding: formOnPressed != null || fittedWhenHasFormOnPress
                  ? EdgeInsets.zero
                  : CreateElementFormConstants.dividerPadding,
              child: const Divider(
                color: AppColor.lineColor,
                thickness: 2,
                height: 0,
              ),
            ),
          ),
          Row(
            children: [
              Image.asset(
                iconPath,
                width: 24.w,
                height: 24.w,
                color: AppColor.iconColor,
              ),
              SizedBox(width: 15.w),
              Expanded(child: SizedBox(width: double.infinity, child: child))
            ],
          ),
          Visibility(
            visible: showLineBottom,
            child: Padding(
              padding: formOnPressed != null || fittedWhenHasFormOnPress
                  ? EdgeInsets.zero
                  : CreateElementFormConstants.dividerPadding,
              child: const Divider(
                color: AppColor.lineColor,
                thickness: 2,
                height: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
