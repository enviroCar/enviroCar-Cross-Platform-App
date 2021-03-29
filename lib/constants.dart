import 'package:flutter/material.dart';

const InputDecoration inputDecoration = InputDecoration(
  alignLabelWithHint: true,
  labelStyle: TextStyle(
    color: const Color(0xff7e7e7e),
  ),
  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: kSecondaryColor, width: 1.5),
    borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(
        color: const Color.fromARGB(255, 23, 33, 43), width: 1.5),
    borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
  ),
);

const Color kPrimaryColor = Color(0xff000000);
const Color kSecondaryColor = Color(0xffD8D8D8);
