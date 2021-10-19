import 'dart:async';
import 'package:easy_reads/model/user.dart';
import 'package:easy_reads/services/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


enum Status{Uninitialized, Authenticated, Authenticating, Unauthenticated}

class AuthProvider with ChangeNotifier{
   static const LOGGEDIN="loggedIn";
   FirebaseAuth _auth = FirebaseAuth.instance;
   User _user;
   UserModel _userModel;
   Status _status = Status.Uninitialized;

   AuthService _authService = AuthService() ;
   String smsOTP;
   String verificationId;
   String errorMsg="";
   bool loggedIn ;
   bool loading = false;

   UserModel get userModel => _userModel;
   Status get status => _status;
   User get user => _user;

   AuthProvider.initialize(): _auth = FirebaseAuth.instance{
     _auth.authStateChanges().listen(onStateChanged);
   }

   Future<void> onStateChanged(User user) async{
     if(user == null){
       _status = Status.Unauthenticated;
     }else{
       _user = user;
       _status = Status.Authenticated;
       _userModel = await _authService.getUserById(user.uid);


     }
     notifyListeners();
   }




}