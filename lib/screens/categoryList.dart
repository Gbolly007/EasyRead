import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_reads/model/bookDetailModel.dart';
import 'package:easy_reads/routes/route_names.dart';
import 'package:easy_reads/widgets/noContentList.dart';
import 'package:easy_reads/widgets/recentlyReadTile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

class CategoryList extends StatefulWidget {

  final String categoryType;
  CategoryList({this.categoryType});

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  navigateToDetailPage(DocumentSnapshot post)async {
    BookDetailArgs bookDetailArgs = new BookDetailArgs();
    bookDetailArgs.post = await FirebaseFirestore.instance.collection("books").doc(post.data()["id"]).get();
    bookDetailArgs.isRecentlyRead = false;
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

                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  widget.categoryType,
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
                      emptyDisplay: NoListContent(txt: nobooksfound,),
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RecentlyReadTile(
                              bookCover: documentSnapshot.data()['bookcover'],
                              bookName: documentSnapshot.data()['title'],
                              authorName: documentSnapshot.data()['authorname'],
                            ),
                          ),
                        );
                      },
                      query: FirebaseFirestore.instance
                          .collection('books')
                          .where("bookType", isEqualTo: widget.categoryType)
                          .orderBy('timePosted', descending: true),
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
