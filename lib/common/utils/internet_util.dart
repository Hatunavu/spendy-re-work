import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

class InternetUtil {
  static final Connectivity connectivity = Connectivity();

  static Future<ConnectivityResult?> checkInternetConnection() async {
    ConnectivityResult connectivityResult = ConnectivityResult.none;
    try {
      connectivityResult = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('$e');
      return null;
    }
    return connectivityResult;
  }
}
