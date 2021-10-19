import 'package:easy_reads/services/postService.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class GetPostCommentCount extends StatelessWidget {
  final String postId;
  GetPostCommentCount({this.postId});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(

      future: PostService().countComment(postId),
      initialData: "0",
      builder: (BuildContext context, AsyncSnapshot<String> text){
        return Text(
          text.data,
          style: TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontFamily: kRoboto,
              fontWeight: FontWeight.bold),
        );
      },
    );
  }
}