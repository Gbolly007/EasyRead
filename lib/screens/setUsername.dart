import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_reads/constant.dart';
import 'package:easy_reads/routes/route_names.dart';
import 'package:easy_reads/services/auth.dart';
import 'package:easy_reads/services/authService.dart';
import 'package:easy_reads/widgets/loadingBtn.dart';
import 'package:easy_reads/widgets/roundedBtn.dart';
import 'package:easy_reads/widgets/textFormWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetUsernameScreen extends StatefulWidget {
  final String editUsername;

  SetUsernameScreen({this.editUsername});

  @override
  _SetUsernameScreenState createState() => _SetUsernameScreenState();
}

class _SetUsernameScreenState extends State<SetUsernameScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController referredCode = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  AuthService _authService = new AuthService();
  bool isReferred = false;

  void updateUser(String username, String id) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"name": username});
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
    var user = Provider.of<User>(context);
    var users = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: kBackGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: screenWidth,
            height: screenHeight,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30),
              child: Column(
                children: <Widget>[
                  widget.editUsername == "yes"
                      ? Row(
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
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 50,
                  ),
                  widget.editUsername == "yes"
                      ? Text(
                          editusername,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: kRoboto,
                              fontSize: 25,
                              color: kDarkColor),
                        )
                      : Text(
                          setupname,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: kRoboto,
                              fontSize: 25,
                              color: kDarkColor),
                        ),
                  SizedBox(
                    height: 60,
                  ),
                  Form(
                    key: _formKey,
                    child: TextFormWidget(
                      controller: name,
                      type: TextInputType.text,
                      data: Icons.alternate_email_outlined,
                      hintText: hint_username,
                      func: (value) => value.isEmpty ? usernamevalidator : null,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  widget.editUsername != "yes"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              referredText,
                              style: TextStyle(
                                  fontFamily: kRoboto,
                                  fontWeight: FontWeight.bold),
                            ),
                            isReferred
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        isReferred = false;
                                      });
                                    },
                                    child: Icon(
                                      Icons.check_box_outlined,
                                      color: Colors.black,
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      setState(() {
                                        isReferred = true;
                                      });
                                    },
                                    child: Icon(
                                      Icons.check_box_outline_blank,
                                      color: Colors.black,
                                    ),
                                  )
                          ],
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 20,
                  ),
                  isReferred
                      ? Text(
                          uniquecodedescText,
                          style: TextStyle(
                            fontFamily: kRoboto,
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  isReferred
                      ? TextFormWidget(
                          controller: referredCode,
                          type: TextInputType.text,
                          data: Icons.tag,
                          hintText: hint_referralCode,
                          func: (value) =>
                              value.isEmpty ? usernamevalidator : null,
                        )
                      : Container(),
                  SizedBox(
                    height: 50,
                  ),
                  isLoading
                      ? LoadingButton()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Container(
                            width: btnSize,
                            height: btnSize,
                            child: RoundedButtonWidget(
                              icons: Icons.arrow_forward_outlined,
                              bgColor: kAppColor,
                              iconColor: kBackGroundColor,
                              onPush: () async {
                                if (_formKey.currentState.validate()) {
                                  if (isReferred &&
                                      referredCode.text.length == 0) {
                                    showFlushBar(enterUniqueCode, Colors.red);
                                  } else {
                                    if (user == null) {
                                      Navigator.pushReplacementNamed(
                                          context, enterNumberRoute);
                                    } else {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      if (isReferred) {
                                        dynamic result =
                                            await _authService.checkUniqueCode(
                                                referredCode.text.trim());
                                        if (result.toString() == "true") {
                                          dynamic results =
                                              await _authService.updateUserName(
                                                  name.text.toString().trim(),
                                                  user.uid,
                                                  true,
                                                  referredCode.text.trim());
                                          if (results.toString() == "0") {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            users.onStateChanged(user);
                                            Navigator.pushReplacementNamed(
                                                context, bottomNavbarRoute);
                                          } else {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            showFlushBar(
                                                errorOccurred, Colors.red);
                                          }
                                        } else if (result.toString() ==
                                            "false") {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          showFlushBar(
                                              codeNotExist, Colors.red);
                                        } else if (result.toString() ==
                                            "error") {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          showFlushBar(
                                              errorOccurred, Colors.red);
                                        }
                                      } else {
                                        dynamic results =
                                            await _authService.updateUserName(
                                                name.text.toString().trim(),
                                                user.uid,
                                                false,
                                                "");
                                        if (results.toString() == "0") {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          users.onStateChanged(user);
                                          Navigator.pushReplacementNamed(
                                              context, bottomNavbarRoute);
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          showFlushBar(
                                              errorOccurred, Colors.red);
                                        }
                                      }
                                    }
                                  }
                                }
                              },
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
