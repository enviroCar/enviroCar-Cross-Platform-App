import 'package:flutter/material.dart';

const InputDecoration inputDecoration = InputDecoration(
  alignLabelWithHint: true,
  labelStyle: TextStyle(
    color: Color(0xff7e7e7e),
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(5.0),
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kSecondaryColor, width: 1.5),
    borderRadius: BorderRadius.all(
      Radius.circular(5.0),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: kGreyColor,
      width: 1.5,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(5.0),
    ),
  ),
);

const Color kGreyColor = Color.fromARGB(255, 23, 33, 43);
const Color kSpringColor = Color.fromARGB(255, 0, 223, 165);
const Color kPrimaryColor = Color(0xff000000);
const Color kSecondaryColor = Color(0xffD8D8D8);
const Color kErrorColor = Color.fromARGB(250, 255, 50, 64);
const Color kWhiteColor = Color(0xffffffff);
const Color kTertiaryColor = Color.fromARGB(200, 0, 0, 0);
const Color kBlueColor = Color.fromARGB(255, 40, 122, 198);

// PlayStore URL for 'Rate Us' feature
const String playstoreUrl =
    'https://play.google.com/store/apps/details?id=org.envirocar.app';

const String localTracksTableName = 'localTracks';

const int kLocalTrackTypeId = 2;
const int kPointPropertiesId = 3;