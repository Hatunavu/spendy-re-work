import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/debt/debt_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';

class DebtItemWidget extends StatelessWidget {
  final bool? isLastList;
  final String? fullName;
  final int? amount;

  DebtItemWidget({Key? key, this.isLastList, this.fullName, this.amount})
      : super(key: key);

  final _userEntity = Injector.resolve<AuthenticationBloc>().userEntity;

  @override
  Widget build(BuildContext context) {
    final _meText =
        _userEntity.fullName == fullName ? DebtConstants.meText : '';

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: DebtConstants.paddingVertical16,
              right: LayoutConstants.paddingHorizontal,
              bottom: DebtConstants.paddingVertical16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$fullName $_meText',
                style: ThemeText.getDefaultTextTheme().captionSemiBold,
              ),
              Text(
                "${amount! > 0 ? '+ ' : ''}${amount.toString().formatStringToCurrency(haveSymbol: true)}",
                style: ThemeText.getDefaultTextTheme().captionSemiBold.copyWith(
                      color: amount! > 0
                          ? AppColor.activeColor
                          : AppColor.redAccent,
                    ),
              )
            ],
          ),
        ),
        Visibility(
          visible: !isLastList!,
          child: Divider(
            color: AppColor.dividerColor,
            thickness: DebtConstants.thickessLine,
          ),
        )
      ],
    );
  }
}
