import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/color_constants.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';



class QuestionView extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<QuestionView> {
  bool _value = false;
  Future _chapterData;
  bool isLoading = false;
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xff2E2A4A));

  TextStyle normalText4 = GoogleFonts.montserrat(
      fontSize: 12, fontWeight: FontWeight.w300, color: Color(0xff2E2A4A));

  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  final completeController = TextEditingController();

  String profile_image = '';

  String user_id="";
  String class_id="";
  String board_id="";
  String payment = '';
  String total_test_quetion = '';
  String _mobile = "";
  String email_id = '';
  String order_id = "";
  String api_token = "";
  @override
  void initState() {
    super.initState();
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
        _chapterData=  readJson();

      });
    });
  }

  Widget _networkImage(url) {
    return Image(
      image: NetworkImage(url),
    );
  }
  List<bool> showExpand = new List();
  List _items = [];
  Future readJson() async {
    final String response = await rootBundle.loadString('assets/images/sample.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["items"];
      for (int i = 0; i <_items.length; i++) {
        showExpand.add(false);
      }
    });

    return _items;
  }

  Widget _buildWikiCategory(
      String icon, String label, Color color, Color circle_color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

      // height: 100,
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: circle_color,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
         Center(
           child: Text(
                icon,
                maxLines: 3,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: normalText5,
              ),
         ),

          const SizedBox(height: 5.0),
          Center(
            child: Text(
                label,
                maxLines: 3,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: normalText4,
              ),
          ),

        ],
      ),
    );
  }

  Widget chapterList(Size deviceSize) {
    return FutureBuilder(
      future: _chapterData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {

            return
            Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return  InkWell(
                      onTap: (){
                        setState(() {
                          showExpand[index]=!showExpand[index];
                        });

                      },
                      child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 10),
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[

                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>[

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                    snapshot
                                                        .data[index]['question'],
                                                    maxLines: 10,
                                                    softWrap: true,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: normalText5
                                                ),
                                              ),

                                              showExpand[index]?Icon(
                                                Icons.arrow_drop_up_outlined,
                                                color: Color(0xff017EFF),
                                                size: 24,
                                              ): Icon(
                                                Icons.arrow_drop_down,
                                                color: Color(0xff017EFF),
                                                size: 24,
                                              ),
                                            ],
                                          ),


                                        ],
                                      ),
                                    ),
                                  ]
                              ),
                            ),

                            showExpand[index]? Column(children: [
                              const SizedBox(height: 5),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 5, right: 5, bottom: 5, top: 5),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {

                                        },
                                        child: _buildWikiCategory(
                                            "Chapter",
                                            snapshot
                                                .data[index]['chapter'],
                                            Color(0xff415EB6),
                                            Color(0xffEEF7FE)),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                      Expanded(
                                      child: InkWell(
                                        onTap: () {

                                        },
                                        child: _buildWikiCategory(
                                            "Topic",
                                            snapshot
                                                .data[index]['topic'],
                                            Color(0xffFFB110),
                                            Color(0xffFFFBEC)),
                                      ),
                                    ),


                                  ],
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 5, right: 5, bottom: 5, top: 5),
                                child: Row(
                                  children: <Widget>[


                                    Expanded(
                                      child: InkWell(
                                        onTap: (){

                                        },
                                        child: _buildWikiCategory(
                                            "Right %",
                                            snapshot
                                                .data[index]['right'],
                                            Color(0xff38CD8B),
                                            Color(0xffE9FFF5)),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Expanded(
                                      child: _buildWikiCategory(
                                          "Wrong %",
                                          snapshot
                                              .data[index]['wrong'],
                                          Color(0xffFFB110),
                                          Color(0xffFFFBEC)),
                                    ),

                                  ],
                                ),
                              ),

                              const SizedBox(height: 10.0),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 5, right: 5, bottom: 5, top: 5),
                                child: Row(
                                  children: <Widget>[


                                    Expanded(
                                      child: InkWell(
                                        onTap: (){

                                        },
                                        child: _buildWikiCategory(
                                            "Parameter",
                                            snapshot
                                                .data[index]['parameter'],
                                            Color(0xff38CD8B),
                                            Color(0xffE9FFF5)),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Expanded(
                                      child: Container(),
                                    ),

                                  ],
                                ),
                              ),

                              const SizedBox(height: 5.0),
                            ],):Container(),
                            new Container(
                                padding: EdgeInsets.only(left: 5,right: 5),
                                child: Divider(
                                  color: Color(0xffE8E8E8),
                                  thickness: 1,
                                )),
                          ]
                      ),
                    );
                  }

              ),
            );


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
              onPressed: (){
                Navigator.of(context).pop(false);
              },
            ),

          ]),
          centerTitle: true,
          title: Container(
            child: Text("Question View", style: normalText6),
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
                  horizontal: deviceSize.width * 0.01,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[



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

}

