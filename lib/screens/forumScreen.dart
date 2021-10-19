import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_reads/constant.dart';
import 'package:easy_reads/model/bookDetailModel.dart';
import 'package:easy_reads/routes/route_names.dart';
import 'package:easy_reads/services/postService.dart';
import 'package:easy_reads/widgets/noContentList.dart';
import 'package:easy_reads/widgets/postCard.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class Forum extends StatefulWidget {
  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  navigateToDetailPage(DocumentSnapshot post) {
    BookDetailArgs bookDetailArgs = new BookDetailArgs();
    bookDetailArgs.post = post;
    Navigator.pushNamed(context, postDetailRoute, arguments: bookDetailArgs);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBackGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: screenWidth,
            height: screenHeight,
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
              vertical: 30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      havesmthtoshare,
                      style: TextStyle(
                        fontFamily: kAbrilFatFace,
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: kAppColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: kBackGroundColor,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, addPostRoute);
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Flexible(
                  child: PaginateFirestore(
                      itemBuilderType: PaginateBuilderType.listView,
                      scrollDirection: Axis.vertical,
                      physics: ClampingScrollPhysics(),
                      emptyDisplay: NoListContent(txt: nopost,),
                      shrinkWrap: true,
                      // listview and gridview
                      itemBuilder: (index, context, documentSnapshot) =>
                          InkWell(
                            onTap: () {
                              navigateToDetailPage(documentSnapshot);
                            },
                            child: PostCard(
                              postTitle: documentSnapshot.data()['title'],
                              postBody: documentSnapshot.data()['body'],
                              uid: documentSnapshot.data()['uid'],
                              postId: documentSnapshot.id,
                              datePosted: PostService().dte(
                                documentSnapshot.data()['timePosted'],
                              ),
                            ),
                          ),
                      // orderBy is compulsary to enable pagination
                      query: FirebaseFirestore.instance
                          .collection('post')
                          .orderBy('timePosted', descending: true),
                      isLive: true // to fetch real-time data
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
