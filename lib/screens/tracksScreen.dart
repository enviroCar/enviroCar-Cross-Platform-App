import 'Package:flutter/material.dart';

import '../../widgets/tracksScrrenWidgets/localTracksList.dart';
import '../../widgets/tracksScrrenWidgets/uploadedTracksList.dart';
import '../widgets/tracksScrrenWidgets/tabButtons.dart';
import '../utils/enums.dart';

class TracksScreen extends StatefulWidget {
  @override
  _TracksScreenState createState() => _TracksScreenState();
}

class _TracksScreenState extends State<TracksScreen> {
  SelectedTab selectedTab = SelectedTab.Local;

  void changeTab() {
    setState(() {
      if (selectedTab == SelectedTab.Local) {
        selectedTab = SelectedTab.Uploaded;
      } else {
        selectedTab = SelectedTab.Local;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TabButtons(
            changeTab: changeTab,
            selectedTab: selectedTab,
          ),
          selectedTab == SelectedTab.Uploaded
              ? UploadedTracksList()
              : LocalTracksList(),
        ],
      ),
    );
  }
}
