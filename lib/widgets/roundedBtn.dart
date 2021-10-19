import 'package:flutter/material.dart';

class RoundedButtonWidget extends StatelessWidget {
  final IconData icons;
  final Color bgColor;
  final Color iconColor;
  final Function onPush;
  RoundedButtonWidget({this.icons, this.bgColor, this.iconColor, this.onPush});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPush,
      color: bgColor,
      shape: CircleBorder(side: BorderSide.none),
      child: Icon(
        icons,
        color: iconColor,
      ),
    );
  }
}