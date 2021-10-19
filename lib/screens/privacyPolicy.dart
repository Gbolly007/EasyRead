import 'package:easy_reads/widgets/textWid.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class PrivacyPolicy extends StatelessWidget {
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
                  privacyPolicy,
                  style: TextStyle(
                    fontFamily: kAbrilFatFace,
                    color: kAppColor,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextBodyWidget(
                  txt: ppFirstText,
                ),
                SizedBox(
                  height: 10,
                ),
                HeadingTextWidget(
                  txt: ppFirstTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: ppSecondText,
                ),
                SizedBox(
                  height: 5,
                ),
                SubTextBodyWidget(
                  txt: ppSecondTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: ppThirdText,
                ),
                SizedBox(
                  height: 5,
                ),
                SubTextBodyWidget(
                  txt: ppThirdTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: ppFourthText,
                ),
                SizedBox(
                  height: 5,
                ),
                SubTextBodyWidget(
                  txt: ppFourthTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: ppFifthText,
                ),
                SizedBox(
                  height: 5,
                ),
                SubTextBodyWidget(
                  txt: ppFifthTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: ppSixthText,
                ),
                SizedBox(
                  height: 10,
                ),
                SubTextBodyWidget(
                  txt: ppSixthTextHeading,
                ),

                SizedBox(
                  height: 10,
                ),
                HeadingTextWidget(
                  txt: ppSeventhTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: ppSeventhText,
                ),
                SizedBox(
                  height: 10,
                ),
                HeadingTextWidget(
                  txt: ppEigthTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: ppEighthText,
                ),
                SizedBox(
                  height: 10,
                ),
                HeadingTextWidget(
                  txt: ppNinthTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: ppNinthText,
                ),
                SizedBox(
                  height: 10,
                ),
                HeadingTextWidget(
                  txt: ppTenthTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: ppTenthText,
                ),

                SizedBox(
                  height: 10,
                ),
                HeadingTextWidget(
                  txt: ppEleventhTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: ppEleventhText,
                ),
                SizedBox(
                  height: 10,
                ),
                HeadingTextWidget(
                  txt: ppTwelveTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: ppTwelveText,
                ),
                SizedBox(
                  height: 10,
                ),
                HeadingTextWidget(
                  txt: ppThirteenTextHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                TextBodyWidget(
                  txt: ppThirteenText,
                ),
              ],
            ),
          ),
        ),
      ),


    );
  }
}
