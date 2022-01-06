import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/date_picker/spendy_date_picker_constants.dart';

import 'strings.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';

// ignore: must_be_immutable

class DatePickerWidget extends StatefulWidget {
  final Function(DateTime)? onDateTimeChanged;
  final Function(DateTime)? onDonePressed;
  final int maxYear;
  final int minYear;
  final DateTime initialDateTime;
  final DateTime maximumDate;

  DatePickerWidget({
    Key? key,
    this.onDateTimeChanged,
    this.onDonePressed,
    required this.initialDateTime,
    required this.maximumDate,
    this.maxYear = 2100,
    this.minYear = 1950,
  }) : super(key: key);

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;

  bool isMonthPickerScrolling = false;
  bool isYearPickerScrolling = false;

  late int currentMonth;
  late int currentYear;

  bool get isScrolling => isMonthPickerScrolling || isYearPickerScrolling;

  Widget durationPicker(BuildContext context,
      {FixedExtentScrollController? scrollController,
      bool inYear = false,
      int? initialItem}) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isMonthPickerScrolling = true;
          if (inYear) {
            isYearPickerScrolling = true;
          }
        } else if (notification is ScrollEndNotification) {
          isMonthPickerScrolling = false;
          isYearPickerScrolling = false;
          _pickerDidStopScrolling();
        }
        return false;
      },
      child: CupertinoPicker(
        scrollController: scrollController,
        backgroundColor: Colors.white,
        onSelectedItemChanged: (value) {
          if (inYear) {
            final int selectYear = widget.minYear + value;
            if (selectYear <= widget.maximumDate.year) {
              currentYear = widget.minYear + value;
            }
          } else {
            final int selectMonth = value + 1;
            currentMonth = selectMonth;
          }
          if (widget.onDateTimeChanged != null) {
            widget.onDateTimeChanged!(DateTime(currentYear, currentMonth));
          }
        },
        itemExtent: 40,
        children: inYear ? _yearText(context) : _monthText(context),
      ),
    );
  }

  List<Widget> _monthText(BuildContext context) {
    return List.generate(
        12,
        (index) => Row(
              children: [
                const Spacer(
                  flex: 3,
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    '${getMonths[index]!.capitalize}',
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .pickerTextStyle
                        .copyWith(fontSize: 23),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ));
  }

  List<Widget> _yearText(BuildContext context) {
    return List.generate(
        widget.maxYear - widget.minYear + 1,
        (index) => Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Text('${widget.minYear + index}',
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .pickerTextStyle
                          .copyWith(fontSize: 23),
                      textAlign: TextAlign.right),
                ),
                const Spacer(
                  flex: 3,
                ),
              ],
            ));
  }

  @override
  void initState() {
    super.initState();
    currentMonth = widget.initialDateTime.month;
    currentYear = widget.initialDateTime.year;
    monthController =
        FixedExtentScrollController(initialItem: currentMonth - 1);
    yearController =
        FixedExtentScrollController(initialItem: currentYear - widget.minYear);
  }

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
                  SpendyDatePickerConstant.textTimeReport,
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
                    // Condition before confirming the date
                    // Used when the user has "hands faster than brain" :D
                    if (currentYear > widget.maximumDate.year ||
                        (currentYear == widget.maximumDate.year &&
                            currentMonth > widget.maximumDate.month)) {
                      widget.onDonePressed!(DateTime(
                          widget.initialDateTime.year,
                          widget.initialDateTime.month));
                    } else {
                      widget
                          .onDonePressed!(DateTime(currentYear, currentMonth));
                    }
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
        Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.28,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: durationPicker(context,
                      scrollController: monthController,
                      initialItem: currentMonth - 1)),
              Expanded(
                  child: durationPicker(context,
                      scrollController: yearController,
                      inYear: true,
                      initialItem: currentYear - widget.minYear)),
            ],
          ),
        ),
      ],
    );
  }

  void _pickerDidStopScrolling() {
    final DateTime lastDay = _lastDayInMonth(currentYear, currentMonth);
    setState(() {});
    if (isScrolling) {
      return;
    }
    _scrollToDate(lastDay);
  }

  void _scrollToDate(DateTime? newDate) {
    assert(newDate != null, 'new date not null');
    SchedulerBinding.instance!.addPostFrameCallback((Duration timestamp) {
//      print('currentYear: $currentYear');
//      print('currentMonth: $currentMonth');
      if (currentYear > widget.maximumDate.year) {
        _resetDatePicker();
      } else if (currentYear == widget.maximumDate.year) {
        if (currentMonth > widget.maximumDate.month) {
//          print('currentMonth: $currentMonth');
          _resetDatePicker();
        }
      }
    });
  }

  void _resetDatePicker() {
    _animateColumnControllerToItem(
        yearController, widget.maximumDate.year - widget.minYear);
    _animateColumnControllerToItem(
        monthController, widget.maximumDate.month - 1);
  }

  void _animateColumnControllerToItem(
      FixedExtentScrollController controller, int targetItem) {
    controller.animateToItem(
      targetItem,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 200),
    );
  }

  DateTime _lastDayInMonth(int year, int month) => DateTime(year, month + 1, 0);
}
