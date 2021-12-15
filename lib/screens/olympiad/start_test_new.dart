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

class StartOlyMCQNEW extends StatefulWidget {
  final Object argument;

  const StartOlyMCQNEW({Key key, this.argument}) : super(key: key);

  @override
  _LoginWithLogoState createState() => _LoginWithLogoState();
}

class _LoginWithLogoState extends State<StartOlyMCQNEW>
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
  List<bool> optionsClicked;
  bool full_show = false;
  List<String> list = new List();
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
      print(arr);
      list = new List(data['Response'].length);
      optionsClicked = new List(data['Response'].length);
      xmlList.length = data['Response'].length;
      print( xmlList.length);
      print(xmlList);
      setState(() {
        question_attempt = data['question_attempt'].toString();
      });
      for (int i = 0; i < data['Response'].length; i++) {
        optionsClicked[i] = false;
      }
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
                selectedRadio(val, index,response1);
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
                selectedRadio(val, index,response1);
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
                selectedRadio(val, index,response1);
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
                selectedRadio(val, index,response1);
              },
            ),
          ]),
        ]));
  }

  XMLJSON xmljson = new XMLJSON();
  selectedRadio(int val, int ind,response) {
    setState(() {
      optionsClicked[ind]=!optionsClicked[ind];
      print(optionsClicked);

      if(arr[ind] ==null) {
        arr[ind] = val;
        print(arr);
        if (arr[ind] == 1) {
          xmljson.question = response[ind]['id'].toString();
          xmljson.answer = response[ind]['question_option'][0]['option_value'];
          xmljson.time_taken = "";
          if (optionsClicked[ind] == false) {
            optionsClicked[ind] = true;
            xmlList.removeAt(ind);
            xmlList.insert(ind, xmljson);

            print("1");
          }
          else {
            optionsClicked[ind] = true;
            xmlList.removeAt(ind);
            xmlList.insert(ind, xmljson);
            print("2");
          }
          print(xmlList);
        }
        if (arr[ind] == 2) {
          xmljson.question = response[ind]['id'].toString();
          xmljson.answer = response[ind]['question_option'][1]['option_value'];
          xmljson.time_taken = "";
          if (optionsClicked[ind] == false) {
            optionsClicked[ind] = true;
            xmlList.removeAt(ind);
            xmlList.insert(ind, xmljson);
            print("3");
          }
          else {
            optionsClicked[ind] = true;
            xmlList.removeAt(ind);
            xmlList.insert(ind, xmljson);
            print("4");
          }
          print(xmlList);
        }
        if (arr[ind] == 3) {
          xmljson.question = response[ind]['id'].toString();
          xmljson.answer = response[ind]['question_option'][2]['option_value'];
          xmljson.time_taken = "";
          if (optionsClicked[ind] == false) {
            optionsClicked[ind] = true;
            xmlList.removeAt(ind);
            xmlList.insert(ind, xmljson);
          }
          else {
            optionsClicked[ind] = true;
            xmlList.removeAt(ind);
            xmlList.insert(ind, xmljson);
          }
          print(xmlList);
        }
        if (arr[ind] == 4) {
          xmljson.question = response[ind]['id'].toString();
          xmljson.answer = response[ind]['question_option'][3]['option_value'];
          xmljson.time_taken = "";
          if (optionsClicked[ind] == false) {
            optionsClicked[ind] = true;
            xmlList.removeAt(ind);
            xmlList.insert(ind, xmljson);
          }
          else {
            optionsClicked[ind] = true;
            xmlList.removeAt(ind);
            xmlList.insert(ind, xmljson);
          }
          print(xmlList);
        }
        if (arr.where((item) => item != null).toList().length >=
            int.parse(question_attempt)) {
          setState(() {
            lastAns = true;
          });
        }
        if (!arr.contains(null)) {
          setState(() {
            lastAns = true;
          });
        }
      }
      else{
        setState(() {
          arr[ind] = null;
          xmlList.removeAt(ind);
          xmlList.insert(ind, null);
          print(arr);
          print(xmlList);
          if (arr.indexWhere((item) => item == null) >=
              int.parse(question_attempt)) {
            setState(() {
              lastAns = true;
            });
          }
          if (!arr.contains(null)) {
            setState(() {
              lastAns = true;
            });
          }
        });

      }
    });
  }

  CarouselController buttonCarouselController = CarouselController();

  Widget ansBuilder(response, int itemIndex) {
    if (response[itemIndex]['type'] == "MCQ") {
      return _radioBuilderMCQ(
          response[itemIndex]['question_option'], itemIndex, response);
    } else if (response[itemIndex]['type'] == "Case Study") {
      return _radioBuilderMCQ(
          response[itemIndex]['question_option'], itemIndex, response);
    } else if (response[itemIndex]['type'] == "Assertion Reasoning") {
      return _radioBuilderMCQ(
          response[itemIndex]['question_option'], itemIndex, response);
    }
  }


  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller

    super.dispose();
  }


  Future<bool> _submitPop() async {
    return (await showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
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
        var getScreenHeight = MediaQuery
            .of(context)
            .size
            .height;
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
                                                    backgroundColor: Color
                                                        .fromARGB(
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
                                                    backgroundColor: Color
                                                        .fromARGB(
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
                                    padding: EdgeInsets.only(
                                        left: 15, right: 15),
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[

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
                                                  backgroundColor: Color
                                                      .fromARGB(
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
                                          )
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
                                                  onSkipClick(itemIndex);
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
                                                  onNextClick(itemIndex);
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
                                      Container(),
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
                                                  print(arr.where((item) => item != null).toList().length);
                                                  if (arr.where((item) => item != null).toList().length ==int.parse(question_attempt)) {


                                                      setState(() {
                                                        xmlList.removeWhere((item) => item==null);
                                                      });
                                                    print(xmlList);
                                                    _submitPop();
                                                  }
                                                  else {
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
      builder: (context) =>
      new AlertDialog(
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
        final size = MediaQuery
            .of(context)
            .size;
        print(size.width);
        return Consumer<Timer_Data>(builder: (context, data, child) {
          return Positioned(
            width: 56,
            height: 56,
            bottom: size.height - 150,
            left: size.width - 62,
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xff017EFF)),
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
    Size deviceSize = MediaQuery
        .of(context)
        .size;
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
                              index.isEven ? Color(0xff017EFF) : Color(
                                  0xffFFC700),
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
                                          textColor: arr[index] != null ? Colors
                                              .white : Color(0xff017EFF),
                                          color: arr[index] != null ? Color(
                                              0xff017EFF) : Colors.white,
                                          onPressed: () async {
                                            /*setState(() {
                                              lastAns = false;
                                            });*/

                                            buttonCarouselController.jumpToPage(
                                                index);
                                          },
                                          child: Text(
                                            (index + 1).toString(),
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

    buttonCarouselController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  onSkipClick(int itemIndex) {
    buttonCarouselController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }
}
