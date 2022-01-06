class RouteKeeper {
  static final RouteKeeper _instance = RouteKeeper._internal();
  final List<String> _activeRouteList = [];
  factory RouteKeeper() => _instance;
  RouteKeeper._internal();

  void addRoute(String routeName) {
    _activeRouteList.add(routeName);
  }

  void removeRoute(String routeName) {
    _activeRouteList.remove(routeName);
  }

  bool doesRouteExists(String routeName) =>
      _activeRouteList.contains(routeName);
}
