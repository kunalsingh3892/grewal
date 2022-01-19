import 'dart:convert';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/api/create_test_api.dart';
import 'package:grewal/components/general.dart';
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
    chapter_id = data['chapter_id'].toString();
    Preference().getPreferences().then((prefs) {
      setState(() {
        student_id = prefs.getString('user_id').toString();
      });
      MCQLevelTestAPI()
          .getTopicListChapterWise(chapter_id, student_id)
          .then((value) {
        if (value.length > 0) {
          setState(() {
            value.forEach((element) {
              if (element['totaldetails'].toString() != "0 out of 0") {
                topicsList.add(element);
              }
            });
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
                  flex: 4,
                  child: Column(
                    children: [
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   child: ElevatedButton(
                      //       onPressed: () {
                      //         showDialog(
                      //             context: context,
                      //             builder: (context) => AlertDialog(
                      //                   title: Text("Tap to Select"),
                      //                   content: Table(
                      //                     columnWidths: const <int,
                      //                         TableColumnWidth>{
                      //                       0: FlexColumnWidth(),
                      //                       1: FlexColumnWidth()
                      //                     },
                      //                     border: TableBorder.all(),
                      //                     children: topicsList.map((e) {

                      //                         return TableRow(children: [
                      //                           TableCell(
                      //                               child: Padding(
                      //                             padding:
                      //                                 const EdgeInsets.all(8.0),
                      //                             child: Text(
                      //                                 e['name'].toString()),
                      //                           )),
                      //                           TableCell(
                      //                               child: Padding(
                      //                             padding:
                      //                                 const EdgeInsets.all(8.0),
                      //                             child: Text(e['totaldetails']
                      //                                 .toString()),
                      //                           ))
                      //                         ]);

                      //                     }).toList(),
                      //                   ),
                      //                 ));
                      //       },
                      //       child: Text("Select Topics")),
                      // ),

                      DropdownButtonFormField(
                          validator: (value) =>
                              value == null ? "Required" : null,
                          isDense: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(),
                            labelText: 'Select Topics',
                            isDense: true,
                          ),
                          isExpanded: true,
                          elevation: 8,
                          items: topicsList.map((e) {
                            return DropdownMenuItem(
                              child: SingleChildScrollView(
                                child: Card(
                                  elevation: 8,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e['name'].toString().toUpperCase(),
                                        ),
                                        Text(
                                          "No. of Remaining Questions : " +
                                              e['totaldetails'].toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // child: ListTile(

                              //   style: ListTileStyle.list,
                              //   title: Text(
                              //     e['name'].toString(),
                              //   ),
                              //   isThreeLine: true,
                              //   subtitle: Text(
                              //     "No. of Questions : " +
                              //         e['totaldetails'].toString(),
                              //     overflow: TextOverflow.ellipsis,
                              //     style: TextStyle(
                              //         fontWeight: FontWeight.bold,
                              //         fontSize: 16,
                              //         color: Colors.black),
                              //   ),
                              // ),
                              value: e,
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              topicSelect = true;
                              print(int.parse(val['totaldetails']
                                  .toString()
                                  .substring(
                                      0,
                                      val['totaldetails']
                                          .toString()
                                          .indexOf(" "))));
                              selectedTopicIndex = topicsList.indexOf(val);
                              currentSelectedTopicLen.clear();
                              currentSelectedTopicLen.addAll(
                                  new List<int>.generate(
                                      int.parse(val['totaldetails']
                                          .toString()
                                          .substring(
                                              0,
                                              val['totaldetails']
                                                  .toString()
                                                  .indexOf(" "))),
                                      (i) => i + 1));
                            });
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      topicSelect
                          ? currentSelectedTopicLen.length == 0
                              ? Text(
                                  "No. of Question is 0. Please select another topic.")
                              : Container(
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: DropdownButtonFormField(
                                            autofocus: true,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(14),
                                              border: OutlineInputBorder(),
                                              labelText: 'Select Que',
                                            ),
                                            isExpanded: true,
                                            value: 1,
                                            items: currentSelectedTopicLen
                                                .map((en) => DropdownMenuItem(
                                                      child:
                                                          Text(en.toString()),
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
                                  ),
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
                                                e['totaldetails']
                                                    .toString()
                                                    .substring(
                                                        0,
                                                        e['totaldetails']
                                                            .toString()
                                                            .indexOf(" "))),
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
              ]),
            ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: TextButton(
            onPressed: () {
              if (selectedTopicsArray.length == 0) {
                Fluttertoast.showToast(
                    msg: "Please select topics", gravity: ToastGravity.CENTER);
              } else {
                int totalSelectedQuestions = 0;
                List selectedQuestionMap = [];
                selectedTopicsArray.forEach((element) {
                  Map quesMap = {};
                  quesMap['topicid'] = element['topic_id'].toString();
                  quesMap['attempt'] = element['selected_question'].toString();
                  selectedQuestionMap.add(quesMap);
                  totalSelectedQuestions = totalSelectedQuestions +
                      int.parse(element['selected_question']);
                });
                Map map = {};
                map["student_id"] = student_id.toString();
                map["chapter_id"] = chapter_id.toString();
                map["total_question"] = totalSelectedQuestions.toString();
                map["topiclist"] = selectedQuestionMap;
                print(jsonEncode(map));
                ProgressBarLoading().showLoaderDialog(context);
                MCQLevelTestAPI().createSubjectiveTest(map).then((value) {
                  Navigator.of(context).pop();
                  if (value['ErrorCode'] == 0) {
                    value['total_qus'] = totalSelectedQuestions.toString();
                    value['chapter_id'] = chapter_id.toString();
                    Navigator.pushNamed(context, '/create-subjective',
                        arguments: value);
                  } else {
                    Fluttertoast.showToast(
                        msg: value['ErrorMessage'].toString());
                  }
                });
              }
            },
            child: Text(
              "Start Test",
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}
