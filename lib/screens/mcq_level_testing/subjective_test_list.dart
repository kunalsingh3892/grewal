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
  List data = [];
  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        user_id = prefs.getString('user_id').toString();
      });
      MCQLevelTestAPI()
          .getSubjectiveTestList(prefs.getString('user_id').toString())
          .then((value) {
        if (value.length > 0) {
          setState(() {
            data.addAll(value);
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
          title: Text("Subjective Tests (" + data.length.toString() + ")",
              style: normalText6),
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
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : data.length == 0
                ? Center(
                    child: Text(
                      "No Subjective Test Given",
                      style: normalText6,
                    ),
                  )
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: data
                            .map((e) => ListTile(
                                  title: Text(e['name'].toString()),
                                  subtitle: Text(e['created_at'].toString()),
                                  trailing: IconButton(
                                      onPressed: () {
                                        ProgressBarLoading()
                                            .showLoaderDialog(context);
                                        MCQLevelTestAPI()
                                            .getTotalQuestionCountofTest(
                                                user_id, e['id'].toString())
                                            .then((value) {
                                          Navigator.pop(context);
                                          if (value > 0) {
                                            Navigator.pushNamed(
                                              context,
                                              '/view-test',
                                              arguments: <String, String>{
                                                'test_id': e['id'].toString(),
                                                'total_question':
                                                    value.toString()
                                              },
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Test have no questions");
                                          }
                                        });
                                      },
                                      icon: Icon(
                                        Icons.visibility,
                                        color: Colors.green,
                                      )),
                                ))
                            .toList(),
                      ),
                    ),
                  ));
  }
}
