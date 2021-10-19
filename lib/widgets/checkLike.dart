import 'package:easy_reads/services/postService.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class CheckIfUserLiked extends StatelessWidget {
  CheckIfUserLiked({this.postId, this.uid});

  final String uid;
  final String postId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PostService().checkIfUserLikedPost(postId, uid),
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot<bool> text) {
        return Icon(
          Icons.recommend,
          color: text.data == true ? kDarkAppColor : Colors.grey,
        );
      },
    );
  }
}
