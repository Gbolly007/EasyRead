import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_reads/model/bookDetailModel.dart';
import 'package:easy_reads/model/postArgs.dart';
import 'package:easy_reads/model/viewDetailModel.dart';
import 'package:easy_reads/routes/route_names.dart';
import 'package:easy_reads/services/auth.dart';
import 'package:easy_reads/services/authService.dart';
import 'package:easy_reads/widgets/bookList.dart';
import 'package:easy_reads/widgets/longBtn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import 'homepage.dart';

class BookDetail extends StatefulWidget {
  final BookDetailArgs data;

  BookDetail({this.data});

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  AuthService _authService = AuthService();
  int diff = 0;

  checkforPayment() async {
    final users = Provider.of<AuthProvider>(context, listen: false);
    final user = Provider.of<User>(context, listen: false);
    if (user == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, enterNumberRoute, (route) => false);
    } else {
      final Timestamp endTime = Timestamp.now();
      final Timestamp startTime = users.userModel.lastPayment;
      final DateTime endTimeDate = endTime.toDate();
      final DateTime startTimeDate = startTime.toDate();
      final Duration difference = endTimeDate.difference(startTimeDate);

      diff = int.parse(difference.inDays.toString()) ;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkforPayment();
  }



  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBackGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(

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

                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          height: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              widget.data.post["bookcover"],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.data.post["title"],
                              style: TextStyle(
                                fontFamily: kAbrilFatFace,
                                fontSize: 25,
                                color: kDarkColor,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.data.post["authorname"],
                              style: TextStyle(
                                fontFamily: kRoboto,
                                fontSize: 20,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.visibility,
                                  color: kDarkAppColor,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.data.post["numberofreads"].toString(),
                                  style: TextStyle(
                                      fontFamily: kRoboto, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),


                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    widget.data.post["desc"],
                    style: TextStyle(
                        fontFamily: kRoboto,
                        color: Colors.grey[800],
                        height: 1.5),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: InkWell(
                            onTap: () async {

                              if (diff >= 30) {
                                Navigator.pushNamed(
                                    context, paymentPageRoute,);
                              }
                              else{
                                ViewDetail viewDetail = new ViewDetail();
                                viewDetail.id = widget.data.post.id;
                                viewDetail.bookAuthor = widget.data.post["authorname"];
                                viewDetail.bookCover = widget.data.post["bookcover"];
                                viewDetail.bookName = widget.data.post["title"];
                                viewDetail.url =widget.data.post["bookPdf"];

                                Navigator.pushNamed(context, viewPdfRoute,arguments: viewDetail);
                              }


                            },
                            child: BtnWidget(
                              screenWidth: screenWidth,
                              txt: widget.data.isRecentlyRead? continueReading : readBooktext,
                            ),
                          ),
                        ),
                      ),
                     widget.data.isRecentlyRead? Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: InkWell(
                            onTap: () async {
                              showAlertDialog(context,user.uid,widget.data.post.id);
                            },
                            child: DelBtnWidget(
                              screenWidth: screenWidth,
                              txt: delRecenttext,
                            ),
                          ),
                        ),
                      ):Container(),
                    ],
                  ),

                  SizedBox(
                    height: 15,
                  ),
                  Divider(
                    color: kDarkColor,
                  ),

                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Recommended books in this category",
                    style: TextStyle(
                        fontFamily: kRoboto,
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RecommendBookList(bookId: widget.data.post.id),

                ],
              ),
            ),
          ),
        ),
      ),
    );


  }

  showAlertDialog(BuildContext context,String uid,String bookId) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed:  () async{

        dynamic result = await _authService.deleteRecentlyRead(
          bookId, uid
            );

        if (result.toString() == "0") {

          PostArgs pargs = new PostArgs();
          pargs.msg = bookdeleted;
          pargs.tab = "1";
          Navigator.pushReplacementNamed(
              context, bottomNavbarRoute,
              arguments: pargs);
        } else {

          Flushbar(
              icon: Icon(
                Icons.info_outline,
                color: Colors.red,
              ),
              message: errorOccurred,
              duration: Duration(seconds: 5),
              margin: EdgeInsets.all(8),
              borderRadius:
              BorderRadius.circular(8),
              flushbarStyle:
              FlushbarStyle.FLOATING)
              .show(context);
        }



      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(deleteText),
      content: Text(proceedwithdeleting),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
