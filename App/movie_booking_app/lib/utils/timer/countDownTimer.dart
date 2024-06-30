import 'dart:async';

class CountdownManager {
  int _countdown = 300;
  Timer? _timer;

  final Future<void> Function() callApi;

  CountdownManager({required this.callApi});

  int get countdown => _countdown;

  void startApiCallTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_countdown > 0) {
        _countdown--;
      } else {
        await callApi();
      }
    });
  }

  void cancelTimer() {
    _timer?.cancel();
  }
}
