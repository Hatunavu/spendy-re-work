import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/domain/entities/app_default_entity/payment_entity.dart';
import 'package:spendy_re_work/presentation/journey/personal/payments/bloc/payments_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/payments/bloc/payments_state.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/common/extensions/num_extensions.dart';

enum ChangeColorForm { titleColor, descriptionColor }

class BoxPayments extends StatelessWidget {
  const BoxPayments({Key? key, this.index, required this.paymentEntity})
      : super(key: key);
  final int? index;

  final PaymentEntity paymentEntity;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentsBloc, PaymentsState>(
      buildWhen: (previousState, state) =>
          !(state is PaymentsChangeSplashContentState),
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  width: 1,
                  color: _actionButtonColor(
                    state,
                  ))),
          width: 102.w,
          height: 150.h,
          child: Column(
            children: [
              Container(
                height: 32.h,
                width: 102.w,
                decoration: BoxDecoration(
                  color: _actionButtonColor(
                    state,
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.w),
                      topRight: Radius.circular(10.w)),
                ),
                alignment: Alignment.center,
                child: Text(
                  paymentEntity.name!,
                  style: ThemeText.getDefaultTextTheme().paymentTitle.copyWith(
                      color: _actionDescriptionColor(
                          state, ChangeColorForm.titleColor)),
                ),
              ),
              Column(children: [
                Padding(
                  padding: EdgeInsets.only(top: 13.h, bottom: 8.h),
                  child: Text(
                      '${convertNumberWithComma(paymentEntity.amount!)} đ',
                      style: ThemeText.getDefaultTextTheme()
                          .priceStyle
                          .copyWith(
                              color: _actionDescriptionColor(
                                  state, ChangeColorForm.descriptionColor))),
                ),
                Text(paymentEntity.description!,
                    textAlign: TextAlign.center,
                    style: ThemeText.getDefaultTextTheme()
                        .infomationPaymentStyle
                        .copyWith(
                            color: _actionDescriptionColor(
                                state, ChangeColorForm.descriptionColor))),
                SizedBox(height: 10.h),
                Text(paymentEntity.hint!,
                    textAlign: TextAlign.center,
                    style: ThemeText.getDefaultTextTheme()
                        .infomationPaymentStyle
                        .copyWith(
                            color: _actionDescriptionColor(
                                state, ChangeColorForm.descriptionColor),
                            fontSize: 12.sp)),
              ])
            ],
          ),
        );
      },
    );
  }

  Color _actionButtonColor(
    PaymentsState state,
  ) {
    if (state is PaymentsInitialState && state.indexInitMoney != index ||
        state is PaymentsChangeMoneyState && state.indexMoney != index) {
      return AppColor.lightGrey;
    } else {
      return AppColor.lightPurple;
    }
  }

  Color _actionDescriptionColor(PaymentsState state, ChangeColorForm form) {
    if (state is PaymentsInitialState && state.indexInitMoney != index ||
        state is PaymentsChangeMoneyState && state.indexMoney != index) {
      return AppColor.grey;
    } else {
      switch (form) {
        case ChangeColorForm.titleColor:
          return AppColor.white;
        default:
          return AppColor.lightPurple;
      }
    }
  }
}
