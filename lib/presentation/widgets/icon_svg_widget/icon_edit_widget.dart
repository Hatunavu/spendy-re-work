import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconSvgWidget extends StatelessWidget {
  const IconSvgWidget({
    Key? key,
    this.onTap,
    required this.iconSvg,
  }) : super(key: key);
  final Function()? onTap;
  final String iconSvg;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        iconSvg,
      ),
    );
  }
}
