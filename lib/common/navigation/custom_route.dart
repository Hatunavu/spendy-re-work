import 'package:flutter/material.dart';

class CustomRoutes {
  static const rubber = 'rubber';
}

class CustomRoute {
  static final Map<String, Map<String, Route Function(RouteSettings)>> _config =
      {
    CustomRoutes.rubber: {},
  };

  static final Map<String, String> _rewrites = {};

  static Map<String, Route Function(RouteSettings)> getPrefix(
    String prefix,
  ) {
    return _config[prefix]!;
  }

  static Route Function(RouteSettings)? getInitialize(
      String prefix, String name) {
    final init = getPrefix(prefix);
    //return init != null ? init[name] : null;
    return init.isNotEmpty ? init[name] : null;
  }

  static void rewrite(Map<String, String> map) {
    _rewrites.addAll(map);
  }

  static Route? switcher(RouteSettings settings) {
    String routeName = settings.name!;
    while (_rewrites[routeName] != null) {
      routeName = _rewrites[routeName]!;
    }

    final prefix = CustomRoute._config.keys.firstWhere((prefix) {
      return routeName.indexOf('$prefix/') == 0;
    });
    routeName = routeName.substring(prefix.length);
    return getInitialize(prefix, routeName)!.call(settings);
  }

  static String nameWith(String prefix, String name) {
    return '$prefix$name';
  }

  static String wrapInRubberRoute(String route) =>
      CustomRoute.nameWith(CustomRoutes.rubber, route);
}
