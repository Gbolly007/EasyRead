import 'package:another_flushbar/flushbar.dart';
import 'package:easy_reads/services/postService.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import 'getUsername.dart';

class CommentCard extends StatelessWidget {
  final String comment, username, datePosted, postId, commentId;
  final BuildContext ctx;

  final bool allowDelete;

  final PostService postService = new PostService();

  CommentCard({
    @required this.comment,
    @required this.username,
    @required this.datePosted,
    @required this.allowDelete,
    @required this.postId,
    @required this.commentId,
    @required this.ctx,
  });

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    showFlushBar(String message, Color clr) {
      Flushbar(
              icon: Icon(
                Icons.info_outline,
                color: clr,
              ),
              message: message,
              duration: Duration(seconds: 5),
              margin: EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(8),
              flushbarStyle: FlushbarStyle.FLOATING)
          .show(ctx);
    }

    return Container(
      width: screenWidth,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: <Widget>[
                    GetUsername(
                      uid: username,
                      fontSize: 12,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.access_time_outlined,
                      size: 15,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      datePosted,
                      style: TextStyle(
                        fontSize: 12,
                        color: kDarkColor,
                        fontFamily: kRoboto,
                      ),
                    )
                  ],
                )
              ],
            ),
            Divider(
              thickness: 1,
            ),
            Text(
              comment,
              style: TextStyle(
                fontSize: 17,
                color: Colors.black,
                fontFamily: kRoboto,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                allowDelete
                    ? InkWell(
                        onTap: () async {
                          dynamic result = await postService.deleteComment(
                              postId, commentId);

                          if (result.toString() == "success") {
                            showFlushBar(commentRemove, Colors.blue);
                          } else {
                            showFlushBar(errorOccurred, Colors.red);
                          }
                        },
                        child: Icon(Icons.delete_outline),
                      )
                    : SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
