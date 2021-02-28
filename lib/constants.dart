import 'dart:ui';

import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xffff7643);
const kPrimaryLightColor = Color(0xffffecdf);

const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFFFA53E),
    Color(0xFFFF7643)
  ],
);

const kSecondColor = Color(0xFF979797);
const kTextColor  = Color(0xFF757575);
const kDrawerTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
);



OutlineInputBorder kOutlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28.0),
    gapPadding: 10.0,
    borderSide: BorderSide(color: kTextColor)
);

InputDecoration inputDecoration ({String labelText, String hintText}) {
  return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20.0),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: kOutlineBorder,
      enabledBorder: kOutlineBorder,
      focusedBorder: kOutlineBorder,
      labelStyle: TextStyle(color: kTextColor)
  );
}


const kAnimationDuration = Duration(milliseconds: 200);