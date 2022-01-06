import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/utils/currency_text_input_formatter.dart';
import 'package:spendy_re_work/domain/entities/currency_entity.dart';
import 'package:spendy_re_work/presentation/journey/goal/create_goal/create_goal_bloc/create_goal_bloc.dart';
import 'package:spendy_re_work/presentation/widgets/create_form/element_form_textfield.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';
import '../../goal_list/goal_page_constants.dart';

class MoneyTextFieldWidget extends StatelessWidget {
  final int amountPerMonth;
  final CurrencyEntity currencyEntity;
  final TextEditingController controller;
  final String? initText;

  MoneyTextFieldWidget(
      {required this.amountPerMonth,
      required this.currencyEntity,
      required this.controller,
      this.initText});

  @override
  Widget build(BuildContext context) {
    return ElementFormTextField(
      inputFormatters: [
        CurrencyTextInputFormatter(
            decimalDigits: 0, locale: currencyEntity.locale),
        LengthLimitingTextInputFormatter(15),
      ],
      controller: controller,
      initText: initText?.formatStringToCurrency(haveSymbol: false),
      hintText: GoalPageConstants.textHintMoney.formatStringToCurrency(),
      textInputType: TextInputType.number,
      iconPath: IconConstants.currencyIcon,
      showLineBottom: true,
      onChanged: (content) => _onMoneyChanged(context, content),
      trailingText:
          '${amountPerMonth.toString().formatStringToCurrency()} ${GoalPageConstants.textPerMonth}',
    );
  }

  void _onMoneyChanged(BuildContext context, String content) {
    BlocProvider.of<CreateGoalBloc>(context).add(MoneyChangeEvent(content));
  }
}
