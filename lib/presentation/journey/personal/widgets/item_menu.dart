import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/widgets/create_form/create_element_form.dart';

class ItemMenu extends CreateElementFormWidget {
  final Function() onPressed;
  @override
  final String iconPath;
  @override
  final Widget? child;
  @override
  final bool showLineTop;
  @override
  final bool showLineBottom;

  const ItemMenu(
      {Key? key,
      required this.onPressed,
      required this.iconPath,
      this.child,
      this.showLineTop = false,
      this.showLineBottom = false})
      : super(
            key: key,
            child: child,
            iconPath: iconPath,
            showLineBottom: showLineBottom,
            showLineTop: showLineTop);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: super.build(context),
    );
  }
}
