import 'dart:convert';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/api/create_test_api.dart';
import 'package:grewal/components/progress_bar.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class StartSubjectiveTest extends StatefulWidget {
  final Object argument;

  const StartSubjectiveTest({Key key, this.argument}) : super(key: key);
  @override
  _StartSubjectiveTestState createState() => _StartSubjectiveTestState();
}

class _StartSubjectiveTestState extends State<StartSubjectiveTest> {
  String chapter_id = "";
  List topicsList = [];
  bool isLoading = true;
  List selectedTopicsArray = [];
  List currentSelectedTopicLen = [];
  int noOfQuestionSelected = 1;
  int selectedTopicIndex = 0;
  bool topicSelect = false;
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w300, color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  String student_id = "";
  int count = 0;
  void countTotalQuestionSelected() {
    int totalquestionselected = 0;

    selectedTopicsArray.forEach((element) {
      totalquestionselected =
          totalquestionselected + int.parse(element['selected_question']);
    });
    setState(() {
      count = totalquestionselected;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    chapter_id = data['chapter_id'];
    Preference().getPreferences().then((prefs) {
      setState(() {
        student_id = prefs.getString('user_id').toString();
      });
      MCQLevelTestAPI().getTopicListChapterWise(chapter_id).then((value) {
        if (value.length > 0) {
          setState(() {
            topicsList.addAll(value);
            isLoading = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
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
        // iconTheme: IconThemeData(
        //   color: Colors.white, //change your color here
        // ),
        // backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          height: 100,
          color: Color(0xffffffff),
        ),
        centerTitle: true,
        title: Text("Subjective Test", style: normalText6),
      ),
      body: isLoading
          ? Center(
              child: Align(
              alignment: Alignment.center,
              child: Container(
                child: SpinKitFadingCube(
                  itemBuilder: (_, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven
                            ? Color(0xff017EFF)
                            : Color(0xffFFC700),
                      ),
                    );
                  },
                  size: 30.0,
                ),
              ),
            ))
          : Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      DropdownButtonFormField(
                          validator: (value) =>
                              value == null ? "Required" : null,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(14),
                            border: OutlineInputBorder(),
                            labelText: 'Select Topics',
                          ),
                          isExpanded: true,
                          items: topicsList
                              .map((e) => DropdownMenuItem(
                                    child: Text(
                                      e['name'].toString() +
                                          "( Detailed - " +
                                          e['totaldetails'].toString() +
                                          " )",
                                    ),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              topicSelect = true;

                              selectedTopicIndex = topicsList.indexOf(val);
                              currentSelectedTopicLen.clear();
                              currentSelectedTopicLen.addAll(
                                  new List<int>.generate(
                                      int.parse(val['totaldetails'].toString()),
                                      (i) => i + 1));
                            });
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      topicSelect
                          ? currentSelectedTopicLen.length == 0
                              ? Text(
                                  "No. of Question is 0. Please select another topic.")
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: DropdownButtonFormField(
                                          autofocus: true,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(14),
                                            border: OutlineInputBorder(),
                                            labelText: 'Select Que',
                                          ),
                                          isExpanded: true,
                                          value: 1,
                                          items: currentSelectedTopicLen
                                              .map((en) => DropdownMenuItem(
                                                    child: Text(en.toString()),
                                                    value: en,
                                                  ))
                                              .toList(),
                                          onChanged: (val) {
                                            setState(() {
                                              noOfQuestionSelected = val;
                                            });
                                          }),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          "  /  " +
                                              currentSelectedTopicLen.length
                                                  .toString(),
                                          style: normalText6,
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: ElevatedButton(
                                          child: Text("ADD"),
                                          onPressed: () {
                                            setState(() {
                                              topicsList[selectedTopicIndex]
                                                      ['selected_question'] =
                                                  noOfQuestionSelected
                                                      .toString();
                                              selectedTopicsArray.add(
                                                  topicsList[
                                                      selectedTopicIndex]);
                                              noOfQuestionSelected = 1;
                                              currentSelectedTopicLen.clear();
                                              topicSelect = false;
                                            });
                                            countTotalQuestionSelected();
                                          },
                                        ))
                                  ],
                                )
                          : SizedBox()
                    ],
                  ),
                ),
                Divider(
                  height: 10,
                  thickness: 2,
                ),
                Text(
                  "Selected No. of Qus (" + count.toString() + ")",
                  style: normalText6,
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    flex: 10,
                    child: selectedTopicsArray.toSet().toList().length == 0
                        ? Text("No topic added.")
                        : ListView(
                            children: selectedTopicsArray
                                .toSet()
                                .toList()
                                .map((e) => Card(
                                      child: ListTile(
                                        title: Text(e['name'].toString()),
                                        subtitle: Text(
                                            e['selected_question'].toString() +
                                                "/" +
                                                e['totaldetails'].toString()),
                                        trailing: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                selectedTopicsArray.removeAt(
                                                    selectedTopicsArray
                                                        .indexOf(e));
                                              });
                                              countTotalQuestionSelected();
                                            },
                                            icon: Icon(Icons.delete,
                                                color: Colors.red)),
                                      ),
                                    ))
                                .toList(),
                          )),
                Expanded(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () {
                            if (selectedTopicsArray.length == 0) {
                              Fluttertoast.showToast(
                                  msg: "Please select topics",
                                  gravity: ToastGravity.CENTER);
                            } else {
                              int totalSelectedQuestions = 0;
                              List selectedQuestionMap = [];
                              selectedTopicsArray.forEach((element) {
                                Map quesMap = {};
                                quesMap['topicid'] =
                                    element['topic_id'].toString();
                                quesMap['attempt'] =
                                    element['selected_question'].toString();
                                selectedQuestionMap.add(quesMap);
                                totalSelectedQuestions =
                                    totalSelectedQuestions +
                                        int.parse(element['selected_question']);
                              });
                              Map map = {};
                              map["student_id"] = student_id.toString();
                              map["chapter_id"] = chapter_id.toString();
                              map["total_question"] =
                                  totalSelectedQuestions.toString();
                              map["topiclist"] = selectedQuestionMap;
                              print(jsonEncode(map));
                              ProgressBarLoading().showLoaderDialog(context);
                              MCQLevelTestAPI()
                                  .createSubjectiveTest(map)
                                  .then((value) {
                                Navigator.of(context).pop();
                                if (value['ErrorCode'] == 0) {
                                  value['total_qus'] =
                                      totalSelectedQuestions.toString();
                                  Navigator.pushNamed(
                                      context, '/create-subjective',
                                      arguments: value);
                                }
                              });
                            }
                          },
                          child: Text("Start Test")),
                    ))
              ]),
            ),
    );
  }
}
