import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/api/data_list.dart';
import 'package:grewal/components/color_constants.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import '../constants.dart';

class ChapterList extends StatefulWidget {
  final String modal;
  final Map term;
  ChapterList(this.modal, this.term);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<ChapterList> {
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
  String user_id = "";
  String class_id = "";
  String board_id = "";
  String payment = '';
  String total_test_quetion = '';
  String _mobile = "";
  String email_id = '';
  String order_id = "";
  String api_token = "";
  String term = "";
  String term_id = "";
  @override
  void initState() {
    super.initState();

    setState(() {
      if (widget.term.containsKey("id")) {
        print("if");
        term = widget.term['term'].toString();
        term_id = widget.term['id'].toString();
        _getUser(term_id.toString());
      }
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

  _getUser(terms_ids) async {
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
        _chapterData = _getChapterData(terms_ids);
      });
    });
  }

  Widget _networkImage(url) {
    return Image(
      image: NetworkImage(url),
    );
  }

  List<bool> showExpand = new List();
  Future _getChapterData(String terms_ids) async {
    _searchResult.clear();
    _userDetails.clear();
    completeController.text = "";
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/chapter"),
      body: {
        "board_id": board_id,
        "class_id": class_id,
        "subject_id": terms_ids,
        "student_id": user_id
      },
      headers: headers,
    );
    print(jsonEncode({
      "board_id": board_id,
      "class_id": class_id,
      "subject_id": terms_ids,
      "student_id": user_id
    }));
    print(response.body);
    print({
      "board_id": board_id,
      "class_id": class_id,
      "subject_id": term_id.toString(),
      "student_id": user_id
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      setState(() {
        for (Map user in result) {
          _userDetails.add(UserDetails.fromJson(user));
        }
      });
      for (int i = 0; i < data['Response'].length; i++) {
        showExpand.add(false);
      }
      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Widget _buildWikiCategory(
      String icon, String label, Color color, Color circle_color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

      // height: 100,
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: circle_color,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: color,
            radius: 20,
            child: Image(
              image: AssetImage(icon),
              height: 18.0,
              width: 18.0,
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              label,
              maxLines: 3,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget chapterList(Size deviceSize) {
    return FutureBuilder(
      future: _chapterData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['Response'].length != 0) {
            return _searchResult.length != 0 ||
                    completeController.text.isNotEmpty
                ? Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _searchResult.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                showExpand[index] = !showExpand[index];
                              });
                            },
                            child: Column(children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10),
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      /* Container(
                                      //  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                      height: 60,
                                      width: 60,
                                      decoration: new BoxDecoration(
                                          color: Color(0xffF6F6F6),
                                          borderRadius: new BorderRadius.only(
                                              topLeft: const Radius.circular(5.0),
                                              bottomLeft: const Radius.circular(5.0),
                                              bottomRight: const Radius.circular(5.0),
                                              topRight: const Radius.circular(5.0))),
                                      child: */ /*_networkImage(snapshot.data['url']+snapshot.data['Response'][index]['image']),*/ /*
                                      Center(
                                        child: Text(
                                          _searchResult[index].chapter_name[0]
                                              .toUpperCase(),
                                          style: TextStyle(fontSize: 30.0,
                                            color: Color(0xff017EFF),),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12.0,
                                    ),*/
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                      _searchResult[index]
                                                          .chapter_name,
                                                      maxLines: 3,
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: normalText5),
                                                ),
                                                showExpand[index]
                                                    ? Icon(
                                                        Icons
                                                            .arrow_drop_up_outlined,
                                                        color:
                                                            Color(0xff017EFF),
                                                        size: 24,
                                                      )
                                                    : Icon(
                                                        Icons.arrow_drop_down,
                                                        color:
                                                            Color(0xff017EFF),
                                                        size: 24,
                                                      ),
                                              ],
                                            ),
                                            Container(
                                              child: Text(
                                                  _searchResult[index]
                                                      .short_description,
                                                  maxLines: 2,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: normalText7),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                              ),
                              showExpand[index]
                                  ? Column(
                                      children: [
                                        const SizedBox(height: 5),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              bottom: 5,
                                              top: 5),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/chapter-overview',
                                                      arguments: <String,
                                                          String>{
                                                        'chapter_id':
                                                            _searchResult[index]
                                                                .id
                                                                .toString(),
                                                      },
                                                    );
                                                  },
                                                  child: _buildWikiCategory(
                                                      "assets/images/video_icon.png",
                                                      "Chapter Overview",
                                                      Color(0xff415EB6),
                                                      Color(0xffEEF7FE)),
                                                ),
                                              ),
                                              const SizedBox(width: 16.0),
                                              /* Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/videos',
                                            arguments: <String, String>{
                                              'chapter_id': _searchResult[index].id.toString(),
                                            },
                                          );
                                        },
                                        child: _buildWikiCategory(
                                            "assets/images/video_icon.png",
                                            "Concept Based Videos",
                                            Color(0xffFFB110),
                                            Color(0xffFFFBEC)),
                                      ),
                                    ),*/

                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    if (term == "1") {
                                                      Navigator.pushNamed(
                                                        context,
                                                        '/test-list',
                                                        arguments: <String,
                                                            String>{
                                                          'chapter_id':
                                                              _searchResult[
                                                                      index]
                                                                  .id
                                                                  .toString(),
                                                          'chapter_name':
                                                              _searchResult[
                                                                      index]
                                                                  .chapter_name
                                                                  .toString(),
                                                          'type': "inside"
                                                        },
                                                      );
                                                    } else if (term == "2") {
                                                      Navigator.pushNamed(
                                                          context,
                                                          '/mcq-level-testing',
                                                          arguments: <String,
                                                              String>{
                                                            'chapter_id':
                                                                _searchResult[
                                                                        index]
                                                                    .id
                                                                    .toString(),
                                                          });
                                                    }
                                                  },
                                                  child: _buildWikiCategory(
                                                      "assets/images/video_icon.png",
                                                      "Objective type Questions",
                                                      Color(0xffAC4141),
                                                      Color(0xffFEEEEE)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              bottom: 5,
                                              top: 5),
                                          child: term == "2"
                                              ? Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.pushNamed(
                                                            context,
                                                            '/start-subjective-list',
                                                            arguments: <String,
                                                                String>{
                                                              'chapter_id': snapshot
                                                                  .data[
                                                                      'Response']
                                                                      [index]
                                                                      ['id']
                                                                  .toString(),
                                                            },
                                                          );
                                                        },
                                                        child: _buildWikiCategory(
                                                            "assets/images/support.png",
                                                            "Subjective Questions",
                                                            Color(0xff34DEDE),
                                                            Color(0xffF0FFFF)),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 16,
                                                    ),
                                                    Expanded(child: SizedBox())
                                                  ],
                                                )
                                              : SizedBox(),
                                        ),
                                        /* const SizedBox(height: 10.0),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, bottom: 5, top: 5),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: _buildWikiCategory(
                                          "assets/images/video_icon.png",
                                          "Topic Wise Videos",
                                          Color(0xffFFB110),
                                          Color(0xffFFFBEC)),
                                    ),
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: _buildWikiCategory(
                                          "assets/images/video_icon.png",
                                          "Register for Live Doubt Session",
                                          Color(0xffFF3D0D),
                                          Color(0xffFFE4DD)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, bottom: 5, top: 5),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: _buildWikiCategory(
                                          "assets/images/video_icon.png",
                                          "Project Support",
                                          Color(0xffFF3D0D),
                                          Color(0xffFFE7EF)),
                                    ),
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: _buildWikiCategory(
                                          "assets/images/video_icon.png",
                                          "Important Exam Question",
                                          Color(0xff007AFF),
                                          Color(0xffE0F1FF)),
                                    ),
                                  ],
                                ),
                              ),*/
                                        const SizedBox(height: 5.0),
                                      ],
                                    )
                                  : Container(),
                              new Container(
                                  padding: EdgeInsets.only(left: 15, right: 10),
                                  child: Divider(
                                    color: Color(0xffE8E8E8),
                                    thickness: 1,
                                  )),
                            ]),
                          );
                        }),
                  )
                : Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: snapshot.data['Response'].length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                showExpand[index] = !showExpand[index];
                              });
                            },
                            child: Column(children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10),
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      /* Container(
                                        //  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                          height: 60,
                                          width: 60,
                                          decoration: new BoxDecoration(
                                              color: Color(0xffF6F6F6),
                                              borderRadius: new BorderRadius.only(
                                                  topLeft: const Radius.circular(5.0),
                                                  bottomLeft: const Radius.circular(5.0),
                                                  bottomRight: const Radius.circular(5.0),
                                                  topRight: const Radius.circular(5.0))),
                                       child: */ /*_networkImage(snapshot.data['url']+snapshot.data['Response'][index]['image']),*/ /*
                                          Center(
                                            child: Text(
                                              snapshot
                                                  .data['Response'][index]['chapter_name'][0]
                                                  .toUpperCase(),
                                              style: TextStyle(fontSize: 30.0,
                                                  color: Color(0xff017EFF),),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12.0,
                                        ),*/
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                      snapshot.data['Response']
                                                              [index]
                                                          ['chapter_name'],
                                                      maxLines: 3,
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: normalText5),
                                                ),
                                                showExpand[index]
                                                    ? Icon(
                                                        Icons
                                                            .arrow_drop_up_outlined,
                                                        color:
                                                            Color(0xff017EFF),
                                                        size: 24,
                                                      )
                                                    : Icon(
                                                        Icons.arrow_drop_down,
                                                        color:
                                                            Color(0xff017EFF),
                                                        size: 24,
                                                      ),
                                              ],
                                            ),

                                            /* snapshot
                                                  .data['Response'][index]['short_description']!=null? Container(
                                                child: Text(
                                                    snapshot
                                                        .data['Response'][index]['short_description'],
                                                    maxLines: 2,
                                                    softWrap: true,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: normalText7
                                                ),
                                              ):Container(
                                                child: Text(
                                                   "",
                                                    maxLines: 2,
                                                    softWrap: true,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: normalText7
                                                ),
                                              ),*/
                                          ],
                                        ),
                                      ),
                                    ]),
                              ),
                              showExpand[index]
                                  ? Column(
                                      children: [
                                        const SizedBox(height: 5),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              bottom: 5,
                                              top: 5),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/chapter-overview',
                                                      arguments: <String,
                                                          String>{
                                                        'chapter_id': snapshot
                                                            .data['Response']
                                                                [index]['id']
                                                            .toString(),
                                                      },
                                                    );
                                                  },
                                                  child: _buildWikiCategory(
                                                      "assets/images/ordered_list.png",
                                                      "Chapter Overview",
                                                      Color(0xff415EB6),
                                                      Color(0xffEEF7FE)),
                                                ),
                                              ),
                                              const SizedBox(width: 16.0),
                                              /*  Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/videos',
                                            arguments: <String, String>{
                                              'chapter_id': snapshot
                                                  .data['Response'][index]['id'].toString(),
                                            },
                                          );
                                        },
                                        child: _buildWikiCategory(
                                            "assets/images/video_icon.png",
                                            "Concept Based Videos",
                                            Color(0xffFFB110),
                                            Color(0xffFFFBEC)),
                                      ),
                                    ),
*/
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    if (term == "1") {
                                                      print(jsonEncode({
                                                        'chapter_id': snapshot
                                                            .data['Response']
                                                                [index]['id']
                                                            .toString(),
                                                        'chapter_name': snapshot
                                                            .data['Response']
                                                                [index]
                                                                ['chapter_name']
                                                            .toString(),
                                                        'type': "inside"
                                                      }));
                                                      Navigator.pushNamed(
                                                        context,
                                                        '/test-list',
                                                        arguments: <String,
                                                            String>{
                                                          'chapter_id': snapshot
                                                              .data['Response']
                                                                  [index]['id']
                                                              .toString(),
                                                          'chapter_name': snapshot
                                                              .data['Response']
                                                                  [index][
                                                                  'chapter_name']
                                                              .toString(),
                                                          'type': "inside"
                                                        },
                                                      );
                                                    } else if (term == "2") {
                                                      Navigator.pushNamed(
                                                        context,
                                                        '/mcq-level-testing',
                                                        arguments: <String,
                                                            String>{
                                                          'chapter_id': snapshot
                                                              .data['Response']
                                                                  [index]['id']
                                                              .toString(),
                                                          'term':
                                                              term.toString()
                                                        },
                                                      );
                                                    }
                                                  },
                                                  child: _buildWikiCategory(
                                                      "assets/images/mcq.png",
                                                      "Objective Type Questions",
                                                      Color(0xffAC4141),
                                                      Color(0xffFEEEEE)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              bottom: 5,
                                              top: 5),
                                          child: term == "2"
                                              ? Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.pushNamed(
                                                            context,
                                                            '/start-subjective-list',
                                                            arguments: <String,
                                                                String>{
                                                              'chapter_id': snapshot
                                                                  .data[
                                                                      'Response']
                                                                      [index]
                                                                      ['id']
                                                                  .toString(),
                                                            },
                                                          );
                                                        },
                                                        child: _buildWikiCategory(
                                                            "assets/images/support.png",
                                                            "Subjective Questions",
                                                            Color(0xff34DEDE),
                                                            Color(0xffF0FFFF)),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 16,
                                                    ),
                                                    Expanded(child: SizedBox())
                                                  ],
                                                )
                                              : SizedBox(),
                                        ),
                                        /* const SizedBox(height: 10.0),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, bottom: 5, top: 5),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: _buildWikiCategory(
                                          "assets/images/video_icon.png",
                                          "Topic Wise Videos",
                                          Color(0xffFFB110),
                                          Color(0xffFFFBEC)),
                                    ),
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: _buildWikiCategory(
                                          "assets/images/video_icon.png",
                                          "Register for Live Doubt Session",
                                          Color(0xffFF3D0D),
                                          Color(0xffFFE4DD)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, bottom: 5, top: 5),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: _buildWikiCategory(
                                          "assets/images/video_icon.png",
                                          "Project Support",
                                          Color(0xffFF3D0D),
                                          Color(0xffFFE7EF)),
                                    ),
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: _buildWikiCategory(
                                          "assets/images/video_icon.png",
                                          "Important Exam Question",
                                          Color(0xff007AFF),
                                          Color(0xffE0F1FF)),
                                    ),
                                  ],
                                ),
                              ),*/
                                        const SizedBox(height: 5.0),
                                      ],
                                    )
                                  : Container(),
                              new Container(
                                  padding: EdgeInsets.only(left: 15, right: 10),
                                  child: Divider(
                                    color: Color(0xffE8E8E8),
                                    thickness: 1,
                                  )),
                            ]),
                          );
                        }),
                  );
          } else {
            return _emptyOrders();
          }
        } else {
          return snapshot.hasError
              ? Text("No record found")
              : Center(
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
        style:
            TextStyle(fontSize: 20, letterSpacing: 1, color: Color(0xff2E2A4A)),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: widget.modal != ""
            ? AppBar(
                elevation: 0.0,
                leading: widget.modal != ""
                    ? Row(children: <Widget>[
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
                      ])
                    : Row(children: <Widget>[
                        IconButton(
                          icon: Image(
                            image: AssetImage("assets/images/list_icon.png"),
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
                  child: Text("List of Chapters", style: normalText6),
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
              )
            : null,
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
                    Container(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                      margin: EdgeInsets.only(bottom: 10),
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
                        /* SizedBox(
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
                      ),*/
                      ]),
                    ),
                    Expanded(
                      child: Container(
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
        ));
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
  final String id, chapter_name, short_description;

  UserDetails({
    this.id,
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
