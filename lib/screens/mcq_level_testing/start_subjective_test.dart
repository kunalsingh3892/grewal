// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/CustomRadioWidget.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/models/xml_json.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class StartSubjective extends StatefulWidget {
  final Object argument;

  const StartSubjective({Key key, this.argument}) : super(key: key);

  @override
  _LoginWithLogoState createState() => _LoginWithLogoState();
}

class _LoginWithLogoState extends State<StartSubjective>
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
  String set_id = "";
  bool re_attempt = false;
  var answerId;
  bool lastAns = false;
  bool done = false;

  List<XMLJSON> xmlList = new List();

  bool full_show = false;
  String testQuestionId = "";
  String totalQuestions = "";
  List<bool> previousClicked;
  List<bool> optionsClicked;
  Map finalMap = {};
  @override
  void initState() {
    super.initState();

    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    print(data.toString() + "  2nd");

    test_id = data['Response']['testId'].toString();

    finalMap["TestQuestionId"] = data['Response']['TestQuestionId'].toString();
    finalMap["test_id"] = data['Response']['testId'].toString();

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {});
      });
    _getUser();
  }

  ScrollController _scrollController;
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: Color(0xff2E2A4A),
      letterSpacing: 1);
  String api_token = "";
  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        user_id = prefs.getString('user_id').toString();
        class_id = prefs.getString('class_id').toString();
        board_id = prefs.getString('board_id').toString();
        api_token = prefs.getString('api_token').toString();
        _getTime();
        _quiz = _getTestData();
        _controller.start();
        _controller1.start();
      });
    });
  }

  Future _getTestData() async {
    var response = await http.post(
        new Uri.https(BASE_URL, API_PATH + "/subjective-test-start"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + api_token.toString(),
        },
        body: {
          "test_id": test_id.toString(),
          "student_id": user_id.toString()
        });
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      setState(() {
        totalQuestions = data['Response'].length.toString();
      });

      arr = new List(int.parse(totalQuestions));
      optionsClicked = new List(int.parse(totalQuestions));
      previousClicked = new List(int.parse(totalQuestions));

      for (int i = 0; i < int.parse(totalQuestions); i++) {
        setState(() {
          optionsClicked[i] = false;
          previousClicked[i] = false;
        });
      }

      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  var currentTime;

  void _getTime() {
    setState(() {
      currentTime = DateTime.now();
      print(currentTime);
    });
  }

  int id = 0;
  List<int> arr;
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));

  TextStyle normalText4 = GoogleFonts.montserrat(
      fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xff2E2A4A));

  TextStyle normalText3 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));

  Widget _radioBuilderMCQ(response, int index) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 16),
        child: Column(children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            CustomRadioWidget(
              value: 1,
              groupValue: arr[index],
              color: Color(0xffF9F9FB),
              groupName: response[0]['option_name'],
              onChanged: (val) {
                selectedRadio(val, index);
              },
            ),
          ]),
          SizedBox(
            height: 6,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            CustomRadioWidget(
              value: 2,
              groupValue: arr[index],
              color: Color(0xffF9F9FB),
              groupName: response[1]['option_name'],
              onChanged: (val) {
                selectedRadio(val, index);
              },
            ),
          ]),
          SizedBox(
            height: 6,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            CustomRadioWidget(
              value: 3,
              groupValue: arr[index],
              color: Color(0xffF9F9FB),
              groupName: response[2]['option_name'],
              onChanged: (val) {
                selectedRadio(val, index);
              },
            ),
          ]),
          SizedBox(
            height: 6,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            CustomRadioWidget(
              value: 4,
              groupValue: arr[index],
              color: Color(0xffF9F9FB),
              groupName: response[3]['option_name'],
              onChanged: (val) {
                selectedRadio(val, index);
              },
            ),
          ]),
        ]));
  }

  /* Widget _radioBuilderTRUE(response, int index) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 16),
        child: Column(children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            CustomRadioWidget(
              value: 1,
              groupValue: arr[index],
              color: Color(0xffF9F9FB),
              groupName: response[0]['option_name'],
              onChanged: (val) {
                selectedRadio(val, index);
              },
            ),
          ]),
          SizedBox(
            height: 6,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            CustomRadioWidget(
              value: 2,
              groupValue: arr[index],
              color: Color(0xffF9F9FB),
              groupName: response[1]['option_name'],
              onChanged: (val) {
                selectedRadio(val, index);
              },
            ),
          ]),
        ]));
  }*/

  selectedRadio(int val, int ind) {
    setState(() {
      optionsClicked[ind] = true;
      arr[ind] = val;
    });
  }

  CarouselController buttonCarouselController = CarouselController();

  Widget ansBuilder(response, int itemIndex) {
    return _radioBuilderMCQ(response[itemIndex]['question_option'], itemIndex);
  }

  void timerValueChangeListener(Duration timeElapsed) {
    print(timeElapsed);
  }

  void handleTimerOnStart() {
    print("timer has just started");
  }

  void handleTimerOnEnd() {
    print("timer has ended");
  }

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(seconds: 3), curve: Curves.linear);
  }

  Widget _customContent() {
    return FutureBuilder(
      future: _quiz,
      builder: (context, snapshot) {
        var getScreenHeight = MediaQuery.of(context).size.height;
        if (snapshot.connectionState == ConnectionState.done) {
          var errorCode = snapshot.data['ErrorCode'];
          var response = snapshot.data['Response'];

          if (errorCode == 0) {
            return response.length != 0
                ? Container(
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
                        itemCount: response.length,
                        itemBuilder: (BuildContext context, int itemIndex) {
                          return ListView(primary: false, children: <Widget>[
                            Container(
                                child: Column(children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 0, right: 10),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    child: CircularCountDownTimer(
                                      // Countdown duration in Seconds.
                                      duration: _duration1,

                                      // Countdown initial elapsed Duration in Seconds.
                                      initialDuration: 0,

                                      // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
                                      controller: _controller1,

                                      // Width of the Countdown Widget.
                                      width: 0,

                                      // Height of the Countdown Widget.
                                      height: 0,

                                      // Ring Color for Countdown Widget.
                                      ringColor: Colors.white,

                                      // Ring Gradient for Countdown Widget.
                                      ringGradient: null,

                                      // Filling Color for Countdown Widget.
                                      fillColor: Color(0xff017EFF),

                                      // Filling Gradient for Countdown Widget.
                                      fillGradient: null,

                                      // Background Color for Countdown Widget.
                                      backgroundColor: Colors.white,

                                      // Background Gradient for Countdown Widget.
                                      backgroundGradient: null,

                                      // Border Thickness of the Countdown Ring.
                                      strokeWidth: 5.0,

                                      // Begin and end contours with a flat edge and no extension.
                                      strokeCap: StrokeCap.butt,

                                      // Text Style for Countdown Text.
                                      textStyle: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),

                                      // Format for the Countdown Text.
                                      textFormat: CountdownTextFormat.S,

                                      // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
                                      isReverse: false,

                                      // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
                                      isReverseAnimation: false,

                                      // Handles visibility of the Countdown Text.
                                      isTimerTextShown: true,

                                      // Handles the timer start.
                                      autoStart: true,

                                      // This Callback will execute when the Countdown Starts.
                                      onStart: () {},

                                      // This Callback will execute when the Countdown Ends.
                                      onComplete: () {
                                        // Here, do whatever you want
                                        print('Countdown Ended');
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              // response[itemIndex]['type'] == "Case Study"
                              //     ?
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text("Case Based MCQ" + ': ',
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white)),
                                        ),
                                      ]),
                                ),
                              ),
                              //     : Container(),
                              SizedBox(
                                height: 12,
                              ),

                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  color: Color(0xffF9F9FB),
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 10, bottom: 10),
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        // response[itemIndex]
                                        //             ['comprahensive_paragraph ']
                                        //         .contains("<")
                                        //     ? Flexible(
                                        //         child: Html(
                                        //           data: response[itemIndex][
                                        //               'comprahensive_paragraph '],
                                        //           style: {
                                        //             "table": Style(
                                        //               backgroundColor:
                                        //                   Color.fromARGB(0x50,
                                        //                       0xee, 0xee, 0xee),
                                        //             ),
                                        //             "tr": Style(
                                        //               border: Border(
                                        //                 bottom: BorderSide(
                                        //                     color:
                                        //                         Colors.black),
                                        //                 top: BorderSide(
                                        //                     color:
                                        //                         Colors.black),
                                        //                 right: BorderSide(
                                        //                     color:
                                        //                         Colors.black),
                                        //                 left: BorderSide(
                                        //                     color:
                                        //                         Colors.black),
                                        //               ),
                                        //             ),
                                        //             "th": Style(
                                        //               padding:
                                        //                   EdgeInsets.all(6),
                                        //               backgroundColor:
                                        //                   Colors.grey,
                                        //             ),
                                        //             "td": Style(
                                        //               padding:
                                        //                   EdgeInsets.all(6),
                                        //               alignment:
                                        //                   Alignment.topLeft,
                                        //             ),
                                        //             'h5': Style(
                                        //                 maxLines: 2,
                                        //                 textOverflow:
                                        //                     TextOverflow
                                        //                         .ellipsis),
                                        //           },
                                        //         ),
                                        //       )
                                        // :
                                        Flexible(
                                          child: Text(
                                            response[itemIndex]
                                                    ['comprahensive_paragraph ']
                                                .toString()
                                                .replaceAll("<p>", "")
                                                .replaceAll("</p>", "")
                                                .replaceAll("&nbsp;", "")
                                                .replaceAll("&#39;", "\'"),
                                            textAlign: TextAlign.justify,
                                            maxLines: 100,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                        /*  Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Color(0xff017EFF),
                                                  size: 24,
                                                )*/
                                      ]),
                                ),
                              ),
                              // InkWell(
                              //   onTap: () {
                              //     setState(() {
                              //       full_show = !full_show;
                              //     });
                              //   },
                              //   child: Align(
                              //     alignment: Alignment.topLeft,
                              //     child: Container(
                              //       color: Color(0xffF9F9FB),
                              //       padding: EdgeInsets.only(
                              //           left: 15,
                              //           right: 15,
                              //           top: 10,
                              //           bottom: 10),
                              //       margin:
                              //           EdgeInsets.only(left: 10, right: 10),
                              //       child: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.start,
                              //           crossAxisAlignment:
                              //               CrossAxisAlignment.start,
                              //           children: <Widget>[
                              //             full_show
                              //                 ? response[itemIndex][
                              //                             'comprahensive_paragraph ']
                              //                         .contains("<")
                              //                     ? Flexible(
                              //                         child: Html(
                              //                           data: response[
                              //                                   itemIndex][
                              //                               'comprahensive_paragraph '],
                              //                           style: {
                              //                             "table": Style(
                              //                               backgroundColor:
                              //                                   Color.fromARGB(
                              //                                       0x50,
                              //                                       0xee,
                              //                                       0xee,
                              //                                       0xee),
                              //                             ),
                              //                             "tr": Style(
                              //                               border: Border(
                              //                                 bottom: BorderSide(
                              //                                     color: Colors
                              //                                         .black),
                              //                                 top: BorderSide(
                              //                                     color: Colors
                              //                                         .black),
                              //                                 right: BorderSide(
                              //                                     color: Colors
                              //                                         .black),
                              //                                 left: BorderSide(
                              //                                     color: Colors
                              //                                         .black),
                              //                               ),
                              //                             ),
                              //                             "th": Style(
                              //                               padding:
                              //                                   EdgeInsets.all(
                              //                                       6),
                              //                               backgroundColor:
                              //                                   Colors.grey,
                              //                             ),
                              //                             "td": Style(
                              //                               padding:
                              //                                   EdgeInsets.all(
                              //                                       6),
                              //                               alignment: Alignment
                              //                                   .topLeft,
                              //                             ),
                              //                             'h5': Style(
                              //                                 maxLines: 2,
                              //                                 textOverflow:
                              //                                     TextOverflow
                              //                                         .ellipsis),
                              //                           },
                              //                         ),
                              //                       )
                              //                     : Flexible(
                              //                         child: Text(
                              //                             response[itemIndex][
                              //                                 'comprahensive_paragraph '],
                              //                             textAlign:
                              //                                 TextAlign.left,
                              //                             overflow: TextOverflow
                              //                                 .visible,
                              //                             style: normalText4),
                              //                       )
                              //                 : response[itemIndex][
                              //                             'comprahensive_paragraph ']
                              //                         .contains("<")
                              //                     ? Expanded(
                              //                         child: Html(
                              //                           data: response[
                              //                                   itemIndex][
                              //                               'comprahensive_paragraph '],
                              //                           style: {
                              //                             "table": Style(
                              //                               backgroundColor:
                              //                                   Color.fromARGB(
                              //                                       0x50,
                              //                                       0xee,
                              //                                       0xee,
                              //                                       0xee),
                              //                             ),
                              //                             "tr": Style(
                              //                               border: Border(
                              //                                 bottom: BorderSide(
                              //                                     color: Colors
                              //                                         .black),
                              //                                 top: BorderSide(
                              //                                     color: Colors
                              //                                         .black),
                              //                                 right: BorderSide(
                              //                                     color: Colors
                              //                                         .black),
                              //                                 left: BorderSide(
                              //                                     color: Colors
                              //                                         .black),
                              //                               ),
                              //                             ),
                              //                             "th": Style(
                              //                               padding:
                              //                                   EdgeInsets.all(
                              //                                       6),
                              //                               backgroundColor:
                              //                                   Colors.grey,
                              //                             ),
                              //                             "td": Style(
                              //                               padding:
                              //                                   EdgeInsets.all(
                              //                                       6),
                              //                               alignment: Alignment
                              //                                   .topLeft,
                              //                             ),
                              //                             'h5': Style(
                              //                                 maxLines: 2,
                              //                                 textOverflow:
                              //                                     TextOverflow
                              //                                         .ellipsis),
                              //                           },
                              //                         ),
                              //                       )
                              //                     : Flexible(
                              //                         child: Text(
                              //                             response[itemIndex][
                              //                                 'comprahensive_paragraph '],
                              //                             textAlign:
                              //                                 TextAlign.left,
                              //                             maxLines: 1,
                              //                             overflow: TextOverflow
                              //                                 .visible,
                              //                             style: normalText4),
                              //                       ),
                              //             full_show
                              //                 ? Icon(
                              //                     Icons.arrow_drop_up_outlined,
                              //                     color: Color(0xff017EFF),
                              //                     size: 24,
                              //                   )
                              //                 : Icon(
                              //                     Icons.arrow_drop_down,
                              //                     color: Color(0xff017EFF),
                              //                     size: 24,
                              //                   )
                              //           ]),
                              //     ),
                              //   ),
                              // )

                              // SizedBox(
                              //   height: 10,
                              // ),
                              // Align(
                              //   alignment: Alignment.topLeft,
                              //   child: Container(
                              //     color: Color(0xffF9F9FB),
                              //     padding: EdgeInsets.only(left: 15, right: 15),
                              //     margin: EdgeInsets.only(left: 10, right: 10),
                              //     child: Row(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.start,
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.start,
                              //         children: <Widget>[
                              //           /* Align(
                              //             alignment: Alignment.centerLeft,
                              //             child: Text(
                              //                 "Q" +
                              //                     (itemIndex + 1).toString() +
                              //                     '. ',
                              //                 textAlign: TextAlign.left,
                              //                 style: normalText5),
                              //           ),*/
                              //           /*response[itemIndex][
                              //           'question'].contains("&")?*/
                              //           Flexible(
                              //             child: Html(
                              //               data: "Q" +
                              //                   (itemIndex + 1).toString() +
                              //                   '. ' +
                              //                   response[itemIndex]['question'],
                              //               style: {
                              //                 "body": Style(
                              //                   fontSize: FontSize(15.0),
                              //                   color: Color(0xff2E2A4A),
                              //                   fontWeight: FontWeight.w600,
                              //                 ),
                              //                 "table": Style(
                              //                   backgroundColor: Color.fromARGB(
                              //                       0x50, 0xee, 0xee, 0xee),
                              //                 ),
                              //                 "tr": Style(
                              //                   border: Border(
                              //                     bottom: BorderSide(
                              //                         color: Colors.black),
                              //                     top: BorderSide(
                              //                         color: Colors.black),
                              //                     right: BorderSide(
                              //                         color: Colors.black),
                              //                     left: BorderSide(
                              //                         color: Colors.black),
                              //                   ),
                              //                 ),
                              //                 "th": Style(
                              //                   padding: EdgeInsets.all(6),
                              //                   backgroundColor: Colors.grey,
                              //                 ),
                              //                 "td": Style(
                              //                   padding: EdgeInsets.all(6),
                              //                   alignment: Alignment.topLeft,
                              //                 ),
                              //                 'h5': Style(
                              //                     maxLines: 2,
                              //                     textOverflow:
                              //                         TextOverflow.ellipsis),
                              //               },
                              //             ),
                              //           ) /*:

                              // */
                              //           ,
                              //         ]),
                              //   ),
                              // ),
                              // Text("data"),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Q" +
                                            (itemIndex + 1).toString() +
                                            ". " +
                                            response[itemIndex]['question']
                                                .toString()
                                                .replaceAll("<p>", "")
                                                .replaceAll("</p>", "")
                                                .replaceAll("&nbsp;", "")
                                                .replaceAll("&#39;", "\'")
                                                .replaceAll("&amp;", "\'"),
                                        textAlign: TextAlign.left,
                                        // maxLines: 100,
                                        overflow: TextOverflow.visible,
                                        style: normalText5),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),

                              ansBuilder(response, itemIndex),
                              lastAns != true
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                          Align(
                                            alignment:
                                                FractionalOffset.bottomRight,
                                            child: ButtonTheme(
                                              minWidth: 50.0,
                                              height: 34.0,
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 20),
                                                  child: RaisedButton(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2,
                                                            bottom: 2,
                                                            left: 25,
                                                            right: 25),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.0)),
                                                    textColor: Colors.white,
                                                    color: Color(0xff017EFF),
                                                    onPressed: () async {
                                                      onPreviousClick(
                                                          itemIndex);
                                                    },
                                                    child: Text(
                                                      "Previous",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          letterSpacing: 1,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                FractionalOffset.bottomRight,
                                            child: ButtonTheme(
                                              minWidth: 50.0,
                                              height: 34.0,
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      right: 20),
                                                  child: RaisedButton(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2,
                                                            bottom: 2,
                                                            left: 25,
                                                            right: 25),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.0)),
                                                    textColor: Colors.white,
                                                    color: Color(0xff017EFF),
                                                    onPressed: () async {
                                                      XMLJSON xmljson =
                                                          new XMLJSON();
                                                      print(xmljson);
                                                      print(arr.toString() +
                                                          " test");

                                                      if (previousClicked
                                                          .contains(true)) {
                                                        if (optionsClicked[
                                                                itemIndex] ==
                                                            true) {
                                                          optionsClicked[
                                                                  itemIndex] =
                                                              false;
                                                        }
                                                      }
                                                      print(previousClicked);
                                                      print(optionsClicked);
                                                      if (arr[itemIndex] !=
                                                          null) {
                                                        // print(_controller1.getTime());

                                                        if (arr[itemIndex] ==
                                                            1) {
                                                          setState(() {
                                                            xmljson.question =
                                                                response[itemIndex]
                                                                        ['id']
                                                                    .toString();
                                                            xmljson
                                                                .answer = response[
                                                                        itemIndex]
                                                                    [
                                                                    'question_option'][0]
                                                                [
                                                                'option_value'];
                                                            xmljson.time_taken =
                                                                _controller1
                                                                    .getTime();
                                                          });
                                                          if (previousClicked[
                                                              itemIndex]) {
                                                            xmlList.removeAt(
                                                                itemIndex);
                                                            xmlList.insert(
                                                                itemIndex,
                                                                xmljson);
                                                            print("a");
                                                          } else {
                                                            if (optionsClicked[
                                                                    itemIndex] ==
                                                                false) {
                                                              xmlList.removeAt(
                                                                  itemIndex);
                                                              xmlList.insert(
                                                                  itemIndex,
                                                                  xmljson);
                                                              print("b");
                                                            } else {
                                                              xmlList
                                                                  .add(xmljson);
                                                              print("c");
                                                            }
                                                          }
                                                          print(xmlList);
                                                        } else if (arr[
                                                                itemIndex] ==
                                                            2) {
                                                          setState(() {
                                                            xmljson.question =
                                                                response[itemIndex]
                                                                        ['id']
                                                                    .toString();
                                                            xmljson
                                                                .answer = response[
                                                                        itemIndex]
                                                                    [
                                                                    'question_option'][1]
                                                                [
                                                                'option_value'];
                                                            xmljson.time_taken =
                                                                _controller1
                                                                    .getTime();
                                                          });
                                                          if (previousClicked[
                                                              itemIndex]) {
                                                            xmlList.removeAt(
                                                                itemIndex);
                                                            xmlList.insert(
                                                                itemIndex,
                                                                xmljson);
                                                            print("a");
                                                          } else {
                                                            if (optionsClicked[
                                                                    itemIndex] ==
                                                                false) {
                                                              xmlList.removeAt(
                                                                  itemIndex);
                                                              xmlList.insert(
                                                                  itemIndex,
                                                                  xmljson);
                                                              print("b");
                                                            } else {
                                                              xmlList
                                                                  .add(xmljson);
                                                              print("c");
                                                            }
                                                          }
                                                          print(jsonEncode(
                                                              xmlList));
                                                        } else if (arr[
                                                                itemIndex] ==
                                                            3) {
                                                          setState(() {
                                                            xmljson.question =
                                                                response[itemIndex]
                                                                        ['id']
                                                                    .toString();
                                                            xmljson
                                                                .answer = response[
                                                                        itemIndex]
                                                                    [
                                                                    'question_option'][2]
                                                                [
                                                                'option_value'];
                                                            xmljson.time_taken =
                                                                _controller1
                                                                    .getTime();
                                                          });
                                                          if (previousClicked[
                                                              itemIndex]) {
                                                            xmlList.removeAt(
                                                                itemIndex);
                                                            xmlList.insert(
                                                                itemIndex,
                                                                xmljson);
                                                            print("a");
                                                          } else {
                                                            if (optionsClicked[
                                                                    itemIndex] ==
                                                                false) {
                                                              xmlList.removeAt(
                                                                  itemIndex);
                                                              xmlList.insert(
                                                                  itemIndex,
                                                                  xmljson);
                                                              print("b");
                                                            } else {
                                                              xmlList
                                                                  .add(xmljson);
                                                              print("c");
                                                            }
                                                          }
                                                          print(jsonEncode(
                                                              xmlList));
                                                        } else if (arr[
                                                                itemIndex] ==
                                                            4) {
                                                          setState(() {
                                                            xmljson.question =
                                                                response[itemIndex]
                                                                        ['id']
                                                                    .toString();
                                                            xmljson
                                                                .answer = response[
                                                                        itemIndex]
                                                                    [
                                                                    'question_option'][3]
                                                                [
                                                                'option_value'];
                                                            xmljson.time_taken =
                                                                _controller1
                                                                    .getTime();
                                                          });
                                                          if (previousClicked[
                                                              itemIndex]) {
                                                            xmlList.removeAt(
                                                                itemIndex);
                                                            xmlList.insert(
                                                                itemIndex,
                                                                xmljson);
                                                            print("a");
                                                          } else {
                                                            if (optionsClicked[
                                                                    itemIndex] ==
                                                                false) {
                                                              xmlList.removeAt(
                                                                  itemIndex);
                                                              xmlList.insert(
                                                                  itemIndex,
                                                                  xmljson);
                                                              print("b");
                                                            } else {
                                                              xmlList
                                                                  .add(xmljson);
                                                              print("c");
                                                            }
                                                          }
                                                          print(jsonEncode(
                                                              xmlList));
                                                        }
                                                        if (itemIndex ==
                                                            (response.length -
                                                                1)) {
                                                          setState(() {
                                                            lastAns = true;
                                                          });
                                                        }

                                                        onNextClick(itemIndex);
                                                        _scrollToTop();
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Please Select Answer");
                                                      }
                                                    },
                                                    child: Text(
                                                      "Next",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          letterSpacing: 1,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ])
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                          Align(
                                            alignment:
                                                FractionalOffset.bottomRight,
                                            child: ButtonTheme(
                                              minWidth: 50.0,
                                              height: 34.0,
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 20),
                                                  child: RaisedButton(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2,
                                                            bottom: 2,
                                                            left: 25,
                                                            right: 25),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.0)),
                                                    textColor: Colors.white,
                                                    color: Color(0xff017EFF),
                                                    onPressed: () async {
                                                      onPreviousClick(
                                                          itemIndex);
                                                    },
                                                    child: Text(
                                                      "Previous",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          letterSpacing: 1,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                FractionalOffset.bottomRight,
                                            child: ButtonTheme(
                                              minWidth: 50.0,
                                              height: 34.0,
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      right: 20),
                                                  child: RaisedButton(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2,
                                                            bottom: 2,
                                                            left: 25,
                                                            right: 25),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.0)),
                                                    textColor: Colors.white,
                                                    color: Color(0xff017EFF),
                                                    onPressed: () async {
                                                      setState(() {
                                                        _loading = true;
                                                      });
                                                      final currentTime1 =
                                                          DateTime.now();
                                                      final diff_mn =
                                                          currentTime1
                                                              .difference(
                                                                  currentTime)
                                                              .inSeconds;

                                                      finalMap["start_time"] =
                                                          currentTime
                                                              .toString();
                                                      finalMap["end_time"] =
                                                          currentTime1
                                                              .toString();
                                                      finalMap["total_time"] =
                                                          diff_mn.toString();
                                                      finalMap["questions"] =
                                                          xmlList;
                                                      finalMap["user_id"] =
                                                          user_id.toString();
                                                      print(finalMap);
                                                      Map<String, String>
                                                          headers = {
                                                        'Accept':
                                                            'application/json',
                                                        'Content-Type':
                                                            'application/json',
                                                        'Authorization':
                                                            'Bearer $api_token',
                                                      };
                                                      print(
                                                          jsonEncode(finalMap));
                                                      var response =
                                                          await http.post(
                                                        new Uri.https(
                                                            BASE_URL,
                                                            API_PATH +
                                                                "/subjective-test-finish"),
                                                        body: jsonEncode(
                                                            finalMap),
                                                        headers: headers,
                                                      );

                                                      if (response.statusCode ==
                                                          200) {
                                                        setState(() {
                                                          _loading = false;
                                                        });
                                                        var data = json.decode(
                                                            response.body);
                                                        print(data);
                                                        var errorCode =
                                                            data['ErrorCode'];
                                                        var errorMessage = data[
                                                            'ErrorMessage'];
                                                        if (errorCode == 0) {
                                                          setState(() {
                                                            _loading = false;
                                                          });
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Test Submitted Successfully");
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pushNamed(
                                                            context,
                                                            '/view-performance',
                                                            arguments: <String,
                                                                String>{
                                                              'test_id': test_id
                                                                  .toString(),
                                                              'type': type ==
                                                                      "institute"
                                                                  ? "institute"
                                                                  : "",
                                                              'total_ques':
                                                                  totalQuestions
                                                                      .toString()
                                                            },
                                                          );
                                                        } else {
                                                          setState(() {
                                                            _loading = false;
                                                          });
                                                          showAlertDialog(
                                                              context,
                                                              ALERT_DIALOG_TITLE,
                                                              errorMessage);
                                                        }
                                                      }
                                                    },
                                                    child: Text(
                                                      "Submit",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          letterSpacing: 1,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                              const SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: double.infinity,
                                  child: Center(
                                    child: Text(
                                      '${itemIndex + 1}/' + totalQuestions,
                                      style: normalText6,
                                    ),
                                  ),
                                ),
                              ),
                            ])),
                          ]);
                        }),
                  )
                : Container();
          } else {
            return Container();
          }
        } else {
          return Center(child: Container(child: CircularProgressIndicator()));
        }
      },
    );
  }

  CountDownController _controller = CountDownController();
  CountDownController _controller1 = CountDownController();
  int _duration = 86400;
  int _duration1 = 86400;
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            /*title: new Text(
          "Your answers data will be cleared. Press yes to continue.",
        ),*/
            content: new Text(
                "Your answers data will be cleared. Press yes to continue."),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  "No",
                  style: TextStyle(
                    color: Color(0xff2E2A4A),
                  ),
                ),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  Navigator.pushNamed(context, '/dashboard');
                },
                child:
                    new Text("Yes", style: TextStyle(color: Color(0xff2E2A4A))),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: _loading,
          progressIndicator: Center(
              child: Align(
            alignment: Alignment.center,
            child: Container(
              child: SpinKitFadingCube(
                itemBuilder: (_, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color:
                          index.isEven ? Color(0xff017EFF) : Color(0xffFFC700),
                    ),
                  );
                },
                size: 30.0,
              ),
            ),
          )),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              child: Stack(
                children: [
                  Container(
                    child: Stack(children: <Widget>[
                      Image(
                        image: AssetImage('assets/images/Vector6.png'),
                        // fit: BoxFit.fill,
                      ),
                      /*  InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            '/test-list',
                            arguments: <String, String>{
                              'chapter_id': chapter_id.toString(),
                              'chapter_name': chapter_name.toString(),
                              'type': "outside"
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 60, left: 22),
                          child: Container(
                            width: 30,
                            height: 17,
                            child: Image(
                                image: AssetImage('assets/images/Icon.png'),
                                height: 20,
                                width: 10,
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),*/
                      Positioned(
                        right: 0.0,
                        left: 0.0,
                        top: 0.0,
                        bottom: 0.0,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Image.asset(
                                  'assets/images/question.png',
                                  width: 0,
                                  height: 0,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Stack(children: <Widget>[
                                    Align(
                                      alignment: Alignment.center,
                                      child: CircularCountDownTimer(
                                        // Countdown duration in Seconds.
                                        duration: _duration,

                                        // Countdown initial elapsed Duration in Seconds.
                                        initialDuration: 0,

                                        // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
                                        controller: _controller,

                                        // Width of the Countdown Widget.
                                        width: 0,

                                        // Height of the Countdown Widget.
                                        height: 0,

                                        // Ring Color for Countdown Widget.
                                        ringColor: Colors.grey[300],

                                        // Ring Gradient for Countdown Widget.
                                        ringGradient: null,

                                        // Filling Color for Countdown Widget.
                                        fillColor: Color(0xff017EFF),

                                        // Filling Gradient for Countdown Widget.
                                        fillGradient: null,

                                        // Background Color for Countdown Widget.
                                        backgroundColor: Colors.white,

                                        // Background Gradient for Countdown Widget.
                                        backgroundGradient: null,

                                        // Border Thickness of the Countdown Ring.
                                        strokeWidth: 10.0,

                                        // Begin and end contours with a flat edge and no extension.
                                        strokeCap: StrokeCap.round,

                                        // Text Style for Countdown Text.
                                        textStyle: TextStyle(
                                            fontSize: 33.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),

                                        // Format for the Countdown Text.
                                        textFormat: CountdownTextFormat.MM_SS,

                                        // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
                                        isReverse: true,

                                        // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
                                        isReverseAnimation: true,

                                        // Handles visibility of the Countdown Text.
                                        isTimerTextShown: true,

                                        // Handles the timer start.
                                        autoStart: false,

                                        // This Callback will execute when the Countdown Starts.
                                        onStart: () {},

                                        // This Callback will execute when the Countdown Ends.
                                        onComplete: () {
                                          // Here, do whatever you want
                                          print('Countdown Ended');
                                        },
                                      ),
                                    ),

                                    //   const SizedBox(width: 20.0),
                                  ]),
                                ),
                              ),
                            ]),
                      ),
                    ]),
                  ),
                  Container(
                    child: Form(
                      key: _formKey,
                      child: _customContent(),
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

  onNextClick(int itemIndex) {
    setState(() {
      previousClicked[itemIndex] = false;
      optionsClicked[itemIndex] = false;
    });
    buttonCarouselController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.linear);
    print(previousClicked);
    print(optionsClicked);
    _controller1.restart();
  }

  onPreviousClick(int itemIndex) {
    setState(() {
      lastAns = false;
      previousClicked[itemIndex - 1] = true;
      if (optionsClicked[itemIndex] == true) {
        optionsClicked[itemIndex] = true;
      } else {
        optionsClicked[itemIndex] = false;
      }
    });
    buttonCarouselController.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }
}
