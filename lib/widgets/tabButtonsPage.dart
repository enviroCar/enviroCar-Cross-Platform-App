import 'package:flutter/material.dart';

import '../constants.dart';
import '../globals.dart';

/// The two tabs widget on create car screen and tracks screen

class TabButtonsPage extends StatefulWidget {
  final String button1Title;
  final String button2Title;
  final dynamic tab1;
  final dynamic tab2;
  final Widget page1;
  final Widget page2;

  const TabButtonsPage({
    @required this.button1Title,
    @required this.button2Title,
    @required this.tab1,
    @required this.tab2,
    @required this.page1,
    @required this.page2,
  });

  @override
  _TabButtonsPageState createState() => _TabButtonsPageState();
}

class _TabButtonsPageState extends State<TabButtonsPage> {
  dynamic selectedTab;

  void changeTab() {
    setState(() {
      if (selectedTab == widget.tab1) {
        selectedTab = widget.tab2;
      } else {
        selectedTab = widget.tab1;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    selectedTab = widget.tab1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
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
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                    color: selectedTab == widget.tab1
                        ? kSpringColor
                        : Theme.of(context).primaryColor,
                  ),
                  height: 40,
                  width: deviceWidth * 0.46,
                  child: Center(
                    child: Text(
                      widget.button1Title.toUpperCase(),
                      style: TextStyle(
                        color: selectedTab == widget.tab1
                            ? Colors.white
                            : kSpringColor,
                      ),
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
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    color: selectedTab == widget.tab2
                        ? kSpringColor
                        : Theme.of(context).primaryColor,
                  ),
                  height: 40,
                  width: deviceWidth * 0.46,
                  child: Center(
                    child: Text(
                      widget.button2Title.toUpperCase(),
                      style: TextStyle(
                        color: selectedTab == widget.tab2
                            ? Colors.white
                            : kSpringColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (selectedTab == widget.tab1) widget.page1 else widget.page2,
      ],
    );
  }
}
