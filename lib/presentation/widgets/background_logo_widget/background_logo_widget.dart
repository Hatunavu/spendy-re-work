import 'package:flutter/material.dart';

import 'package:spendy_re_work/common/constants/image_constants.dart';
import 'package:spendy_re_work/presentation/widgets/background_logo_widget/background_logo_constants.dart';

class BackgroundLogoWidget extends StatelessWidget {
  final Widget? child;
  final Widget? leadingTop;
  @override
  final Key? key;

  BackgroundLogoWidget({this.key, this.child, this.leadingTop})
      : assert(child != null, 'child must not be null');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          _backgroundWidget(),
          Visibility(visible: child != null, child: child ?? const Text('')),
          _leadingTopWidget()
        ],
      ),
    );
  }

  Widget _leadingTopWidget() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
          padding: EdgeInsets.only(
              left: BgLogoConstant.paddingLeftLeadingTop,
              top: BgLogoConstant.paddingTopLeadingTop),
          child: leadingTop),
    );
  }

  Widget _backgroundWidget() {
    return Positioned(
        left: BgLogoConstant.paddingLeftBackground,
        child: Image.asset(
          ImageConstants.spendyBackgroundLogo,
          //fit: BoxFit.fitHeight,
          //height: BgLogoConstant.sizeLogo.height,
        ));
  }
}
