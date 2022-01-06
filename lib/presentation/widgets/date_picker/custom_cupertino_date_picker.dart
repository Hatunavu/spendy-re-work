import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/date_time_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/date_picker/spendy_date_picker_constants.dart';

// ignore: must_be_immutable
class CupertinoDatePickerWithTitle extends StatelessWidget {
  final DateTime initialDateTime;
  final DateTime? maximumDate;
  final int? minimumYear;
  final DateTime? minimumDate;
  final int? maximumYear;
  final CupertinoDatePickerMode? mode;
  final Function(DateTime)? onPressedDone;
  final Function(DateTime)? onDateTimeChanged;
  final String? title;

  CupertinoDatePickerWithTitle(
      {required this.initialDateTime,
      this.onPressedDone,
      this.onDateTimeChanged,
      this.maximumDate,
      this.maximumYear,
      this.minimumDate,
      this.minimumYear,
      this.title,
      this.mode});

  late DateTime _dateTimeSelected;

  @override
  Widget build(BuildContext context) {
    _dateTimeSelected = initialDateTime;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: LayoutConstants.headerBottomSheet,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: LayoutConstants.paddingHorizontal),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    SpendyDatePickerConstant.textCancel,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .pickerTextStyle
                        .copyWith(
                            fontSize: 18, color: AppColor.primaryAccentColor),
                  ),
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
                GestureDetector(
                  onTap: () {
                    onPressedDone!(_dateTimeSelected);
                    Navigator.pop(context);
                  },
                  child: Text(
                    SpendyDatePickerConstant.textDone,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .pickerTextStyle
                        .copyWith(fontSize: 18, color: AppColor.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.28,
          child: CupertinoDatePicker(
            backgroundColor: Colors.white,
            initialDateTime: initialDateTime,
            onDateTimeChanged: (value) {
              _dateTimeSelected = value;
              if (onDateTimeChanged != null) {
                onDateTimeChanged!(value);
              }
            },
            maximumDate: maximumDate,
            minimumYear: minimumYear!,
            minimumDate: minimumDate,
            maximumYear: maximumYear ?? DateTimeConstants.maxDateTime.year,
            mode: CupertinoDatePickerMode.date,
          ),
        ),
      ],
    );
  }
}
