import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';

class BottomSheetWidget extends StatelessWidget {
  final Widget? body;
  final String? title;
  final String? cancelTitle;
  final String? confirmTitle;
  //final Function()? onCancel;
  final Function? onConfirm;

  const BottomSheetWidget(
      {Key? key,
      this.body,
      this.title,
      this.cancelTitle,
      this.confirmTitle,
      //this.onCancel,
      this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: LayoutConstants.headerBottomSheet,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: LayoutConstants.paddingHorizontal),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        cancelTitle ?? translate('label.cancel'),
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .pickerTextStyle
                            .copyWith(
                                fontSize: 18,
                                color: AppColor.primaryAccentColor),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        onConfirm!();
                      },
                      child: Text(
                        confirmTitle ?? '',
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .pickerTextStyle
                            .copyWith(
                                fontSize: 18, color: AppColor.primaryColor),
                      ),
                    ),
                  ],
                ),
                Text(
                  title!,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .pickerTextStyle
                      .copyWith(
                          fontSize: 18,
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        body!,
      ],
    );
  }
}
