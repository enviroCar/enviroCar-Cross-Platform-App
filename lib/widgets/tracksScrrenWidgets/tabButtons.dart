import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../globals.dart';
import '../../utils/enums.dart';

class TabButtons extends StatelessWidget {
  final Function changeTab;
  final SelectedTab selectedTab;

  TabButtons({@required this.changeTab, @required this.selectedTab});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              changeTab();
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: kSpringColor,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
                color: selectedTab == SelectedTab.Local
                    ? kSpringColor
                    : Colors.white,
              ),
              height: 40,
              width: deviceWidth * 0.3,
              child: Center(
                child: Text(
                  'Local',
                  style: TextStyle(
                      color: selectedTab == SelectedTab.Local
                          ? Colors.white
                          : kSpringColor),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              changeTab();
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: kSpringColor,
                ),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: selectedTab == SelectedTab.Uploaded
                    ? kSpringColor
                    : Colors.white,
              ),
              height: 40,
              width: deviceWidth * 0.3,
              child: Center(
                child: Text(
                  'Uploaded',
                  style: TextStyle(
                      color: selectedTab == SelectedTab.Uploaded
                          ? Colors.white
                          : kSpringColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
