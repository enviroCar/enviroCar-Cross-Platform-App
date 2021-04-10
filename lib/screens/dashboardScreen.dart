import 'package:flutter/material.dart';

import '../widgets/statsWidget.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQuery = MediaQuery.of(context);
    double _height = _mediaQuery.size.height;
    double _width = _mediaQuery.size.width;

    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            StatsWidget(
              height: _height,
              width: _width,
            ),
          ],
        ),
      ),
    );
  }
}
