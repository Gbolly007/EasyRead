import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_reads/model/user.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  String collection = "users";
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  var uuid = Uuid();

  Future<String> createUser(Map<String, dynamic> values) async {
    String res = "";
    try {
      String id = values["id"];
      await _firebaseFirestore.collection(collection).doc(id).set(values);
      res = "success";
    } catch (e) {
      res = "error";
    }
    return res;
  }

  Future<String> updateUser(Map<String, dynamic> values) async {
    String res = "";
    try {
      String id = values["id"];
      await _firebaseFirestore.collection(collection).doc(id).update(values);
      res = "success";
    } catch (e) {
      res = "error";
    }
    return res;
  }

  Future<UserModel> getUserById(String ids) async =>
      await FirebaseFirestore.instance
          .collection("users")
          .doc(ids)
          .get()
          .then((doc) {
        return UserModel.fromSnapshot(doc);
      });

  Future<String> favoriteBook(String id, String bookid, String bookName,
      String bookCover, String authorName) async {
    String res = "";
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .collection("recentlyread")
          .where('id', isEqualTo: bookid)
          .get();
      final List<DocumentSnapshot> documents = result.docs;

      if (documents.length == 0) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(id)
            .collection("recentlyread")
            .add({
          "id": bookid,
          "bookName": bookName,
          "bookCover": bookCover,
          "authorName": authorName,
          "dateAdded": Timestamp.now()
        }).then((value) {
          FirebaseFirestore.instance
              .collection("books")
              .doc(bookid)
              .update({"numberofreads": FieldValue.increment(1)});
        });
      }
      res = "success";
    } catch (e) {
      res = "error";
    }
    return res;
  }

  Future<String> deleteRecentlyRead(String bookId, String userId) async {
    String value = "";
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("recentlyread")
          .where('id', isEqualTo: bookId)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
      value = "0";
    } catch (e) {
      value = "1";
    }
    return value;
  }

  Future<String> updateUserName(
      String username, String id, bool isReferred, String referralCode) async {
    String value = "";
    try {
      if (isReferred) {
        await FirebaseFirestore.instance.collection("users").doc(id).update({
          "name": username,
          "uniquecode": uuid.v4().substring(0, 8),
          "referredBy": referralCode
        }).then((value) async{
          QuerySnapshot documentReference = await FirebaseFirestore.instance
              .collection("users")
              .where('uniquecode', isEqualTo: referralCode)
              .get();
          String uid =documentReference.docs[0]['id'];

          FirebaseFirestore.instance.collection("uniquecode").add({
            "referredBy": referralCode,
            "name": username,
            "uid":uid
          });
        });
      } else {
        await FirebaseFirestore.instance.collection("users").doc(id).update(
            {"name": username, "uniquecode": uuid.v4().substring(0, 8)});
      }

      value = "0";
    } catch (e) {
      print(e);
      value = "1";
    }
    return value;
  }

  Future<String> checkUniqueCode(String ucode) async {
    String exist = '';
    try {
      QuerySnapshot documentReference = await FirebaseFirestore.instance
          .collection("users")
          .where('uniquecode', isEqualTo: ucode)
          .get();


      if (documentReference.size == 0) {
        exist = "false";
      } else {
        exist = "true";
      }
    } catch (e) {
      print(e);
      exist = "error";
    }
    return exist;
  }

  Future<String> checkNewUser(String mobileNumber) async {
    String res = "";
    try {
      QuerySnapshot documentReference = await FirebaseFirestore.instance
          .collection('users')
          .where('number', isEqualTo: mobileNumber)
          .get();

      if (documentReference.size == 0) {
        res = "false";
      } else {
        res = "true";
      }
    } catch (e) {
      res = "error";
    }

    print("This is res " + res);
    return res;
  }

  Future<Timestamp> getPaid(String uid) async {
    Timestamp timestamp;
    try {
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(collection)
          .doc(uid)
          .collection("payment")
          .orderBy("dateCreated", descending: true)
          .get();

      if (querySnapshot.size > 0) {
        timestamp = querySnapshot.docs[0].data()["dateCreated"];
      } else {
        timestamp = Timestamp(2592000, 0);
      }
    } catch (e) {}

    return timestamp;
  }

  Future<String> logUserPayment(String id, double amount) async {
    String res = "";
    try {
      await _firebaseFirestore
          .collection(collection)
          .doc(id)
          .collection("payment")
          .add({"dateCreated": Timestamp.now(), "amount": amount}).then((value){

        _firebaseFirestore
            .collection("payment")
            .add({"dateCreated": Timestamp.now(), "amount": amount,"userId":id});

      });
      res = "success";
    } catch (e) {
      res = "error";
    }
    return res;
  }
}
