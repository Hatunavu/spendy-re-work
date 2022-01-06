import 'package:flutter/material.dart';

import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/presentation/journey/goal/goal_list/goal_page_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'item_list_widget_constants.dart';

class ItemWidget extends StatelessWidget {
  final Color? bgLeadingColor;
  final String iconPath;
  final bool? showLineBottom;
  final Widget child;
  final Widget? circleIconWidget;
  final double? linePadding;
  final Widget? stackWidget;

  const ItemWidget({
    Key? key,
    this.bgLeadingColor,
    required this.iconPath,
    required this.child,
    this.circleIconWidget,
    this.linePadding,
    this.stackWidget,
    this.showLineBottom = false,
  });

  @override
  Widget build(BuildContext context) {
    final leadingSize = circleIconWidget == null
        ? LayoutConstants.dimen_48.w
        : LayoutConstants.dimen_61.w;
    final spaceLeftContent =
        SizedBox(width: GoalPageConstants.paddingLeftContent);

    return Stack(
      children: [
        SizedBox(
            height:
                linePadding ?? ItemListWidgetConstants.dividerPaddingVertical),
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    width: leadingSize,
                    height: leadingSize,
                    child: circleIconWidget ??
                        CircleAvatar(
                          backgroundColor: bgLeadingColor ?? Colors.white,
                          backgroundImage: AssetImage(
                            iconPath,
                          ),
                        )),
                spaceLeftContent,
                Expanded(child: child)
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: leadingSize,
                ),
                spaceLeftContent,
                Expanded(
                    child: Visibility(
                  visible: showLineBottom ?? false,
                  child: Column(
                    children: [
                      SizedBox(
                          height: linePadding ??
                              ItemListWidgetConstants.dividerPaddingVertical),
                      const Divider(
                        color: AppColor.lineColor,
                        thickness: 1,
                        height: 0,
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ],
        ),
        if (stackWidget != null) stackWidget!
      ],
    );
  }
}
