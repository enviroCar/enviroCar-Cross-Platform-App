import 'package:flutter/material.dart';

import '../../globals.dart';

class CarDetailsCard extends StatelessWidget {
  Widget buildWidget({
    @required String title,
    @required IconData iconData,
    @required String information,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              iconData,
              size: 30,
            ),
            const SizedBox(
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[350],
            blurRadius: 3.0,
            spreadRadius: 1.0,
            offset: const Offset(-2, 2),
          ),
        ],
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        children: [
          buildWidget(
            title: 'Car',
            iconData: Icons.drive_eta,
            information: 'ALPHA ROMEO 209\n2009, Diesel',
          ),
          const SizedBox(
            height: 20,
          ),
          buildWidget(
            title: 'Start',
            iconData: Icons.timer,
            information: 'Jun 28, 2021 1:10:31 PM',
          ),
          const SizedBox(
            height: 20,
          ),
          buildWidget(
            title: 'End',
            iconData: Icons.lock_clock,
            information: 'Jun 28, 2021 1:10:31 PM',
          ),
          const SizedBox(
            height: 20,
          ),
          const Align(
            child: Text(
              'Bei diesen Werten handelt es sich um geschätzte Werte, die sich deutlich von den realen Werten unterscheiden können. Wir können daher keine Gewährleistungfür diese Angaben geben.',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
