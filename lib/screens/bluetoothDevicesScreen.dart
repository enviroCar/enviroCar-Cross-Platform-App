import 'package:flutter/material.dart';

import 'package:system_shortcuts/system_shortcuts.dart';
import 'package:flutter_blue/flutter_blue.dart' as blue;

import '../widgets/bleDialog.dart';
import '../constants.dart';

// TODO: Add button to connect to devices after searching them

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

  /// Toggles bluetooth on and off
  // Works only on Android
  // iOS doesn't give permission to toggle Bluetooth from inside the app
  Future<void> toggleBluetooth() async {
    await SystemShortcuts.bluetooth();
  }

  @override
  void initState() {
    selected = -1;
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
    _flutterBlue.stopScan();
    Future<bool> returnValue;
    await selectedBluetoothDevice.connect(
      autoConnect: false,
    ).timeout(
      Duration(seconds: 60), onTimeout: () {
       print('timeout occurred');
       returnValue = Future.value(false);
       disconnectDevice();
    }).then((value) {
      if (returnValue == null) {
        print('connection successful');
      }
    });
    // try {
    //   await selectedBluetoothDevice.connect(
    //     autoConnect: false,
    //   ).whenComplete(() => {
    //     print('connected to ${selectedBluetoothDevice.state}')
    //   });
    // } catch (e) {
    //   throw e;
    // } finally {
    //   var services = await selectedBluetoothDevice.services.toList();
    //   print('services ${services.toString()}');
    // }
  }

  /// function to disconnect [selectedBluetoothDevice]
  void disconnectDevice() {
    selectedBluetoothDevice.disconnect();
  }

  @override
  void dispose() {
    super.dispose();

    // Stops any running scan before closing the screen
    _flutterBlue.stopScan();
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
                    _flutterBlue.stopScan();
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
            _flutterBlue.stopScan();
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
