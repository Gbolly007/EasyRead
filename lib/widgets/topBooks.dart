import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_reads/model/bookDetailModel.dart';
import 'package:easy_reads/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import '../constant.dart';
import 'bookTile.dart';
import 'noBooks.dart';

class TopBookList extends StatelessWidget {
  Future getPosts() async {
    Query q = FirebaseFirestore.instance
        .collection('books')
        .orderBy('timePosted', descending: true);

    QuerySnapshot qn = await q.limit(5).get();

    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    navigateToDetailPage(DocumentSnapshot post) {
      BookDetailArgs bookDetailArgs = new BookDetailArgs();
      bookDetailArgs.post = post;
      bookDetailArgs.isRecentlyRead = false;
      Navigator.pushNamed(context, bookDetailRoute, arguments: bookDetailArgs);
    }

    var circularProgButton = CircularProgressIndicator(
      strokeWidth: 2,
      valueColor: AlwaysStoppedAnimation<Color>(kAppColor),
    );

    return Container(
        height: 250,
        child: FutureBuilder(
          future: getPosts(),
          builder: (_, snapshot) {
            if (snapshot.data != null) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    return InkWell(
                      onTap: () {
                        navigateToDetailPage(snapshot.data[index]);
                      },
                      child: BookTile(
                        bookImage: snapshot.data[index].data()['bookcover'],
                        bookAuthor: snapshot.data[index].data()['authorname'],
                        bookTitle: snapshot.data[index].data()['title'],
                        bookDesc: snapshot.data[index].data()['desc'],
                      ),
                    );
                  });
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: circularProgButton);
            } else {
              return NoBooks();
            }
          },
        ));
  }
}
