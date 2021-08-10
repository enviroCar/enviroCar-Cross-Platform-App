import 'package:flutter/material.dart';

import '../../globals.dart';
import '../../constants.dart';
import 'statusIndicatorCard.dart';
import '../../screens/bluetoothDevicesScreen.dart';

class TabBarViewWidget extends StatefulWidget {

  @override
  _TabBarViewWidgetState createState() => _TabBarViewWidgetState();
}

class _TabBarViewWidgetState extends State<TabBarViewWidget> with TickerProviderStateMixin {
  TabController _tabController;
  int currentIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(handleControllerTab);
    currentIndex = 0;
    super.initState();
  }

  void handleControllerTab() {
    setState(() {
      currentIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> list = getTabBarChild();

    return Center(
      child: Container(
        alignment: Alignment.center,
        width: deviceWidth * 0.8,
        height: deviceHeight * 0.7,
        child: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: list,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: list.map((child) {
                  final int index = list.indexOf(child);
                  return Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentIndex == index
                            ? kSpringColor
                            : kSecondaryColor
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> getTabBarChild() {
  return [
    LocationStatusWidget(),
    BluetoothStatusWidget()
  ];
}

class LocationStatusWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StatusIndicatorCard(
      heading: 'Location turned off',
      subHeading: 'Your location services is turned off.',
      buttonTitle: 'Turn on location',
      icon: const Icon(Icons.location_off, size: 50, color: kWhiteColor),
      function: () {
        // TODO: turn on location
      },
    );
  }
}

class BluetoothStatusWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StatusIndicatorCard(
      heading: 'No OBD-II selected',
      subHeading: 'Your device is not connected to OBD-II adapter',
      buttonTitle: 'Select OBD-II adapter',
      icon: const Icon(Icons.bluetooth, size: 50, color: kWhiteColor),
      function: () {
        // _logger.i('Going to bluetooth devices screen');
        Navigator.pushReplacementNamed(context, BluetoothDevicesScreen.routeName);
      },
    );
  }
}
