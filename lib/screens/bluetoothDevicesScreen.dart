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

  // Toggles bluetooth on and off
  // Works only on Android
  // iOS doesn't give permission to toggle Bluetooth from inside the app
  Future<void> toggleBluetooth() async {
    await SystemShortcuts.bluetooth();
  }

  @override
  void dispose() {
    super.dispose();

    // Stops any running scan before closing the screen
    blue.FlutterBlue.instance.stopScan();
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
                    blue.FlutterBlue.instance.stopScan();
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
              blue.FlutterBlue.instance.startScan();
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
            blue.FlutterBlue.instance.stopScan();
            setState(() {
              _isScanning = false;
            });
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Shows available Bluetooth devices
            StreamBuilder<List<blue.ScanResult>>(
              stream: blue.FlutterBlue.instance.scanResults,
              initialData: [],
              builder: (_, snapshot) {
                return Column(
                  children: snapshot.data.map((d) {
                    return d.device.name.isEmpty
                        ? Container()
                        : ListTile(
                            leading: Icon(
                              Icons.bluetooth,
                            ),
                            title: Text(d.device.name),
                            subtitle: Text(d.device.id.toString()),
                          );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
