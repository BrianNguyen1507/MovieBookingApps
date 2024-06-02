import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final _controller = StreamController<bool>.broadcast();
  Stream<bool> get isConnected => _controller.stream;

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }
  void _updateConnectionStatus(List<ConnectivityResult> result) {
    bool isConnected = result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.ethernet);
    _controller.sink.add(isConnected);
  }

  void dispose() {
    _controller.close();
  }
}
