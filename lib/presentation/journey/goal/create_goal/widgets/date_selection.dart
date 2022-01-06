import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/goal_contants.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/enums/goal_duration_type.dart';
import 'package:spendy_re_work/presentation/journey/goal/create_goal/widgets/duration_bottom_sheet.dart';
import 'package:spendy_re_work/presentation/widgets/create_form/element_form_textfield.dart';
import 'package:spendy_re_work/presentation/widgets/date_picker/custom_cupertino_date_picker.dart';
import '../../goal_list/goal_page_constants.dart';
import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';

class DateSelectionWidget extends StatelessWidget {
  final DateTime? date;
  final double? amountOfTime;
  final TextEditingController controller;
  final Function(GoalDurationType) onSelectDurationDone;
  final Function(DateTime) onSelectDateDone;
  final GoalDurationType? currentDurationType;

  final _now = DateTime.now();

  DateSelectionWidget(
      {this.date,
      this.amountOfTime,
      required this.controller,
      required this.onSelectDurationDone,
      required this.onSelectDateDone,
      this.currentDurationType});

  @override
  Widget build(BuildContext context) {
    return ElementFormTextField(
      controller: controller,
      changedText: date?.toStringDefault,
      iconPath: IconConstants.todayIcon,
      showLineBottom: true,
      enableField: false,
      trailingText: valueGoalDurationTypeMap[currentDurationType],
      onSelectDate: () => _showDatePicker(context),
      onSelectDuration: () => _showDurationPicker(context),
    );
  }

  void _showDurationPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LayoutConstants.roundedRadius),
        ),
        builder: (context) => DurationBottomSheet(
              onDone: onSelectDurationDone,
              durationType: currentDurationType!,
            ));
  }

  void _showDatePicker(BuildContext context) {
    log('DateSelection - dateTimeGoal: $date');
    final differenceDay = _now.differenceDay(input: date);
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LayoutConstants.roundedRadius),
        ),
        builder: (context) => CupertinoDatePickerWithTitle(
              title: GoalPageConstants.txtExpiredDate,
              initialDateTime: differenceDay < 0 ? _now : date!,
              onPressedDone: onSelectDateDone,
              maximumDate: DateTime(_now.year + 10, 12, 31),
              minimumYear: _now.year - 10,
              minimumDate: DateTime(_now.year, _now.month, _now.day),
              maximumYear: _now.year + 10,
              mode: CupertinoDatePickerMode.date,
            ));
  }
}
