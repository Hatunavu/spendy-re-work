import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/journey/personal/security_menu/security_menu_screen_constants.dart';
import 'package:spendy_re_work/presentation/journey/personal/widgets/item_menu.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class SwitchMenuItem extends StatelessWidget {
  final String icon;
  final String? title;
  final bool? value;
  final Function(bool tick) onChanged;
  final bool showBottomLine;

  const SwitchMenuItem(
      {Key? key,
      required this.icon,
      this.title,
      this.value,
      required this.onChanged,
      this.showBottomLine = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemMenu(
      showLineBottom: showBottomLine,
      iconPath: icon,
      onPressed: () {},
      child: Row(
        children: [
          Expanded(
              child: Text(
            title!,
            style: ThemeText.getDefaultTextTheme().textMenu,
          )),
          Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: SecurityMenuConstants.heightSwitch,
                child: Transform.scale(
                  scale: SecurityMenuConstants.scaleSwitch,
                  child: CupertinoSwitch(
                    value: value!,
                    onChanged: onChanged,
                    activeColor: AppColor.activeColor,
                    trackColor: AppColor.trackColor,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
