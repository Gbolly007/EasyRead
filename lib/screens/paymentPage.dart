import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_reads/constant.dart';
import 'package:easy_reads/routes/route_names.dart';
import 'package:easy_reads/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool available = false;

  Offerings offerings;

  Timer _timer;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  void initState() {
    super.initState();
    getOfferings();
  }

  void getOfferings() async {
    Offerings getofferings = await Purchases.getOfferings();
    setState(() {
      offerings = getofferings;
    });

    print(offerings.current);
  }

  void payForSub({Package package}) async {
    var user = Provider.of<User>(context, listen: false);
    var users = Provider.of<AuthProvider>(context, listen: false);
    try {
      PurchaserInfo purchaserInfo = await Purchases.purchasePackage(package);
      if (purchaserInfo.entitlements.all["allFeatures"].isActive) {
        // Send data to firestore here.
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'lastPayment': DateTime.now()}).then((value) {
          FirebaseFirestore.instance.collection("purchases").add({
            "id": purchaserInfo.originalAppUserId,
            "userId": user.uid,
            "date": DateTime.now().toString(),
          });

          users.onStateChanged(user);
          showFlushBar("Payment successful", Colors.blue);

        });

        if(this.mounted){
          _timer = new Timer(
              Duration(
                  seconds: 2),
                  () {
                Navigator.pushNamedAndRemoveUntil(context,bottomNavbarRoute,(route) => false,);
              });
        }


      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);

      showFlushBar("Error Occurred, please try again", Colors.red);
    }
  }

  showFlushBar(String message, Color clr) {
    Flushbar(
            icon: Icon(
              Icons.info_outline,
              color: clr,
            ),
            message: message,
            duration: Duration(seconds: 5),
            margin: EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(8),
            flushbarStyle: FlushbarStyle.FLOATING)
        .show(context);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kBackGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: screenHeight,
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PriceListContainer(
                    screenWidth: screenWidth,
                    price: offerings.current.monthly.product.priceString,
                    smsqty: "",
                    desc: offerings.current.monthly.product.description,

                  ),

                  InkWell(
                    onTap: (){
                      payForSub(package: offerings.current.monthly);
                    },
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                        color: Colors.blue,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                                "Continue to Payment",
                                style: TextStyle(
                                    fontFamily: kRoboto, fontSize: 14, color: Colors.white),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BtnWidget extends StatelessWidget {
  const BtnWidget({
    Key key,
    @required this.screenWidth,
    @required this.txt,
  }) : super(key: key);

  final double screenWidth;
  final String txt;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: kAppColor,
        borderRadius: BorderRadius.all(
          Radius.circular(30.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 8,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Center(
          child: Text(
        txt,
        style:
            TextStyle(fontFamily: kRoboto, fontSize: 14, color: Colors.white),
      )),
    );
  }
}

class PriceListContainer extends StatelessWidget {
  const PriceListContainer({
    Key key,
    @required this.screenWidth,
    @required this.price,
    @required this.smsqty,
    @required this.desc,

  }) : super(key: key);

  final double screenWidth;

  final String price;
  final String smsqty;
  final String desc;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      height: 220,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                "A payment of " + price + " is required " + desc,
                style: TextStyle(
                    fontSize: 20,
                    color: kDarkColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: "RobotoLight"),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
