import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../utils/enums.dart';

class BluetoothStatusChecker {
  static const DEFAULT_INTERVAL = Duration(seconds: 2);

  factory BluetoothStatusChecker() => _bluetoothStatusChecker;
  BluetoothStatusChecker._() {
    _statusController.onListen = () {
      _sendStatusUpdate();
    };

    _statusController.onCancel = () {
      _timer?.cancel();
      _lastStatus = null;
    };
  }

  static final BluetoothStatusChecker _bluetoothStatusChecker = BluetoothStatusChecker._();

  /// function to get [BluetoothConnectionStatus]
  Future<BluetoothConnectionStatus> get connectionStatus async {
    final FlutterReactiveBle flutterReactiveBle = FlutterReactiveBle();
    final BleStatus hasConnection = flutterReactiveBle.status;
    return hasConnection == BleStatus.ready ? BluetoothConnectionStatus.ON : BluetoothConnectionStatus.OFF;
  }

  Duration checkInterval = DEFAULT_INTERVAL;

  /// function to send status updates
  Future _sendStatusUpdate([Timer timer]) async {
    _timer?.cancel();
    timer?.cancel();

    final _currentStatus = await connectionStatus;

    // if the current status is different from the last known status and stream has listeners then adding the new value to the stream
    if (_currentStatus != _lastStatus && _statusController.hasListener) {
      _statusController.add(_currentStatus);
    }

    // if the stream does not have any listeners returning from the function
    if (!_statusController.hasListener) {
      return;
    }

    // calling the function after an interval of time
    _timer = Timer(checkInterval, _sendStatusUpdate);

    // update last known status
    _lastStatus = _currentStatus;
  }

  BluetoothConnectionStatus _lastStatus;
  Timer _timer;

  final StreamController<BluetoothConnectionStatus> _statusController = StreamController.broadcast();

  /// function to return stream of [BluetoothConnectionStatus]
  Stream<BluetoothConnectionStatus> get onStatusChange => _statusController.stream;

  /// function to check whether [BluetoothConnectionStatus] stream has listeners
  bool get hasListeners => _statusController.hasListener;
}