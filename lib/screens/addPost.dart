import 'package:another_flushbar/flushbar.dart';
import 'package:easy_reads/model/postArgs.dart';
import 'package:easy_reads/routes/route_names.dart';
import 'package:easy_reads/services/postService.dart';
import 'package:easy_reads/widgets/loadingBtn.dart';
import 'package:easy_reads/widgets/roundedBtn.dart';
import 'package:easy_reads/widgets/textFormWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constant.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  PostService postService = new PostService();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  showFlushBar(String message, Color clr) {
    Flushbar(
            icon: Icon(
              Icons.info_outline,
              color: clr,
            ),
            message: message,
            duration: Duration(seconds: 5),
            margin: EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(8),
            flushbarStyle: FlushbarStyle.FLOATING)
        .show(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: screenWidth,
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
              vertical: 30,
            ),
            child: Form(
              key: _formKey,
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

                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        newPostText,
                        style: TextStyle(
                          fontFamily: kAbrilFatFace,
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  PostTitleTextFormWidget(
                    controller: titleController,
                    type: TextInputType.text,
                    hintText: hint_title,
                    func: (value) => value.isEmpty ? postTitleValidator : null,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  PostBodyTextFormWidget(
                    controller: bodyController,
                    type: TextInputType.text,
                    hintText: hint_body,
                    func: (value) => value.isEmpty ? postTitleValidator : null,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  isLoading
                      ? LoadingButton()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            width: btnSize,
                            height: btnSize,
                            child: RoundedButtonWidget(
                              icons: Icons.arrow_forward_outlined,
                              bgColor: kAppColor,
                              iconColor: kBackGroundColor,
                              onPush: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  dynamic result = await postService.addNewPost(
                                      user.uid,
                                      titleController.text.trim(),
                                      bodyController.text.trim());

                                  if (result.toString() == "success") {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    PostArgs pargs = new PostArgs();
                                    pargs.msg = postadded;
                                    pargs.tab = "2";
                                    Navigator.pushReplacementNamed(
                                        context, bottomNavbarRoute,
                                        arguments: pargs);
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    showFlushBar(errorOccurred, Colors.red);
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
