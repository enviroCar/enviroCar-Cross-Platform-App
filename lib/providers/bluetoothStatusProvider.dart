import 'package:flutter/foundation.dart';

import '../services/bluetoothStatusChecker.dart';
import '../models/enums/bluetoothConnectionStatus.dart';

class BluetoothStatusProvider extends ChangeNotifier {
  BluetoothConnectionStatus bluetoothStatus;

  BluetoothStatusProvider() {
    bluetoothStatus = BluetoothConnectionStatus.OFF;
    updateBluetoothStatus();
  }

  /// function to update bluetooth status upon listening status updates
  void updateBluetoothStatus() {
    BluetoothStatusChecker().onStatusChange.listen((status) {
      bluetoothStatus = status;
      notifyListeners();
    });
  }

  /// function to get current [bluetoothStatus]
  BluetoothConnectionStatus get bluetoothState => bluetoothStatus;
}