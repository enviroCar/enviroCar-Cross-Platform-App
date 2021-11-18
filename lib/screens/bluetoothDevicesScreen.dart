import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:system_shortcuts/system_shortcuts.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../constants.dart';
import '../widgets/bleDialog.dart';
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
  Future determineBluetoothStatus() async {
    final BleStatus status =
        await Provider.of<BluetoothProvider>(context, listen: false)
            .bluetoothState();
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
            builder: (context, AsyncSnapshot<BleStatus> snapshot) {
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
        child: _isScanning
            ? const Icon(
                Icons.stop,
                color: Colors.white,
              )
            : const Icon(
                Icons.search_rounded,
                color: Colors.white,
              ),
      ),
      body: Consumer<BluetoothProvider>(
          builder: (context, bluetoothProvider, child) {
        final List<DiscoveredDevice> detectedBluetoothDevices =
            bluetoothProvider.bluetoothDevices;

        return ListView.builder(
          itemBuilder: (BuildContext context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ListTile(
                title: Text(
                  (detectedBluetoothDevices[index].name == null ||
                          detectedBluetoothDevices[index].name.trim().isEmpty)
                      ? 'Unknown device'
                      : detectedBluetoothDevices[index].name,
                ),
                subtitle: Text(
                  detectedBluetoothDevices[index].id,
                ),
                trailing: Radio(
                  activeColor: kSpringColor,
                  value: index,
                  groupValue: selected,
                  onChanged: (int value) async {
                    setState(() {
                      selected = value;
                    });
                    final bool connectedStatus =
                        await bluetoothProvider.connectToDevice(
                            detectedBluetoothDevices[value], context, value);
                    if (connectedStatus) {
                      bluetoothProvider.discoverServices();
                    }
                  },
                ),
              ),
            );
          },
          itemCount: detectedBluetoothDevices.length,
        );
      }),
    );
  }
}
