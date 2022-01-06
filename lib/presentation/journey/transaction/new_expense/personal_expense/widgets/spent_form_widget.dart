import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spendy_re_work/common/utils/currency_text_input_formatter.dart';
import 'package:spendy_re_work/domain/entities/currency_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/new_expense_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';

class SpendFormWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final CurrencyEntity currency;
  final int? maxLength;

  const SpendFormWidget(
      {Key? key,
      required this.controller,
      this.maxLength,
      required this.onChanged,
      required this.currency})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enableInteractiveSelection: false,
      autofocus: true,
      textAlign: TextAlign.center,
      style: NewExpenseConstants.spentStyle,
      keyboardType: TextInputType.number,
      buildCounter: (BuildContext context,
              {int? currentLength, int? maxLength, bool? isFocused}) =>
          null,
      inputFormatters: [
        CurrencyTextInputFormatter(
          locale: currency.locale,
          decimalDigits: 0,
          symbol: currency.code!,
        ),
        LengthLimitingTextInputFormatter(maxLength),
      ],
      decoration: InputDecoration.collapsed(
        hintText: '0 ${currency.code}',
        hintStyle: NewExpenseConstants.spentHintStyle,
      ),
      onChanged: onChanged,
      cursorColor: AppColor.white,
    );
  }
}
