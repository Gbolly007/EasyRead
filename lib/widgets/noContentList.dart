import 'package:flutter/material.dart';

import '../constant.dart';

class NoListContent extends StatelessWidget {
   final String txt;
   NoListContent({this.txt});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/empty.png",
            width: 100,
            height: 100,
          ),
          Text(
            txt,
            style: TextStyle(fontFamily: kRoboto),
          ),
        ],
      ),
    );
  }
}