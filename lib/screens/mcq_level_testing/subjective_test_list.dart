import 'dart:convert';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/api/create_test_api.dart';
import 'package:grewal/components/progress_bar.dart';
import 'package:grewal/screens/mcq_level_testing/subjective_test.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:grewal/components/progress_bar.dart';

class SubjectiveTestListGiven extends StatefulWidget {
  final Object argument;

  const SubjectiveTestListGiven({Key key, this.argument}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SubjectiveTestListGiven> {
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

  bool isLoading = true;
  String chapter_id = "";
  String user_id = "";
  Future data;
  String totalSubjects = "0";
  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        user_id = prefs.getString('user_id').toString();
        data = _getData();
      });
    });
  }

  Future _getData() async {
    return MCQLevelTestAPI().getSubjectiveTestList(user_id, chapter_id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(json.encode(widget.argument));
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    chapter_id = data['chapter_id'];
    print(chapter_id);
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
          title: Text("Subjective Tests", style: normalText6),
          flexibleSpace: Container(
            height: 100,
            color: Color(0xffffffff),
          ),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Colors.transparent,
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //     backgroundColor: Colors.blue,
        //     onPressed: () {
        //       Navigator.pushNamed(
        //         context,
        //         '/subjective_test',
        //         arguments: <String, String>{
        //           'chapter_id': chapter_id.toString()
        //         },
        //       );
        //     },
        //     label: Text("Create Subjective Test")),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blue,
          child: TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/subjective_test',
                  arguments: <String, String>{
                    'chapter_id': chapter_id.toString()
                  },
                );
              },
              child: Text(
                "Create Subjective Test",
                style: TextStyle(color: Colors.white),
              )),
        ),
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                  future: _getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title:
                                  Text(snapshot.data[index]['name'].toString()),
                              subtitle: Text(snapshot.data[index]['created_at']
                                  .toString()),
                              trailing: snapshot.data[index]['is_taken'] == 1
                                  ? IconButton(
                                      onPressed: () {
                                        ProgressBarLoading()
                                            .showLoaderDialog(context);
                                        MCQLevelTestAPI()
                                            .getTotalQuestionCountofTest(
                                                user_id,
                                                snapshot.data[index]['id']
                                                    .toString())
                                            .then((value) {
                                          Navigator.pop(context);
                                          if (value > 0) {
                                            Navigator.pushNamed(
                                              context,
                                              '/view-performance-new',
                                              arguments: <String, String>{
                                                'test_id': snapshot.data[index]
                                                        ['id']
                                                    .toString(),
                                                'type': "",
                                                'total_ques': "".toString(),
                                                "chapter_id":
                                                    chapter_id.toString(),
                                                "testType": "sub",
                                                "nob": "1"
                                              },
                                            );

                                            // Navigator.pushNamed(
                                            //   context,
                                            //   '/view-test-new',
                                            //   arguments: <String, String>{
                                            //     'test_id': snapshot.data[index]
                                            //             ['id']
                                            //         .toString(),
                                            //     'total_question':
                                            //         value.toString()
                                            //   },
                                            // );
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Test have no questions");
                                          }
                                        });
                                      },
                                      icon: Icon(
                                        Icons.visibility,
                                        color: Colors.green,
                                      ))
                                  : TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/start-subjective-test',
                                            arguments: {
                                              "ErrorCode": 0,
                                              "ErrorMessage": "Success",
                                              "Response": {
                                                "testId": snapshot.data[index]
                                                    ['id'],
                                                "TestQuestionId":
                                                    snapshot.data[index]
                                                        ['test_question_id']
                                              },
                                              "chapter_id": snapshot.data[index]
                                                      ['chapter']
                                                  .toString()
                                            });
                                      },
                                      child: Text("Re-Attempt")),
                            );
                          },
                        );
                      } else {
                        return Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: ListTile(
                              title: Text("Note : "),
                              subtitle: Text(
                                "Subjective questions on this platform are a combination of technology embedded assesment (in form of MCQ) and then self-assessment (complete detailed solution).Students attempting a subjective question will be required to solve the complete question and then enter their answer to the MCQs carved out of the subjective question for assessment to take place. Thereafter, on submitting the answer on the platform, they will be able to view the complete solution for self-assessment in terms of whether they have adhered to the format and figures correctly.",
                                textAlign: TextAlign.justify,
                              ),
                            ));
                      }
                    } else {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Loading"),
                            SizedBox(
                              height: 10,
                            ),
                            CircularProgressIndicator(),
                          ],
                        ),
                      );
                    }
                  })),
        ));
  }
}
