import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/button_widget/button_widget.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/app_dialog/app_dialog_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/delete_dialog/delete_dialog_constants.dart';

class DeleteGroupDialog extends StatelessWidget {
  final String? nameGroup;
  final Function()? cancelAction;
  final Function()? deleteAction;

  DeleteGroupDialog({
    Key? key,
    this.nameGroup,
    this.cancelAction,
    this.deleteAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding:
          const EdgeInsets.symmetric(horizontal: AppDialogConstants.dialogMarginHorizontal),
      child: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(LayoutConstants.roundedRadius),
          color: AppColor.white),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 23.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              _title(),
              SizedBox(
                height: 15.h,
              ),
              Column(
                children: [
                  Text(
                    '${translate('group.delete.want_delete')} "$nameGroup" ?',
                    textAlign: TextAlign.center,
                    style: ThemeText.getDefaultTextTheme()
                        .headline4!
                        .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    translate('group.delete.notification'),
                    textAlign: TextAlign.center,
                    style: ThemeText.getDefaultTextTheme()
                        .titleMenuPayments
                        .copyWith(color: AppColor.lightGrey, fontSize: 14.sp),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 18.h,
          ),
          _groupButton(),
        ],
      ),
    );
  }

  Widget _title() => Text(
        AppDialogConstants.confirm,
        style: ThemeText.getDefaultTextTheme()
            .headline4!
            .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
      );

  Widget _groupButton() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonWidget.primary(
            width: 102.w,
            title: DeleteDialogConstants.noButtonTitle,
            onPress: cancelAction,
            color: AppColor.lightPurple,
            padding: EdgeInsets.zero,
            textSize: 16.sp,
            height: 42.h,
          ),
          SizedBox(width: 37.w),
          ButtonWidget.primary(
            title: DeleteDialogConstants.yesButtonTitle,
            onPress: deleteAction,
            color: AppColor.red,
            padding: EdgeInsets.zero,
            textSize: 16.sp,
            width: 102.w,
            height: 42.h,
          ),
        ],
      );
}
