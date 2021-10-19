import 'dart:async';
import 'package:another_flushbar/flushbar.dart';
import 'package:easy_reads/constant.dart';
import 'package:easy_reads/model/viewDetailModel.dart';
import 'package:easy_reads/services/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdf extends StatefulWidget {
  final ViewDetail data;

  ViewPdf({this.data});

  @override
  _ViewPdfState createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  AuthService authService = AuthService();

  Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeTimer();
  }

  void _initializeTimer() {
    final user = Provider.of<User>(context, listen: false);
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      authService.favoriteBook(user.uid, widget.data.id, widget.data.bookName,
          widget.data.bookCover, widget.data.bookAuthor);
      _timer.cancel();
    });
  }

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void dispose() {
    // TODO: implement dispose
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  showFlushBar(String message, Color clr){
    Flushbar(
        icon: Icon(
          Icons.info_outline,
          color: clr,
        ),
        message: message,
        duration: Duration(seconds: 5),
        margin: EdgeInsets.all(8),
        borderRadius:
        BorderRadius.circular(8),
        flushbarStyle:
        FlushbarStyle.FLOATING)
        .show(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.favorite_border),
          backgroundColor: kDarkAppColor,
          onPressed: ()async{
             dynamic res= await authService.favoriteBook(user.uid, widget.data.id, widget.data.bookName,
                widget.data.bookCover, widget.data.bookAuthor);

             if(res.toString()=="success"){
               showFlushBar(bookhasbeenadded, Colors.blue);
             }
             else{
               showFlushBar(errorOccurred, Colors.red);
             }
          }
      ),

      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),

      ),
      body: SafeArea(

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SfPdfViewer.network(
              widget.data.url,
            key: _pdfViewerKey,
            enableTextSelection: false,
          ),
        ),
      ),
    );
  }
}
