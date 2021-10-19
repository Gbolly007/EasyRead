import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_reads/screens/getCommentCount.dart';
import 'package:easy_reads/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import 'checkLike.dart';
import 'getPostLikeCount.dart';
import 'getUsername.dart';

class PostCard extends StatefulWidget {
  final String postTitle, postBody, datePosted, postId, uid;

  PostCard({
    @required this.postTitle,
    @required this.postBody,
    @required this.datePosted,
    @required this.postId,
    @required this.uid,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  onTapLike(String postId) async {
    final user = Provider.of<User>(context, listen: false);
    final users = Provider.of<AuthProvider>(context,listen: false);
    try {
      await firebaseFirestore
          .collection("post")
          .doc(postId)
          .collection("like")
          .doc(user.uid)
          .get()
          .then((DocumentSnapshot ds) {
        if (ds.exists) {
          firebaseFirestore
              .collection("post")
              .doc(postId)
              .collection("like")
              .doc(user.uid)
              .delete();
          setState(() {});
        } else {
          firebaseFirestore
              .collection("post")
              .doc(postId)
              .collection("like")
              .doc(user.uid)
              .set({"id": user.uid,"timePosted": Timestamp.now(),
            'uidnotify': widget.uid,
            'name': users.userModel.name,
            'postId':widget.postId,
            'postname': widget.postTitle});
          setState(() {});
        }
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 3,
      child: Container(
        height: 150,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.postTitle,
                style: TextStyle(
                  fontSize: 20,
                  color: kDarkColor,
                  fontFamily: kAbrilFatFace,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.postBody,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontFamily: kRoboto,
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                onTapLike(widget.postId);
                              },
                              child: CheckIfUserLiked(
                                postId: widget.postId,
                                uid: user.uid,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GetPostLikeCount(
                              postId: widget.postId,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.comment_outlined),
                            SizedBox(
                              width: 5,
                            ),
                            GetPostCommentCount(
                              postId: widget.postId,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 20,
                                ),
                                GetUsername(
                                  uid: widget.uid,
                                  fontSize: 15,
                                ),
                              ],
                            ),
                            Text(
                              widget.datePosted,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontFamily: kRoboto,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
