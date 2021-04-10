import 'package:flutter/material.dart';

import '../services/mapServices.dart';
import '../widgets/mapWidget.dart';
import '../constants.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/mapScreen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _locationServiceEnabled = false;
  Future _startLocationService;

  // checks if location service in enabled
  // promts permission dialogbox if service is disabled
  Future<void> initializeLocation() async {
    bool permissionStatus = await MapServices().initializeLocationService();

    setState(() {
      _locationServiceEnabled = permissionStatus;
    });
  }

  @override
  void initState() {
    super.initState();
    _startLocationService = initializeLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreyColor,
        elevation: 0,
        centerTitle: true,
        title: Text('Location'),
      ),
      body: FutureBuilder(
        future: _startLocationService,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // when location service is disabled by clicking 'No Thanks' on dialogbox
            if (!_locationServiceEnabled) {
              return Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Location Service is OFF',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await initializeLocation();
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: kSpringColor,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                          child: Text(
                            'Turn on',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return MapWidget(
                initializeLocation: initializeLocation,
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
