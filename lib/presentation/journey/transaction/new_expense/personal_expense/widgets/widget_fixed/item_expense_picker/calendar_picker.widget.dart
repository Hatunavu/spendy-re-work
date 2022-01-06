import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendy_re_work/common/constants/date_time_constants.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/constants/list_item_setting_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/create_form/item_button_widget.dart';
import 'package:spendy_re_work/presentation/widgets/date_picker/custom_cupertino_date_picker.dart';
import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';
import '../../../../new_expense_constants.dart';

class CalendarPickerWidget extends StatelessWidget {
  const CalendarPickerWidget(
      {Key? key,
      required this.onChangedDateTime,
      required this.initialDateTime})
      : super(key: key);
  final Function(DateTime) onChangedDateTime;
  final DateTime initialDateTime;
  @override
  Widget build(BuildContext context) {
    return ItemButtonWidget(
      onItemClick: () => _showDatePickerBottomSheet(context),
      itemPersonalEntity:
          ItemPersonalEntity(icon: IconConstants.todayIcon, name: _title()),
      widgetSuffix: InkWell(
          onTap: _onChangeYesterday,
          child: Text(_content(),
              style: ThemeText.getDefaultTextTheme().textMenu)),
    );
  }

  void _onChangeYesterday() {
    if (initialDateTime == DateTime.now().dateTimeYmd) {
      onChangedDateTime(DateTime.now().yesterday);
    } else if (initialDateTime == DateTime.now().yesterday) {
      onChangedDateTime(DateTime.now());
    }
  }

  void _showDatePickerBottomSheet(BuildContext buildContext) {
    showModalBottomSheet(
        context: buildContext,
        backgroundColor: AppColor.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LayoutConstants.roundedRadius),
        ),
        builder: (buildContext) => CupertinoDatePickerWithTitle(
              title: NewExpenseConstants.expenseDataTxt,
              initialDateTime: initialDateTime,
              onPressedDone: onChangedDateTime,
              maximumDate: DateTime.now(),
              minimumYear: 2010,
              maximumYear: DateTime.now().year,
              mode: CupertinoDatePickerMode.date,
            ));
  }

  String _title() {
    if (initialDateTime == DateTime.now().dateTimeYmd) {
      return NewExpenseConstants.categoryTodayTitle;
    } else if (initialDateTime == DateTime.now().yesterday) {
      return NewExpenseConstants.categoryYesterdayTitle;
    }
    return DateFormat(DateTimeConstants.datePattern).format(initialDateTime);
  }

  String _content() {
    if (initialDateTime == DateTime.now().dateTimeYmd) {
      return NewExpenseConstants.categoryYesterdayContent;
    } else if (initialDateTime == DateTime.now().yesterday) {
      return NewExpenseConstants.categoryTodayContent;
    }
    return '';
  }
}
