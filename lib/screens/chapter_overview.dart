import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/color_constants.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constants.dart';

class ChapterOverview extends StatefulWidget {
  final Object argument;

  const ChapterOverview({Key key, this.argument}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<ChapterOverview> {
  bool _value = false;
  String chapter_id = "";
  bool _loading = false;
  String profile_image = '';
  Future _chapterData;
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  TextStyle normalText4 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText3 = GoogleFonts.montserrat(
      fontSize: 15, fontWeight: FontWeight.w400, decoration: TextDecoration.underline,color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  String api_token = "";
  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    chapter_id = data['chapter_id'];
    _getUser();
  }
  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
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

  Future _getChapterData() async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/chapter-overview"),
      body: {"chapter_id": chapter_id.toString()},
      headers: headers,
    );
    print({"chapter_id": chapter_id.toString()});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }
  Widget _networkImage(url) {
    return Image(
      image: CachedNetworkImageProvider(url),
    );
  }
  Widget _chapterBuilder(Size deviceSize) {
    return FutureBuilder(
      future: _chapterData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var errorCode = snapshot.data['ErrorCode'];
          var response = snapshot.data['Response'];
          if (errorCode == 0) {
            return Container(
              child: ListView(
                children: <Widget>[
                  Container(
                      height: 200,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Color(0xffF6F6F6),
                      ),
                      child: response[0]['image']!=null?Container(
                        decoration: new BoxDecoration(
                           // color: Color(0xffF6F6F6),
                            borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(5.0),
                                bottomLeft: const Radius.circular(5.0),
                                bottomRight: const Radius.circular(5.0),
                                topRight: const Radius.circular(5.0))),
                          child:  _networkImage(snapshot.data['url']+response[0]['image'],
                      ),
                      ):Container(height: 200,)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    // height: MediaQuery.of(context).size.height * 0.75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Text(response[0]['chapter_name'], style: normalText5),
                        SizedBox(
                          height: 10,
                        ),
                        Text(response[0]['overview'], style: normalText4),
                        SizedBox(
                          height: 50,
                        ),
                        InkWell(
                          onTap: (){
                            if(response[0]['pdf']!=null) {
                              Navigator.pushNamed(
                                context,
                                '/open-pdf',

                                arguments: <String, String>{
                                  'dataSet': snapshot.data['url'] +
                                      response[0]['pdf'],

                                },

                              );
                            }

                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text("View Attachment", style: normalText3)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
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
          child: Text("Chapter Overview", style: normalText6),
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
      body: Container(
        color: Colors.white,
        child: /*Center(
          child: Container(

              child: Text('COMING SOON...',style: TextStyle(color: Color(0xff2E2A4A)),)),
        )*/ Column(children: <Widget>[

          Expanded(
            child: ModalProgressHUD(
              inAsyncCall: _loading,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: deviceSize.width * 0.03,
                  vertical: 10
                ),
                child: _chapterBuilder(deviceSize),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
