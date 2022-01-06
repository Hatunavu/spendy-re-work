import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/loader/loading_flare_widget.dart';

class LoaderScreen extends StatelessWidget {
  final Color? textColor;

  LoaderScreen({this.textColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.transparent,
      body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black54,
          child: FlareLoadingWidget(
            textColor: textColor,
          )),
    );
  }
}
