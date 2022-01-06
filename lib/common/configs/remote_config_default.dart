import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigDefault {
  final RemoteConfig _remoteConfigSpendy = RemoteConfig.instance;

  Future<void> initialApp() async {
    await _remoteConfigSpendy.fetchAndActivate();
    await _remoteConfigSpendy.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 1),
      minimumFetchInterval: const Duration(hours: 12),
    ));
  }

  String get version => _remoteConfigSpendy.getString('min_version');

  String get payments => _remoteConfigSpendy.getString('payments');

  String get defaultGroups => _remoteConfigSpendy.getString('default_groups');
}
