import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'package:system_shortcuts/system_shortcuts.dart';
import 'package:toast/toast.dart';

import '../widgets/bleDialog.dart';
import '../constants.dart';

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
  String selectedDeviceId = '';
  List<DiscoveredService> _services;
  Map<Uuid, List<Uuid>> _servicesCharacteristics;

  /// Toggles bluetooth on and off
  // Works only on Android
  // iOS doesn't give permission to toggle Bluetooth from inside the app
  Future<void> toggleBluetooth() async {
    await SystemShortcuts.bluetooth();
  }

  @override
  void initState() {
    determineBluetoothStatus();
    _services = [];
    _servicesCharacteristics = {};
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

    bool addDeviceToList = true;
    for (DiscoveredDevice device in detectedBluetoothDevices) {
      if (device.id == discoveredDevice.id) {
        addDeviceToList = false;
        break;
      }
    }

    if (addDeviceToList) {
      print(discoveredDevice.toString());
      setState(() {
        detectedBluetoothDevices.add(discoveredDevice);
      });
    }
  }

  /// function to determine [_state] the status of Bluetooth
  void determineBluetoothStatus() {
    flutterReactiveBlue.statusStream.listen((status) {
      // code for handling status updates
      if (mounted) {
        setState(() {
          _state = status;
        });
      }
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

  /// function to connect to selected device
  void connectToDevice() {
    flutterReactiveBlue.connectToDevice(
      id: selectedDeviceId,
      connectionTimeout: Duration(seconds: 10),
      // servicesWithCharacteristicsToDiscover: // TODO: specify characteristics for OBD-II for faster connection
    ).listen(sendConnectionStatusUpdates).onError(handleError);
  }

  /// callback function to send connection status updates
  void sendConnectionStatusUpdates(ConnectionStateUpdate connectionStateUpdate) {
    print('connected to ${detectedBluetoothDevices[selected].name}');
    print('connection state ${connectionStateUpdate.connectionState.toString()}');
    print('device id ${connectionStateUpdate.deviceId}');
    print('failure ${connectionStateUpdate.failure.toString()}');

    if (connectionStateUpdate.failure != null) {
      debugPrint('connection unsuccessful');
      Toast.show(
        'Cannot connect to ${detectedBluetoothDevices[selected].name.isNotEmpty ? detectedBluetoothDevices[selected].name : selectedDeviceId}',
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.black87
      );
    }

    if (connectionStateUpdate.connectionState == DeviceConnectionState.connected) {
      Toast.show(
          'Connected to ${detectedBluetoothDevices[selected].name.isNotEmpty ? detectedBluetoothDevices[selected].name : selectedDeviceId}',
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          backgroundColor: Colors.black87
      );
      discoverServices();
    }
  }

  /// function to discover services
  void discoverServices() async {
    _services = await flutterReactiveBlue.discoverServices(selectedDeviceId);
    debugPrint('${_services.toString()}');
    logCharacteristicsForServices();
  }

  /// function to add the [serviceId] and [characteristicIds] to [_servicesCharacteristics]
  void logCharacteristicsForServices() async {
    for (DiscoveredService service in _services) {
      _servicesCharacteristics[service.serviceId] = service.characteristicIds;
      debugPrint('service id ${service.serviceId.toString()} characteristics Id ${service.characteristicIds.toString()}');
      for (Uuid ch in service.characteristicIds) {
        subscribeCharacteristic(service.serviceId, ch);
      }
    }
  }

  /// function to read characteristic
  void readCharacteristic(Uuid serviceId, Uuid characteristicId) async {
    QualifiedCharacteristic qualifiedCharacteristic = QualifiedCharacteristic(characteristicId: characteristicId, serviceId: serviceId, deviceId: selectedDeviceId);

    final List<int> response = await flutterReactiveBlue.readCharacteristic(qualifiedCharacteristic)
        .catchError((e) {
          debugPrint('error is ${e.toString()}');
    });

    debugPrint('read characteristics response ${response.toString()}');
  }

  /// function to write characteristic value
  void writeCharacteristic(Uuid serviceId, Uuid characteristicId, List<int> byteArray) async {
    QualifiedCharacteristic qualifiedCharacteristic = QualifiedCharacteristic(characteristicId: characteristicId, serviceId: serviceId, deviceId: selectedDeviceId);

    await flutterReactiveBlue.writeCharacteristicWithResponse(qualifiedCharacteristic, value: byteArray).whenComplete(() {
      debugPrint('write operation completed');
    }).catchError((e) {
      debugPrint('error is ${e.toString()}');
    });
  }

  /// function to subscribe to a characteristic and listen to the updates in the value of [characteristic]
  void subscribeCharacteristic(Uuid serviceId, Uuid characteristicId) async {
    QualifiedCharacteristic qualifiedCharacteristic = QualifiedCharacteristic(characteristicId: characteristicId, serviceId: serviceId, deviceId: selectedDeviceId);

    flutterReactiveBlue.subscribeToCharacteristic(qualifiedCharacteristic).listen((value) {
      debugPrint('the value of characteristic is ${value.toString()}');
    }).onError((e) {
      debugPrint('error is ${e.toString()}');
    });
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
                      selectedDeviceId = detectedBluetoothDevices[value].id;
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
