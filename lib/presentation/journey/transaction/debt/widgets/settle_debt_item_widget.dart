import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/common/utils/algorithm/settle_debt_algorithm/model/settle_debt_model.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/debt/debt_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

class SettleDebtItemWidget extends StatelessWidget {
  final SettleDebtModel settleDebtModel;
  final CategoryEntity debtCate;
  final double? paddingRight;

  SettleDebtItemWidget(this.settleDebtModel, this.debtCate,
      {this.paddingRight});

  final _userEntity = Injector.resolve<AuthenticationBloc>().userEntity;

  @override
  Widget build(BuildContext context) {
    final payeeName = _userEntity.fullName == settleDebtModel.payeeName
        ? '${settleDebtModel.payeeName} ${DebtConstants.meText}'
        : settleDebtModel.payeeName;
    final payerName = _userEntity.fullName == settleDebtModel.payerName
        ? '${settleDebtModel.payerName} ${DebtConstants.meText}'
        : settleDebtModel.payerName;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: DebtConstants.paddingVertical16,
              right: paddingRight ?? LayoutConstants.paddingHorizontal,
              bottom: DebtConstants.paddingVertical16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payeeName,
                      style: ThemeText.getDefaultTextTheme().captionSemiBold,
                    ),
                    Text(
                      '${DebtConstants.sendMoneyTo} $payerName',
                      style: ThemeText.getDefaultTextTheme()
                          .overline!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          minWidth: 0,
                          maxWidth: DebtConstants.maxWidthDebtAmount),
                      margin:
                          EdgeInsets.only(top: DebtConstants.paddingVertical5),
                      padding: EdgeInsets.symmetric(
                          horizontal: DebtConstants.paddingHorizontal16,
                          vertical: DebtConstants.paddingVertical5),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(LayoutConstants.roundedRadius)),
                          color: AppColor.primaryColor),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          settleDebtModel.debtAmount
                              .toInt()
                              .toString()
                              .formatStringToCurrency(haveSymbol: true),
                          style: ThemeText.getDefaultTextTheme()
                              .captionSemiBold
                              .copyWith(
                                color: AppColor.white,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(
          color: AppColor.dividerColor,
          thickness: DebtConstants.thickessLine,
        )
      ],
    );
  }
}
