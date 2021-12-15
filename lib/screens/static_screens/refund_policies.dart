import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:webview_flutter/webview_flutter.dart';





class Refund extends StatefulWidget {


  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<Refund> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  num position = 1;
  final key = UniqueKey();
  var _userId;
  Future<dynamic> _contest;
  @override
  void initState() {
    super.initState();
  }



  doneLoading(String value) {
    setState(() {
      position = 0;
    });
  }

  startLoading(String value) {
    setState(() {
      position = 1;
    });
  }


  Widget htmlList(Size deviceSize) {
    return IndexedStack(
      index: position,
      children: <Widget>[
        Container(

          child: WebView(
            initialUrl:"https://www.grewaleducation.com/return-refund.php",
            javascriptMode: JavascriptMode.unrestricted,
            key: key,
            onPageFinished: doneLoading,
            onPageStarted: startLoading,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
          ),
        ),
        Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar:  AppBar(
          elevation: 0.0,
          leading: InkWell(
            child: Row(children: <Widget>[
              IconButton(
                icon: Image(
                  image: AssetImage("assets/images/Icon.png"),
                  height: 20.0,
                  width: 10.0,
                  color: Color(0xff2E2A4A),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ]),
          ),
          centerTitle: true,
          title: Container(
            child: Text("Refund Policy", style: normalText6),
          ),
          flexibleSpace: Container(
            height: 100,
            color: Color(0xffffffff),
          ),
          actions: <Widget>[
            /* Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: _networkImage1(
                  profile_image,
                ),
              ),
            ),*/
          ],
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Colors.transparent,
        ),
        body: htmlList( deviceSize)
    );
  }
}




