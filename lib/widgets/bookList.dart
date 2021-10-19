import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_reads/model/bookDetailModel.dart';
import 'package:easy_reads/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import 'bookTile.dart';
import 'noBooks.dart';

class BookList extends StatelessWidget {
  final String bookCategory;
  BookList({this.bookCategory});



  @override
  Widget build(BuildContext context) {

    navigateToDetailPage(DocumentSnapshot post) {
      BookDetailArgs bookDetailArgs = new BookDetailArgs();
      bookDetailArgs.post = post;
      bookDetailArgs.isRecentlyRead = false;
      Navigator.pushNamed(context, bookDetailRoute, arguments: bookDetailArgs);
    }

    return Container(
      height: 250,
      child: PaginateFirestore(
          itemBuilderType: PaginateBuilderType.listView,
          scrollDirection: Axis.horizontal,
          //
          emptyDisplay: NoBooks(),
          shrinkWrap: true,
          // listview and gridview
          itemBuilder: (index, context,
              documentSnapshot) =>
              InkWell(
                onTap: () {
                  navigateToDetailPage(
                      documentSnapshot);
                },
                child: BookTile(
                  bookImage: documentSnapshot
                      .data()['bookcover'],
                  bookAuthor: documentSnapshot
                      .data()['authorname'],
                  bookTitle:
                  documentSnapshot.data()['title'],
                  bookDesc:
                  documentSnapshot.data()['desc'],
                ),
              ),
          // orderBy is compulsary to enable pagination
          query: FirebaseFirestore.instance
              .collection('books')
              .where("bookType",
              isEqualTo: bookCategory)
              .orderBy('timePosted'),
          isLive: true,
        // to fetch real-time data
      ),
    );
  }
}


class RecommendBookList extends StatelessWidget {


  final String bookId;
  RecommendBookList({this.bookId});


  @override
  Widget build(BuildContext context) {

    navigateToDetailPage(DocumentSnapshot post) {
      BookDetailArgs bookDetailArgs = new BookDetailArgs();
      bookDetailArgs.post = post;
      bookDetailArgs.isRecentlyRead = false;
      Navigator.pushNamed(context, bookDetailRoute, arguments: bookDetailArgs);
    }

    return Container(
      height: 250,
      child: PaginateFirestore(
        itemBuilderType: PaginateBuilderType.listView,
        scrollDirection: Axis.horizontal,
        //
        emptyDisplay: NoBooks(),
        shrinkWrap: true,
        // listview and gridview
        itemBuilder: (index, context,
            documentSnapshot) =>
        bookId==documentSnapshot
            .data()['id']? SizedBox(): InkWell(
              onTap: () {
                navigateToDetailPage(
                    documentSnapshot);
              },
              child: BookTile(
                bookImage: documentSnapshot
                    .data()['bookcover'],
                bookAuthor: documentSnapshot
                    .data()['authorname'],
                bookTitle:
                documentSnapshot.data()['title'],
                bookDesc:
                documentSnapshot.data()['desc'],
              ),
            ),
        // orderBy is compulsary to enable pagination
        query: FirebaseFirestore.instance
            .collection('books').where('numberofreads', isGreaterThan: 20).orderBy("numberofreads",descending: true)

            .limit(15),
        isLive: true,
        // to fetch real-time data
      ),
    );
  }
}
