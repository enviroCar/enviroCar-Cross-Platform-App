import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:system_shortcuts/system_shortcuts.dart';
import 'package:flutter_blue/flutter_blue.dart' as blue;
import 'package:toast/toast.dart';

import '../widgets/bleDialog.dart';
import '../constants.dart';

class BluetoothDevicesScreen extends StatefulWidget {
  static const routeName = '/bluetoothDeviceScreen';

  @override
  _BluetoothDevicesScreenState createState() => _BluetoothDevicesScreenState();
}

class _BluetoothDevicesScreenState extends State<BluetoothDevicesScreen> {
  blue.BluetoothState _state;
  bool _isScanning = false;
  final blue.FlutterBlue _flutterBlue = blue.FlutterBlue.instance;
  final List<blue.BluetoothDevice> detectedBluetoothDevices = [];
  int selected;
  blue.BluetoothDevice selectedBluetoothDevice;
  List<blue.BluetoothService> _services;
  Map<blue.Guid, List<blue.BluetoothCharacteristic>> _servicesCharacteristics;

  /// Toggles bluetooth on and off
  // Works only on Android
  // iOS doesn't give permission to toggle Bluetooth from inside the app
  Future<void> toggleBluetooth() async {
    await SystemShortcuts.bluetooth();
  }

  @override
  void initState() {
    selected = -1;
    _services = [];
    _servicesCharacteristics = {};
    determineBluetoothStatus();
    super.initState();
  }

  /// determining the status of bluetooth to initialize [_state] of bluetooth
  void determineBluetoothStatus() async {
    var state = await _flutterBlue.isOn;
    setState(() {
      _state = state ? blue.BluetoothState.on : blue.BluetoothState.off;
    });
  }

  /// function to start the scan and population of [detectedBluetoothDevices] list if [_state] bluetooth is ON
  void startScan() async {
    if (_state == blue.BluetoothState.on) {
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

  /// callback function to add the [connectedDevices] to [detectedBluetoothDevices] list
  void addConnectedDevices(List<blue.BluetoothDevice> devices) {
    for (blue.BluetoothDevice bluetoothDevice in devices) {
      addDeviceToList(bluetoothDevice);
      print(bluetoothDevice.toString());
    }
  }

  /// callback function to add the [scannedDevices] to [detectedBluetoothDevices] list
  void addScannedDevices(List<blue.ScanResult> stream) {
    for (blue.ScanResult scanResult in stream) {
      addDeviceToList(scanResult.device);
      print(scanResult.device.toString());
    }
  }

  /// function to populate the [detectedBluetoothDevices] list
  void addDeviceToList(blue.BluetoothDevice bluetoothDevice) {
    if (!detectedBluetoothDevices.contains(bluetoothDevice)) {
      setState(() {
        detectedBluetoothDevices.add(bluetoothDevice);
      });
    }
  }

  /// function to connect to [selectedBluetoothDevice]
  void connectToDevice() async {
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
            backgroundColor: Colors.black87
          );
          // discovering the services upon connecting to the device
          discoverServices();
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
          backgroundColor: Colors.black87
        );
        discoverServices();
      }
      throw e;
    } catch (e) {
      debugPrint(e.toString());
      Toast.show(
        'Cannot connected to ${selectedBluetoothDevice.name}',
        context,
        gravity: Toast.BOTTOM,
        duration: Toast.LENGTH_LONG,
        backgroundColor: Colors.black87
      );
      throw e;
    }
  }

  /// function to discover services
  void discoverServices() async {
    _services = await selectedBluetoothDevice.discoverServices();
    debugPrint('services ${_services.toString()}');
    logCharacteristicsForServices();
  }

  /// function to retrieve the service uuid and characteristic uuid from [_services]
  void logCharacteristicsForServices() async {
    for (blue.BluetoothService service in _services) {
      List<blue.BluetoothCharacteristic> characteristics = [];
      for (blue.BluetoothCharacteristic characteristic in service.characteristics) {
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
  void readCharacteristics(blue.BluetoothCharacteristic characteristic) async {
    List<int> readValue = await characteristic.read();
    debugPrint('read characteristic ${characteristic.uuid.toString()} its value is ${readValue.toString()}');
  }

  /// function to write data to a [characteristic]
  void writeCharacteristics(blue.BluetoothCharacteristic characteristic) async {
    // write characteristics is a way to send data to the bluetooth device
    String response = await characteristic.write([0x12, 0x34]);
    print('response after writing the characteristics ${characteristic.uuid.toString()} is $response');
  }

  /// notify is simply a callback executed every time the characteristic’s value handling the notifications is updated
  void notify(blue.BluetoothCharacteristic characteristic) async {
    // set notify value property of characteristics and listen to any changes
    await characteristic.setNotifyValue(true);
    characteristic.value.listen((value) {
      debugPrint('characteristics value updated its first value is ${value.toString()}');
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
    selectedBluetoothDevice.disconnect();
  }

  /// function to stop the scan in progress
  void stopScan() {
    _flutterBlue.stopScan();
  }

  @override
  void dispose() {
    super.dispose();

    // Stops any running scan before closing the screen
    stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreyColor,
        elevation: 0,
        actions: [
          // Switch to turn Bluetooth on and off
          StreamBuilder(
            stream: blue.FlutterBlue.instance.state,
            initialData: blue.BluetoothState.unknown,
            builder: (context, snapshot) {
              _state = snapshot.data;
              return Switch(
                value: _state == blue.BluetoothState.on ? true : false,
                onChanged: (value) async {
                  if (_isScanning) {
                    stopScan();
                    setState(() {
                      _isScanning = false;
                    });
                  }
                  toggleBluetooth();
                },
              );
            },
          ),
        ],
      ),

      // Button to start and stop scanning
      floatingActionButton: FloatingActionButton(
        backgroundColor: _isScanning ? Colors.red : kSpringColor,
        child: _isScanning
            ? Icon(
                Icons.stop,
                color: Colors.white,
              )
            : Icon(
                Icons.search_rounded,
                color: Colors.white,
              ),
        onPressed: () {
          if (!_isScanning) {
            if (_state == blue.BluetoothState.on) {
              setState(() {
                _isScanning = true;
              });
              startScan();
            } else {
              showDialog(
                context: context,
                builder: (_) {
                  return BLEDialog(
                    toggleBluetooth: toggleBluetooth,
                  );
                },
              );
            }
          } else {
            stopScan();
            setState(() {
              _isScanning = false;
            });
          }
        },
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (BuildContext context, index) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: ListTile(
                title: Text(
                  (detectedBluetoothDevices[index].name == null || detectedBluetoothDevices[index].name.trim().length == 0) ? 'Unknown Device' : detectedBluetoothDevices[index].name,
                ),
                subtitle: Text(
                  detectedBluetoothDevices[index].id.toString()
                ),
                trailing: Radio(
                  activeColor: kSpringColor,
                  value: index,
                  groupValue: selected,
                  onChanged: (value) {
                    setState(() {
                      // disconnecting the previously connected device before connecting to new bluetooth device
                      if (selected != -1)
                        disconnectDevice();
                      selected = value;
                      selectedBluetoothDevice = detectedBluetoothDevices[value];
                    });
                    connectToDevice();
                  },
                ),
              ),
            );
          },
          itemCount: detectedBluetoothDevices.length,
        ),
      ),
    );
  }
}
