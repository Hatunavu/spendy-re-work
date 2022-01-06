import 'default_env.dart';

class Configurations {
  static const String androidID =
      'com.acaziasoft.spendy'; //com.acaziasoft.spendy
  static const String iosID = '1506769608'; //1506769608

  // static const String androidID = "com.acaziasoft.youngKids";//com.acaziasoft.spendy
  // static const String iosID= "1519187050";//1506769608

  // static String _host = DefaultConfig.host;
  // static String _token = DefaultConfig.token;
  static int _splashScreenSecondTimeOut =
      DefaultConfig.splashScreenSecondTimeOut;
  static String _environment = DefaultConfig.environment;

  // static String get host => _host;
  //
  // static String get token => _token;

  static int get splashScreenSecondTimeOut => _splashScreenSecondTimeOut;

  static String get environment => _environment;

  int getIntegerValue(String value, int defaultValue) {
    if (value.isEmpty) {
      return defaultValue;
    } else {
      return int.parse(value);
    }
  }

  void setConfigurationValues(Map<String, dynamic> value) {
    // Set default application constant if configuration value is null
    // _host = value['host'] ?? DefaultConfig.host;
    // _token = value['token'] ?? DefaultConfig.token;
    _environment = value['environment'] ?? DefaultConfig.environment;
    _splashScreenSecondTimeOut = getIntegerValue(
      value['splashScreenSecondTimeOut'],
      DefaultConfig.splashScreenSecondTimeOut,
    );
  }
}
