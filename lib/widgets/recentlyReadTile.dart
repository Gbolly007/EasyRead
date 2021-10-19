import 'package:flutter/material.dart';

import '../constant.dart';


class RecentlyReadTile extends StatelessWidget {
  final String bookCover, bookName, authorName;
  RecentlyReadTile({this.bookCover,this.bookName,this.authorName});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              bookCover,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context,
                  Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      kAppColor),
                  value: loadingProgress.expectedTotalBytes !=
                      null
                      ? loadingProgress
                      .cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                      : null,
                );
              },
            ),
          ),
        ),
        Text(
          bookName.length > 15
              ? bookName
              .substring(0, 15) +
              "..."
              : bookName,
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
          authorName.length > 15
              ? "By " +
              authorName
                  .substring(0, 15) +
              "..."
              : "By " + authorName,
          style: TextStyle(
              color: kDarkColor,
              fontFamily: kRoboto,
              fontSize: 15),
        ),
      ],
    );
  }
}
