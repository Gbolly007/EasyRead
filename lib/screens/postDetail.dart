import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_reads/model/bookDetailModel.dart';
import 'package:easy_reads/services/auth.dart';
import 'package:easy_reads/services/postService.dart';
import 'package:easy_reads/widgets/checkLike.dart';
import 'package:easy_reads/widgets/commentCard.dart';
import 'package:easy_reads/widgets/getPostLikeCount.dart';
import 'package:easy_reads/widgets/getUsername.dart';
import 'package:easy_reads/widgets/msgText.dart';
import 'package:easy_reads/widgets/nocomment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

class PostDetail extends StatefulWidget {
  final BookDetailArgs data;

  PostDetail({this.data});

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  TextEditingController commentController = TextEditingController();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  PostService postService = new PostService();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isSwap = false;

  onTapLike(String postId) async {
    final user = Provider.of<User>(context, listen: false);
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
            .set({"id": user.uid});
        setState(() {});
      }
    });
  }

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
        .show(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final users = Provider.of<AuthProvider>(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBackGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: screenWidth,
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
              vertical: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: kDarkColor,
                        size: 30,
                      ),
                    ),
                    SizedBox(),
                    SizedBox(),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  widget.data.post["title"],
                  style: TextStyle(
                    fontSize: 20,
                    color: kDarkColor,
                    fontFamily: kAbrilFatFace,
                  ),
                ),
                GetUsername(
                  uid: widget.data.post["uid"],
                  fontSize: 15,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  widget.data.post["body"],
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontFamily: kRoboto,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            onTapLike(widget.data.post.id);
                          },
                          child: CheckIfUserLiked(
                            postId: widget.data.post.id,
                            uid: user.uid,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GetPostLikeCount(postId: widget.data.post.id)
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      PostService().dte(widget.data.post["timePosted"]),
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontFamily: kRoboto,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Divider(
                  color: kDarkColor,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      commentText,
                      style: TextStyle(
                          fontSize: 15,
                          color: kDarkColor,
                          fontFamily: kRoboto,
                          fontWeight: FontWeight.bold),
                    ),
                    isSwap
                        ? CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 15,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(Icons.close),
                              color: Colors.white,
                              onPressed: () {
                                setState(() {
                                  isSwap = false;
                                });
                              },
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: kAppColor,
                            radius: 15,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(Icons.add),
                              color: Colors.white,
                              onPressed: () {
                                setState(() {
                                  isSwap = true;
                                });
                              },
                            ),
                          ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                isSwap
                    ? Form(
                        key: _formKey,
                        child: Row(
                          children: [
                            Expanded(
                                child: MsgTextWidget(
                              controller: commentController,
                              func: (value) =>
                                  value.isEmpty ? commentValidator : null,
                            )),
                            isLoading
                                ? IconButton(
                                    icon: Icon(
                                      Icons.send,
                                    ),
                                    onPressed: () {},
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Icons.send,
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        dynamic result =
                                            await postService.addComment(
                                                user.uid,
                                                widget.data.post.id,
                                                commentController.text.trim(), widget.data.post["uid"],users.userModel.name,widget.data.post["title"],);

                                        setState(() {
                                          isLoading = true;
                                        });
                                        if (result.toString() == "success") {
                                          setState(() {
                                            isLoading = false;
                                            isSwap = false;
                                          });
                                          commentController.clear();
                                          showFlushBar(
                                              commentAdded, Colors.blue);
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                          });

                                          showFlushBar(
                                              errorOccurred, Colors.red);
                                        }
                                      }
                                    },
                                    color: kAppColor,
                                  ),
                          ],
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  height: 30,
                ),
                Card(
                  elevation: 2,
                  child: Container(
                    height: 350,
                    child: Scrollbar(
                      child: PaginateFirestore(
                          itemBuilderType: PaginateBuilderType.listView,
                          scrollDirection: Axis.vertical,
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          emptyDisplay: NoComment(),
                          // listview and gridview
                          itemBuilder: (index, contexts, documentSnapshot) =>
                              CommentCard(
                                postId: widget.data.post.id,
                                commentId: documentSnapshot.id,
                                username: documentSnapshot.data()['uid'],
                                comment: documentSnapshot.data()['comment'],
                                datePosted: PostService().dte(
                                  documentSnapshot.data()['timePosted'],
                                ),
                                allowDelete: user.uid ==
                                            documentSnapshot.data()['uid'] ||
                                        user.uid == widget.data.post["uid"]
                                    ? true
                                    : false,
                                ctx: context,
                              ),
                          // orderBy is compulsary to enable pagination
                          query: FirebaseFirestore.instance
                              .collection('post')
                              .doc(widget.data.post.id)
                              .collection("comment")
                              .orderBy('timePosted', descending: true),
                          isLive: true // to fetch real-time data
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
