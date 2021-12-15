import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/color_constants.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class TicketDetails extends StatefulWidget {
  final Object argument;

  const TicketDetails({Key key, this.argument}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<TicketDetails> {
  bool _value = false;
  Future _chapterData;
  bool isLoading = false;
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff2E2A4A));
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText3 = GoogleFonts.montserrat(
      fontSize: 10, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText2 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xffBBBFC3));
  TextStyle normalText1 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w400, color: Colors.white);
  TextStyle normalText4 = GoogleFonts.montserrat(
      fontSize: 10, fontWeight: FontWeight.w400, color: Colors.white);
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  TextStyle normalText8 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff2E2A4A));
  TextStyle normalText9 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white);
  final completeController = TextEditingController();

  String user_id = "";
  String ticket_id = "";
  String subject = "";
  String type = "";
  String profile_image = '';

  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    ticket_id = data['ticket_id'];

    _getUser();
  }
  String api_token = "";
  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        user_id = prefs.getString('user_id').toString();
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
      new Uri.https(BASE_URL, API_PATH + "/student_generate_ticket_details"),
      body: {"ticket_id": ticket_id},
      headers: headers,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      setState(() {
        subject = data['ticket_info']['subject'];
      });

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
          if (snapshot.data['ErrorCode'] == 0) {
            return Column(children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Flex(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6,
                              ),
                              padding: EdgeInsets.all(12.0),
                              decoration: new BoxDecoration(
                                  color: Color(0xff017EFF),
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(20.0),
                                    topRight: const Radius.circular(20.0),
                                    bottomLeft: const Radius.circular(20.0),
                                  )),
                              child: Column(children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: new Text(
                                    "${snapshot.data['student_message']['reply_message']}",
                                    style: normalText1,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    child: new Text(
                                      "${snapshot.data['student_message']['created_at']}",
                                      style: normalText4,
                                    ),
                                  ),
                                )
                              ]),
                            )
                          ],
                        )
                      ],
                    )),
              ]),
              Container(
                margin: EdgeInsets.only(bottom: 100),
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: snapshot.data['Chat_Response'].length,
                    itemBuilder: (context, index) {
                      return Row(
                          mainAxisAlignment: snapshot.data['Chat_Response']
                                      [index]['by_reply'] ==
                                  "user"
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          children: <Widget>[
                            new Column(
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: <Widget>[
                                        snapshot.data['Chat_Response'][index]
                                                    ['by_reply'] ==
                                                "user"
                                            ? Flex(
                                                direction: Axis.horizontal,
                                                children: <Widget>[
                                                  Container(
                                                    constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.6,
                                                    ),
                                                    padding:
                                                        EdgeInsets.all(12.0),
                                                    decoration:
                                                        new BoxDecoration(
                                                            color: Color(
                                                                0xffF9F9FB),
                                                            borderRadius:
                                                                new BorderRadius
                                                                    .only(
                                                              topLeft: const Radius
                                                                      .circular(
                                                                  20.0),
                                                              topRight: const Radius
                                                                      .circular(
                                                                  20.0),
                                                              bottomRight:
                                                                  const Radius
                                                                          .circular(
                                                                      20.0),
                                                            )),
                                                    child: Column(children: <
                                                        Widget>[
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  2.0),
                                                          child: new Text(
                                                            "${snapshot.data['Chat_Response'][index]['username']}",
                                                            style: normalText8,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(5.0),
                                                        child: new Text(
                                                          "${snapshot.data['Chat_Response'][index]['reply_message']}",
                                                          style: normalText7,
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Container(
                                                          child: new Text(
                                                            "${snapshot.data['Chat_Response'][index]['created_at']}",
                                                            style: normalText3,
                                                          ),
                                                        ),
                                                      )
                                                    ]),
                                                  )
                                                ],
                                              )
                                            : Flex(
                                                direction: Axis.horizontal,
                                                children: <Widget>[
                                                  Container(
                                                    constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.6,
                                                    ),
                                                    padding:
                                                        EdgeInsets.all(12.0),
                                                    decoration:
                                                        new BoxDecoration(
                                                            color: Color(
                                                                0xff017EFF),
                                                            borderRadius:
                                                                new BorderRadius
                                                                    .only(
                                                              topLeft: const Radius
                                                                      .circular(
                                                                  20.0),
                                                              topRight: const Radius
                                                                      .circular(
                                                                  20.0),
                                                              bottomLeft:
                                                                  const Radius
                                                                          .circular(
                                                                      20.0),
                                                            )),
                                                    child: Column(children: <
                                                        Widget>[
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  2.0),
                                                          child: new Text(
                                                            "${snapshot.data['Chat_Response'][index]['username']}",
                                                            style: normalText9,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(5.0),
                                                        child: new Text(
                                                          "${snapshot.data['Chat_Response'][index]['reply_message']}",
                                                          style: normalText1,
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Container(
                                                          child: new Text(
                                                            "${snapshot.data['Chat_Response'][index]['created_at']}",
                                                            style: normalText4,
                                                          ),
                                                        ),
                                                      )
                                                    ]),
                                                  )
                                                ],
                                              )
                                      ],
                                    )),
                              ],
                            )
                          ]);
                    }),
              ),
            ]);
          } else {
            return _emptyOrders();
          }
        } else {
          return Center(child: Container(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _emptyOrders() {
    return Center(
      child: Container(
          child: Text(
        'NO CHAT FOUND!',
        style:
            TextStyle(fontSize: 20, letterSpacing: 1, color: Color(0xff2E2A4A)),
      )),
    );
  }

  final TextEditingController _chatController = new TextEditingController();

  Widget _chatEnvironment() {
    return IconTheme(
      data: new IconThemeData(color: Color(0xffBBBFC3)),
      child: new Container(
        decoration: new BoxDecoration(
            color: Color(0xfff9f9fb),
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(25.0),
              topRight: const Radius.circular(25.0),
              bottomLeft: const Radius.circular(25.0),
              bottomRight: const Radius.circular(25.0),
            )),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: new Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  child: new TextField(
                    minLines: 1,
                    maxLines: 5,
                    decoration: new InputDecoration.collapsed(
                        hintText: ('Message here...'), hintStyle: normalText2),
                    controller: _chatController,
                    // onSubmitted: _handleSubmit,
                  ),
                ),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Center(
                  child: Container(
                    //  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                    height: 30,
                    width: 30,
                    decoration: new BoxDecoration(
                        // color: Color(0xffF6F6F6),
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(5.0),
                            bottomLeft: const Radius.circular(5.0),
                            bottomRight: const Radius.circular(5.0),
                            topRight: const Radius.circular(5.0))),
                    child: CircleAvatar(
                      backgroundColor: Color(0xff017EFF),
                      radius: 30,
                      child: Image(
                        image: AssetImage(
                          'assets/images/up.png',
                        ),
                        height: 12.0,
                        width: 12.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
            child: Text(subject,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: normalText6),
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
        body: ModalProgressHUD(
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
                        padding: EdgeInsets.only(bottom: 5),
                        child: chapterList(deviceSize),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    new Container(
                      child: _chatEnvironment(),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              )),
        ));
  }
}
