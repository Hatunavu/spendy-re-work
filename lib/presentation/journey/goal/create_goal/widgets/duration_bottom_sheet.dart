import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/goal_contants.dart';
import 'package:spendy_re_work/common/enums/goal_duration_type.dart';
import 'package:spendy_re_work/presentation/journey/goal/goal_list/goal_page_constants.dart';
import 'package:spendy_re_work/presentation/widgets/bottom_sheet/bottom_sheet_widget.dart';
import 'package:spendy_re_work/presentation/widgets/date_picker/spendy_date_picker_constants.dart';

class DurationBottomSheet extends StatefulWidget {
  final Function(GoalDurationType)? onChanged;
  final Function(GoalDurationType) onDone;
  final GoalDurationType? durationType;

  const DurationBottomSheet(
      {Key? key, this.onChanged, required this.onDone, this.durationType})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DurationBottomSheetState();
}

class _DurationBottomSheetState extends State<DurationBottomSheet> {
  FixedExtentScrollController? scrollController;

  bool isScrolling = false;

  int? currentDurationIndex;

  @override
  void initState() {
    super.initState();
    currentDurationIndex =
        GoalDurationType.values.indexOf(widget.durationType!);
    scrollController = FixedExtentScrollController(
        initialItem: GoalDurationType.values.indexOf(widget.durationType!));
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      title: GoalPageConstants.txtGoalDuration,
      confirmTitle: SpendyDatePickerConstant.textDone,
      onConfirm: () {
        widget.onDone(GoalDurationType.values[scrollController!.selectedItem]);
      },
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.28,
        child: durationPicker(context,
            scrollController: scrollController!,
            inYear: true,
            initialItem: currentDurationIndex!),
      ),
    );
  }

  Widget durationPicker(BuildContext context,
      {FixedExtentScrollController? scrollController,
      bool inYear = false,
      int? initialItem}) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isScrolling = false;
          // _pickerDidStopScrolling();
        }
        return false;
      },
      child: CupertinoPicker(
        scrollController: scrollController,
        backgroundColor: Colors.white,
        onSelectedItemChanged: (value) {
          setState(() {
            currentDurationIndex = value;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(GoalDurationType.values[currentDurationIndex!]);
          }
        },
        itemExtent: 40,
        children: _durationTextList(context),
      ),
    );
  }

  List<Widget> _durationTextList(BuildContext context) {
    return List.generate(GoalDurationType.values.length, (index) {
      final String? title =
          valueGoalDurationTypeMap[GoalDurationType.values[index]];
      return Row(
        children: [
          const Spacer(
            flex: 2,
          ),
          Expanded(
            flex: 6,
            child: Text(
              '$title',
              style: CupertinoTheme.of(context)
                  .textTheme
                  .pickerTextStyle
                  .copyWith(fontSize: 23),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(
            flex: 2,
          ),
        ],
      );
    });
  }
}
