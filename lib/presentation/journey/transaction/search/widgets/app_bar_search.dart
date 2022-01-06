import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/appbar/appbar_constants.dart';
import 'package:spendy_re_work/presentation/widgets/seach/search_field_widget.dart';

class AppbarSearchWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final TextEditingController searchController;
  final Function() onCleanText;
  final Function(String) onSubmitted;
  final Function(String) onSuggestionSelected;
  final Function(String) onChanged;
  final List<String> categoryNameList;
  final bool showCleanButton;

  AppbarSearchWidget({
    required this.searchController,
    required this.onCleanText,
    required this.onSubmitted,
    required this.onSuggestionSelected,
    required this.onChanged,
    required this.categoryNameList,
    required this.showCleanButton,
  });

  @override
  Size get preferredSize => AppbarConstants.heightAppbar;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      child: SafeArea(
        child: _headerWidget(context),
      ),
    );
  }

  Widget _headerWidget(BuildContext context) {
    EdgeInsetsGeometry padding;

    if (Platform.isIOS) {
      padding = AppbarConstants.appbarPaddingIOS;
    } else {
      padding = AppbarConstants.appbarPaddingAndroid;
    }

    return Padding(
      padding: padding,
      child: Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                IconConstants.backIcon,
                color: AppColor.iconColor,
              ),
            ),
          ),
          const SizedBox(
            width: LayoutConstants.dimen_16,
          ),
          Expanded(
            child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: SearchFieldWidget(
                  controller: searchController,
                  onSubmitted: onSubmitted,
                  onChanged: onChanged,
                  onClearText: onCleanText,
                )),
          ),
        ],
      ),
    );
  }
}
