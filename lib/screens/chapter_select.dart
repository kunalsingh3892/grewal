import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/services/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class ChapterListScreen extends StatefulWidget {
  final Object argument;

  const ChapterListScreen({Key key, this.argument}) : super(key: key);

  @override
  _ChangePageState createState() => _ChangePageState();
}

class _ChangePageState extends State<ChapterListScreen> {
  Future<dynamic> _chapterData;
  bool _loading = false;
  var access_token;
  String api_token = "";
  bool showList = false;
  bool valuefirst = false;
  String user_id = "";
  String class_id = "";
  String board_id = "";
  String payment = '';
  String total_test_quetion = '';
  String _mobile = "";
  String email_id = '';
  String order_id = "";
  String profile_image = '';
  List<bool> isChecked = new List();

  List<String> list = [];
  String chapter_id = "";
  String chapter_name = "";
  String type = "";
  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    chapter_id = data['chapter_id'];
    chapter_name = data['chapter_name'];
    type = data['type'];
    _getUser();
  }

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        email_id = prefs.getString('email_id').toString();
        _mobile = prefs.getString('mobile_no').toString();
        user_id = prefs.getString('user_id').toString();
        order_id = prefs.getString('order_id').toString();
        class_id = prefs.getString('class_id').toString();
        board_id = prefs.getString('board_id').toString();
        profile_image = prefs.getString('profile_image').toString();
        total_test_quetion = prefs.getString('total_test').toString();
        payment = prefs.getString('payment').toString();
        api_token = prefs.getString('api_token').toString();
        _chapterData = _getChapterData();
      });
    });
  }
  var result;
  Future _getChapterData() async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/chapter"),
      body: {"board_id": board_id, "class_id": class_id, "subject_id": "8","student_id":user_id},
      headers: headers,
    );
    print({"board_id": board_id, "class_id": class_id, "subject_id": "8","student_id":user_id});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
       result = data['Response'];

      for (int i = 0; i < result.length; i++) {
        isChecked.add(false);
      }
      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Widget _emptyOrders() {
    return Center(
      child: Container(
          child: Text(
        'NO RECORDS FOUND!',
        style:
            TextStyle(fontSize: 20, letterSpacing: 1, color: Color(0xff2E2A4A)),
      )),
    );
  }

  Widget chapterList(Size deviceSize) {
    return FutureBuilder(
      future: _chapterData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['Response'].length != 0) {
            return Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: snapshot.data['Response'].length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xff2E2A4A).withOpacity(0.40)),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                  snapshot.data['Response'][index]
                                      ['chapter_name'],
                                  maxLines: 2,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: normalText5),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Center(
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 5, right: 5,),
                                child: Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor: Color(0xff2E2A4A),
                                  ),
                                  child: Checkbox(
                                    focusColor: Color(0xff2E2A4A),
                                    checkColor: Color(0xffffffff),
                                    activeColor: Color(0xff2E2A4A),
                                    value: isChecked[index],
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          isChecked[index] = value;
                                          if (isChecked[index] == true) {
                                              list.add( snapshot.data['Response'][index]['id']
                                                .toString());
                                            print(list);
                                          } else if (isChecked[index] ==
                                              false) {
                                             list.remove( snapshot.data['Response'][index]['id']
                                                .toString());
                                            print(list);
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ));
                  }),
            );
          } else {
            return _emptyOrders();
          }
        } else {
          return Center(child: Container(child: CircularProgressIndicator()));
        }
      },
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w300, color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));

  TextStyle next = GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
      letterSpacing: 1);

  Widget _networkImage1(url) {
    return Container(
      margin: EdgeInsets.only(
        right: 8,
        left: 8,
      ),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffffffff),
        image: DecorationImage(
          image: NetworkImage(profile_image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
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
        centerTitle: false,
        title: Align(
          alignment: Alignment.topLeft,
          child: Container(
            child: Text("Select Chapter", style: normalText6),
          ),
        ),
        flexibleSpace: Container(
          height: 120,
          color: Color(0xffffffff),
        ),
        actions: <Widget>[
          Row(
            children: [
              Text("Select All", style: normalText7),
              Container(
                padding: EdgeInsets.only(

                  right: 10,
                ),
                child: Theme(
                  data: ThemeData(
                    unselectedWidgetColor: Color(0xff2E2A4A),
                  ),
                  child: Checkbox(
                    focusColor: Color(0xff2E2A4A),
                    checkColor: Color(0xffffffff),
                    activeColor: Color(0xff2E2A4A),
                    value: this.valuefirst,
                    onChanged: (bool value) {
                      setState(() {
                        isChecked.clear();
                        list.clear();
                        this.valuefirst = value;

                        if (valuefirst == true) {
                          for (int i = 0; i < result.length; i++) {
                          isChecked.add(true);
                          list.add(result[i]['id'].toString());
                          print(isChecked);
                          print(list);
                        }
                        } else if (valuefirst == false) {
                           for (int i = 0; i < result.length; i++) {
                          isChecked.add(false);
                          list.remove(result[i]['id'].toString());
                          print(isChecked);
                          print(list);
                        }
                          /*  if (isChecked.contains(true)) {
                          enable = true;
                        }
                        else {
                          enable = false;
                        }*/
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          )
        ],
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: deviceSize.width * 0.02,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  height: 15.0,
                ),
                Expanded(child: Container(child: chapterList(deviceSize))),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(right: 8.0, left: 8, bottom: 20),
                  child: ButtonTheme(
                    height: 28.0,
                    minWidth: MediaQuery.of(context).size.width * 0.80,
                    child: RaisedButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      textColor: Colors.white,
                      color: Color(0xff017EFF),
                      onPressed: () async {
                        if(list.length != 0){
                          for (int i = 0; i < list.length; i++) {
                            if (i == (list.length - 1)) {
                              chapter_id = chapter_id + list[i].toString();
                            } else {
                              chapter_id = chapter_id + list[i].toString() + ",";
                            }
                          }
                          Navigator.pushNamed(
                            context,
                            '/create-mcq',
                            arguments: <String, String>{
                              'chapter_id': chapter_id.toString(),
                              'chapter_name': chapter_name.toString(),
                              'type': type
                            },
                          );

                        }
                        else{
                          Fluttertoast.showToast(msg: "Please Select any chapter.");
                        }
                      },
                      child: Text("Continue", style: next),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
