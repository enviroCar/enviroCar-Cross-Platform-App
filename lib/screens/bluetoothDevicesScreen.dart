import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:system_shortcuts/system_shortcuts.dart';

import '../widgets/bleDialog.dart';
import '../constants.dart';
import '../providers/bluetoothProvider.dart';

class BluetoothDevicesScreen extends StatefulWidget {
  static const routeName = '/bluetoothDeviceScreen';

  @override
  _BluetoothDevicesScreenState createState() => _BluetoothDevicesScreenState();
}

class _BluetoothDevicesScreenState extends State<BluetoothDevicesScreen> {
  BleStatus _state;
  bool _isScanning = false;
  FlutterReactiveBle flutterReactiveBlue = FlutterReactiveBle();
  int selected = -1;
  BluetoothProvider bluetoothProvider;

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

  /// function to determine [_state] the status of Bluetooth
  void determineBluetoothStatus() async {
    BleStatus status = await Provider.of<BluetoothProvider>(context, listen: false).bluetoothState();
    setState(() {
      _state = status;
    });
  }

  @override
  void didChangeDependencies() {
    bluetoothProvider = Provider.of<BluetoothProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    flutterReactiveBlue.deinitialize();
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
                    bluetoothProvider.stopScan();
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
              bluetoothProvider.startScan();
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
            bluetoothProvider.stopScan();
            setState(() {
              _isScanning = false;
            });
          }
        },
      ),
      body: Consumer<BluetoothProvider>(
        builder: (context, bluetoothProvider, child) {
          List<DiscoveredDevice> detectedBluetoothDevices = bluetoothProvider.bluetoothDevices;

          return Container(
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
                      onChanged: (value) async {
                        setState(() {
                          selected = value;
                        });
                        bool connectedStatus = await bluetoothProvider.connectToDevice(detectedBluetoothDevices[value], context, value);
                        if (connectedStatus)
                          bluetoothProvider.discoverServices();
                      },
                    ),
                  ),
                );
              },
              itemCount: detectedBluetoothDevices.length,
            ),
          );
        }
      ),
    );
  }
}
