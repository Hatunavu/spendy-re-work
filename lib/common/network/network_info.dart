import 'package:spendy_re_work/common/data_connection_checker/data_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker _connectionChecker;

  NetworkInfoImpl(this._connectionChecker);

  @override
  Future<bool> get isConnected async =>
      Future<bool>.value(await _connectionChecker.hasConnection);
}
