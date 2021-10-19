import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_reads/routes/route_names.dart';
import 'package:easy_reads/services/auth.dart';
import 'package:easy_reads/services/authService.dart';
import 'package:easy_reads/widgets/loadingBtn.dart';
import 'package:easy_reads/widgets/roundedBtn.dart';
import 'package:easy_reads/widgets/textFormWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../constant.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class EnterNumber extends StatefulWidget {
  @override
  _EnterNumberState createState() => _EnterNumberState();
}

class _EnterNumberState extends State<EnterNumber> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();

  AuthService authService = new AuthService();
  TextEditingController mobilenumber = TextEditingController();
  final TextEditingController otpController = new TextEditingController();

  var isValidUser = false;

  var isLoading = false;
  var isResend = false;
  var isLoginScreen = true;
  var isOTPScreen = false;

  String country = "";
  String countryCode = "";

  String verificationCode = '';

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 60;

  int currentSeconds = 0;
  Timer timer;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int milliseconds]) {
    var duration = interval;
    if (this.mounted) {
      timer = Timer.periodic(duration, (timer) {
        setState(() {
          currentSeconds = timer.tick;
          if (timer.tick >= timerMaxSeconds) timer.cancel();
        });
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    mobilenumber.dispose();

    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isOTPScreen ? returnOTPScreen() : returnLoginScreen();
  }

  Widget returnLoginScreen() {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        getstatrtedText,
                        style: TextStyle(
                          fontFamily: kAbrilFatFace,
                          fontSize: 25,
                          color: kAppColor,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        enternumberforotptext,
                        style: TextStyle(fontFamily: kRoboto, fontSize: 16),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: IntlPhoneField(
                          controller: mobilenumber,
                          style: TextStyle(
                            fontFamily: kRoboto,
                            fontSize: 20,
                            color: kDarkColor,
                          ),
                          validator: (val) =>
                          val.isEmpty ? phoneNumValidator : null,
                          decoration: InputDecoration(
                            hintText: hint_phoneNumber,
                            hintStyle: TextStyle(
                              fontFamily: kRoboto,
                              color: kDarkColor,
                            ),
                          ),
                          initialCountryCode: 'SA',
                          onChanged: (phone) {
                            country = phone.country;
                            countryCode = phone.countryCode;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
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
                                      login();
                                    }
                                  },
                                ),
                              ),
                            )
                    ],
                  ),
                  SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget returnOTPScreen() {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var users = Provider.of<AuthProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          enterthecodetext,
                          style: TextStyle(
                            fontFamily: kAbrilFatFace,
                            fontSize: 25,
                            color: kAppColor,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          countryCode+mobilenumber.text.trim(),
                          style: TextStyle(
                              fontFamily: kRoboto,
                              fontSize: 25,
                              color: Colors.grey),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          wesentafourdigitcode,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: kRoboto,
                              fontSize: 16,
                              color: kDarkColor),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Form(
                          key: _formKeyOTP,
                          child: TextFormWidget(
                            controller: otpController,
                            type: TextInputType.number,
                            data: Icons.vpn_key_outlined,
                            hintText: hint_otp,
                            func: (value) =>
                                value.isEmpty ? otpvalidator : null,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        currentSeconds < 60
                            ? Text(requestNewOtp + timerText,
                                style: TextStyle(
                                    fontFamily: kRoboto,
                                    fontSize: 16,
                                    color: kDarkColor,
                                    fontWeight: FontWeight.bold))
                            : InkWell(
                                onTap: () {
                                  login();
                                },
                                child: RichText(
                                  text: TextSpan(
                                      style: TextStyle(fontSize: 15),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: didntgetsms,
                                          style: TextStyle(
                                              fontFamily: kRoboto,
                                              fontSize: 16,
                                              color: kDarkColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: requestnew,
                                          style: TextStyle(
                                            fontFamily: kAbrilFatFace,
                                            fontSize: 16,
                                            color: kAppColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                        SizedBox(
                          height: 20,
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
                                      if (_formKeyOTP.currentState.validate()) {
                                        setState(() {
                                          isResend = false;
                                          isLoading = true;
                                        });

                                        try {
                                          final AuthCredential credential =
                                              PhoneAuthProvider.credential(
                                                  verificationId:
                                                      verificationCode,
                                                  smsCode: otpController.text
                                                      .toString());
                                          final UserCredential user =
                                              await _auth.signInWithCredential(
                                                  credential);
                                          if (isValidUser) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            users.onStateChanged(user.user);
                                            Navigator.pushReplacementNamed(
                                                context, bottomNavbarRoute);
                                          } else {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            authService.createUser({
                                              "id": user.user.uid,
                                              "number": user.user.phoneNumber,
                                              "timeCreated": Timestamp.now(),
                                              "country": country
                                            });
                                            Navigator.pushReplacementNamed(
                                                context, setusernameRoute,arguments: "no");
                                          }
                                        } catch (e) {
                                          displaySnackBar(
                                              'Validation error, please try again later');
                                          print(e);
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      }
                                    },
                                  ),
                                ),
                              )
                      ],
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

  var textDecor = InputDecoration(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: kAppColor),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: kAppColor),
    ),
    hintText: hint_phoneNumber,
    hintStyle: TextStyle(
      fontFamily: kRoboto,
      color: kDarkColor,
    ),
    prefixIcon: IconButton(
      icon: Icon(
        Icons.call_outlined,
        size: 30,
      ),
    ),
  );

  displaySnackBar(text) {
    final snackBar = SnackBar(content: Text(text));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future login() async {
    var number = countryCode+mobilenumber.text;
    var users = Provider.of<AuthProvider>(context,listen: false);

    setState(() {
      isLoading = true;
    });

    dynamic result = await authService.checkNewUser(countryCode+mobilenumber.text.trim());

    if (result.toString() == "true" || result.toString() == "false") {
      if (result.toString() == "true") {
        isValidUser = true;
      } else {
        isValidUser = false;
      }

      var verifyPhoneNumber = _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (phoneAuthCredential) {
          //auto code complete (not manually)
          _auth.signInWithCredential(phoneAuthCredential).then((user) async => {
                if (user != null)
                  {
                    //redirect
                    setState(() {
                      isLoading = false;
                      isOTPScreen = false;
                    }),
                    if (isValidUser)
                      {
                        users.onStateChanged(user.user),
                        Navigator.pushReplacementNamed(
                            context, bottomNavbarRoute)
                      }
                    else
                      {
                        await authService.createUser({
                          "id": user.user.uid,
                          "number": user.user.phoneNumber,
                          "country": country
                        }).then((value) {
                          if (value.toString() == "success") {
                            Navigator.pushReplacementNamed(
                                context, setusernameRoute,arguments: "no");
                          } else {
                            displaySnackBar(errorOccurred);
                          }
                        }),
                      }
                  }
              });
        },
        verificationFailed: (FirebaseAuthException error) {
          displaySnackBar('Validation error, please try again later');
          setState(() {
            isLoading = false;
          });
        },
        codeSent: (verificationId, [forceResendingToken]) {
          setState(() {
            isLoading = false;
            verificationCode = verificationId;
            isOTPScreen = true;
          });
          startTimeout();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (this.mounted) {
            setState(() {
              isLoading = false;
              verificationCode = verificationId;
            });
          }
        },
        timeout: Duration(seconds: 60),
      );
      await verifyPhoneNumber;
    } else {
      displaySnackBar(errorOccurred);
    }
  }
}
