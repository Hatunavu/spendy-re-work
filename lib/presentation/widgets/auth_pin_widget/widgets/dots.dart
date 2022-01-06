import 'package:flutter/material.dart';

import 'package:spendy_re_work/presentation/theme/theme_color.dart';

class Dots extends StatelessWidget {
  final Color? color;
  final Color borderColor;
  final bool? isSelected;
  final double? size;

  Dots(
      {Key? key,
      this.color,
      this.borderColor = AppColor.textColor,
      this.size,
      this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boxDecoration = isSelected!
        ? BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(size!),
          )
        : BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(size!),
            border: Border.all(color: borderColor));
    return Container(width: size, height: size, decoration: boxDecoration);
  }
}
