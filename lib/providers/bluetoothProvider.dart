import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:toast/toast.dart';

import '../constants.dart';

class BluetoothProvider extends ChangeNotifier {
  FlutterReactiveBle _flutterReactiveBle;
  DiscoveredDevice connectedBluetoothDevice;
  BuildContext context;

  List<DiscoveredDevice> _detectedBluetoothDevices;

  // list of services advertised by the connected bluetooth device
  List<DiscoveredService> _services;

  Map<Uuid, List<Uuid>> _servicesCharacteristics;

  factory BluetoothProvider() => _bluetoothProvider;

  BluetoothProvider._() {
    _flutterReactiveBle = FlutterReactiveBle();
    _detectedBluetoothDevices = [];
    _services = [];
    _servicesCharacteristics = {};
  }

  static final BluetoothProvider _bluetoothProvider = BluetoothProvider._();

  Future<BleStatus> bluetoothState() async {
    return _flutterReactiveBle.status;
  }

  /// function to scan the devices and populate the [_detectedBluetoothDevices] list
  Future startScan() async {
    // withServices specifies the advertised services IDs to look for
    // but if an empty list is passed as a parameter,  all advertising devices are listed
    _flutterReactiveBle = FlutterReactiveBle();
    final BleStatus bleStatus = await bluetoothState();
    if (bleStatus == BleStatus.ready) {
      _flutterReactiveBle.scanForDevices(withServices: [], scanMode: ScanMode.balanced).listen((device) {
        populateList(device);
      }).onError(handleError);
    }
  }

  /// function to add the [discoveredDevice] to [_detectedBluetoothDevices] list
  void populateList(DiscoveredDevice discoveredDevice) {
    if (_detectedBluetoothDevices.isEmpty) {
      debugPrint(discoveredDevice.toString());
      _detectedBluetoothDevices.add(discoveredDevice);
      notifyListeners();
      return;
    }

    bool addDeviceToList = true;
    for (final DiscoveredDevice device in _detectedBluetoothDevices) {
      if (device.id == discoveredDevice.id) {
        addDeviceToList = false;
        break;
      }
    }

    if (addDeviceToList) {
      debugPrint(discoveredDevice.toString());
      _detectedBluetoothDevices.add(discoveredDevice);
      notifyListeners();
    }
  }

  /// function to handle error while scanning
  void handleError(Object error, StackTrace stackTrace) {
    debugPrint(error.toString());
    debugPrint(stackTrace.toString());
  }

  /// function to stop scanning by deinitializing [_flutterReactiveBle]
  void stopScan() {
    _flutterReactiveBle.deinitialize();
  }

  /// function to connect to selected device
  Future<bool> connectToDevice(DiscoveredDevice selectedDevice, BuildContext ctx, int index) async {
    context = ctx;
    _flutterReactiveBle.connectToDevice(
      id: selectedDevice.id,
      connectionTimeout: const Duration(seconds: 10),
      // servicesWithCharacteristicsToDiscover: // TODO: specify characteristics for OBD-II for faster connection
    ).listen(sendConnectionStatusUpdates).onError(handleError);
    connectedBluetoothDevice = selectedDevice;
    notifyListeners();
    return connectedBluetoothDevice == null ? false : true;
  }

  /// callback function to send connection status updates
  void sendConnectionStatusUpdates(ConnectionStateUpdate connectionStateUpdate) {
    debugPrint('connected to ${connectedBluetoothDevice.id}');
    debugPrint('connection state ${connectionStateUpdate.connectionState.toString()}');
    debugPrint('device id ${connectionStateUpdate.deviceId}');
    debugPrint('failure ${connectionStateUpdate.failure.toString()}');

    if (connectionStateUpdate.failure != null) {
      debugPrint('connection unsuccessful');
      Toast.show(
          'Cannot connect to ${connectedBluetoothDevice.name.isNotEmpty ? connectedBluetoothDevice.name : connectedBluetoothDevice.id}',
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          backgroundColor: kTertiaryColor
      );
      connectedBluetoothDevice = null;
      notifyListeners();
    }

    if (connectionStateUpdate.connectionState == DeviceConnectionState.connected) {
      Toast.show(
          'Connected to ${connectedBluetoothDevice.name.isNotEmpty ? connectedBluetoothDevice.name : connectedBluetoothDevice.id}',
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          backgroundColor: kTertiaryColor
      );
      discoverServices();
    }
  }

  /// function to discover services
  Future discoverServices() async {
    _flutterReactiveBle = FlutterReactiveBle();
    _services = await _flutterReactiveBle.discoverServices(connectedBluetoothDevice.id);
    // debugPrint(_services.toString());
    logCharacteristicsForServices();
  }

  /// function to add the [serviceId] and [characteristicIds] to [_servicesCharacteristics]
  Future logCharacteristicsForServices() async {
    for (final DiscoveredService service in _services) {
      _servicesCharacteristics[service.serviceId] = service.characteristicIds;
      // debugPrint('service id ${service.serviceId.toString()} characteristics Id ${service.characteristicIds.toString()}');
      for (final Uuid characteristicId in service.characteristicIds) {
        readCharacteristic(service.serviceId, characteristicId);
        // writeCharacteristic(service.serviceId, characteristicId, [0x00]);
        // subscribeCharacteristic(service.serviceId, characteristicId);
      }
    }
  }

  /// function to read characteristic
  Future readCharacteristic(Uuid serviceId, Uuid characteristicId) async {
    _flutterReactiveBle = FlutterReactiveBle();
    final QualifiedCharacteristic qualifiedCharacteristic = QualifiedCharacteristic(characteristicId: characteristicId, serviceId: serviceId, deviceId: connectedBluetoothDevice.id);

    final List<int> response = await _flutterReactiveBle.readCharacteristic(qualifiedCharacteristic)
        .catchError((e) {
      debugPrint('error is ${e.toString()}');
    });

    debugPrint('read characteristics response ${response.toString()}');
  }

  /// function to write characteristic value
  Future writeCharacteristic(Uuid serviceId, Uuid characteristicId, List<int> byteArray) async {
    _flutterReactiveBle = FlutterReactiveBle();
    final QualifiedCharacteristic qualifiedCharacteristic = QualifiedCharacteristic(characteristicId: characteristicId, serviceId: serviceId, deviceId: connectedBluetoothDevice.id);

    await _flutterReactiveBle.writeCharacteristicWithResponse(qualifiedCharacteristic, value: byteArray).whenComplete(() {
      debugPrint('write operation completed');
    }).catchError((e) {
      debugPrint('error is ${e.toString()}');
    });
  }

  /// function to subscribe to a characteristic and listen to the updates in the value of [characteristic]
  Future subscribeCharacteristic(Uuid serviceId, Uuid characteristicId) async {
    _flutterReactiveBle = FlutterReactiveBle();
    final QualifiedCharacteristic qualifiedCharacteristic = QualifiedCharacteristic(characteristicId: characteristicId, serviceId: serviceId, deviceId: connectedBluetoothDevice.id);

    try {
      _flutterReactiveBle.subscribeToCharacteristic(qualifiedCharacteristic).listen((value) {
        debugPrint('the value of characteristic is ${value.toString()}');
      }).onError((e) {
        debugPrint('error is ${e.toString()}');
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// function to return [_detectedBluetoothDevices]
  List<DiscoveredDevice> get bluetoothDevices {
    return [..._detectedBluetoothDevices];
  }

  /// function to return [connectedBluetoothDevice]
  DiscoveredDevice get getConnectedDevice => connectedBluetoothDevice;

  /// function to check whether the device is connected
  bool isConnected() {
    return connectedBluetoothDevice == null ? false : true;
  }

}