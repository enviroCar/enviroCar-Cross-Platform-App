import 'package:flutter/material.dart';

const InputDecoration inputDecoration = InputDecoration(
  alignLabelWithHint: true,
  labelStyle: TextStyle(
    color: const Color(0xff7e7e7e),
  ),
  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: const BorderRadius.all(
      const Radius.circular(5.0),
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: kSecondaryColor, width: 1.5),
    borderRadius: const BorderRadius.all(
      const Radius.circular(5.0),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: kGreyColor,
      width: 1.5,
    ),
    borderRadius: const BorderRadius.all(
      const Radius.circular(5.0),
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