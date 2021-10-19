import 'package:easy_reads/constant.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBackGroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: screenWidth,
            height: screenHeight,
            child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
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
                          height: 30,
                        ),
                        Text(
                          "+234-955-5446-500",
                          style: TextStyle(
                              fontFamily: kRoboto,
                              fontSize: 25,
                            color: Colors.grey
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                            wesentafourdigitcode,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: kRoboto,
                              fontSize: 16,
                              color: kDarkColor
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        RichText(

                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 15
                            ),
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
                            ]
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
}
