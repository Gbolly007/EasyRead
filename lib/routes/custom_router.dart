import 'package:easy_reads/routes/route_names.dart';
import 'package:easy_reads/screens/addPost.dart';
import 'package:easy_reads/screens/bookDetail.dart';
import 'package:easy_reads/screens/bottomNavBar.dart';
import 'package:easy_reads/screens/categoryList.dart';
import 'package:easy_reads/screens/changePhoneNum.dart';
import 'package:easy_reads/screens/contactUs.dart';
import 'package:easy_reads/screens/enterNumberScreen.dart';
import 'package:easy_reads/screens/forumScreen.dart';
import 'package:easy_reads/screens/homepage.dart';
import 'package:easy_reads/screens/onboardingScreen.dart';
import 'package:easy_reads/screens/otpScreen.dart';
import 'package:easy_reads/screens/paymentPage.dart';
import 'package:easy_reads/screens/postDetail.dart';
import 'package:easy_reads/screens/privacyPolicy.dart';
import 'package:easy_reads/screens/recentlyRead.dart';
import 'package:easy_reads/screens/searchScreen.dart';
import 'package:easy_reads/screens/setUsername.dart';
import 'package:easy_reads/screens/settings.dart';
import 'package:easy_reads/screens/splashScreen.dart';
import 'package:easy_reads/screens/termsCondition.dart';
import 'package:easy_reads/screens/viewPdf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case onboardRoute:
        return MaterialPageRoute(builder: (_) => OnboardScreen());
      case enterNumberRoute:
        return MaterialPageRoute(builder: (_) => EnterNumber());
      case otpRoute:
        return MaterialPageRoute(builder: (_) => OtpScreen());
      case setusernameRoute:
        var datas = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => SetUsernameScreen(editUsername: datas,));
      case homeScreenRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case bookDetailRoute:
        var datas = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => BookDetail(
                  data: datas,
                ));
      case viewPdfRoute:
        var datas = settings.arguments;
        return MaterialPageRoute(builder: (_) => ViewPdf(data: datas,));
      case settingsRoute:
        return MaterialPageRoute(builder: (_) => Settings());
      case bottomNavbarRoute:
        var datas = settings.arguments;
        return MaterialPageRoute(builder: (_) => BottomNavbar(data: datas,));
      case recentlyReadRoute:
        return MaterialPageRoute(builder: (_) => RecentlyRead());
      case forumRoute:
        return MaterialPageRoute(builder: (_) => Forum());
      case addPostRoute:
        return MaterialPageRoute(builder: (_) => AddPost());
      case postDetailRoute:
        var datas = settings.arguments;
        return MaterialPageRoute(builder: (_) => PostDetail(data: datas,));
      case changeNumberRoute:
        return MaterialPageRoute(builder: (_) => ChangePhoneNumber());
      case contactUsRoute:
        return MaterialPageRoute(builder: (_) => ContactUs());
      case paymentPageRoute:
        return MaterialPageRoute(builder: (_) => PaymentPage());
      case tcRoute:
        return MaterialPageRoute(builder: (_) => TermsCondition());
      case privacyPolicyRoute:
        return MaterialPageRoute(builder: (_) => PrivacyPolicy());
      case categoryListRoute:
        var datas = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => CategoryList(categoryType: datas,));
      case searchScreenRoute:
        var datas = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => SearchScreen(searchType: datas,));
    }
  }
}
