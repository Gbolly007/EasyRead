import 'package:easy_reads/widgets/textWid.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class TermsCondition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBackGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_outlined,
                    size: 25,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  tandc,
                  style: TextStyle(
                    fontFamily: kAbrilFatFace,
                    color: kAppColor,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                HeadingTextWidget(
                  txt: tcfirstTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: tcfirstText,
                ),
                SizedBox(
                  height: 10,
                ),
                HeadingTextWidget(
                  txt: tcSecondTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: tcSecondText,
                ),
                SizedBox(
                  height: 10,
                ),
                HeadingTextWidget(
                  txt: tcThirdTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: tcThirdText,
                ),
                SizedBox(
                  height: 10,
                ),
                HeadingTextWidget(
                  txt: tcFourthTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: tcFourthText,
                ),
                SizedBox(
                  height: 10,
                ),
                HeadingTextWidget(
                  txt: tcFifthTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: tcFifthText,
                ),
                SizedBox(
                  height: 10,
                ),
                HeadingTextWidget(
                  txt: tcSixthTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: tcSixthText,
                ),
                SizedBox(
                  height: 10,
                ),
                HeadingTextWidget(
                  txt: tcSeventhTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: tcSeventhText,
                ),
                SizedBox(
                  height: 10,
                ),
                HeadingTextWidget(
                  txt: tcEigthTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: tcEigthText,
                ),
                SizedBox(
                  height: 10,
                ),
                HeadingTextWidget(
                  txt: tcNinthTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: tcNinthText,
                ),
                SizedBox(
                  height: 10,
                ),
                HeadingTextWidget(
                  txt: tcTenthTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: tcTenthText,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: tcEleventhText,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: tcTwelveText,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: tcThirteenthText,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: tcFourteenthText,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: tcFifteenthText,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: tcSixteenthText,
                ),
                SizedBox(
                  height: 15,
                ),
                TextBodyWidget(
                  txt: tcSeventeenthText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



