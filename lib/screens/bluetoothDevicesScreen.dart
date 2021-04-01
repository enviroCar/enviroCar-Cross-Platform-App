import 'package:flutter/material.dart';

import 'package:system_shortcuts/system_shortcuts.dart';
import 'package:flutter_blue/flutter_blue.dart' as blue;

import '../widgets/ble_dialog.dart';

// TODO: Add button to connect to devices after searching them

class BluetoothDevicesScreen extends StatefulWidget {
  @override
  _BluetoothDevicesScreenState createState() => _BluetoothDevicesScreenState();
}

class _BluetoothDevicesScreenState extends State<BluetoothDevicesScreen> {
  blue.BluetoothState state;
  bool isScanning = false;

  // Toggles bluetooth on and off
  Future<void> toggleBluetooth() async {
    await SystemShortcuts.bluetooth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 23, 33, 43),
        elevation: 0,
        actions: [
          // Switch to turn Bluetooth on and off
          StreamBuilder(
            stream: blue.FlutterBlue.instance.state,
            initialData: blue.BluetoothState.unknown,
            builder: (context, snapshot) {
              state = snapshot.data;
              return Switch(
                value: state == blue.BluetoothState.on ? true : false,
                onChanged: (value) {
                  toggleBluetooth();
                },
              );
            },
          ),
        ],
      ),

      // Starts scan and scans for 4 seconds for now
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            isScanning ? Colors.red : Color.fromARGB(255, 0, 223, 165),
        child: isScanning
            ? Icon(
                Icons.stop,
                color: Colors.white,
              )
            : Icon(
                Icons.search_rounded,
                color: Colors.white,
              ),
        onPressed: () {
          if (!isScanning) {
            if (state == blue.BluetoothState.on) {
              setState(() {
                isScanning = true;
              });
              blue.FlutterBlue.instance.startScan(
                timeout: Duration(seconds: 4),
              );
              Future.delayed(
                Duration(seconds: 4),
                () {
                  setState(() {
                    isScanning = false;
                  });
                },
              );
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
              isScanning = false;
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
              builder: (c, snapshot) {
                return Column(
                  children: snapshot.data.map((d) {
                    return ListTile(
                      leading: Icon(
                        Icons.phone_android_sharp,
                      ),
                      title: Text(d.device.name.isEmpty
                          ? 'Unknown Device'
                          : d.device.name),
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
