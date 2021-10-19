import 'package:easy_reads/constant.dart';
import 'package:easy_reads/routes/route_names.dart';
import 'package:easy_reads/widgets/roundedBtn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: kBackGroundColor,
      body: SafeArea(
        child: Column(

          children: <Widget>[
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Image.asset(
                  konboardImg,
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      onboardText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          height: 1.5,
                          fontFamily: kAbrilFatFace,
                          color: kDarkColor,),
                    ),
                  ),
                ],
              ),
            ),
        Padding(
          padding: const EdgeInsets.only(bottom:15.0),
          child: Container(
            width: btnSize,
            height: btnSize,
            child: RoundedButtonWidget(
              icons: Icons.arrow_forward,
              bgColor: kAppColor,
              iconColor: kBackGroundColor,
              onPush: () async {
                if(user!=null){
                  Navigator.pushReplacementNamed(context, homeScreenRoute);
                }
                else{
                  Navigator.pushReplacementNamed(context, enterNumberRoute);
                }

              },
            ),
          ),
        )


          ],
        ),
      ),
    );
  }
}
