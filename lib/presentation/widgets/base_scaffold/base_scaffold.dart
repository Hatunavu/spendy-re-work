import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/appbar/appbar_widget.dart';

class BaseScaffold extends Scaffold {
  @override
  final Widget? body;
  @override
  final Widget? bottomNavigationBar;
  final String? appBarTitle;
  final Function? actionOnTap;
  final BuildContext? context;
  @override
  final GlobalKey<ScaffoldState>? key;

  final Alignment actionAlignment;
  final bool leading;
  final List<Widget>? actionAppbar;

  BaseScaffold(this.context,
      {this.body,
      this.key,
      this.appBarTitle,
      this.actionAppbar,
      this.actionOnTap,
      this.bottomNavigationBar,
      this.actionAlignment = Alignment.centerRight,
      this.leading = false})
      : super(
          //resizeToAvoidBottomPadding: false,
          resizeToAvoidBottomInset: false,
          key: key,
          backgroundColor: AppColor.white,
          appBar: AppBarWidget(
            title: appBarTitle!,
            leading: leading,
            actions: actionAppbar ?? [],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: body,
          ),
          bottomNavigationBar: bottomNavigationBar,
        );
}
