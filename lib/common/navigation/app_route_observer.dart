import 'package:flutter/widgets.dart';

import 'route_keeper.dart';

class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    RouteKeeper().addRoute(route.settings.name!);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    RouteKeeper().removeRoute(route.settings.name!);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    RouteKeeper().removeRoute(route.settings.name!);
  }
}
