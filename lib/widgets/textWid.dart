import 'package:flutter/material.dart';

import '../constant.dart';

class HeadingTextWidget extends StatelessWidget {
  final String txt;

  const HeadingTextWidget({
    this.txt,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
          fontSize: 19, fontWeight: FontWeight.bold, fontFamily: kRoboto),
    );
  }
}

class TextBodyWidget extends StatelessWidget {
  final String txt;

  const TextBodyWidget({
    Key key,
    this.txt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
        fontSize: 15,
        fontFamily: kRoboto,
      ),
    );
  }
}

class SubTextBodyWidget extends StatelessWidget {
  final String txt;

  const SubTextBodyWidget({
    Key key,
    this.txt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
        fontSize: 15,
        fontFamily: kRoboto,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}