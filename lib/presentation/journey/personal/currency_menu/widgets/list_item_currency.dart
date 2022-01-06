import 'package:flutter/material.dart';
import 'package:spendy_re_work/domain/entities/currency_entity.dart';
import 'package:spendy_re_work/presentation/journey/personal/currency_menu/currency_screen_constants.dart';
import 'package:spendy_re_work/presentation/journey/personal/currency_menu/widgets/currency_radio.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class ListCurrencyRadio extends StatelessWidget {
  const ListCurrencyRadio({
    Key? key,
    required this.onChanged,
    required this.currencies,
    required this.currencySelected,
    required this.label,
  }) : super(key: key);
  final Function(CurrencyEntity?) onChanged;
  final Set<CurrencyEntity> currencies;
  final CurrencyEntity currencySelected;

  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: CurrencyScreenConstants.paddingBottom,
        horizontal: CurrencyScreenConstants.titlePaddingRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: ThemeText.getDefaultTextTheme()
                .textLabelItem
                .copyWith(color: const Color(0xff7077EA)),
          ),
          Column(
              children: List.generate(currencies.length, (index) {
            final currency = currencies.toList()[index];
            return CurrencyRadioWidget(
              currencySelected: currencySelected,
              onChangedCurrency: onChanged,
              currency: currency,
            );
          })),
        ],
      ),
    );
  }
}
