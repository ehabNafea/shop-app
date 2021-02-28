import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class DefaultBtn extends StatelessWidget {
  final  text;
  final Function onTap;
  DefaultBtn({
    this.onTap,
    this.text
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 12.0),
      height: getProportionateScreenHeight(56),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
        onPressed: onTap,
        child: Text(text, style: TextStyle(
          fontSize: getProportionateScreenWidth(18),
          color: Colors.white,
        ),),
        color: kPrimaryColor,
      ),
    );
  }
}