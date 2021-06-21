import 'package:flutter/material.dart';

import '../../globals.dart';

class CarDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceWidth * 0.9,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.drive_eta,
                    size: 30,
                  ),
                  Text('Car'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ALPHA ROMEO 209'),
                  Text('2009, Diesel'),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.drive_eta,
                    size: 30,
                  ),
                  Text('Car'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ALPHA ROMEO 209'),
                  Text('2009, Diesel'),
                ],
              ),
            ],
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
