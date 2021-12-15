import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/indicator.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math' as math;

import '../../constants.dart';



class OlympiadViewPerformance extends StatefulWidget {
  final Object argument;

  const OlympiadViewPerformance({Key key, this.argument}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

const double degrees2Radians = math.pi / 180.0;

class _SettingsState extends State<OlympiadViewPerformance> {
  bool _value = false;
  Future _chapterData;
  bool isLoading = false;
  ScreenshotController screenshotController = ScreenshotController();
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      letterSpacing: 1);
  TextStyle normalTex10 = GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Color(0xff2E2A4A),
      letterSpacing: 1);
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w300, color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  TextStyle normalText9 = GoogleFonts.montserrat(
      fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xff2E2A4A));
  TextStyle normalText8 = GoogleFonts.montserrat(
      fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  TextStyle normalText1 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w300, color: Color(0xff22215B));
  TextStyle normalText2 = GoogleFonts.montserrat(
      fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText4 = GoogleFonts.montserrat(
      fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText10 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText11 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff017EFF));
  TextStyle normalText12 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xffFF317B));
  TextStyle correct = GoogleFonts.montserrat(
      fontSize: 21, fontWeight: FontWeight.w600, color: Color(0xff4CE364));
  TextStyle incorrect = GoogleFonts.montserrat(
      fontSize: 21, fontWeight: FontWeight.w600, color: Color(0xffFF3131));
  TextStyle normalText3 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white);

  final completeController = TextEditingController();

  String user_id = "";
  String chapter_id = "";
  String chapter_name = "";
  String type = "";
  String test_id = "";
  String profile_image = '';

  bool show_pie=true;
  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    test_id = data['test_id'];

    _getUser();
  }
  String api_token = "";
  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        user_id = prefs.getString('user_id').toString();
        profile_image = prefs.getString('profile_image').toString();
        api_token = prefs.getString('api_token').toString();
        _chapterData = _getPerformanceData();
        //_requestPermission();
      });
    });
  }

  Widget _networkImage(url) {
    return Image(
      image: NetworkImage(url),
    );
  }


  List<String> _value1 = new List();

  TooltipBehavior _tooltipBehavior;
  var easy;
  var diff;
  var avg;

  Future _getPerformanceData() async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/olympiadperformance"),
      body: {
        "user_id": user_id,
        "test_id": test_id

      },
      headers: headers,
    );
    print(jsonEncode({
      "user_id": user_id,
      "test_id": test_id
    }));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (int i = 0; i < data['section_wise_performance'].length; i++) {
        if (data['section_wise_performance'][i]['total_section_right_question'].toString() != '0') {
          var d = ((int.parse(data['section_wise_performance'][i]['total_section_right_question']
              .toString()) *
              100) /
              int.parse(data['section_wise_performance'][i]['total_section_question'].toString()));
          _value1.add(d.round().toString());
        } else {
          _value1.add("0");
        }
      }



      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  int _currentSliderValue = 2;

  int touchedIndex = -1;

  List<String> color = [];


  final _random = Random();

  Widget winnerText(int data){
    if(data<51){
      return Container(
          child: Text("Revise your chapter and re-take tests to improve your accuracy.",
              //  textAlign: TextAlign.justify,
              style: normalText4));

    }
    else if(data>75){
      return Container(
          child: Text("Congratulations, you have earned your badge! Keep practicing more questions.",
              //  textAlign: TextAlign.justify,
              style: normalText4));
    }
    else{
      return Container(
          child: Text("Practice more to improve your accuracy level . Identify weaker topics and revise concepts.",
              //  textAlign: TextAlign.justify,
              style: normalText4));
    }

  }
  Widget winner(int data){
    if(data<51){
      return  Image(
        image: AssetImage(
          'assets/images/thumb_down.png',
        ),
        height: 100.0,
        width: 100.0,
      );

    }
    else if(data>75){
      return  Image(
        image: AssetImage(
          'assets/images/badge.png',
        ),
        height: 100.0,
        width: 100.0,
      );
    }
    else{
      return  Image(
        image: AssetImage(
          'assets/images/thumb_up.png',
        ),
        height: 100.0,
        width: 100.0,
      );
    }



  }
  Color widgetColor(int index){
    if(_value1[index].toString() == "100") {
      return Color(0xff4CE364);
    }
    else if(_value1[index].toString() == "0"){
      return Colors.grey.shade300;
    }
    else{
      return Color(0xff0293ee);
    }



  }
  Widget chapterList(Size deviceSize) {
    return FutureBuilder(
      future: _chapterData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return SingleChildScrollView(
              child: RepaintBoundary(
                key: _key,
                child: Column(
                  children: [
                    Container(
                      width: deviceSize.width,
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(20.0),
                              bottomLeft: const Radius.circular(20.0),
                              bottomRight: const Radius.circular(20.0),
                              topRight: const Radius.circular(20.0))),
                      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                      child: Column(children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                                "You Scored: " +
                                                    snapshot.data[
                                                    'total_right_per']
                                                        .toString() +
                                                    "%",
                                                style: normalText6)
                                          ]),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    backgroundColor:
                                                    Color(0xff1EE76E),
                                                    radius: 10,
                                                    child: Icon(
                                                      Icons.done,
                                                      color: Colors.white,
                                                      size: 14,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Text(
                                                      "${snapshot.data['total_right_per'].toString()}% correct",
                                                      style: normalText2)
                                                ]),
                                          ),
                                          SizedBox(
                                            width: 20.0,
                                          ),
                                          Container(
                                            child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    backgroundColor:
                                                    Color(0xffF45656),
                                                    radius: 10,
                                                    child: Icon(
                                                      Icons.clear,
                                                      color: Colors.white,
                                                      size: 14,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Text(
                                                      "${snapshot.data['total_wrong_per'].toString()}% incorrect",
                                                      style: normalText2)
                                                ]),
                                          ),
                                        ]),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  winner(snapshot.data[
                                  'total_right_per']),
                                 /* SizedBox(
                                    height: 15.0,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: winnerText(snapshot.data[
                                    'total_right_per']),
                                  ),
*/
                                ],
                              ),
                            ),
                          ],
                        )
                      ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: deviceSize.width,
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(20.0),
                              bottomLeft: const Radius.circular(20.0),
                              bottomRight: const Radius.circular(20.0),
                              topRight: const Radius.circular(20.0))),
                      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                      child: Column(children: [
                        Container(
                          child: Text("Performance based on Sections",
                              style: normalText6),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: snapshot.data['section_wise_performance'].length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 10),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5),
                                    ),
                                  ),
                                  child: Column(children: <Widget>[
                                    Row(children: <Widget>[
                                      Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          color:widgetColor(index),
                                          // border color
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                                snapshot.data['section_wise_performance'][index]
                                                ['section_name'],
                                                maxLines: 2,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: normalText2),
                                          ),
                                        ),
                                      ),
                                    ]),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Row(children: <Widget>[
                                      Container(
                                        width: MediaQuery.of(context).size.width *
                                            0.10,
                                        child: Text(_value1[index].toString() + "% "+"("+snapshot.data['section_wise_performance'][index]
                                        ['total_section_right_question'].toString()+"/"+snapshot.data['section_wise_performance'][index]
                                        ['total_section_question'].toString()+")",
                                            style: normalText1),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: LinearPercentIndicator(
                                            backgroundColor: Colors.grey.shade300,
                                            lineHeight: 7.0,
                                            percent: _value1.length != 0
                                                ? double.parse(_value1[index]) / 100
                                                : 0.0,
                                            center: Text(
                                              "",
                                              // snapshot.data['cart_quantity'] > 0 ? 'Go to Basket' : 'Add to Basket',
                                              style: TextStyle(
                                                  color: Color(0xff0293ee),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            progressColor: widgetColor(index),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ]),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                      ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop(false);
                          Navigator.of(context).pop(false);
                          Navigator.pushNamed(
                            context,
                            '/section-list',
                            arguments: <String, String>{
                              'test_id': test_id,
                            },
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          color: Colors.blueAccent,
                          child: Center(
                            child: Text('Review Your Answers', style: normalText5),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
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
            'NO RECORDS FOUND!',
            style: TextStyle(fontSize: 20, letterSpacing: 1, color: Colors.white),
          )),
    );
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
  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }
  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);

  }
  final GlobalKey _key = GlobalKey();
  void _takeScreenshot() async {

    RenderRepaintBoundary boundary =
    _key.currentContext.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(
        format: ui.ImageByteFormat.png);
    if (byteData != null) {
      Uint8List pngBytes = byteData.buffer.asUint8List();

      // Saving the screenshot to the gallery
      final result = await ImageGallerySaver.saveImage(
        byteData.buffer.asUint8List(),
      );
      print(result);
      Fluttertoast.showToast(msg: "Save Successfully");
    }
  }
  /* Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }*/
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return  WillPopScope(
      onWillPop: () async {

        Navigator.of(context).pop();
        Navigator.pushNamed(context, '/dashboard');
        return false;
      },
      child: Scaffold(
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

                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/dashboard');
                },
              ),
            ]),
          ),
          centerTitle: true,
          title: Container(
            child: Text("Olympiad Performance", style: normalText6),
          ),
          flexibleSpace: Container(
            height: 100,
            color: Color(0xffffffff),
          ),
          actions: <Widget>[
          /*  InkWell(
              onTap: (){

                _takeScreenshot();


              },

              child: Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child:Icon(Icons.download,color:Color(0xff2E2A4A) ,),
                ),
              ),
            ),*/
          ],
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          color: Color(0xff2E2A4A),
          child: Container(
              padding: EdgeInsets.only(bottom: 5),
              child: chapterList(deviceSize)
          ),

        ),
      ),


    );

  }


}

