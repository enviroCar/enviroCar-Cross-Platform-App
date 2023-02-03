import 'package:flutter/material.dart';

import '../../models/preferencesTileModel.dart';

class PreferencesWidget extends StatefulWidget {
  final List<PreferencesTileModel> preferences;
  final Function? onChanged;

  const PreferencesWidget(
      {Key? key, required this.preferences, required this.onChanged})
      : super(key: key);

  @override
  State<PreferencesWidget> createState() => _PreferencesWidgetState();
}

class _PreferencesWidgetState extends State<PreferencesWidget> {
  // Toggles the checkbox
  void toggleCheckBox({required int index}) {
    setState(() {
      final bool currentVal = widget.preferences[index].isChecked;
      widget.preferences[index].isChecked = !currentVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.preferences.length,
        (index) {
          return CheckboxListTile(
            // contentPadding: const EdgeInsets.only(
            //   bottom: 10,
            // ),
            dense: true,
            title: Text(widget.preferences[index].title),
            value: widget.preferences[index].isChecked,
            onChanged: (bool? val) {
              if (widget.onChanged != null) widget.onChanged!();
              toggleCheckBox(index: index);
            },
          );
        },
      ),
    );
  }
}
