import 'package:flutter/material.dart';

import '../widgets/tracksScrrenWidgets/localTracksList.dart';
import '../widgets/tracksScrrenWidgets/uploadedTracksList.dart';
import '../widgets/tabButtonsPage.dart';
import '../utils/enums.dart';

class TracksScreen extends StatefulWidget {
  @override
  _TracksScreenState createState() => _TracksScreenState();
}

class _TracksScreenState extends State<TracksScreen> {
  TracksTab selectedTab = TracksTab.local;

  void changeTab() {
    setState(() {
      if (selectedTab == TracksTab.local) {
        selectedTab = TracksTab.uploaded;
      } else {
        selectedTab = TracksTab.local;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: TabButtonsPage(
        button1Title: 'Local',
        button2Title: 'Uploaded',
        tab1: TracksTab.local,
        tab2: TracksTab.uploaded,
        page1: LocalTracksList(),
        page2: UploadedTracksList(),
      ),
    );
  }
}
