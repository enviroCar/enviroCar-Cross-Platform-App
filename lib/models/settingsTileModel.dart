import 'package:flutter/foundation.dart';

// Model for the checkbox tile on settings screen
class SettingsTileModel {
  String title;
  String subtitle;
  bool isChecked;

  SettingsTileModel({
    required this.title,
    required this.subtitle,
    required this.isChecked,
  });
}
