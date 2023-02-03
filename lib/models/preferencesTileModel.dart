import 'package:flutter/foundation.dart';

// Model for the checkbox tile on settings screen
class PreferencesTileModel {
  String title;
  bool isChecked;

  PreferencesTileModel({
    required this.title,
    required this.isChecked,
  });
}
