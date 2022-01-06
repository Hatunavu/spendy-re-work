import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/domain/entities/currency_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/widgets/widget_fixed/item_widget/type_money.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/icon_svg_widget/icon_edit_widget.dart';

class ItemCheckBoxParticipantsWidget extends StatelessWidget {
  const ItemCheckBoxParticipantsWidget(
      {Key? key,
      required this.name,
      required this.isChecked,
      required this.currency,
      required this.onChecked,
      required this.money,
      this.keyText,
      required this.editMoney})
      : super(key: key);
  final String name;
  final bool isChecked;
  final Function() onChecked;
  final CurrencyEntity currency;
  final String money;
  final Key? keyText;
  final Function(int) editMoney;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: onChecked,
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(value: isChecked, onChanged: (value) => onChecked()),
              Expanded(
                flex: 2,
                child: Text(
                  name,
                  style: TextStyle(
                      color: const Color(0xff3A385A),
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp),
                ),
              ),
              Expanded(
                  child: TypeMoneyParticipant(
                      key: keyText,
                      editMoney: editMoney,
                      money: isChecked ? money : '',
                      isChecked: isChecked,
                      currency: currency)),
              isChecked
                  ? const IconSvgWidget(
                      iconSvg: IconConstants.icEditParticipants)
                  : const SizedBox()
            ],
          ),
          const Divider(
            color: AppColor.lightGrey,
            height: 0,
          ),
        ],
      ),
    );
  }
}
