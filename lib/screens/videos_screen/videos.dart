import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/color_constants.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';



class VideosList extends StatefulWidget {
  final Object argument;

  const VideosList({Key key, this.argument}) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<VideosList> {
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

  String profile_image = '';
  List<UserDetails> _userDetails = [];
  List<UserDetails> _searchResult = [];
  String user_id="";
  String class_id="";
  String board_id="";
  String payment = '';
  String total_test_quetion = '';
  String _mobile = "";
  String email_id = '';
  String order_id = "";
  String chapter_id = "";
  String api_token = "";
  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    chapter_id = data['chapter_id'];
    _getUser();



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
        _chapterData= _getChapterData();
      });
    });
  }

  Widget _networkImage(url) {
    return Image(
      image: NetworkImage(url),
    );
  }
  List<bool> showExpand = new List();
  Future _getChapterData() async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.http(BASE_URL, API_PATH + "/chapterwisevideos"),
      body: {
        "user_id":user_id,
        "chapter_id":chapter_id,
      },
      headers: headers,

    );
    print({
      "user_id":user_id,
      "chapter_id":chapter_id,
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];

      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }
  String getYoutubeVideoId(String url) {
    RegExp regExp = new RegExp(
      r'.*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/)|(?:(?:watch)?\?v(?:i)?=|\&v(?:i)?=))([^#\&\?]*).*',
      caseSensitive: false,
      multiLine: false,
    );
    final match = regExp.firstMatch(url).group(1); // <- This is the fix
    String str = match;
    return str;
  }

  Widget chapterList(Size deviceSize) {
    return FutureBuilder(
      future: _chapterData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var response = snapshot.data['Response'];
          var errorCode = snapshot.data['ErrorCode'];
          if (errorCode == 0) {
            return GridView.count(
                shrinkWrap: true,
                // primary: false,
                crossAxisCount: 2,
                padding: const EdgeInsets.only(
                    left: 15, right: 15, bottom: 10, top: 3),
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
                children:
                List.generate(response.length, (index) {
                  return InkWell(
                      onTap: () {


                          Navigator.pushNamed(
                            context,
                            '/videos-detail',

                            arguments: <String, String>{
                              '_youtube_id': getYoutubeVideoId(response[index]['video_link']),
                              '_heading': response[index]['topic'],
                            },

                          );


                      },
                      child: Column(children: [
                        Stack(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height * 0.15,
                                padding: const EdgeInsets.only(
                                    left: 3, right: 3, bottom: 3, top: 3),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Color(0xff2E2A4A).withOpacity(0.80)),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(0.0))),
                                child: Container(
                                  child: Image(
                                      image: CachedNetworkImageProvider(
                                          'https://img.youtube.com/vi/'+getYoutubeVideoId(response[index]['video_link'])+'/0.jpg'),
                                      fit: BoxFit.fill,
                                      width: 1000.0),
                                ),
                              ),
                              Positioned(
                                  right: 0,
                                  left: 0,
                                  bottom: 0,
                                  top: 0,
                                  child: Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.white.withOpacity(0.8),
                                      shape: BoxShape.circle,
                                    ),

                                    margin: EdgeInsets.symmetric(
                                        vertical: 40, horizontal: 40),

                                    child: Center(
                                      child: Container(
                                        width: 35,
                                        height: 35,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical:5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(20.0),
                                            image: DecorationImage(
                                                image: AssetImage('assets/images/play.png'),
                                                fit: BoxFit.fill)
                                        ),
                                      ),

                                    ),
                                  ))
                            ]),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                response[index]['topic'],
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Color(0xff2E2A4A), fontSize: 12),
                              ),
                            ),
                          ),
                        ),


                      ]));
                }));
          }
          else {
            return  _emptyOrders();
          }

        }  else {
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
            'NO RECORDS FOUND!',
            style: TextStyle(fontSize: 20, letterSpacing: 1, color: Color(0xff2E2A4A)),
          )),
    );
  }



  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          leading:Row(children: <Widget>[
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
          centerTitle: true,
          title: Container(
            child: Text("Videos", style: normalText6),
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
        body:ModalProgressHUD(
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

                  /*  Container(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                      margin: EdgeInsets.only( bottom: 10),
                      child: Row(children: <Widget>[
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: new TextField(
                                enabled: true,
                                controller: completeController,
                                decoration: InputDecoration(
                                  fillColor: Color(0xfff9f9fb),
                                  filled: true,
                                  contentPadding:
                                  EdgeInsets.fromLTRB(10, 30, 30, 0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  counterText: "",
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Color(0xff200E32),
                                    size: 24,
                                  ),
                                  hintStyle: TextStyle(
                                      color: Color(0xffBBBFC3), fontSize: 16),
                                  hintText: 'Search your chapters... ',
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.black,
                                textCapitalization: TextCapitalization.none,
                                onChanged: onSearchTextChanged,
                              ),
                            ),
                          ),
                        ),
                        *//* SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.20,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        height: 15,
                        child: Image(
                            image: AssetImage('assets/images/filter.png'),
                            height: 15,
                            width: 15,
                            fit: BoxFit.fill),
                      ),*//*
                      ]),
                    ),
*/
                    Expanded(child:
                    Container(
                      padding: EdgeInsets.only(bottom: 5),
                      child: chapterList(deviceSize),
                    ),

                    ),

                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              )),
        )
    );
  }
  onSearchTextChanged(String text) async {
    print(text);
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.chapter_name
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase())) _searchResult.add(userDetail);
    });
    print(_searchResult);

    setState(() {});
  }
}

class UserDetails {
  final String id,
      chapter_name,
      short_description;

  UserDetails(
      {this.id,
        this.chapter_name,
        this.short_description,
      });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return new UserDetails(
        id: json['id'].toString(),
        chapter_name: json['chapter_name'].toString(),
        short_description: json['short_description'].toString());
  }
}