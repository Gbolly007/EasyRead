import 'package:flutter/material.dart';

import '../constant.dart';

class NoComment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(
            "Post has not received any comments yet",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontFamily: kRoboto,
            ),
          ),
        ],
      ),
    );
  }
}
