import 'package:flutter/material.dart';

import '../constant.dart';


class LoadingBtn extends StatelessWidget {
  const LoadingBtn({
    Key key,
    @required this.screenWidth,
    @required this.circularProgButton,
  }) : super(key: key);

  final double screenWidth;
  final CircularProgressIndicator circularProgButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,

      decoration: BoxDecoration(
        color: kAppColor,
        borderRadius: BorderRadius.all(
          Radius.circular(30.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 8,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Center(
          child: circularProgButton),
    );
  }
}