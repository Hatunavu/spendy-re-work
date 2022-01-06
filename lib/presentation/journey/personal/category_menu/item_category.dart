import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/items_widget/item_widget.dart';

class ItemCateGory extends StatelessWidget {
  final Color? bgLeadingColor;
  final String? iconPath;
  final String? title;
  final bool showLineTop;
  final bool showLineBottom;

  const ItemCateGory(
      {Key? key,
      this.bgLeadingColor,
      this.iconPath,
      this.title,
      this.showLineTop = false,
      this.showLineBottom = false});

  @override
  Widget build(BuildContext context) {
    return ItemWidget(
      bgLeadingColor: bgLeadingColor,
      iconPath: iconPath!,
      showLineBottom: true,
      child: Container(
        alignment: Alignment.centerLeft,
        width: double.infinity,
        height: LayoutConstants.dimen_48,
        child: Text(
          title!,
          style: ThemeText.getDefaultTextTheme().textMenu,
        ),
      ),
    );
  }
}
