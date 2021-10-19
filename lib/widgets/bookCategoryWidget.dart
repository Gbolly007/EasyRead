import 'package:easy_reads/constant.dart';
import 'package:easy_reads/routes/route_names.dart';
import 'package:easy_reads/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesTile extends StatelessWidget {
  final String title;
  final Color clr;
  final Color clr1;
  final AssetImage icn;
  final String args;
  CategoriesTile({@required this.clr, @required this.title,@required this.icn,@required this.clr1,this.args});

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<AuthProvider>(context);
    final user = Provider.of<User>(context);
    return Padding(
      padding: const EdgeInsets.only(right:8.0,left: 8.0),
      child: GestureDetector(
        onTap: () {
          if (users.userModel != null &&
              (users.userModel.name == null || users.userModel.name.isEmpty)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamedAndRemoveUntil(
                  context, setusernameRoute, (route) => false,
                  arguments: "no");
            });
          }
          else{
            Navigator.pushNamed(context, categoryListRoute,arguments: args);
          }


        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            width: 150,
            height: 170,
            margin: const EdgeInsets.only(bottom: 6.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [clr, clr1]),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ],
            ),

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageIcon(
                      icn,
                    color: Colors.white,
                    size: 35,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: kRoboto,
                      fontSize: 18,
                      color: Colors.white
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