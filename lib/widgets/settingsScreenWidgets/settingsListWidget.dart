import 'package:flutter/material.dart';

import '../../globals.dart';
import '../../models/settingsTileModel.dart';

// List of checkbox settings tile on settings screen
class SettingsListWidget extends StatefulWidget {
  final List<SettingsTileModel> settings;
  final Function onChanged;

  const SettingsListWidget({
    @required this.settings,
    this.onChanged,
  });
  @override
  _SettingsListWidgetState createState() => _SettingsListWidgetState();
}

class _SettingsListWidgetState extends State<SettingsListWidget> {
  // Toggles the checkbox
  void toggleCheckBox({@required int index}) {
    setState(() {
      final bool currentVal = widget.settings[index].isChecked;
      widget.settings[index].isChecked = !currentVal;
    });
    preferences.setString(
      widget.settings[index].title,
      '${widget.settings[index].isChecked}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.settings.length,
        (index) {
          return CheckboxListTile(
            contentPadding: const EdgeInsets.only(
              bottom: 10,
            ),
            title: Text(widget.settings[index].title),
            subtitle: Text(widget.settings[index].subtitle),
            value: widget.settings[index].isChecked,
            onChanged: (bool val) {
              if (widget.onChanged != null) widget.onChanged();
              toggleCheckBox(index: index);
            },
          );
        },
      ),
    );
  }
}
