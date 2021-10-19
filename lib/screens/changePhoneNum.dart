import 'dart:async';
import 'package:easy_reads/routes/route_names.dart';
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

class ChangePhoneNumber extends StatefulWidget {
  @override
  _ChangePhoneNumberState createState() => _ChangePhoneNumberState();
}

class _ChangePhoneNumberState extends State<ChangePhoneNumber> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController mobilenumber = TextEditingController();
  final _formKeyOTP = GlobalKey<FormState>();
  var isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController otpController = new TextEditingController();

  AuthService authService = new AuthService();
  String verificationCode = '';
  var isOTPScreen = false;
  var isResend = false;
  String country = "";
  String countryCode = "";

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
    return isOTPScreen ? enterOtpScreen() : newPhoneScreen();
  }

  Widget newPhoneScreen() {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final user = Provider.of<User>(context);
    return Scaffold(
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
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        replaceNumberText,
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
                        replacenumbersubtext,
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
                                      login(user.uid);
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

  Widget enterOtpScreen() {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final user = Provider.of<User>(context);
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
                                  login(user.uid);
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

                                          await _auth.currentUser
                                              .updatePhoneNumber(credential)
                                              .then((value) {
                                            authService.updateUser({
                                              "id": user.uid,
                                              "number":
                                              countryCode+mobilenumber.text.trim(),
                                              "country": country
                                            }).then((value) {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              print(value.toString());

                                              if (value.toString() ==
                                                  "success") {
                                                Navigator.pushReplacementNamed(
                                                    context, settingsRoute);
                                              } else {
                                                displaySnackBar(errorOccurred);
                                              }
                                            });
                                          });
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

  displaySnackBar(text) {
    final snackBar = SnackBar(content: Text(text));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future login(String uid) async {
    var number = countryCode+mobilenumber.text.trim();

    setState(() {
      isLoading = true;
    });

    var verifyPhoneNumber = _auth.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (phoneAuthCredential) async {
        //auto code complete (not manually)
        await _auth.currentUser
            .updatePhoneNumber(phoneAuthCredential)
            .then((value) async {
          await authService.updateUser({
            "id": uid,
            "number": countryCode+mobilenumber.text.trim(),
            "country": country
          }).then((value) {
            if (value.toString() == "success") {
              Navigator.pushReplacementNamed(
                  context, settingsRoute);
            } else {
              displaySnackBar(errorOccurred);
            }
          });
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
  }
}
