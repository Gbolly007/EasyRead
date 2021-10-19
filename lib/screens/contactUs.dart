import 'package:flutter/material.dart';

import '../constant.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
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
                    height: 15,
                  ),
                  Text(
                    contactUsHeader,
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
                    contactUsSubHeader,
                    style: TextStyle(
                      fontFamily: kRoboto,
                      fontSize: 16,
                      height: 1.5,
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
