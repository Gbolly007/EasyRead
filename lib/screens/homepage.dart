import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_reads/constant.dart';
import 'package:easy_reads/data/categoryData.dart';
import 'package:easy_reads/model/bookCategory.dart';
import 'package:easy_reads/model/bookDetailModel.dart';
import 'package:easy_reads/routes/route_names.dart';
import 'package:easy_reads/services/auth.dart';
import 'package:easy_reads/services/authService.dart';
import 'package:easy_reads/widgets/bookCategoryWidget.dart';
import 'package:easy_reads/widgets/topBooks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = new TextEditingController();
  AuthService authService = new AuthService();
  List<BookCategories> categories = [];

  var queryResultSet = [];
  var tempSearchStore = [];
  var capitalizedValue;

  String number = "";

  String uniquecode = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categories = getCategories();

  }

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

      if (difference.inDays >= 30) {
        Timestamp tmp = await authService.getPaid(user.uid);
        final Timestamp endTime = Timestamp.now();
        final Timestamp startTime = tmp;
        final DateTime endTimeDate = endTime.toDate();
        final DateTime startTimeDate = startTime.toDate();
        final Duration ddifference = endTimeDate.difference(startTimeDate);
        print(ddifference.inDays.toString());
        if (ddifference.inDays >= 30) {
          Navigator.pushNamedAndRemoveUntil(
              context, paymentPageRoute, (route) => false);
        }
      }
    }
  }

  navigateToDetailPage(DocumentSnapshot post) {
    BookDetailArgs bookDetailArgs = new BookDetailArgs();
    bookDetailArgs.post = post;
    bookDetailArgs.isRecentlyRead = false;
    Navigator.pushNamed(context, bookDetailRoute, arguments: bookDetailArgs);
  }

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<AuthProvider>(context);
    final user = Provider.of<User>(context);
    String username = users.userModel != null && users.userModel.name != null  ? users.userModel.name : "";

    return Scaffold(
      backgroundColor: kBackGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Hi " + username,
                        style: TextStyle(
                            fontFamily: kRoboto,
                            fontSize: 25,
                            color: kDarkColor),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, settingsRoute);
                        },
                        child: Icon(
                          Icons.settings,
                          color: kDarkColor,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    welcometext,
                    style: TextStyle(
                      fontFamily: kAbrilFatFace,
                      fontSize: 25,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      showAlertDialog(context);
                    },
                    child: Card(
                      elevation: 5,
                      color: kBackGroundColor,
                      child: Container(
                        decoration: BoxDecoration(
                          color: kBackGroundColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                searchbook,
                                style: TextStyle(fontFamily: kRoboto),
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                child: Icon(Icons.search, color: kDarkAppColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  BooksHeadingText(
                    txt: category,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    browsecategory,
                    style: TextStyle(fontFamily: kRoboto, fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 170,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return CategoriesTile(
                          clr: categories[index].clr,
                          clr1: categories[index].clr1,
                          title: categories[index].categoryTitle,
                          icn: categories[index].icn,
                          args: categories[index].args,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      BooksHeadingText(
                        txt: newbooks,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        newbooksadded,
                        style: TextStyle(fontFamily: kRoboto, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TopBookList()
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(searchby),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.40,
        height: MediaQuery.of(context).size.height * 0.10,
        child: ListView(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                Navigator.pushNamed(context, searchScreenRoute,
                    arguments: "Author");
              },
              child: Text(
                author,
                style: TextStyle(fontFamily: kRoboto),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                Navigator.pushNamed(context, searchScreenRoute,
                    arguments: "Books");
              },
              child: Text(
                books,
                style: TextStyle(fontFamily: kRoboto),
              ),
            ),
          ],
        ),
      ),
      actions: [
        cancelButton,
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

class BooksHeadingText extends StatelessWidget {
  final String txt;

  const BooksHeadingText({Key key, this.txt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
        fontFamily: kAbrilFatFace,
        fontSize: 20,
        color: kDarkColor,
      ),
    );
  }
}
