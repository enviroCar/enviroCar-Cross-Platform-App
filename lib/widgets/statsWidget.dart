import 'package:flutter/material.dart';

import '../constants.dart';

class StatsWidget extends StatelessWidget {
  final double height;
  final double width;

  StatsWidget({
    @required this.height,
    @required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.20,
      width: double.infinity,
      color: kGreyColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // TODO: Replace dummy data with actual data
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '23',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(
                    'Total Tracks',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              width: width * 0.3,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 65, 80, 100),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '100 km',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(
                    'Total Distance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              width: width * 0.3,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 65, 80, 100),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '0.01 hr',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(
                    'Total Time',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              width: width * 0.3,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 65, 80, 100),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
