import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';
import 'package:spendy_re_work/common/utils/currency_text_input_formatter.dart';
import 'package:spendy_re_work/domain/entities/currency_entity.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';

class TypeMoneyParticipant extends StatefulWidget {
  const TypeMoneyParticipant(
      {Key? key,
      required this.isChecked,
      this.money = '',
      required this.currency,
      required this.editMoney})
      : super(key: key);
  final bool isChecked;
  final String money;
  final CurrencyEntity currency;
  final Function(int) editMoney;
  @override
  _TypeMoneyParticipantState createState() => _TypeMoneyParticipantState();
}

class _TypeMoneyParticipantState extends State<TypeMoneyParticipant> {
  late TextEditingController _controller;
  final _focusNode = FocusNode();

  @override
  void initState() {
    _controller = TextEditingController(text: widget.money);
    _controller.selection =
        TextSelection.collapsed(offset: widget.money.length);
    _focusNode.addListener(_focusListener);
    super.initState();
  }

  void _focusListener() {
    if (!_focusNode.hasFocus) {
      if (_controller.text.isNotEmpty) {
        widget.editMoney(int.parse(_controller.text.formatCurrencyToString()));
      }
    }
  }

  @override
  void didUpdateWidget(covariant TypeMoneyParticipant oldWidget) {
    _controller.text = widget.money;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        maxLength: 17,
        keyboardType: TextInputType.number,
        focusNode: _focusNode,
        inputFormatters: [
          CurrencyTextInputFormatter(
            locale: widget.currency.locale,
            decimalDigits: 0,
            symbol: widget.currency.code ?? '',
          ),
        ],
        style: TextStyle(fontSize: 15.sp, color: const Color(0xff3A385A)),
        controller: _controller,
        // enabled: widget.isChecked,
        onSubmitted: (value) {
          _focusNode.unfocus();
        },
        decoration: InputDecoration(
            counterText: '',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: widget.isChecked ? translate('label.type_money') : '',
            hintStyle: TextStyle(
                color: AppColor.lightGrey,
                fontWeight: FontWeight.w600,
                fontSize: 15.sp)));
  }
}
