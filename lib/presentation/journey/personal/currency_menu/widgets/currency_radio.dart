import 'package:flutter/material.dart';
import 'package:spendy_re_work/domain/entities/currency_entity.dart';
import 'package:spendy_re_work/presentation/journey/personal/currency_menu/currency_screen_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class CurrencyRadioWidget extends StatelessWidget {
  const CurrencyRadioWidget(
      {Key? key,
      required this.currency,
      required this.currencySelected,
      required this.onChangedCurrency})
      : super(key: key);
  final CurrencyEntity currency;
  final CurrencyEntity currencySelected;
  final Function(CurrencyEntity?) onChangedCurrency;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => onChangedCurrency(currency),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: CurrencyScreenConstants.paddingBottom,
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: CurrencyScreenConstants.sizeRadio,
                  width: CurrencyScreenConstants.sizeRadio,
                  child: Radio<CurrencyEntity>(
                    value: currency,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    groupValue: currencySelected,
                    onChanged: onChangedCurrency,
                  ),
                ),
                SizedBox(width: CurrencyScreenConstants.titlePaddingLeft),
                Expanded(
                    child: Text(currency.name ?? '',
                        style: ThemeText.getDefaultTextTheme()
                            .currencyNationalStyle)),
                Text(currency.isoCode ?? '',
                    style:
                        ThemeText.getDefaultTextTheme().currencyNationalStyle),
              ],
            ),
          ),
          const Divider(
            height: 0,
          )
        ],
      ),
    );
  }
}
