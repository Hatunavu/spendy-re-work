import 'package:flutter/material.dart';
import 'package:spendy_re_work/presentation/journey/welcome/welcome_screen.dart';
import '../../../common/constants/route_constants.dart';

class WelcomeRoutes {
  static Map<String, WidgetBuilder> getAll() {
    return {
      RouteList.welcome: (context) {
        return WelcomeScreen();
      },
    };
  }
}
