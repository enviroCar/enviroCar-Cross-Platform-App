import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_blue/flutter_blue.dart' as blue;
import 'package:system_shortcuts/system_shortcuts.dart';

import '../constants.dart';
import '../providers/bluetoothProvider.dart';
import '../widgets/bleDialog.dart';

class BluetoothDevicesScreen extends StatefulWidget {
  static const routeName = '/bluetoothDeviceScreen';

  @override
  _BluetoothDevicesScreenState createState() => _BluetoothDevicesScreenState();
}

class _BluetoothDevicesScreenState extends State<BluetoothDevicesScreen> {
  blue.BluetoothState _state;
  bool _isScanning = false;
  int selected;
  blue.BluetoothDevice selectedBluetoothDevice;
  BluetoothProvider bluetoothProvider;

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
  Future determineBluetoothStatus() async {
    final bool state = await Provider.of<BluetoothProvider>(context, listen: false).bluetoothState();
    setState(() {
      _state = state ? blue.BluetoothState.on : blue.BluetoothState.off;
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

    // Stops any running scan before closing the screen
    bluetoothProvider.stopScan();
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
            builder: (context, AsyncSnapshot<blue.BluetoothState> snapshot) {
              _state = snapshot.data;
              return Switch(
                value: _state == blue.BluetoothState.on ? true : false,
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
            if (_state == blue.BluetoothState.on) {
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
            final List<blue.BluetoothDevice> detectedBluetoothDevices = bluetoothProvider.bluetoothDevices;

            return ListView.builder(
              itemBuilder: (BuildContext context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ListTile(
                    title: Text(
                      (detectedBluetoothDevices[index].name == null || detectedBluetoothDevices[index].name.trim().isEmpty) ? 'Unknown Device' : detectedBluetoothDevices[index].name,
                    ),
                    subtitle: Text(
                        detectedBluetoothDevices[index].id.toString()
                    ),
                    trailing: Radio(
                      activeColor: kSpringColor,
                      value: index,
                      groupValue: selected,
                      onChanged: (int value) async {
                        if (selected != -1) {
                          bluetoothProvider.disconnectDevice();
                        }
                        setState(() {
                          selected = value;
                          selectedBluetoothDevice = detectedBluetoothDevices[value];
                        });
                        final bool connectionStatus = await bluetoothProvider.connectToDevice(selectedBluetoothDevice, context);
                        debugPrint('connection status $connectionStatus');
                        if (!connectionStatus && mounted) {
                          setState(() {
                            selected = -1;
                          });
                        }
                      },
                    ),
                  ),
                );
              },
              itemCount: detectedBluetoothDevices.length,
            );
          }
      ),
    );
  }
}