import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/new_expense_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/bottom_sheet/bottom_sheet_widget.dart';

import 'add_photo_element_option_widget.dart';

class AddPhotosBottomSheet extends StatelessWidget {
  final Function? photosOnTap;
  final Function? cameraOnTap;
  final String? title;

  const AddPhotosBottomSheet(
      {Key? key, this.photosOnTap, this.cameraOnTap, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      title: title,
      body: Container(
        color: AppColor.white,
        padding: EdgeInsets.symmetric(
            horizontal: NewExpenseConstants.newExpensePaddingHorizontal),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AddPhotoElementOptionWidget(
                onTap: photosOnTap!,
                icon: const Icon(
                  Icons.image,
                  size: 19,
                  color: AppColor.iconColor,
                ),
                title: NewExpenseConstants.addGalleryOptionTitle),
            AddPhotoElementOptionWidget(
                onTap: cameraOnTap!,
                icon: Image.asset(IconConstants.cameraMenuIcon,
                    width: 17, height: 19, color: AppColor.iconColor),
                title: NewExpenseConstants.addCameraOptionTitle),
            SizedBox(height: NewExpenseConstants.bottomSpace)
          ],
        ),
      ),
    );
  }
}
