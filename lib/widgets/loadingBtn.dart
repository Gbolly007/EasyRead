import 'package:flutter/material.dart';

import '../constant.dart';

class LoadingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var circularProgButton = CircularProgressIndicator(
      strokeWidth: 2,
      valueColor: AlwaysStoppedAnimation<Color>(kBackGroundColor),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom:15.0),
      child: Container(
        width: btnSize,
        height: btnSize,
        child: RaisedButton(

          onPressed: (){

          },
          color: kAppColor,
          shape: CircleBorder(side: BorderSide.none),
          child: circularProgButton,
        ),
      ),
    );
  }
}
