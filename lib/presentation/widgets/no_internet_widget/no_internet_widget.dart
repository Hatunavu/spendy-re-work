import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/image_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/no_internet_widget/no_internet_widget_constants.dart';

class NoInternetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(ImageConstants.imgNoInternetErr),
          const SizedBox(
            height: LayoutConstants.dimen_13,
          ),
          Text(
            NoInterNetWidgetConstants.noInternetConnection,
            style: ThemeText.getDefaultTextTheme().textNoInternet,
          ),
        ],
      ),
    );
  }
}
