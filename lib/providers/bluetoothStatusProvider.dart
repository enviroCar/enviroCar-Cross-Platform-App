import 'package:flutter/foundation.dart';

import '../services/bluetoothStatusChecker.dart';
import '../models/enums/bluetoothConnectionStatus.dart';

class BluetoothStatusProvider extends ChangeNotifier {
  BluetoothConnectionStatus bluetoothStatus;

  BluetoothStatusProvider() {
    bluetoothStatus = BluetoothConnectionStatus.OFF;
    sendStatusUpdates();
  }

  /// function to update bluetooth status upon listening status updates
  void sendStatusUpdates() {
    BluetoothStatusChecker().onStatusChange.listen((status) {
      bluetoothStatus = status;
      notifyListeners();
    });
  }

  /// function to get current [bluetoothStatus]
  BluetoothConnectionStatus get bluetoothState => bluetoothStatus;
}