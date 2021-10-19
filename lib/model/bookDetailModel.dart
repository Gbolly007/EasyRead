import 'package:cloud_firestore/cloud_firestore.dart';

class BookDetailArgs {
  DocumentSnapshot post;
  bool isRecentlyRead;
  BookDetailArgs({this.post,this.isRecentlyRead});
}