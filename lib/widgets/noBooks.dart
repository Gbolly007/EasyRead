import 'package:flutter/material.dart';

import '../constant.dart';

class NoBooks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.auto_stories,

          size: 30,
        ),

        SizedBox(
          height: 20,
        ),
        Text(
          nobooks,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontFamily: kRoboto,

          ),
        ),
      ],
    );
  }
}
