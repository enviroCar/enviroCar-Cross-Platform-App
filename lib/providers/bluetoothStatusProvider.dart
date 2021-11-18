import 'package:flutter/foundation.dart';

import '../utils/enums.dart';
import '../services/bluetoothStatusChecker.dart';

class BluetoothStatusProvider extends ChangeNotifier {
  BluetoothConnectionStatus bluetoothStatus;

  factory BluetoothStatusProvider() => _bluetoothStatusProvider;

  BluetoothStatusProvider._() {
    bluetoothStatus = BluetoothConnectionStatus.OFF;
    updateBluetoothStatus();
  }

  static final BluetoothStatusProvider _bluetoothStatusProvider =
      BluetoothStatusProvider._();

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
