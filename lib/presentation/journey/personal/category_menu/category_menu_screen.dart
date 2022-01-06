import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/firebase_storage_constants.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/presentation/journey/personal/widgets/item_menu.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/appbar/primary_appbar.dart';

import 'category_menu_screen_constants.dart';

class CategoriesMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarNormalWidget(
        leading: GestureDetector(
          onTap: () => _onPressedBack(context),
          child: Image.asset(
            IconConstants.backIcon,
            height: LayoutConstants.dimen_18,
            width: LayoutConstants.dimen_18,
            color: AppColor.iconColor,
          ),
        ),
        title: CategoriesMenuScreenConstant.textTitle,
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: CategoriesMenuScreenConstant.paddingLeft,
            top: CategoriesMenuScreenConstant.paddingTop),
        child: ListView(
          children: [
            _menuItem(
              context,
              IconConstants.expenseMenuIcon,
              CategoriesMenuScreenConstant.textExpense,
              () => Navigator.pushNamed(context, RouteList.categoriesList,
                  arguments: {
                    KeyConstants.categoryTypeKey:
                        FirebaseStorageConstants.transactionType
                  }),
              showLineBottom: true,
            ),
            _menuItem(
              context,
              IconConstants.goalMenuIcon,
              CategoriesMenuScreenConstant.textGoal,
              () {
                Navigator.pushNamed(context, RouteList.categoriesList,
                    arguments: {
                      KeyConstants.categoryTypeKey:
                          FirebaseStorageConstants.goalType
                    });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
      BuildContext context, String iconPath, String title, Function() onPressed,
      {bool showLineBottom = false}) {
    return ItemMenu(
        onPressed: onPressed,
        iconPath: iconPath,
        showLineBottom: showLineBottom,
        child: Row(
          children: [
            Expanded(
                child: Text(
              title,
              style: ThemeText.getDefaultTextTheme().textMenu,
            )),
            const Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.navigate_next,
                  color: AppColor.iconColorGrey,
                ))
          ],
        ));
  }

  void _onPressedBack(BuildContext context) => Navigator.pop(context);
}
