import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/utils/currency_text_input_formatter.dart';
import 'package:spendy_re_work/domain/entities/currency_entity.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class InputMoneyWidget extends StatefulWidget {
  InputMoneyWidget({
    Key? key,
    required this.currency,
    required this.onChanged,
    required this.controller,
  }) : super(key: key);
  final CurrencyEntity currency;
  final Function(String) onChanged;
  final TextEditingController controller;
  @override
  _InputMoneyWidgetState createState() => _InputMoneyWidgetState();
}

class _InputMoneyWidgetState extends State<InputMoneyWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        cursorColor: AppColor.white,
        autofocus: true,
        textAlign: TextAlign.center,
        style:
            ThemeText.getDefaultTextTheme().hint.copyWith(fontSize: 28.sp, color: AppColor.white),
        inputFormatters: [
          CurrencyTextInputFormatter(
            locale: widget.currency.locale,
            decimalDigits: 0,
            symbol: widget.currency.code ?? '',
          ),
        ],
        maxLength: 17,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            fillColor: const Color(0xff7077EA),
            hintText: '0 ${widget.currency.code ?? ''}',
            counterText: '',
            hintStyle: ThemeText.getDefaultTextTheme()
                .hint
                .copyWith(fontSize: 28.sp, color: AppColor.white38),
            filled: true,
            enabledBorder: _outlineInputBoder(),
            focusedBorder: _outlineInputBoder()));
  }

  OutlineInputBorder _outlineInputBoder() => OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xff7077EA), width: 0),
        borderRadius: BorderRadius.circular(0),
      );
}
