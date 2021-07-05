import 'package:flutter/material.dart';

import '../../globals.dart';

class CarDetailsCard extends StatelessWidget {
  Widget buildWidget({
    @required String title,
    @required IconData iconData,
    @required String information,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              iconData,
              size: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Text(title),
          ],
        ),
        Flexible(
          child: Text(information),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceWidth * 0.9,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildWidget(
            title: 'Car',
            iconData: Icons.drive_eta,
            information: 'ALPHA ROMEO 209\n2009, Diesel',
          ),
          SizedBox(
            height: 20,
          ),
          buildWidget(
            title: 'Start',
            iconData: Icons.timer,
            information: 'Jun 28, 2021 1:10:31 PM',
          ),
          SizedBox(
            height: 20,
          ),
          buildWidget(
            title: 'End',
            iconData: Icons.lock_clock,
            information: 'Jun 28, 2021 1:10:31 PM',
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Bei diesen Werten handelt es sich um geschätzte Werte, die sich deutlich von den realen Werten unterscheiden können. Wir können daher keine Gewährleistungfür diese Angaben geben.',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[350],
            blurRadius: 3.0,
            spreadRadius: 1.0,
            offset: Offset(-2, 2),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    );
  }
}
