import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

import '../../models/settingsTileModel.dart';

// List of checkbox settings tile on settings screen
class SettingsDropDownWidget extends StatefulWidget {
  final List<SettingsTileModel> settings;
  final Function onChanged;

  const SettingsDropDownWidget({
    @required this.settings,
    this.onChanged,
  });
  @override
  _SettingsDropDownWidgetState createState() => _SettingsDropDownWidgetState();
}

class _SettingsDropDownWidgetState extends State<SettingsDropDownWidget> {
  // Toggles the checkbox
  void toggleCheckBox({@required int index}) {
    setState(() {
      final bool currentVal = widget.settings[index].isChecked;
      widget.settings[index].isChecked = !currentVal;
    });
  }

  String dropdownValue = 'Auto';
  List<String> lst = ["Auto", "Light", "Dark"];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: DropdownButton(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            alignment: Alignment.center,
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
              switch (newValue) {
                case "Auto":
                  AdaptiveTheme.of(context).setSystem();
                  break;
                case "Dark":
                  AdaptiveTheme.of(context).setDark();
                  break;
                default:
                  AdaptiveTheme.of(context).setLight();
              }
            },
            items: lst.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
