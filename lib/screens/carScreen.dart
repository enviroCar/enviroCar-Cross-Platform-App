import 'package:flutter/material.dart';

import 'createCarScreen.dart';
import '../constants.dart';
import '../widgets/carScreenWidgets/carsListWidget.dart';

class CarScreen extends StatefulWidget {
  static const routeName = '/carScreen';

  @override
  _CarScreenState createState() => _CarScreenState();
}

class _CarScreenState extends State<CarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreyColor,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(CreateCarScreen.routeName);
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(Icons.add),
            ),
          ),
        ],

        // enviroCar logo
        title: Image.asset(
          'assets/images/img_envirocar_logo_white.png',
          scale: 10,
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: CarsListWidget(),
      ),
    );
  }
}
