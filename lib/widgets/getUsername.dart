import 'package:easy_reads/services/postService.dart';
import 'package:flutter/material.dart';
import '../constant.dart';

class GetUsername extends StatelessWidget {
  final String uid;
  final double fontSize;

  GetUsername({this.uid,this.fontSize});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PostService().getAuthorName(uid),
      initialData: "...",
      builder: (BuildContext context, AsyncSnapshot<String> text) {
        return Text(
          text.data.length > 12
              ? text.data.substring(0, 12) + "..."
              : text.data,
          style: TextStyle(
            fontSize: fontSize,
            color: kDarkColor,
            fontFamily: kRoboto,
          ),
        );
      },
    );
  }
}
