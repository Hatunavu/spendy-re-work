import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/constants/string_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/domain/entities/app_default_entity/payment_entity.dart';
import 'package:spendy_re_work/domain/usecases/app_default_usecase.dart';
import 'package:spendy_re_work/presentation/journey/personal/payments/widgets/box_payments.dart';
import 'package:spendy_re_work/presentation/journey/personal/payments/widgets/dot_widget.dart';
import 'package:spendy_re_work/presentation/journey/personal/payments/widgets/menu_payments_screen.dart';
import 'package:spendy_re_work/presentation/journey/personal/payments/widgets/subscription_widget.dart';
import 'package:spendy_re_work/presentation/widgets/button_widget/button_widget.dart';
import 'bloc/payments_bloc.dart';
import 'bloc/payments_event.dart';

class BodyPayments extends StatefulWidget {
  const BodyPayments({Key? key}) : super(key: key);

  @override
  _BodyPaymentsState createState() => _BodyPaymentsState();
}

class _BodyPaymentsState extends State<BodyPayments> {
  late PaymentsBloc _paymentBloc;
  late List<PaymentEntity> _payments;
  late int _lengthListPayment;
  late int _lengthSubscription;
  @override
  void initState() {
    _payments = Injector.resolve<AppDefaultUsecase>().getDataRemoteConfig();
    _paymentBloc = BlocProvider.of<PaymentsBloc>(context);
    _lengthListPayment = _payments.length;
    _lengthSubscription = subscription.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 200.h,
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      onPageChanged: (index) {
                        _paymentBloc.add(
                            ChangeContentEvent(indexInitSplashContent: index));
                      },
                      itemBuilder: (_, index) {
                        final _subscription = subscription[index];
                        final title = translate(_subscription['title']!);
                        final image = translate(_subscription['image']!);
                        final hint = translate(_subscription['hint']!);
                        return SubscriptionWidget(
                            index: index,
                            title: title,
                            image: image,
                            hint: hint);
                      },
                      itemCount: _lengthSubscription,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_lengthSubscription, (index) {
                      return DotWidget(
                        index: index,
                      );
                    }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_lengthListPayment, (index) {
                    final _payment = _payments[index];

                    return GestureDetector(
                      onTap: () {
                        _paymentBloc
                            .add(ChangePaymentsMoneyEvent(indexMoney: index));
                      },
                      child: BoxPayments(
                        paymentEntity: _payment,
                        index: index,
                      ),
                    );
                  })),
            ),
            ButtonWidget.primary(
              width: double.infinity,
              height: 55.h,
              onPress: () {},
              title: startFree,
            ),
            SizedBox(
              height: 10.h,
            ),
            MenuPayments(),
          ],
        ),
      ),
    );
  }
}
