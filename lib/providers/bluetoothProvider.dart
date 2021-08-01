import 'package:envirocar_app_main/obd/ascii_util.dart';
import 'package:envirocar_app_main/obd/obdResponseParser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  List<BluetoothCharacteristic> readCharacteristicsQueue;
  List<BluetoothCharacteristic> writeCharacteristicsQueue;
  List<BluetoothCharacteristic> notifyCharacteristicsQueue;

  factory BluetoothProvider() => _bluetoothProvider;

  BluetoothProvider._() {
    _flutterBlue = FlutterBlue.instance;
    _detectedBluetoothDevices = [];
    _services = [];
    _servicesCharacteristics = {};
    readCharacteristicsQueue = [];
    writeCharacteristicsQueue = [];
    notifyCharacteristicsQueue = [];
  }

  static final BluetoothProvider _bluetoothProvider = BluetoothProvider._();

  /// determining the status of bluetooth to initialize [_state] of bluetooth
  Future<bool> bluetoothState() async {
    final status = await _flutterBlue.isOn;
    return status;
  }

  /// function to start the scan and population of [_detectedBluetoothDevices] list if [_state] bluetooth is ON
  Future startScan() async {
    final state = await bluetoothState();
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
    for (final BluetoothDevice bluetoothDevice in devices) {
      addDeviceToList(bluetoothDevice);
      debugPrint(bluetoothDevice.toString());
    }
  }

  /// callback function to add the [scannedDevices] to [_detectedBluetoothDevices] list
  void addScannedDevices(List<ScanResult> stream) {
    for (final ScanResult scanResult in stream) {
      addDeviceToList(scanResult.device);
      debugPrint(scanResult.device.toString());
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
    String deviceDisplayName;
    if (selectedBluetoothDevice.name.trim().isNotEmpty) {
      deviceDisplayName = selectedBluetoothDevice.name;
    }
    else {
      deviceDisplayName = selectedBluetoothDevice.id.toString();
    }

    try {
      await selectedBluetoothDevice.connect(
        autoConnect: false,
      ).timeout(
          const Duration(seconds: 30), onTimeout: () {
        debugPrint('timeout occurred');
        returnValue = Future.value(false);
        disconnectDevice();
      }).then((value) {
        if (returnValue == null) {
          debugPrint('connection successful');
          Toast.show(
              'Connected to $deviceDisplayName',
              context,
              gravity: Toast.BOTTOM,
              duration: Toast.LENGTH_LONG,
              backgroundColor: kTertiaryColor
          );
          connectedBluetoothDevice = selectedBluetoothDevice;
          // discovering the services upon connecting to the device
          discoverServices();
          notifyListeners();
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'already_connected') {
        debugPrint('already connected to $deviceDisplayName');
        Toast.show(
            'Already connected to $deviceDisplayName',
            context,
            gravity: Toast.BOTTOM,
            duration: Toast.LENGTH_LONG,
            backgroundColor: kTertiaryColor
        );
        connectedBluetoothDevice = selectedBluetoothDevice;
        discoverServices();
        notifyListeners();
      }
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      Toast.show(
          'Cannot connected to $deviceDisplayName',
          context,
          gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_LONG,
          backgroundColor: kTertiaryColor
      );
      connectedBluetoothDevice = null;
      notifyListeners();
      rethrow;
    }
    return connectedBluetoothDevice == null ? false : true;
  }

  /// function to discover services
  Future discoverServices() async {
    _services = await connectedBluetoothDevice.discoverServices();
    debugPrint('services ${_services.toString()}');
    logCharacteristicsForServices();
  }

  /// function to retrieve the service uuid and characteristic uuid from [_services]
  void logCharacteristicsForServices() {
    for (final BluetoothService service in _services) {
      final List<BluetoothCharacteristic> characteristics = [];
      for (final BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid != null) {
          characteristics.add(characteristic);
        }

        if (service.uuid.toString().toLowerCase().substring(4,8) == "fff0") {
          if (characteristic.uuid.toString().startsWith("0000fff1-0000-1000-8000", 0)) {
            // if the characteristic can be read, reading the value it returns
            if (characteristic.properties.read) {
              addCharacteristicsToReadQueue(characteristic);
            }

            // if the characteristic have the property to write to it
            if (characteristic.properties.write) {
              addCharacteristicsToWriteQueue(characteristic);
            }

            // if the characteristic have the property to notify changes in its value
            if (characteristic.properties.notify) {
              addCharacteristicsToNotifyQueue(characteristic);
            }
          }
        }
      }
      _servicesCharacteristics[service.uuid] = characteristics;
    }

    // logging the values of read, write and notify queue
    debugPrint('read queue ${readCharacteristicsQueue.length} is ${readCharacteristicsQueue.toString()}');
    debugPrint('write queue ${writeCharacteristicsQueue.length} is ${writeCharacteristicsQueue.toString()}');
    debugPrint('notify queue ${notifyCharacteristicsQueue.length} is ${notifyCharacteristicsQueue.toString()}');

  }

  /// function to call read, write and notify characteristics functions
  Future interactWithDevice(List<int> value) async {
    if (readCharacteristicsQueue.isNotEmpty) {
      for (final BluetoothCharacteristic readCh in readCharacteristicsQueue) {
        final List<int> value = await readCharacteristics(readCh);
        if (value != null) {
          dataCallback(value);
        }
      }
    }

    if (writeCharacteristicsQueue.isNotEmpty) {
      for (final BluetoothCharacteristic writeCh in writeCharacteristicsQueue) {
        await writeCharacteristics(writeCh, value);
      }
    }

    if (notifyCharacteristicsQueue.isNotEmpty) {
      for (final BluetoothCharacteristic notifyCh in notifyCharacteristicsQueue) {
        await notify(notifyCh);
      }
    }
  }

  void dataCallback(List<int> value) {
    final List<int> data = [];
    for (var i = 0; i < value.length; i++) {
      String dataString = value[i].toRadixString(16);
      if (dataString.length < 2) {
        dataString = "0$dataString";
      }
      dataString = "0x$dataString";
      data.add(hexadecimalToDecimal(dataString));
    }

    // ObdResponseParseService(buffer: data).parseSpeed();
    // ObdResponseParseService(buffer: data).parseRPM();
    // ObdResponseParseService(buffer: data).parseFuelLevel();
    // ObdResponseParseService(buffer: data).parseTemperature();
    // ObdResponseParseService(buffer: data).parseVIN();
  }

  void addCharacteristicsToReadQueue(BluetoothCharacteristic characteristic) {
    readCharacteristicsQueue.add(characteristic);
  }

  void addCharacteristicsToWriteQueue(BluetoothCharacteristic characteristic) {
    writeCharacteristicsQueue.add(characteristic);
  }

  void addCharacteristicsToNotifyQueue(BluetoothCharacteristic characteristic) {
    notifyCharacteristicsQueue.add(characteristic);
  }

  /// function to read data of a particular [characteristic]
  Future<List<int>> readCharacteristics(BluetoothCharacteristic characteristic) async {
    final List<int> readValue = await characteristic.read().onError((error, stackTrace) {
      debugPrint('error is ${error.toString()}');
      return null;
    });

    if (readValue != null) {
      return readValue;
      // debugPrint('read characteristic ${characteristic.uuid.toString()} its value is ${readValue.toString()}');
    }

    return null;
  }

  /// function to write data to a [characteristic]
  Future writeCharacteristics(BluetoothCharacteristic characteristic, List<int> value) async {
    // write characteristics is a way to send data to the bluetooth device
    final String response = await characteristic.write(value).onError((error, stackTrace) {
      debugPrint('error is ${error.toString()}');
    });
    debugPrint('response after writing the characteristics ${characteristic.uuid.toString()} is $response');
  }

  /// notify is simply a callback executed every time the characteristic’s value handling the notifications is updated
  Future notify(BluetoothCharacteristic characteristic) async {
    // set notify value property of characteristics and listen to any changes
    await characteristic.setNotifyValue(true).onError((error, stackTrace) {
      debugPrint('error is ${error.toString()}');
      return false;
    });
    characteristic.value.listen((value) {
      debugPrint('characteristics (${characteristic.uuid.toString()}) value updated, its value is ${value.toString()}');
    });
  }

  /// function to disconnect [selectedBluetoothDevice]
  void disconnectDevice() {
    // clearing the list and map related to services before disconnecting from connected bluetooth device
    if (_services.isNotEmpty) {
      _services.clear();
    }
    if (_servicesCharacteristics.isNotEmpty) {
      _servicesCharacteristics.clear();
    }

    // clearing the list of read characteristics list before disconnecting from the connected bluetooth device
    if (readCharacteristicsQueue.isNotEmpty) {
      readCharacteristicsQueue.clear();
    }

    // clearing the list of write characteristics list before disconnecting from the connected bluetooth device
    if (writeCharacteristicsQueue.isNotEmpty) {
      writeCharacteristicsQueue.clear();
    }

    // clearing the list of notify characteristics list before disconnecting from the connected bluetooth device
    if (notifyCharacteristicsQueue.isNotEmpty) {
      notifyCharacteristicsQueue.clear();
    }

    // disconnecting from the connected bluetooth device
    if (connectedBluetoothDevice != null) {
      connectedBluetoothDevice.disconnect();
      connectedBluetoothDevice = null;
    }
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