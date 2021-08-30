import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/iconBadge.dart';

/// function to show alert dialog
// ignore: avoid_positional_boolean_parameters
void showAlertDialog({
      @required BuildContext context,
      @required String title,
      @required String content,
      @required bool carState,
      @required bool bluetoothState,
      @required bool locationState
    }) {
  showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: kSpringColor
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Spacer(),
                    const Spacer(),
                    IconBadge(
                      iconData: Icons.smartphone,
                      checked: bluetoothState,
                    ),
                    const Spacer(),
                    IconBadge(
                      iconData: Icons.directions_car,
                      checked: carState,
                    ),
                    const Spacer(),
                    IconBadge(
                      iconData: Icons.location_on,
                      checked: locationState,
                    ),
                    const Spacer(),
                    const Spacer()
                  ],
                ),
              ),
              Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.caption.color,
                  fontWeight: FontWeight.normal,
                  fontSize: 15
                ),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: kSpringColor,
                ),
                margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Text(
                  'close'.toUpperCase(),
                  style: const TextStyle(
                    color: kWhiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
          ],
        );
      }
  );
}