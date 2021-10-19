import 'dart:async';

import 'package:easy_reads/routes/route_names.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  final _auth = FirebaseAuth.instance;
  User loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    startSplashCreen();
  }

  signOut() {
    //redirect
    _auth.signOut();
  }

  Future<void> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          loggedInUser = user;
        });
      } else {
        setState(() {
          loggedInUser = null;
        });
      }
    } catch (e) {
      print(e);
    }
  }


  startSplashCreen() async {
    var duration = const Duration(seconds: 3);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    return Timer(duration, () async {
      if (_seen) {
        loggedInUser != null
            ? Navigator.pushReplacementNamed(context, bottomNavbarRoute)
            : Navigator.pushReplacementNamed(context, enterNumberRoute);
      } else {
        await prefs.setBool('seen', true);
        return Navigator.pushReplacementNamed(context, onboardRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              child: Image.asset(
                "images/applogo.png",
                width: 350,
                height: 350,
              ),
            ),
          ),
        ],
      )
    );
  }
}
