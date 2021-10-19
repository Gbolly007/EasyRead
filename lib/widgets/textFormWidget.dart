import 'package:flutter/material.dart';

import '../constant.dart';

class TextFormWidget extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;

  final IconData data;
  final Function func;
  final String hintText;


  TextFormWidget({this.controller,this.type,this.func,this.hintText,this.data});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      keyboardType: type,
      controller: controller,
      style: TextStyle(
        fontFamily: kRoboto,
        fontSize: 20,
        color: kDarkColor,
      ),
      validator:func,

      decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kAppColor),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kAppColor),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: kRoboto,
            color: Colors.grey,
          ),
          prefixIcon: IconButton(
            icon: Icon(
              data,
              size: 30,
              color: kDarkColor,
            ),
          )),
    );
  }
}


class PostTitleTextFormWidget extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;


  final Function func;
  final String hintText;


  PostTitleTextFormWidget({this.controller,this.type,this.func,this.hintText});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      keyboardType: type,
      controller: controller,
      style: TextStyle(
        fontFamily: kRoboto,
        fontSize: 20,
        color: kDarkColor,
      ),
      validator:func,

      maxLength: 30,
      decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kDarkAppColor),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kDarkAppColor),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: kRoboto,
            color: Colors.grey,
          ),
      )
    );
  }
}

class PostBodyTextFormWidget extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;


  final Function func;
  final String hintText;


  PostBodyTextFormWidget({this.controller,this.type,this.func,this.hintText});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        textAlignVertical: TextAlignVertical.center,

        controller: controller,
        style: TextStyle(
          fontFamily: kRoboto,
          fontSize: 20,
          color: kDarkColor,
        ),
        validator:func,

        keyboardType: TextInputType.multiline,
        maxLength: null,
        maxLines: null,

        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kDarkAppColor),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kDarkAppColor),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: kRoboto,
            color: Colors.grey,
          ),
        )
    );
  }
}