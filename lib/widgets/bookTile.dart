import 'package:flutter/material.dart';

import '../constant.dart';

class BookTile extends StatelessWidget {
  final String bookImage, bookTitle, bookAuthor, bookDesc;

  BookTile(
      {@required this.bookImage,
        @required this.bookTitle,
        @required this.bookAuthor,
        @required this.bookDesc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  bookImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              bookTitle.length > 15
                  ? bookTitle.substring(0, 15) + "..."
                  : bookTitle,
              style: TextStyle(
                  color: kDarkColor,
                  fontFamily: kRoboto,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              bookAuthor.length > 15
                  ? "By " + bookAuthor.substring(0, 15) + "..."
                  : "By " + bookAuthor,
              style: TextStyle(
                  color: kDarkColor, fontFamily: kRoboto, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}