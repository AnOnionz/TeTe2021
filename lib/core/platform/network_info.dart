import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo{
  Future<bool> get isConnected;
  Stream<InternetConnectionStatus> get listener;
}
class NetworkInfoImpl extends NetworkInfo{
  final InternetConnectionChecker _connectionChecker;

  NetworkInfoImpl(this._connectionChecker);
  @override
  Future<bool> get isConnected async => await _connectionChecker.hasConnection;

  @override
  Stream<InternetConnectionStatus> get listener => _connectionChecker.onStatusChange;


}