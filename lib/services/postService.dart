import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as inn;

class PostService {
  final _firestore = FirebaseFirestore.instance;

  Future<String> addNewPost(String uid, String title, String body) async {
    String ref = "";
    try {
      Map<String, dynamic> messageMap = {
        'uid': uid,
        'title': title,
        'body': body,
        "timePosted": Timestamp.now(),
      };

      await _firestore.collection("post").add(messageMap);
      return ref = "success";
    } catch (e) {
      print(e);
      return ref = "failed";
    }
  }

  Future<String> addComment(String uid, String postId, String comment,
      String uidnotify, String name, String title) async {
    String ref = "";
    try {
      Map<String, dynamic> messageMap = {
        'uid': uid,
        'comment': comment,
        "timePosted": Timestamp.now(),
        'uidnotify': uidnotify,
        'name': name,
        'postname': title,
        'postId':postId
      };
      await _firestore
          .collection("post")
          .doc(postId)
          .collection("comment")
          .add(messageMap);
      return ref = "success";
    } catch (e) {
      print(e);
      return ref = "failed";
    }
  }

  Future<String> deleteComment(String postId, String commentId) async {
    String ref = "";
    try {
      await _firestore
          .collection("post")
          .doc(postId)
          .collection("comment")
          .doc(commentId)
          .delete();
      ref = "success";
    } catch (e) {
      print(e);
      ref = "failed";
    }
    return ref;
  }

  String dte(Timestamp t) {
    String dt = '';
    DateTime d = t.toDate();
    var newDt = inn.DateFormat.Hm().format(d);
    var newDts = inn.DateFormat.MMMEd().format(d);
    var date = t.toDate();
    var dateParse = inn.DateFormat.y().format(date);

    var cdate = new DateTime.now().toString();

    var cdateParse = DateTime.parse(cdate);

    var formattedDate = cdateParse.year.toString();

    //print(month.toString());

    if (dateParse.toString() == formattedDate) {
      dt = newDts.toString().substring(4) + ', ' + newDt.toString();
    } else {
      dt = newDts.toString().substring(4) +
          ' ' +
          dateParse.toString() +
          ', ' +
          newDt.toString();
    }
    return dt;
  }

  Future<String> getAuthorName(String uid) async {
    String username = '';

    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("users").doc(uid);
      await documentReference.get().then((datasnapshot) {
        if (datasnapshot.exists) {
          username = datasnapshot.data()['name'].toString();
        } else {
          username = "";
        }
      });
    } catch (e) {
      username = "";
      print(e);
    }
    return username;
  }

  Future<bool> checkIfUserLikedPost(String postId, String userId) async {
    bool res = false;
    try {
      await FirebaseFirestore.instance
          .collection('post')
          .doc(postId)
          .collection("like")
          .doc(userId)
          .get()
          .then((DocumentSnapshot ds) {
        if (ds.exists) {
          res = true;
        } else {
          res = false;
        }
      });
    } catch (e) {
      res = false;
    }

    return res;
  }

  Future<String> countLike(String postId) async {
    String like = '';
    try {
      QuerySnapshot _myDoc = await FirebaseFirestore.instance
          .collection('post')
          .doc(postId)
          .collection("like")
          .get();
      List<DocumentSnapshot> _myDocCount = _myDoc.docs;

      like = _myDocCount.length.toString();
    } catch (e) {
      like = "0";
    }

    return like;
  }

  Future<String> countComment(String postId) async {
    String like = '';
    try {
      QuerySnapshot _myDoc = await FirebaseFirestore.instance
          .collection('post')
          .doc(postId)
          .collection("comment")
          .get();
      List<DocumentSnapshot> _myDocCount = _myDoc.docs;

      like = _myDocCount.length.toString();
    } catch (e) {
      like = "0";
    }

    return like;
  }
}
