import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:meta/meta.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker checker;

  NetworkInfoImpl({@required this.checker});
  @override
  Future<bool> get isConnected => checker.hasConnection;
}
