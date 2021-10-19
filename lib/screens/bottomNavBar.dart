import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_reads/constant.dart';
import 'package:easy_reads/model/bookDetailModel.dart';
import 'package:easy_reads/model/postArgs.dart';
import 'package:easy_reads/routes/route_names.dart';
import 'package:easy_reads/screens/forumScreen.dart';
import 'package:easy_reads/screens/homepage.dart';
import 'package:easy_reads/screens/recentlyRead.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavbar extends StatefulWidget {
  PostArgs data;
  BottomNavbar({this.data});
  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  final PageStorageBucket bucket = PageStorageBucket();
  PageController pageController = PageController();
  bool _isConfigured = false;

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;

  onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  final List<Widget> screens = [
    HomeScreen(),
    RecentlyRead(),
    Forum()
  ];

  configureRealTimePushNotifcations() async {
    final user = Provider.of<User>(context, listen: false);
    if (Platform.isIOS) {
      getIOSPermissions();
    }
    await FirebaseMessaging.instance.getToken().then((token) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'androidNotificationToken': token});
    });
  }

  getIOSPermissions() async {
    FirebaseMessaging.instance
        .requestPermission(alert: true, badge: true, sound: true);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    configureRealTimePushNotifcations();
    if (widget.data != null) {
      var one = int.parse(widget.data.tab);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pageController.hasClients) {
          pageController.animateToPage(one,
              duration: Duration(milliseconds: 1), curve: Curves.easeInOut);
        }

        _onPageChanged(one);
        Flushbar(
            icon: Icon(
              Icons.verified_outlined,
              color: Colors.blue,
            ),
            message: widget.data.msg,
            duration: Duration(seconds: 8),
            margin: EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(8),
            flushbarStyle: FlushbarStyle.FLOATING)
            .show(context);
      });


    }
    firebaseTrigger();
  }

  navigateToDetailPage(DocumentSnapshot post) {
    BookDetailArgs bookDetailArgs = new BookDetailArgs();
    bookDetailArgs.post = post;
    Navigator.pushNamed(context, postDetailRoute, arguments: bookDetailArgs);
  }

  void firebaseTrigger() {
    if (_isConfigured==false) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // FlutterAppBadger.updateBadgeCount(1);
        //
        // final data = message.data;
        // // if (data["page"] != null) {
        // //
        // //   Navigator.pushNamed(context, chatRoomRoute);
        // // }
        //  if(data["page"] != null && data["page"]=="TeacherChat"){
        //
        //
        //   Navigator.pushNamed(context, teacherChatRoute, arguments: data["chatroomId"] );
        // }
      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async{

        final data = message.data;
        // if (data["page"] != null && data["page"]=="ChatRoom") {
        //   Navigator.pushNamed(context, chatRoomRoute);
        // }
        if (data["page"] != null && data["page"] == "PostDetail") {

          DocumentSnapshot doc = await FirebaseFirestore.instance
              .collection("post")
              .doc(data["postId"])
              .get();
          navigateToDetailPage(doc);
        }
        else {
          print("FLUTTER_NOTIFICATION_CLICK");
        }
      });
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage message) async{
        //If there is data in our notification
        if(message!=null){
          final data = message.data;
          // if (data["page"] != null && data["page"]=="ChatRoom") {
          //   Navigator.pushNamed(context, chatRoomRoute);
          // }
          if (data["page"] != null && data["page"] == "PostDetail") {
            print('not here');
            DocumentSnapshot doc = await FirebaseFirestore.instance
                .collection("post")
                .doc(data["postId"])
                .get();
            navigateToDetailPage(doc);
          }
        }

      });

      _isConfigured = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: _onPageChanged,
        children: screens,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
        backgroundColor: kBackGroundColor,
        iconSize: 20,
        activeColor: kAppColor,
        inactiveColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.collections_bookmark_sharp,
            ),
            label: bookTxt,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.update,
            ),
            label: recentlyReadText,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.forum_outlined,
            ),
            label: forumText,
          ),
        ],
      ),
    );
  }
}
