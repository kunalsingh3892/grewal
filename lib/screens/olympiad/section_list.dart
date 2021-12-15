import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/color_constants.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';


class SectionList extends StatefulWidget {
  final Object argument;

  const SectionList({Key key, this.argument}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SectionList> {
  bool _value = false;
  Future _chapterData;
  bool isLoading = false;
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff2E2A4A));
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w300, color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  final completeController = TextEditingController();

  String user_id = "";
  String test_id = "";
  String chapter_name = "";
  String type = "";
  String profile_image = '';
  String payment = '';
  String total_test_quetion = '';
  String _mobile = "";
  String email_id = '';
  String order_id = "";
  bool testfinal = false;
  bool showResult = false;
  String api_token = "";
  bool showTimer=false;
  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    test_id = data['test_id'];
    _getUser();
  }

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        email_id = prefs.getString('email_id').toString();
        _mobile = prefs.getString('mobile_no').toString();
        user_id = prefs.getString('user_id').toString();
        order_id = prefs.getString('order_id').toString();
        profile_image = prefs.getString('profile_image').toString();
        api_token = prefs.getString('api_token').toString();
        _chapterData = _getChapterData();
      });
    });
  }

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

  Widget _networkImage(url) {
    return Image(
      image: NetworkImage(url),
    );
  }

  Future _getChapterData() async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/test-details-olympiad"),
      body: {
        "user_id": user_id,
        "test_id":test_id,
      },
      headers: headers,
    );

    print(jsonEncode({
      "user_id": user_id,
      "test_id":test_id,
    }));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if(data['ErrorCode']==0){

        setState(() {
          if(data['Response']['testinfo']['testfinal']==0) {
            for (int i = 0; i < data['Response']['section'].length; i++) {
              if (data['Response']['section'][i]['testdone'] == 1) {
                testfinal = true;
              }
              else {
                testfinal = false;
              }
            }
          }
          else{
            testfinal = false;
            showResult=true;
          }

        });

      }
      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }
  Widget chapterList(Size deviceSize) {
    return FutureBuilder(
      future: _chapterData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['Response']['section'].length != 0) {
            return Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: snapshot.data['Response']['section'].length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (snapshot.data['Response']['section'][index]['testdone'] ==
                            0) {
                          Navigator.pushNamed(
                            context,
                            '/start-test-new',
                            arguments: <String, String>{
                              'test_id':test_id,
                              'section_id': snapshot.data['Response']['section'][index]['section_id'].toString(),
                              'time':(snapshot.data['Response']['section'][index]['question_attempt']*120).toString(),

                            },
                          );
                        } else {
                          Navigator.pushNamed(
                            context,
                            '/review-test',
                            arguments: <String, String>{
                              'test_id':test_id,
                              'section_id': snapshot.data['Response']['section'][index]['section_id'].toString(),

                            },
                          );
                        }
                      },
                      child: Column(children: <Widget>[
                        Stack(children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10),
                            color: Color(0xffF9F9FB),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Center(
                                    child: Container(
                                      //  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                      height: 50,
                                      width: 50,
                                      decoration: new BoxDecoration(
                                        // color: Color(0xffF6F6F6),
                                          borderRadius: new BorderRadius.only(
                                              topLeft:
                                              const Radius.circular(5.0),
                                              bottomLeft:
                                              const Radius.circular(5.0),
                                              bottomRight:
                                              const Radius.circular(5.0),
                                              topRight: const Radius.circular(
                                                  5.0))),
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xff017EFF),
                                        radius: 40,
                                        child: Image(
                                          image: AssetImage(
                                            'assets/images/ribbon.png',
                                          ),
                                          height: 22.0,
                                          width: 22.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      /*   child: Center(
                                                      child: Text(
                                                        snapshot
                                                            .data['Response'][index]['chapter_name'][0]
                                                            .toUpperCase(),
                                                        style: TextStyle(fontSize: 30.0,
                                                            color: Color(0xff017EFF),),
                                                      ),
                                                    ),*/
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                  snapshot.data['Response']['section']
                                                  [index]['name'],
                                                  maxLines: 2,
                                                  softWrap: true,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  style: normalText5),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Icon(
                                    Icons.arrow_right,
                                    color: Color(0xff017EFF),
                                    size: 20,
                                  )
                                ]),
                          ),

                        ]),


                      ]),
                    );
                  }),
            );
          } else {
            return _emptyOrders();
          }
        } else {
          return Center(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  child: SpinKitFadingCube(
                    itemBuilder: (_, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: index.isEven ? Color(0xff017EFF) :Color(0xffFFC700),
                        ),
                      );
                    },
                    size: 30.0,
                  ),
                ),
              ));
        }
      },
    );
  }

  Widget _emptyOrders() {
    return Center(
      child: Container(
          child: Text(
            'NO SECTION FOUND!',
            style:
            TextStyle(fontSize: 20, letterSpacing: 1, color: Color(0xff2E2A4A)),
          )),
    );
  }
  TextStyle next = GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
      letterSpacing: 1);


  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
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
          title: Container(
            child: Text("Section Lists", style: normalText6),
          ),
          flexibleSpace: Container(
            height: 100,
            color: Color(0xffffffff),
          ),
          actions: <Widget>[
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: _networkImage1(
                  profile_image,
                ),
              ),
            ),
          ],
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Colors.transparent,
        ),

        body: LayoutBuilder(
        builder: (context, constraints) {


         return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: deviceSize.width * 0.02,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[

                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 5,top: 10),
                          child: chapterList(deviceSize),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      testfinal?
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
                              // if (type == "inside") {
                              setState(() {
                                isLoading = true;
                              });
                              final msg = jsonEncode({
                                "test_id": test_id,
                                "user_id": user_id,
                              });
                              Map<String, String> headers = {
                                'Accept': 'application/json',
                                'Authorization': 'Bearer $api_token',
                              };
                              var response = await http.post(
                                new Uri.https(
                                    BASE_URL,
                                    API_PATH + "/finish-test-olympiad-final"),
                                body: {
                                  "test_id": test_id,
                                  "user_id": user_id,

                                },
                                headers: headers,
                              );
                              print(msg);

                              if (response.statusCode == 200) {
                                setState(() {
                                  isLoading = false;
                                });
                                var data = json.decode(response.body);
                                print(data);
                                var errorCode = data['ErrorCode'];
                                var errorMessage = data['ErrorMessage'];

                                if (errorCode == 0) {
                                  setState(() {
                                    isLoading = false;
                                  });

                                  Fluttertoast.showToast(msg: errorMessage);
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                    context,
                                    '/olympiad-performance',
                                    arguments: <String, String>{
                                      'test_id': test_id,

                                    },
                                  );

                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  showAlertDialog(
                                      context, ALERT_DIALOG_TITLE,
                                      errorMessage);
                                }
                              }

                            },
                            child: Text("SUBMIT TEST", style: next),
                          ),
                        ),
                      ):Container(),
                      showResult? Container(
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
                              setState(() {

                              });
                              Navigator.pushNamed(
                                context,
                                '/olympiad-performance',
                                arguments: <String, String>{
                                  'test_id': test_id,

                                },
                              );

                            },
                            child: Text("View Result", style: next),
                          ),
                        ),
                      ):Container(),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                )),
          );
        }

        ));
  }
}
