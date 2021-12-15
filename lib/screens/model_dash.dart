import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/color_constants.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../constants.dart';

class ModelDash extends StatefulWidget {


  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<ModelDash> {
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

  @override
  void initState() {
    super.initState();

  //  _getUser();
  }
  /*_getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        profile_image = prefs.getString('profile_image').toString();

      });
    });
  }*/
 /* Widget _networkImage1(url) {
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
  }*/


  Widget htmlList(Size deviceSize) {
    return Container(
      child: SfPdfViewer.network(
        "https://www.grewaleducation.com/admin/public/assets/chapter_images/mtp1.pdf",
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
          child: Text("Model Test Paper", style: normalText6),
        ),
        flexibleSpace: Container(
          height: 100,
          color: Color(0xffffffff),
        ),
        actions: <Widget>[
          /*Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
              child: _networkImage1(
                profile_image,
              ),
            ),
          ),*/
        ],
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.transparent,
      ),
      body:  SingleChildScrollView(
        child: Container(
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                     onTap: (){
                       Navigator.pushNamed(
                         context,
                         '/mtp-list',
                       );
                            },
                  child: Container(
                    padding: const EdgeInsets.only(left: 30.0, top: 20.0,right: 10,bottom: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: planbg1,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color:planbg1)),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, top: 10.0,right: 10,bottom: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 26.0),
                               child: Center(
                                child: Container(
                                  width: 78,
                                  height: 67.01,
                                  child: new Image.asset(
                                      'assets/images/lightbulb.png'),
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 14.76),
                              child: Center(
                                child: Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "MTP \n  \n",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: InkWell(
                   onTap: (){
                     Navigator.pushNamed(
                       context,
                       '/answer-list',
                     );
                            },
                  child: Container(
                    padding: const EdgeInsets.only(left: 10.0, top: 20.0,right: 30,bottom: 20),
                    child: Container(
                      /* width: 151,
                                height: 176,*/
                      decoration: BoxDecoration(
                          color: planbg1,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color:planbg1)),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, top: 10.0,right: 10,bottom: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 26.0),
                              child: Center(
                                child: Container(
                                  width: 78,
                                  height: 67.01,
                                  child: new Image.asset(
                                      'assets/images/problem_solving.png'),
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 14.76),
                              child: Center(
                                child: Container(

                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Answer \n Key \n",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
}
