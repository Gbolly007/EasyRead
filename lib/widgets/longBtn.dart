import 'package:flutter/material.dart';

import '../constant.dart';

class BtnWidget extends StatelessWidget {
  const BtnWidget({
    Key key,
    @required this.screenWidth,
    @required this.txt,
  }) : super(key: key);

  final double screenWidth;
  final String txt;

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
          child: Text(
        txt,
        style:
            TextStyle(fontFamily: kRoboto, fontSize: 14, color: Colors.white),
      )),
    );
  }
}

class DelBtnWidget extends StatelessWidget {
  const DelBtnWidget({
    Key key,
    @required this.screenWidth,
    @required this.txt,
  }) : super(key: key);

  final double screenWidth;
  final String txt;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,

      decoration: BoxDecoration(

        borderRadius: BorderRadius.all(
          Radius.circular(30.0),

        ),
          border: Border.all(
            color: Colors.red,

          ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Icon(
              Icons.delete
            ),
          ),
          Center(
              child: Text(
                txt,
                style:
                TextStyle(fontFamily: kRoboto, fontSize: 14, color: Colors.black),
              )),
        ],
      ),
    );
  }
}
