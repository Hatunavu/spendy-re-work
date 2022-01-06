import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/payments/bloc/payments_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/payments/bloc/payments_state.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class DotWidget extends StatelessWidget {
  const DotWidget({Key? key, this.index}) : super(key: key);
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 6.0.w),
      child: BlocBuilder<PaymentsBloc, PaymentsState>(
        buildWhen: (_, state) => !(state is PaymentsChangeMoneyState),
        builder: (_, state) => Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _colorChange(state),
              border: Border.all(
                color: AppColor.lightPurple,
              )),
        ),
      ),
    );
  }

  Color _colorChange(PaymentsState state) {
    if (state is PaymentsInitialState &&
            state.indexInitSplashContent != index ||
        state is PaymentsChangeSplashContentState &&
            state.indexSplashContent != index) {
      return AppColor.white;
    } else {
      return AppColor.lightPurple;
    }
  }
}
