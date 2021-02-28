import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';

OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: kPrimaryColor),
);

ThemeData theme () {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Muli',
    textTheme: TextTheme(
      bodyText1: TextStyle(color: kTextColor),
      bodyText2: TextStyle(color: kTextColor),
    ),
    appBarTheme: AppBarTheme(
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.white),
      textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.white),
        bodyText2: TextStyle(color: Colors.white),
        headline6: TextStyle(color: Colors.white, fontSize: 22.0)
      ),
    ),
primaryColor: Colors.deepPurple,

    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}