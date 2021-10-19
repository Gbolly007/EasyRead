import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_reads/routes/route_names.dart';
import 'package:easy_reads/services/auth.dart';
import 'package:easy_reads/widgets/longBtn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constant.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  DocumentSnapshot variable;
  String number = "";
  String name = "";
  String uniquecode = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI();
  }

  updateUI() async {
    var user = Provider.of<User>(context, listen: false);
    variable = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    if (variable.data()["name"] == null ||
        variable.data()["name"].toString().length == 0) {
      Navigator.pushReplacementNamed(context, setusernameRoute);
    } else {
      setState(() {
        number = variable.data()["number"];
        name = variable.data()["name"];
        uniquecode = variable.data()["uniquecode"];
      });
    }
  }

  void copyToClipboard(String toClipboard) {
    ClipboardData data = new ClipboardData(text: toClipboard);
    Clipboard.setData(data);
    Flushbar(
            icon: Icon(
              Icons.info_outline,
              color: Colors.blue,
            ),
            message: uniqueCodeCopied,
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
    final users = Provider.of<AuthProvider>(context);
    name = users.userModel!=null? users.userModel.name:"";
    uniquecode = users.userModel!=null? users.userModel.uniquecode:"";
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: kDarkColor,
                        size: 30,
                      ),
                    ),
                    SizedBox(),
                    SizedBox(),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name == null ? "..." : name,
                        style: TextStyle(
                            fontFamily: kRoboto,
                            fontSize: 25,
                            color: kDarkColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              uniquecode == null
                                  ? "UniqueCode: ***"
                                  : "UniqueCode: " + uniquecode,
                              style: TextStyle(
                                fontFamily: kRoboto,
                                fontSize: 15,
                                color: kDarkColor,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              copyToClipboard(uniquecode);
                            },
                            child: Icon(Icons.copy),
                          )
                        ],
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, changeNumberRoute);
                        },
                        child: Text(
                          changePhoneNumber,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: kRoboto,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, setusernameRoute, arguments: "yes");
                        },
                        child: Text(
                          changeUsername,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: kRoboto,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, contactUsRoute);
                        },
                        child: Text(
                          contactUsText,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: kRoboto,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, paymentPageRoute);
                        },
                        child: Text(
                          makePayment,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: kRoboto,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, privacyPolicyRoute);
                        },
                        child: Text(
                          privacyPolicyText,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: kRoboto,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: (){

                          Navigator.pushNamed(context, tcRoute);
                        },
                        child: Text(
                          tcText,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: kRoboto,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: InkWell(
                          onTap: () async {
                            FirebaseAuth.instance.signOut().then((value) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, enterNumberRoute, (route) => false);
                            });
                          },
                          child: BtnWidget(
                            screenWidth: screenWidth,
                            txt: logoutText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
