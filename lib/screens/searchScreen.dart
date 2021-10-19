import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_reads/model/bookDetailModel.dart';
import 'package:easy_reads/routes/route_names.dart';
import 'package:easy_reads/services/searchService.dart';
import 'package:easy_reads/widgets/noContentList.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class SearchScreen extends StatefulWidget {
  final String searchType;
  SearchScreen({this.searchType});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  var queryResultSet = [];
  var tempSearchStore = [];
  var capitalizedValue;
  TextEditingController searchController = new TextEditingController();

  navigateToDetailPage(DocumentSnapshot post) {
    BookDetailArgs bookDetailArgs = new BookDetailArgs();
    bookDetailArgs.post = post;
    bookDetailArgs.isRecentlyRead = false;
    Navigator.pushNamed(context, bookDetailRoute, arguments: bookDetailArgs);
  }

  initiateSearchVal(String value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    if (value.isNotEmpty) {
      capitalizedValue =
          value.substring(0, 1).toUpperCase() + value.substring(1);
    }

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value, widget.searchType).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
          setState(() {
            tempSearchStore.add(queryResultSet[i]);
          });
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element["title"].toLowerCase().contains(value.toLowerCase()) ==
            true) {
          if (element["title"].toLowerCase().indexOf(value.toLowerCase()) ==
              0) {
            setState(() {
              tempSearchStore.add(element);
            });
          }
        }
      });
    }
    if (tempSearchStore.length == 0 && value.length > 1) {
      setState(() {});
    }
  }


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
                  Card(
                    elevation: 5,
                    color: kBackGroundColor,
                    child: Container(
                      decoration: BoxDecoration(
                        color: kBackGroundColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              onChanged: (val) {
                                initiateSearchVal(val);
                              },
                              controller: searchController,
                              decoration: InputDecoration(
                                  hintText: widget.searchType=="Author"? searchAuthor:searchbook,
                                  hintStyle: TextStyle(fontFamily: kRoboto),
                                  border: InputBorder.none),
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
                  SizedBox(
                    height: 20,
                  ),
                  queryResultSet.length > 0
                      ? GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 2.0,
                    primary: false,
                    shrinkWrap: true,
                    childAspectRatio: 0.7,
                    padding: EdgeInsets.only(left: 5.0, right: 5),
                    children: tempSearchStore.map((e) {
                      return buildResultCard(e);
                    }).toList(),
                  )
                      : Flexible(child: NoListContent(txt: nosearch,)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget buildResultCard(data) {
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        dismissable: false,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () async {
                progressDialog.show();
                DocumentSnapshot doc = await FirebaseFirestore.instance
                    .collection("books")
                    .doc(data["id"])
                    .get();
                progressDialog.dismiss();
                navigateToDetailPage(doc);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  data["bookcover"],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            data["title"].length > 15
                ? data["title"].substring(0, 15) + "..."
                : data["title"],
            style: TextStyle(
                color: kDarkColor,
                fontFamily: kRoboto,
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            data["authorname"].length > 15
                ? "By " + data["authorname"].substring(0, 15) + "..."
                : "By " + data["authorname"],
            style:
            TextStyle(color: kDarkColor, fontFamily: kRoboto, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
