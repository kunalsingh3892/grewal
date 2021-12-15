import 'dart:async';
import 'dart:convert';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

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
import 'package:grewal/services/Timer_Data.dart';
import 'package:intl/intl.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'clock.dart';

class StartOlyMCQ extends StatefulWidget {
  final Object argument;

  const StartOlyMCQ({Key key, this.argument}) : super(key: key);

  @override
  _LoginWithLogoState createState() => _LoginWithLogoState();
}

class _LoginWithLogoState extends State<StartOlyMCQ>
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
  String section_id = "";
  String question_attempt = "";

  var answerId;
  bool lastAns = false;
  bool lastNext = false;
  bool done = false;

  List<XMLJSON> xmlList = new List();

  bool full_show = false;
//  int _duration = 1800;
  List<bool> previousClicked;
  List<bool> optionsClicked;
  List<String> list=new List();
  String api_token = "";
  int time = 0;
  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    test_id = data['test_id'];
    section_id = data['section_id'];
    time = int.parse(data['time']);
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

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        user_id = prefs.getString('user_id').toString();
        class_id = prefs.getString('class_id').toString();
        board_id = prefs.getString('board_id').toString();
        api_token = prefs.getString('api_token').toString();
        _getTime();
        _quiz = _getTestData();
      //  _controller.start();

      });
    });
  }

  Future _getTestData() async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/start-test-olympiad"),
      body: {
        "test_id": test_id,
        "user_id": user_id,
        "olympiad": "1",
        "section": section_id
      },
      headers: headers,
    );
    print({
      "test_id": test_id,
      "user_id": user_id,
      "olympiad": "1",
      "section": section_id
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      arr = new List(data['Response'].length);

      previousClicked = new List(data['Response'].length);
      optionsClicked = new List(data['Response'].length);
      list = new List(data['Response'].length);
      setState(() {
        //  _duration=(data['Response'].length*2);

        question_attempt = data['question_attempt'].toString();

        for (int i = 0; i < data['Response'].length; i++) {
          optionsClicked[i] = false;
          previousClicked[i] = false;
        }
      });

      print(data);
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

  Widget _radioBuilderMCQ(response, int index, response1) {
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
                 if(xmlList.length >= int.parse(question_attempt)) {
                   setState(() {
                     lastAns = true;
                   });
                  Fluttertoast.showToast(msg: question_attempt+" Questions already selected");
                }
                else{
                selectedRadio(val, index,response1);
                   }
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
                if(xmlList.length >= int.parse(question_attempt)) {
                  setState(() {
                    lastAns = true;
                  });
                  Fluttertoast.showToast(msg: question_attempt+" Questions already selected");
                }
                else{
                selectedRadio(val, index,response1);
                  }
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
                  if(xmlList.length >= int.parse(question_attempt)) {
                    setState(() {
                      lastAns = true;
                    });
                  Fluttertoast.showToast(msg: question_attempt+" Questions already selected");
                }
                else{
                selectedRadio(val, index,response1);
                }
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
                if(xmlList.length >= int.parse(question_attempt)) {
                  setState(() {
                    lastAns = true;
                  });
                  Fluttertoast.showToast(msg: question_attempt+" Questions already selected");
                }
                else{
                selectedRadio(val, index,response1);
                }
              },
            ),
          ]),
        ]));
  }



  selectedRadio(int val, int ind, response) {
    setState(() {
      if(optionsClicked[ind]==true){
        optionsClicked[ind] = false;
      }
      else{
        optionsClicked[ind] = true;
      }

      arr[ind] = val;
      print(arr[ind]);
      XMLJSON xmljson =
      new XMLJSON();
      if (arr[ind] ==
          1) {
        setState(() {
          xmljson.question =
              response[ind]
              ['id']
                  .toString();
          xmljson
              .answer = response[
          ind]
          [
          'question_option'][0]
          [
          'option_value'];
          xmljson.time_taken =

          "";
        });
        if (previousClicked[
        ind]) {
          optionsClicked[
          ind] =
          true;
          xmlList.removeAt(
              ind);
          xmlList.insert(
              ind,
              xmljson);
          print("a");

        } else {
          if (optionsClicked[
          ind] ==
              false) {
            optionsClicked[
            ind] =
            true;
            xmlList.removeAt(
                ind);
            xmlList.insert(
                ind,
                xmljson);
            print("b");
          } else {

            optionsClicked[
            ind] =
            true;

            xmlList
                .add(xmljson);
            print("c");
          }
        }
        print(xmlList);
      } else if (arr[
      ind] ==
          2) {
        setState(() {
          xmljson.question =
              response[ind]
              ['id']
                  .toString();
          xmljson
              .answer = response[
          ind]
          [
          'question_option'][1]
          [
          'option_value'];
          xmljson.time_taken =
          "";
        });
        if (previousClicked[
        ind]) {
          optionsClicked[
          ind] =
          true;
          xmlList.removeAt(
              ind);
          xmlList.insert(
              ind,
              xmljson);
          print("a");

        } else {
          if (optionsClicked[
          ind] ==
              false) {
            optionsClicked[
            ind] =
            true;
            xmlList.removeAt(
                ind);
            xmlList.insert(
                ind,
                xmljson);
            print("b");
          } else {

            optionsClicked[
            ind] =
            true;


            xmlList
                .add(xmljson);
            print("c");
          }
        }
        print(jsonEncode(
            xmlList));
      } else if (arr[
      ind] ==
          3) {
        setState(() {
          xmljson.question =
              response[ind]
              ['id']
                  .toString();
          xmljson
              .answer = response[
          ind]
          [
          'question_option'][2]
          [
          'option_value'];
          xmljson.time_taken =
          "";
        });
        if (previousClicked[
        ind]) {
          optionsClicked[
          ind] =
          true;
          xmlList.removeAt(
              ind);
          xmlList.insert(
              ind,
              xmljson);
          print("a");

        } else {
          if (optionsClicked[
          ind] ==
              false) {
            optionsClicked[
            ind] =
            true;
            xmlList.removeAt(
                ind);
            xmlList.insert(
                ind,
                xmljson);
            print("b");
          } else {

            optionsClicked[
            ind] =
            true;

            xmlList
                .add(xmljson);
            print("c");
          }
        }
        print(jsonEncode(
            xmlList));
      } else if (arr[
      ind] ==
          4) {
        setState(() {
          xmljson.question =
              response[ind]
              ['id']
                  .toString();
          xmljson
              .answer = response[
          ind]
          [
          'question_option'][3]
          [
          'option_value'];
          xmljson.time_taken =
          "";
        });
        if (previousClicked[
        ind]) {
          optionsClicked[
          ind] =
          true;
          xmlList.removeAt(
              ind);
          xmlList.insert(
              ind,
              xmljson);
          print("a");

        } else {
          if (optionsClicked[
          ind] ==
              false) {
            optionsClicked[
            ind] =
            true;
            xmlList.removeAt(
                ind);
            xmlList.insert(
                ind,
                xmljson);
            print("b");
          } else {
            optionsClicked[
            ind] =
            true;

            xmlList
                .add(xmljson);
            print("c");
          }
        }
        print(jsonEncode(
            xmlList));
      }

      /*if (itemIndex == (response.length - 1)) {
                                                          setState(() {
                                                            lastAns = true;
                                                          });
                                                        }
                                                        else */
      if(xmlList.length >= int.parse(question_attempt)){
        setState(() {
          lastAns = true;
        });

      }


    });
  }

  CarouselController buttonCarouselController = CarouselController();

  Widget ansBuilder(response, int itemIndex) {
    if (response[itemIndex]['type'] == "MCQ") {
      return _radioBuilderMCQ(
          response[itemIndex]['question_option'], itemIndex,response);
    } else if (response[itemIndex]['type'] == "Case Study") {
      return _radioBuilderMCQ(
          response[itemIndex]['question_option'], itemIndex,response);
    } else if (response[itemIndex]['type'] == "Assertion Reasoning") {
      return _radioBuilderMCQ(
          response[itemIndex]['question_option'], itemIndex,response);
    }
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
  Future<bool> _submitPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(
          "Are you sure",
        ),
        content: new Text("You want to submit your test?"),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              "No",
              style: TextStyle(
                color: Color(0xff223834),
              ),
            ),
          ),
          new FlatButton(
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
              print(diff_mn);

              final msg = jsonEncode({
                "test_id": test_id,
                "user_id": user_id,
                "section_id":
                section_id,
                "start_time":
                currentTime
                    .toString(),
                "end_time":
                currentTime1
                    .toString(),
                "total_time": diff_mn
                    .toString(),
                "questions": xmlList
              });
              print(msg);
              Map<String, String>
              headers = {
                'Accept':
                'application/json',
                'Content-Type':
                'application/json',
                'Authorization': 'Bearer $api_token',
              };
              var response =
              await http.post(
                new Uri.https(
                    BASE_URL,
                    API_PATH +
                        "/finish-test-olympiad"),
                body: jsonEncode({
                  "test_id": test_id,
                  "user_id": user_id,
                  "section_id":
                  section_id,
                  "start_time":
                  currentTime
                      .toString(),
                  "end_time":
                  currentTime1
                      .toString(),
                  "total_time":
                  diff_mn
                      .toString(),
                  "questions": xmlList
                }),
                headers: headers,
              );

              if (response
                  .statusCode ==
                  200) {
                setState(() {
                  _loading = false;
                });
                var data = json
                    .decode(response
                    .body);
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
                      "Section Submitted Successfully");
                  Navigator.pop(
                      context);
                  Navigator.pushNamed(
                    context,
                    '/section-list',
                    arguments: <
                        String,
                        String>{
                      'test_id':
                      test_id,
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
            child:
            new Text("Yes", style: TextStyle(color: Color(0xff223834))),
          ),
        ],
      ),
    )) ??
        false;
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
                    return ListView(
                        shrinkWrap: true,
                        primary: false,
                        children: <Widget>[
                          Container(
                              child: Column(children: <Widget>[


                                response[itemIndex]['type'] == "Case Study"
                                    ? itemIndex == 11
                                    ? Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    color: Color(0xffF9F9FB),
                                    padding: EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        top: 10,
                                        bottom: 10),
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          response[itemIndex][
                                          'comprahensive_paragraph ']
                                              .contains("<")
                                              ? Flexible(
                                            child: Html(
                                              data: response[
                                              itemIndex][
                                              'comprahensive_paragraph '],
                                              style: {
                                                "table": Style(
                                                  backgroundColor:
                                                  Color.fromARGB(
                                                      0x50,
                                                      0xee,
                                                      0xee,
                                                      0xee),
                                                ),
                                                "tr": Style(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors
                                                            .black),
                                                    top: BorderSide(
                                                        color: Colors
                                                            .black),
                                                    right: BorderSide(
                                                        color: Colors
                                                            .black),
                                                    left: BorderSide(
                                                        color: Colors
                                                            .black),
                                                  ),
                                                ),
                                                "th": Style(
                                                  padding:
                                                  EdgeInsets
                                                      .all(6),
                                                  backgroundColor:
                                                  Colors.grey,
                                                ),
                                                "td": Style(
                                                  padding:
                                                  EdgeInsets
                                                      .all(6),
                                                  alignment:
                                                  Alignment
                                                      .topLeft,
                                                ),
                                                'h5': Style(
                                                    maxLines: 2,
                                                    textOverflow:
                                                    TextOverflow
                                                        .ellipsis),
                                              },
                                            ),
                                          )
                                              : Flexible(
                                            child: Text(
                                                response[
                                                itemIndex]
                                                [
                                                'comprahensive_paragraph '],
                                                textAlign:
                                                TextAlign
                                                    .left,
                                                maxLines: 100,
                                                overflow:
                                                TextOverflow
                                                    .visible,
                                                style:
                                                normalText4),
                                          ),
                                          /*  Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Color(0xff017EFF),
                                                  size: 24,
                                                )*/
                                        ]),
                                  ),
                                )
                                    : InkWell(
                                  onTap: () {
                                    setState(() {
                                      full_show = !full_show;
                                    });
                                  },
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      color: Color(0xffF9F9FB),
                                      padding: EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: 10,
                                          bottom: 10),
                                      margin: EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            full_show
                                                ? response[itemIndex][
                                            'comprahensive_paragraph ']
                                                .contains("<")
                                                ? Flexible(
                                              child: Html(
                                                data: response[
                                                itemIndex]
                                                [
                                                'comprahensive_paragraph '],
                                                style: {
                                                  "table":
                                                  Style(
                                                    backgroundColor: Color.fromARGB(
                                                        0x50,
                                                        0xee,
                                                        0xee,
                                                        0xee),
                                                  ),
                                                  "tr": Style(
                                                    border:
                                                    Border(
                                                      bottom: BorderSide(
                                                          color:
                                                          Colors.black),
                                                      top: BorderSide(
                                                          color:
                                                          Colors.black),
                                                      right: BorderSide(
                                                          color:
                                                          Colors.black),
                                                      left: BorderSide(
                                                          color:
                                                          Colors.black),
                                                    ),
                                                  ),
                                                  "th": Style(
                                                    padding:
                                                    EdgeInsets.all(
                                                        6),
                                                    backgroundColor:
                                                    Colors
                                                        .grey,
                                                  ),
                                                  "td": Style(
                                                    padding:
                                                    EdgeInsets.all(
                                                        6),
                                                    alignment:
                                                    Alignment
                                                        .topLeft,
                                                  ),
                                                  'h5': Style(
                                                      maxLines:
                                                      2,
                                                      textOverflow:
                                                      TextOverflow.ellipsis),
                                                },
                                              ),
                                            )
                                                : Flexible(
                                              child: Text(
                                                  response[
                                                  itemIndex]
                                                  [
                                                  'comprahensive_paragraph '],
                                                  textAlign:
                                                  TextAlign
                                                      .left,
                                                  overflow:
                                                  TextOverflow
                                                      .visible,
                                                  style:
                                                  normalText4),
                                            )
                                                : response[itemIndex][
                                            'comprahensive_paragraph ']
                                                .contains("<")
                                                ? Flexible(
                                              child: Html(
                                                data: response[
                                                itemIndex]
                                                [
                                                'comprahensive_paragraph '],
                                                style: {
                                                  "table":
                                                  Style(
                                                    backgroundColor: Color.fromARGB(
                                                        0x50,
                                                        0xee,
                                                        0xee,
                                                        0xee),
                                                  ),
                                                  "tr": Style(
                                                    border:
                                                    Border(
                                                      bottom: BorderSide(
                                                          color:
                                                          Colors.black),
                                                      top: BorderSide(
                                                          color:
                                                          Colors.black),
                                                      right: BorderSide(
                                                          color:
                                                          Colors.black),
                                                      left: BorderSide(
                                                          color:
                                                          Colors.black),
                                                    ),
                                                  ),
                                                  "th": Style(
                                                    padding:
                                                    EdgeInsets.all(
                                                        6),
                                                    backgroundColor:
                                                    Colors
                                                        .grey,
                                                  ),
                                                  "td": Style(
                                                    padding:
                                                    EdgeInsets.all(
                                                        6),
                                                    alignment:
                                                    Alignment
                                                        .topLeft,
                                                  ),
                                                  'h5': Style(
                                                      maxLines:
                                                      2,
                                                      textOverflow:
                                                      TextOverflow.ellipsis),
                                                },
                                              ),
                                            )
                                                : Flexible(
                                              child: Text(
                                                  response[
                                                  itemIndex]
                                                  [
                                                  'comprahensive_paragraph '],
                                                  textAlign:
                                                  TextAlign
                                                      .left,
                                                  maxLines: 1,
                                                  overflow:
                                                  TextOverflow
                                                      .visible,
                                                  style:
                                                  normalText4),
                                            ),
                                            full_show
                                                ? Icon(
                                              Icons
                                                  .arrow_drop_up_outlined,
                                              color: Color(
                                                  0xff017EFF),
                                              size: 24,
                                            )
                                                : Icon(
                                              Icons
                                                  .arrow_drop_down,
                                              color: Color(
                                                  0xff017EFF),
                                              size: 24,
                                            )
                                          ]),
                                    ),
                                  ),
                                )
                                    : Container(),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    color: Color(0xffF9F9FB),
                                    padding: EdgeInsets.only(left: 15, right: 15),
                                    margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          /* Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              "Q" +
                                                  (itemIndex + 1).toString() +
                                                  '. ',
                                              textAlign: TextAlign.left,
                                              style: normalText5),
                                        ),*/
                                          /*response[itemIndex][
                                        'question'].contains("&")?*/
                                          Flexible(
                                            child: Html(
                                              data: "Q" +
                                                  (itemIndex + 1).toString() +
                                                  '. ' +
                                                  response[itemIndex]['question'],
                                              style: {
                                                "body": Style(
                                                  fontSize: FontSize(15.0),
                                                  color: Color(0xff2E2A4A),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                "table": Style(
                                                  backgroundColor: Color.fromARGB(
                                                      0x50, 0xee, 0xee, 0xee),
                                                ),
                                                "tr": Style(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.black),
                                                    top: BorderSide(
                                                        color: Colors.black),
                                                    right: BorderSide(
                                                        color: Colors.black),
                                                    left: BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                "th": Style(
                                                  padding: EdgeInsets.all(6),
                                                  backgroundColor: Colors.grey,
                                                ),
                                                "td": Style(
                                                  padding: EdgeInsets.all(6),
                                                  alignment: Alignment.topLeft,
                                                ),
                                                'h5': Style(
                                                    maxLines: 2,
                                                    textOverflow:
                                                    TextOverflow.ellipsis),
                                              },
                                            ),
                                          ) /*:  Flexible(
                                          child: Text(
                                              response[itemIndex]['question'],
                                              textAlign: TextAlign.left,
                                              maxLines: 100,
                                              overflow: TextOverflow.visible,
                                              style: normalText5),
                                        )*/
                                          ,
                                        ]),
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

                                                  print(arr);

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

                                                    onNextClick(itemIndex);

                                                    // _scrollToTop();
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
                                                  if (xmlList.length >= int.parse(question_attempt)) {
                                                    _submitPop();

                                                  }
                                                  else{
                                                    Fluttertoast.showToast(
                                                        msg:
                                                        "Please attempt at least $question_attempt questions");
                                                  }

                                                },
                                                child: Text(
                                                  "Submit Section",
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
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(),
                                      Align(
                                        alignment: FractionalOffset.bottomRight,
                                        child: ButtonTheme(
                                          minWidth: 50.0,
                                          height: 34.0,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              margin: EdgeInsets.only(right: 20),
                                              child: RaisedButton(
                                                padding: const EdgeInsets.only(
                                                    top: 2,
                                                    bottom: 2,
                                                    left: 25,
                                                    right: 25),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        25.0)),
                                                textColor: Colors.white,
                                                color: Color(0xff017EFF),
                                                onPressed: () async {
                                                  if (optionsClicked[itemIndex] ==
                                                      true) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                        "Option already selected.Cannot skip question.");
                                                  } else {
                                                    onSkipClick(itemIndex);
                                                    // _scrollToTop();
                                                  }
                                                },
                                                child: Text(
                                                  "Skip",
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
                                        '${itemIndex + 1}/${response.length}',
                                        style: normalText6,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
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

 // CountDownController _controller = CountDownController();




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
              Navigator.of(context).pop(false);
              Navigator.of(context).pop(false);
              Navigator.of(context).pop(false);
              Navigator.pushNamed(context, '/oly-test-list');
            },
            child:
            new Text("Yes", style: TextStyle(color: Color(0xff2E2A4A))),
          ),
        ],
      ),
    )) ??
        false;
  }



  void _insertOverlay(BuildContext context) {
    return Overlay.of(context).insert(
      OverlayEntry(builder: (context) {
        final size = MediaQuery.of(context).size;
        print(size.width);
        return Consumer<Timer_Data>(builder: (context, data,child) {
          return  Positioned(
            width: 56,
            height: 56,
            bottom: size.height - 100,
            left: size.width - 62,
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xff017EFF)),
                  child: Center(child:  Clock()),
                ),
              ),
            ),
          );
        },);
      }),
    );
  }
  TextStyle next = GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      letterSpacing: .5);
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
            builder: (context, constraints) {
              WidgetsBinding.instance.addPostFrameCallback((_) => _insertOverlay(context));
               return ModalProgressHUD(
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
                child:
                Column(
                  children: [
                    Stack(
                        children: [
                          ClipPath(
                            clipper: WaveClipperTwo(),
                            child: Container(
                              decoration: BoxDecoration(color: Color(0xff2E2A4A)),
                              height: 150,
                            ),
                          ),
                          Container(
                            height: 40.0,
                            margin: EdgeInsets.only(top: 45),
                            child: new ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                primary: false,
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  return
                                    ButtonTheme(

                                      height: 40.0,
                                      minWidth: 35,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(

                                          child: RaisedButton(
                                            padding:
                                            const EdgeInsets.only(
                                                top: 2,
                                                bottom: 2,
                                                left: 5,
                                                right: 3),
                                            shape:
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    10.0)),
                                            textColor:arr[index]!=null?Colors.white: Color(0xff017EFF),
                                            color:arr[index]!=null?Color(0xff017EFF): Colors.white,
                                            onPressed: () async {


                                              setState(() {
                                                lastAns = false;
                                              });

                                              buttonCarouselController.jumpToPage(index);





                                            },
                                            child: Text(
                                              (index+1).toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  letterSpacing: 1,
                                                  fontWeight:
                                                  FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );

                                }),)

                        ]
                    ),

                    /*Container(
                  child:  CircularCountDownTimer(
                    // Countdown duration in Seconds.
                    duration: time,

                    // Countdown initial elapsed Duration in Seconds.
                    initialDuration: 0,

                    // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
                    controller: _controller,

                    // Width of the Countdown Widget.
                    width: MediaQuery.of(context).size.width / 5,

                    // Height of the Countdown Widget.
                    height: MediaQuery.of(context).size.height / 5,

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
                        fontSize: 20.0,
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

                ),*/
                    Expanded(
                      child: Container(
                        child: Form(
                          key: _formKey,
                          child: _customContent(),
                        ),
                      ),
                    ),
                  ],
                ),


              );

            },
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

  }

  onSkipClick(int itemIndex) {
    /* setState(() {
      previousClicked[itemIndex]=false;
      optionsClicked[itemIndex]=false;
    });*/
    buttonCarouselController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.linear);
    /* print(previousClicked);
    print(optionsClicked);*/

  }

  onPreviousClick(int itemIndex) {
    print(itemIndex);
    if (itemIndex > 0) {
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
}
