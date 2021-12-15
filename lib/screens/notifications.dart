import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  var _userId;
  String profile_image = '';
  String user_id = "";
  String api_token = "";
  Future _notificationData;
  @override
  void initState() {
    super.initState();
    _getUser();
  }



  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 17, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 13,
      fontWeight: FontWeight.w300,
      color: Color(0xff2E2A4A).withOpacity(0.60));

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        profile_image = prefs.getString('profile_image').toString();
        user_id = prefs.getString('user_id').toString();
        api_token = prefs.getString('api_token').toString();
        _notificationData=_getNotificationData();
      });
    });
  }

  Future _getNotificationData() async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/notification-list"),
      body: {
        "user_id": user_id,
      },
      headers: headers,
    );

    print(jsonEncode({
      "user_id": user_id,
    }));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Widget notificationsListBuilder() {
    return FutureBuilder(
      future: _notificationData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var errorCode = snapshot.data['ErrorCode'];
          var response = snapshot.data['Response'];
          if (errorCode == 0) {
            return ListView.builder(
              itemCount: response.length,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    Map<String, String> headers = {
                      // 'Content-Type': 'application/json',
                      'Accept': 'application/json',
                      'Authorization': 'Bearer $api_token',
                    };
                    var response1 = await http.post(
                      new Uri.https(BASE_URL, API_PATH + "/notification-update"),
                      body: {
                        "user_id": user_id,
                        "notification_id": response[index]['id'].toString(),
                      },
                      headers: headers,
                    );

                    print(jsonEncode({
                      "user_id": user_id,
                      "notification_id": response[index]['id'].toString(),
                    }));
                    if (response1.statusCode == 200) {
                      var data = json.decode(response1.body);

                      setState(() {
                        _notificationData=_getNotificationData();
                      });

                    } else {
                      throw Exception('Something went wrong');
                    }

                  },
                  child: Column(children: <Widget>[
                    Container(
                      color: response[index]['view']==0?Color(0xff017EFF).withOpacity(0.05):Colors.white,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 5.0),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Text(
                                    response[index]['date'],
                                    style: normalText7,
                                  ))),
                          ListTile(
                            dense:true,
                            title: Text(
                              response[index]['subject']??'',
                              style: normalText5,
                            ),
                            subtitle: Text(
                              response[index]['message']??'',
                              style: normalText7,
                            ),
                          ),
                          response[index]['image'] != ""
                              ? Container(
                                  margin: EdgeInsets.only(
                                    right: 8,
                                    left: 8,
                                  ),
                                  height: 150,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            response[index]['image']),
                                        fit: BoxFit.cover),
                                  ),
                                )
                              : Container(),
                          const SizedBox(height: 5.0),
                        ],

                      ),
                    ),
                    const SizedBox(height: 15.0),
                  ]),
                );
              },
            );
          } else {
            return _emptyNotification();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _emptyNotification() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 150,
              width: 150,
              margin: const EdgeInsets.only(bottom: 20),
              child: Image.asset("assets/images/notify_bell.png"),
            ),
            Text(
              "No Notifications Yet!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));

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
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(false);
        Navigator.pushNamed(context, '/dashboard');
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
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
                  Navigator.pushNamed(context, '/dashboard');
                },
              ),
            ]),
          ),
          centerTitle: true,
          title: Container(
            child: Text("Notifications", style: normalText6),
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const SizedBox(height: 15.0),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 5),
                child: notificationsListBuilder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
