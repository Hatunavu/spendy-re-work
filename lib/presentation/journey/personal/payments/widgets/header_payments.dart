import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/constants/string_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class HeaderPayments extends StatelessWidget {
  const HeaderPayments({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            IconConstants.backIcon,
            width: LayoutConstants.dimen_18,
            height: LayoutConstants.dimen_18,
            color: AppColor.iconColor,
          ),
        ),
        Text(
          spendyPro,
          style: ThemeText.getDefaultTextTheme().headline4!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
