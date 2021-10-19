import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_reads/constant.dart';
import 'package:easy_reads/model/bookDetailModel.dart';
import 'package:easy_reads/routes/route_names.dart';
import 'package:easy_reads/widgets/noContentList.dart';
import 'package:easy_reads/widgets/recentlyReadTile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class RecentlyRead extends StatefulWidget {
  @override
  _RecentlyReadState createState() => _RecentlyReadState();
}

class _RecentlyReadState extends State<RecentlyRead> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  navigateToDetailPage(DocumentSnapshot post)async {
    BookDetailArgs bookDetailArgs = new BookDetailArgs();
    bookDetailArgs.post = await FirebaseFirestore.instance.collection("books").doc(post.data()["id"]).get();
    bookDetailArgs.isRecentlyRead = true;
    Navigator.pushNamed(context, bookDetailRoute, arguments: bookDetailArgs);
  }



  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final user = Provider.of<User>(context);
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
                Text(
                  continueReading,
                  style: TextStyle(
                    fontFamily: kAbrilFatFace,
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Flexible(
                  flex: 1,
                  child: PaginateFirestore(
                      itemBuilderType: PaginateBuilderType.gridView,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      emptyDisplay: NoListContent(txt: nocontent,),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        mainAxisSpacing: 6.0,
                        crossAxisSpacing: 6.0,
                      ),
                      itemBuilder: (index, context, documentSnapshot) {
                        return InkWell(
                          onTap: (){
                            navigateToDetailPage(documentSnapshot);
                          },
                          child: RecentlyReadTile(
                            bookCover: documentSnapshot.data()['bookCover'],
                            bookName: documentSnapshot.data()['bookName'],
                            authorName: documentSnapshot.data()['authorName'],
                          ),
                        );
                      },
                      query: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection("recentlyread")
                          .orderBy('dateAdded', descending: true),
                      isLive: true // to fetch real-time data
                      ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
