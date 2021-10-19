import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  static const NUMBER = "number";
  static const ID = "id";
  static const NAME = "name";
  static const UNIQUECODE = "uniquecode";
  static const TIMECREATED = "timeCreated";
  static const LASTPAYMENT = "lastPayment";
  static const COUNTRY ="country";


  String _number="";
  String _id="";
  String _name="";
  String _uniquecode="";
  Timestamp _timecreated;
  Timestamp _lastPayment;
  String _country="";

  String get number => _number;
  String get id => _id;
  String get name => _name;
  String get uniquecode => _uniquecode;
  Timestamp get timeCreated => _timecreated;
  Timestamp get lastPayment => _lastPayment;
  String get country => _country;

  UserModel.fromSnapshot(DocumentSnapshot snapshot){

    _number = snapshot.data()[NUMBER];
    _id =snapshot.data()[ID];
    _name=snapshot.data()[NAME];
    _uniquecode=snapshot.data()[UNIQUECODE];
    _timecreated=snapshot.data()[TIMECREATED];
    _country=snapshot.data()[COUNTRY];
    _lastPayment=snapshot.data()[LASTPAYMENT];
  }
}