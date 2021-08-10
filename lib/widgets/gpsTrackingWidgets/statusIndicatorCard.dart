import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../globals.dart';
import '../button.dart';
import '../../animations/rippleAnimation.dart';

class StatusIndicatorCard extends StatelessWidget {
  final String heading;
  final String subHeading;
  final String buttonTitle;
  final Icon icon;
  final VoidCallback function;

  const StatusIndicatorCard({@required this.heading, @required this.subHeading, @required this.buttonTitle, @required this.icon, @required this.function});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: deviceWidth * 0.8,
        height: deviceHeight * 0.7,
        decoration: BoxDecoration(
          color: kSpringColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: kWhiteColor, blurRadius: 10)
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(7),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                heading.toUpperCase(),
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: kSpringColor
                ),
              ),
              SizedBox(height: deviceHeight * 0.1),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: RippleAnimation(size: deviceWidth * 0.6, child: icon),
              ),
              SizedBox(height: deviceHeight * 0.1),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  subHeading.toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      // fontSize: 12,
                      color: kSpringColor
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Button(
                  title: buttonTitle.toUpperCase(),
                  color: kSpringColor,
                  onTap: function
              ),
            ],
          ),
        ),
      ),
    );
  }
}