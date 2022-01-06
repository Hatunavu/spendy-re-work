import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/image_constants.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/journey/welcome/welcome_screen_constants.dart';
import 'package:spendy_re_work/presentation/widgets/version_widget/version_widget.dart';

class WelcomeScreen extends StatelessWidget {
  dynamic _startTime(BuildContext context, AuthenticationState state) async {
    if (state is Authenticated) {
      await Navigator.of(context).pushReplacementNamed(RouteList.home,
          arguments: {KeyConstants.tabIndexArg: 0});
    } else if (state is UnAuthenticated) {
      // un authenticated
      await Navigator.of(context)
          .pushReplacementNamed(state.nextRoute); //state.nextRoute
    } else if (state is InitAuthenticatePIN) {
      await Navigator.of(context).pushReplacementNamed(RouteList.enterPIN,
          arguments: {KeyConstants.argPreviousRouteKey: RouteList.welcome});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
          if (state is! AuthenticationLoading) {
            _startTime(context, state);
          }
        }, builder: (context, state) {
          if (state is AuthenticatedFailed) {
            return const Center(
              child: Text('Màn hình lỗi chưa được thiết kế'),
            );
          }
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset(
                      ImageConstants.spendyLogo,
                      width: WelcomeScreenConstants.logoSize.width,
                      height: WelcomeScreenConstants.logoSize.height,
                    ),
                    SizedBox(
                      height: WelcomeScreenConstants.paddingTopSlogan,
                    ),
                    Text(
                      WelcomeScreenConstants.textSlogan,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontSize: WelcomeScreenConstants.fzSlogan,
                          color: AppColor.textColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: WelcomeScreenConstants.versionPaddingTop,
                ),
                VersionInfoWidget()
              ],
            ),
          );
        }),
      ),
    );
  }
}
