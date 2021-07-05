import 'package:flutter/material.dart';

import '../../models/settingsTileModel.dart';

// List of checkbox settings tile on settings screen
class SettingsListWidget extends StatefulWidget {
  final List<SettingsTileModel> settings;

  SettingsListWidget({
    @required this.settings,
  });
  @override
  _SettingsListWidgetState createState() => _SettingsListWidgetState();
}

class _SettingsListWidgetState extends State<SettingsListWidget> {
  // Toggles the checkbox
  void toggleCheckBox({@required index}) {
    setState(() {
      bool currentVal = widget.settings[index].isChecked;
      widget.settings[index].isChecked = !currentVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: List.generate(
          widget.settings.length,
          (index) {
            return CheckboxListTile(
              contentPadding: EdgeInsets.only(
                bottom: 10,
              ),
              title: Text(widget.settings[index].title),
              subtitle: Text(widget.settings[index].subtitle),
              value: widget.settings[index].isChecked,
              onChanged: (bool val) {
                toggleCheckBox(index: index);
              },
            );
          },
        ),
      ),
    );
  }
}
