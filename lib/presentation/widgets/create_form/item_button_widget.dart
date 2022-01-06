import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/list_item_setting_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class ItemButtonWidget extends StatelessWidget {
  const ItemButtonWidget(
      {Key? key,
      this.widgetLeading,
      this.showLineBottom = true,
      this.itemPersonalEntity,
      this.onItemClick,
      this.widgetSuffix})
      : super(key: key);
  final bool showLineBottom;
  final Function()? onItemClick;
  final Widget? widgetLeading;
  final ItemPersonalEntity? itemPersonalEntity;
  final Widget? widgetSuffix;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onItemClick,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      itemPersonalEntity?.icon ?? '',
                      width: 24.w,
                      height: 24.w,
                    ),
                    SizedBox(width: 15.w),
                    widgetLeading ??
                        Text(itemPersonalEntity?.name ?? '',
                            style: ThemeText.getDefaultTextTheme().textMenu),
                  ],
                ),
                widgetSuffix ?? const SizedBox(),
              ],
            ),
          ),
          showLineBottom
              ? const Divider(
                  color: AppColor.lightGrey,
                  height: 0,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
