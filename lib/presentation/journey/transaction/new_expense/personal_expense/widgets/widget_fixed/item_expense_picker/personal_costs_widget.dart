import 'package:flutter/cupertino.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/list_item_setting_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/new_expense_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/create_form/item_button_widget.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class PersonalCostsWidget extends StatelessWidget {
  const PersonalCostsWidget(
      {Key? key, required this.onSwitch, required this.isSwitch})
      : super(key: key);
  final Function(bool) onSwitch;
  final bool isSwitch;
  @override
  Widget build(BuildContext context) {
    return ItemButtonWidget(
      onItemClick: () => onSwitch(!isSwitch),
      showLineBottom: false,
      itemPersonalEntity: ItemPersonalEntity(
          icon: IconConstants.icPersonaCost,
          name: NewExpenseConstants.personalCost),
      widgetSuffix: SizedBox(
        width: 30.w,
        child: Transform.scale(
          transformHitTests: false,
          scale: .8,
          child: CupertinoSwitch(
            onChanged: onSwitch,
            value: isSwitch,
            activeColor: const Color(0xff7077EA),
            trackColor: AppColor.lightGrey,
          ),
        ),
      ),
    );
  }
}
