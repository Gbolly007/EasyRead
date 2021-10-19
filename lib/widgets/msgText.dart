import 'package:flutter/material.dart';

import '../constant.dart';

class MsgTextWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function func;

  MsgTextWidget({this.controller, this.func});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        color: kDarkColor,
        fontSize: 15,
      ),
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLength: null,
      maxLines: null,
      validator: func,
      decoration: new InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: kDarkColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(30.0),
          borderSide: BorderSide(color: kDarkColor),
        ),
        hintText: leavecomment,
        errorBorder: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(15.0),
          borderSide: BorderSide(color: kDarkColor),
        ),
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 15,
        ),
      ),
    );
  }
}
