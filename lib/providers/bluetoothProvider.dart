import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:toast/toast.dart';

import '../constants.dart';

class BluetoothProvider extends ChangeNotifier {
  FlutterBlue _flutterBlue;
  BluetoothDevice connectedBluetoothDevice;

  List<BluetoothDevice> _detectedBluetoothDevices;

  // list of the services advertised by the connected bluetooth device
  List<BluetoothService> _services;

  // service id mapped to characteristics of the connected bluetooth device
  Map<Guid, List<BluetoothCharacteristic>> _servicesCharacteristics;

  BluetoothProvider() {
    _flutterBlue = FlutterBlue.instance;
    _detectedBluetoothDevices = [];
    _services = [];
    _servicesCharacteristics = {};
  }

  /// determining the status of bluetooth to initialize [_state] of bluetooth
  Future<bool> bluetoothState() async {
    var status = await _flutterBlue.isOn;
    return status;
  }

  /// function to start the scan and population of [_detectedBluetoothDevices] list if [_state] bluetooth is ON
  void startScan() async {
    bool state = await bluetoothState();
    if (state) {
      scanAndPopulateList();
    }
  }

  /// function to scan and populate list by listening to [connectedDevices] and [scanResults] stream
  void scanAndPopulateList() {
    _flutterBlue.connectedDevices
        .asStream()
        .listen(addConnectedDevices);

    _flutterBlue.scanResults
        .listen(addScannedDevices);

    _flutterBlue.startScan();

  }

  /// callback function to add the [connectedDevices] to [_detectedBluetoothDevices] list
  void addConnectedDevices(List<BluetoothDevice> devices) {
    for (BluetoothDevice bluetoothDevice in devices) {
      addDeviceToList(bluetoothDevice);
      print(bluetoothDevice.toString());
    }
  }

  /// callback function to add the [scannedDevices] to [_detectedBluetoothDevices] list
  void addScannedDevices(List<ScanResult> stream) {
    for (ScanResult scanResult in stream) {
      addDeviceToList(scanResult.device);
      print(scanResult.device.toString());
    }
  }

  /// function to populate the [_detectedBluetoothDevices] list
  void addDeviceToList(BluetoothDevice bluetoothDevice) {
    if (!_detectedBluetoothDevices.contains(bluetoothDevice)) {
      _detectedBluetoothDevices.add(bluetoothDevice);
      notifyListeners();
    }
  }

  /// function to connect to [selectedBluetoothDevice]
  Future<bool> connectToDevice(BluetoothDevice selectedBluetoothDevice, BuildContext context) async {
    Future<bool> returnValue;
    try {
      await selectedBluetoothDevice.connect(
        autoConnect: false,
      ).timeout(
          Duration(seconds: 60), onTimeout: () {
        debugPrint('timeout occurred');
        returnValue = Future.value(false);
        disconnectDevice();
      }).then((value) {
        if (returnValue == null) {
          debugPrint('connection successful');
          Toast.show(
              'Connected to ${selectedBluetoothDevice.name.isNotEmpty ? selectedBluetoothDevice.name : selectedBluetoothDevice.id}',
              context,
              gravity: Toast.BOTTOM,
              duration: Toast.LENGTH_LONG,
              backgroundColor: kTertiaryColor
          );
          connectedBluetoothDevice = selectedBluetoothDevice;
          // discovering the services upon connecting to the device
          discoverServices();
          notifyListeners();
          return true;
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'already_connected') {
        debugPrint('already connected to $selectedBluetoothDevice');
        Toast.show(
            'Already connected to ${selectedBluetoothDevice.name}',
            context,
            gravity: Toast.BOTTOM,
            duration: Toast.LENGTH_LONG,
            backgroundColor: kTertiaryColor
        );
        connectedBluetoothDevice = selectedBluetoothDevice;
        discoverServices();
        notifyListeners();
        return true;
      }
      throw e;
    } catch (e) {
      debugPrint(e.toString());
      Toast.show(
          'Cannot connected to ${selectedBluetoothDevice.name}',
          context,
          gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_LONG,
          backgroundColor: kTertiaryColor
      );
      connectedBluetoothDevice = null;
      notifyListeners();
      throw e;
    }
    return false;
  }

  /// function to discover services
  void discoverServices() async {
    _services = await connectedBluetoothDevice.discoverServices();
    debugPrint('services ${_services.toString()}');
    logCharacteristicsForServices();
  }

  /// function to retrieve the service uuid and characteristic uuid from [_services]
  void logCharacteristicsForServices() async {
    for (BluetoothService service in _services) {
      List<BluetoothCharacteristic> characteristics = [];
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid != null) {
          characteristics.add(characteristic);
        }
        // if the characteristic can be read, reading the value it returns
        if (characteristic.properties.read)
          readCharacteristics(characteristic);

        // if the characteristic have the property to write to it
        if (characteristic.properties.write)
          writeCharacteristics(characteristic);

        // if the characteristic have the property to notify changes in its value
        if (characteristic.properties.notify)
          notify(characteristic);
      }
      _servicesCharacteristics[service.uuid] = characteristics;
    }
  }

  /// function to read data of a particular [characteristic]
  void readCharacteristics(BluetoothCharacteristic characteristic) async {
    List<int> readValue = await characteristic.read().onError((error, stackTrace) {
      debugPrint('error is ${error.toString()}');
      return [];
    });
    debugPrint('read characteristic ${characteristic.uuid.toString()} its value is ${readValue.toString()}');
  }

  /// function to write data to a [characteristic]
  void writeCharacteristics(BluetoothCharacteristic characteristic) async {
    // write characteristics is a way to send data to the bluetooth device
    String response = await characteristic.write([0x12, 0x34]).onError((error, stackTrace) {
      debugPrint('error is ${error.toString()}');
    });
    print('response after writing the characteristics ${characteristic.uuid.toString()} is $response');
  }

  /// notify is simply a callback executed every time the characteristic’s value handling the notifications is updated
  void notify(BluetoothCharacteristic characteristic) async {
    // set notify value property of characteristics and listen to any changes
    await characteristic.setNotifyValue(true).onError((error, stackTrace) {
      debugPrint('error is ${error.toString()}');
      return false;
    });
    characteristic.value.listen((value) {
      debugPrint('characteristics value updated its value is ${value.toString()}');
    });
  }

  /// function to disconnect [selectedBluetoothDevice]
  void disconnectDevice() {
    // clearing the list and map related to services before disconnecting from selected bluetooth device
    if (_services.isNotEmpty) {
      _services.clear();
    }
    if (_servicesCharacteristics.isNotEmpty) {
      _servicesCharacteristics.clear();
    }
    connectedBluetoothDevice.disconnect();
    connectedBluetoothDevice = null;
    notifyListeners();
  }

  /// function to stop the scan in progress
  void stopScan() {
    _flutterBlue.stopScan();
  }

  /// function to return [_detectedBluetoothDevices]
  List<BluetoothDevice> get bluetoothDevices {
    return [..._detectedBluetoothDevices];
  }

  /// function to return [connectedBluetoothDevice]
  BluetoothDevice get getConnectedDevice => connectedBluetoothDevice;

  /// function to check whether the device is connected
  bool isConnected() {
    return connectedBluetoothDevice == null ? false : true;
  }

}