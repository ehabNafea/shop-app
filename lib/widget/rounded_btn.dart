import 'package:flutter/material.dart';

class RoundedBtn extends StatelessWidget {
  final IconData icon;
  final Function onTap;
  RoundedBtn({
    this.icon,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45.0,
      height: 45.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.white,
      ),
      child: FlatButton(
        onPressed: onTap,
        child: Icon(icon),
        padding: EdgeInsets.only(right: 3),
      ),
    );
  }
}