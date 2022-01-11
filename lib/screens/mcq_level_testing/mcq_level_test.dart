import 'dart:convert';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/api/create_test_api.dart';
import 'package:grewal/components/progress_bar.dart';
import 'package:grewal/screens/mcq_level_testing/subjective_test.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:grewal/components/progress_bar.dart';

class MCQLevelTest extends StatefulWidget {
  final Object argument;

  const MCQLevelTest({Key key, this.argument}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<MCQLevelTest> {
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  TextStyle normalText4 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText3 = GoogleFonts.montserrat(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.underline,
      color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  TextStyle deactiveNormalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey);

  TextStyle style = TextStyle(color: Colors.white);

  String student_id;
  String chapter_id;
  bool isLoading = true;
  // bool payment_status;
  List setList = [];
  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        student_id = prefs.getString('user_id').toString();
        // payment_status = prefs.getBool('payment_status');
      });
      MCQLevelTestAPI()
          .getSetList(prefs.getString('user_id').toString(), chapter_id)
          .then((value) {
        if (value.length > 0) {
          setState(() {
            setList.clear();
            setList.addAll(value);
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    chapter_id = data['chapter_id'];
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
          title: Text("MCQ Test Levels", style: normalText6),
          flexibleSpace: Container(
            height: 100,
            color: Color(0xffffffff),
          ),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Colors.transparent,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : setList.length == 0
                ? Center(
                    child: Text(
                      "No level/s available",
                      style: normalText6,
                    ),
                  )
                : SafeArea(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 1.3,
                          child: ListView(
                            shrinkWrap: true,
                            children: setList.map((e) {
                              int percent =
                                  double.parse(e['percent'].toString()).toInt();
                              int currentIndex = setList.indexOf(e);
                              bool active = false;

                              int timeToComplete = 0;
                              switch (currentIndex) {
                                case 0:
                                  timeToComplete = 600;
                                  break;
                                case 1:
                                  timeToComplete = 900;
                                  break;
                                case 2:
                                  timeToComplete = 1200;
                                  break;
                              }

                              if (currentIndex == 0) {
                                active = true;
                              } else {
                                if (double.parse(setList[currentIndex - 1]
                                                ['percent']
                                            .toString())
                                        .toInt() >=
                                    60) {
                                  active = true;
                                }
                              }
                              return Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.20,
                                        ),
                                        Container(
                                          // color: Colors.yellow,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                e['name']
                                                    .toString()
                                                    .replaceAll("Set", "Level"),
                                                style: active
                                                    ? normalText6
                                                    : deactiveNormalText6,
                                              ),
                                              active
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        if (percent != 0)
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Scored\n" +
                                                                    percent
                                                                        .toString() +
                                                                    "%",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator
                                                                        .pushNamed(
                                                                      context,
                                                                      '/view-performance-new',
                                                                      arguments: <
                                                                          String,
                                                                          String>{
                                                                        'test_id': e['testId']
                                                                            .toString()
                                                                            .toString(),
                                                                        'type':
                                                                            "",
                                                                        'total_ques':
                                                                            "10",
                                                                        "chapter_id":
                                                                            chapter_id.toString(),
                                                                        "testType":
                                                                            "obj",
                                                                        "reattempt": e['percent'] ==
                                                                                0
                                                                            ? "0"
                                                                            : "1",
                                                                        "nob":
                                                                            "1"
                                                                      },
                                                                    );
                                                                  },
                                                                  icon: Icon(Icons
                                                                      .visibility))
                                                            ],
                                                          ),
                                                        InkWell(
                                                            onTap: () async {
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  '/create-mcq-new',
                                                                  arguments: {
                                                                    "type": "",
                                                                    "test_id": e[
                                                                            'testId']
                                                                        .toString(),
                                                                    "chapter_id":
                                                                        chapter_id,
                                                                    "set_id": e[
                                                                            'id']
                                                                        .toString(),
                                                                    "re-attempt": e['percent'] ==
                                                                            0
                                                                        ? "false"
                                                                        : "true",
                                                                    "timeToComp":
                                                                        timeToComplete
                                                                            .toString()
                                                                  });
                                                            },
                                                            child: percent == 0
                                                                ? Text(
                                                                    "Tap to Attempt",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .green,
                                                                        fontSize:
                                                                            16))
                                                                : percent < 60
                                                                    ? Text(
                                                                        "Tap Re-Attempt",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.green,
                                                                            fontSize: 16))
                                                                    : Text(""))
                                                      ],
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Locked",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: 60,
                                    child: new Container(
                                      height: size.height * 0.7,
                                      width: 1.0,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  Positioned(
                                    child: Padding(
                                      padding: const EdgeInsets.all(40.0),
                                      child: Container(
                                        height: 40.0,
                                        width: 40.0,
                                        child: active
                                            ? percent == 0
                                                ? Icon(Icons
                                                    .check_box_outline_blank)
                                                : Icon(Icons.check_box_outlined)
                                            : Icon(Icons.lock),
                                        decoration: new BoxDecoration(
                                          color: Colors.yellow,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Text(
                            "Minimum 60% required to unlock the next level.",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ));
  }
}
