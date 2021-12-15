import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/CustomRadioWidget.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/models/xml_json.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class IntroScreens extends StatefulWidget {
  @override
  _LoginWithLogoState createState() => _LoginWithLogoState();
}

class _LoginWithLogoState extends State<IntroScreens>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final chapterController = TextEditingController();

  bool showDrop = false;
  bool _loading = false;
  bool _isHidden = true;
  bool isEnabled1 = true;

  bool isEnabled2 = false;

  Future _quiz;
  String chapter_id = "";
  String chapter_name = "";
  String type = "";
  String user_id = "";
  String class_id = "";
  String board_id = "";

  String test_id = "";

  var answerId;
  bool lastAns = false;
  bool done = false;

  List<XMLJSON> xmlList = new List();

  bool full_show = false;

  @override
  void initState() {
    super.initState();
  }

  TextStyle normalText1 = GoogleFonts.inter(
    fontSize: 35,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  );

  TextStyle normalText2 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w300,
    color: Colors.white,
  );
  TextStyle normalText3 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  TextStyle next = GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
      letterSpacing: 1);

  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    var getScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color(0xff2E2A4A),
        body:  Container(
            child: CarouselSlider.builder(
                carouselController: buttonCarouselController,
                options: CarouselOptions(
                  height: getScreenHeight,
                  initialPage: 0,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  //  aspectRatio: 1,
                  scrollPhysics: NeverScrollableScrollPhysics(),
                  reverse: false,
                  // autoPlay: false,
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal,
                ),
                itemCount: 4,
                itemBuilder: (BuildContext context, int itemIndex) {
                  if(itemIndex==0) {
                    return SingleChildScrollView(
                      child: Container(
                          padding: EdgeInsets.all(30),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(top: 50),
                                    child: Image.asset(
                                      'assets/images/into_1.png',
                                      width: 180,
                                      height: 180,
                                    ),
                                  ),
                                  const SizedBox(height: 25.0),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text("Practice", style: normalText1),
                                  ),
                                  const SizedBox(height: 15.0),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        "Our experienced teachers and academicians have curated 1000s of questions for your practice.",
                                        style: normalText2),
                                  ),
                                  const SizedBox(height: 15.0),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text("\u2022 MCQs", style: normalText3),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        "\u2022 Assertion & Reasoning Questions",
                                        style: normalText3),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        "\u2022 Case Study based Questions  ",
                                        style: normalText3),
                                  ),
                          
                                ]),
                                const SizedBox(height: 30.0),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  margin: const EdgeInsets.only(
                                      right: 8.0, left: 8, bottom: 20),
                                  child: ButtonTheme(
                                    height: 28.0,
                                    minWidth:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.80,
                                    child: RaisedButton(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 50),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0)),
                                      textColor: Colors.white,
                                      color: Color(0xff017EFF),
                                      onPressed: () async {

                                        onNextClick();
                                      },
                                      child: Text("Next", style: next),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30.0),
                              ])),
                    );
                  }
                  else if(itemIndex==1) {
                    return SingleChildScrollView(
                      child: Container(
                          padding: EdgeInsets.all(30),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(top: 50),
                                    child: Image.asset(
                                      'assets/images/intro_2.png',
                                      width: 180,
                                      height: 180,
                                    ),
                                  ),
                                  const SizedBox(height: 25.0),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text("Assess your Performance", style: normalText1),
                                  ),
                                  const SizedBox(height: 15.0),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        "Interactive dashboards with real-time insights, the platform will ensure that you overcome your weaknesses with focussed practice.",
                                        style: normalText2),
                                  ),
                                  const SizedBox(height: 15.0),

                                ]),
                                const SizedBox(height: 30.0),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  margin: const EdgeInsets.only(
                                      right: 8.0, left: 8, bottom: 20),
                                  child: ButtonTheme(
                                    height: 28.0,
                                    minWidth:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.80,
                                    child: RaisedButton(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 50),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0)),
                                      textColor: Colors.white,
                                      color: Color(0xff017EFF),
                                      onPressed: () async {
                                        onNextClick();
                                      },
                                      child: Text("Next", style: next),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30.0),
                              ])),
                    );
                  }
                  else if(itemIndex==2 ) {
                    return SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(30),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(top: 50),
                                    child: Image.asset(
                                      'assets/images/intro_3.png',
                                      width: 180,
                                      height: 180,
                                    ),
                                  ),
                                  const SizedBox(height: 25.0),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text("Ask your Doubts", style: normalText1),
                                  ),
                                  const SizedBox(height: 15.0),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        "Clear your doubts from highly experienced subject matter experts through chat."
                                        ,
                                        style: normalText2),
                                  ),
                                  const SizedBox(height: 15.0),

                                ]),
                                const SizedBox(height: 30.0),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  margin: const EdgeInsets.only(
                                      right: 8.0, left: 8, bottom: 20),
                                  child: ButtonTheme(
                                    height: 28.0,
                                    minWidth:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.80,
                                    child: RaisedButton(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 50),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0)),
                                      textColor: Colors.white,
                                      color: Color(0xff017EFF),
                                      onPressed: () async {
                                        onNextClick();
                                      },
                                      child: Text("Next", style: next),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30.0),
                              ])),
                      );
                  }
                  else{
                    return SingleChildScrollView(
                      child: Container(
                          padding: EdgeInsets.all(30),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(top: 50),
                                    child: Image.asset(
                                      'assets/images/intro_4.png',
                                      width: 180,
                                      height: 180,
                                    ),
                                  ),
                                  const SizedBox(height: 25.0),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text("Now you are all set to begin.", style: normalText1),
                                  ),
                                  const SizedBox(height: 15.0),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        "Practice Accountancy on the go!!",
                                        style: normalText2),
                                  ),
                                  const SizedBox(height: 15.0),

                                ]),
                                const SizedBox(height: 30.0),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  margin: const EdgeInsets.only(
                                      right: 8.0, left: 8, bottom: 20),
                                  child: ButtonTheme(
                                    height: 28.0,
                                    minWidth:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.80,
                                    child: RaisedButton(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 50),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0)),
                                      textColor: Colors.white,
                                      color: Color(0xff017EFF),
                                      onPressed: () async {
                                        SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                        prefs.setBool('intro_in', true);
                                        Navigator.pushNamed(context, '/login-with-logo');
                                      },
                                      child: Text("Get Started", style: next),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30.0),
                              ])),
                    );
                  }
                }),
          ),
        );
  }

  onNextClick() {
    buttonCarouselController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }
}
