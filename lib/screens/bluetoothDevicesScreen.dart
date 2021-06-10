import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

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
  BleStatus _state;
  bool _isScanning = false;
  FlutterReactiveBle flutterReactiveBlue = FlutterReactiveBle();
  final List<DiscoveredDevice> detectedBluetoothDevices = [];
  int selected = -1;

  /// Toggles bluetooth on and off
  // Works only on Android
  // iOS doesn't give permission to toggle Bluetooth from inside the app
  Future<void> toggleBluetooth() async {
    await SystemShortcuts.bluetooth();
  }

  @override
  void initState() {
    determineBluetoothStatus();
    super.initState();
  }

  /// function to scan the devices and populate the [detectedBluetoothDevices] list
  void startScan() {
    // withServices specifies the advertised services IDs to look for
    // but if an empty list is passed as a parameter,  all advertising devices are listed
    flutterReactiveBlue = FlutterReactiveBle();
    determineBluetoothStatus();
    if (_state == BleStatus.ready) {
      flutterReactiveBlue.scanForDevices(withServices: [], scanMode: ScanMode.balanced).listen((device) {
        populateList(device);
      }).onError(handleError);
    }
  }

  /// function to add the [discoveredDevice] to [detectedBluetoothDevices] list
  void populateList(DiscoveredDevice discoveredDevice) {
    if (detectedBluetoothDevices.isEmpty) {
      print(discoveredDevice.toString());
      setState(() {
        detectedBluetoothDevices.add(discoveredDevice);
      });
      return;
    }

    for (DiscoveredDevice device in detectedBluetoothDevices) {
      if (device.id != discoveredDevice.id) {
        print(discoveredDevice.toString());
        setState(() {
          detectedBluetoothDevices.add(discoveredDevice);
        });
      }
    }
  }

  /// function to determine [_state] the status of Bluetooth
  void determineBluetoothStatus() {
    flutterReactiveBlue.statusStream.listen((status) {
      // code for handling status updates
      setState(() {
        _state = status;
      });
    });
  }

  /// function to handle error while scanning
  void handleError(e) {
    print(e.toString());
  }

  /// function to stop scanning by deinitializing [flutterReactiveBlue]
  void stopScan() {
    flutterReactiveBlue.deinitialize();
  }

  @override
  void dispose() {
    super.dispose();
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
            stream: flutterReactiveBlue.statusStream,
            initialData: BleStatus.unknown,
            builder: (context, snapshot) {
              _state = snapshot.data;
              return Switch(
                value: _state == BleStatus.ready ? true : false,
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
            if (_state == BleStatus.ready) {
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
                    (detectedBluetoothDevices[index].name == null || detectedBluetoothDevices[index].name.trim().length == 0) ? 'Unknown device' : detectedBluetoothDevices[index].name,
                ),
                subtitle: Text(
                  detectedBluetoothDevices[index].id,
                ),
                trailing: Radio(
                  activeColor: kSpringColor,
                  value: index,
                  groupValue: selected,
                  onChanged: (value) {
                    setState(() {
                      selected = value;
                    });
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
