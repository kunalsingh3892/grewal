import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/indicator.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math' as math;

import '../constants.dart';

class ViewPerformanceChart extends StatefulWidget {
  final Object argument;

  const ViewPerformanceChart({Key key, this.argument}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

const double degrees2Radians = math.pi / 180.0;

class _SettingsState extends State<ViewPerformanceChart> {
  bool _value = false;
  Future _chapterData;
  bool isLoading = false;

  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
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
      fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white);

  final completeController = TextEditingController();
  String api_token = "";
  String user_id = "";
  String chapter_id = "";
  String chapter_name = "";
  String type = "";
  String test_id = "";
  String profile_image = '';
  ZoomPanBehavior _zoomPanBehavior;
  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    test_id = data['test_id'];
    type = data['type'];
    _tooltipBehavior = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(
        enableDoubleTapZooming: true,
        enablePanning: true,
        enablePinching: true,
        enableSelectionZooming: true);
    _getUser();
  }

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        user_id = prefs.getString('user_id').toString();
        profile_image = prefs.getString('profile_image').toString();
        api_token = prefs.getString('api_token').toString();
        _chapterData = _getPerformanceData();
      });
    });
  }

  Widget _networkImage(url) {
    return Image(
      image: NetworkImage(url),
    );
  }

  List<bool> showExpand = new List();
  List<String> _value1 = new List();
  List<ChartData> chartData = [];
  TooltipBehavior _tooltipBehavior;
  var easy;
  var diff;
  var avg;
  List<_SalesData> datas = [];
  Future _getPerformanceData() async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/test-performancenew"),
      body: {
        "user_id": user_id,
        "test_id": type == "institute" ? "" : test_id,
        "inst_test_id": type == "institute" ? test_id : "",
      },
      headers: headers,
    );
    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      setState(() {
        for (var i = 0; i < data['questionwiseanalytic'].length; i++) {
          datas.add(_SalesData(
              (i + 1).toString(),
              double.parse(data['questionwiseanalytic'][i]['time_taken']),
              data['questionwiseanalytic'][i]['final_result'],
              data['questionwiseanalytic'][i]['short_diffculttype']));
        }
        // datas = [
        //   _SalesData(
        //       '1',
        //       double.parse(data['questionwiseanalytic'][0]['time_taken']),
        //       data['questionwiseanalytic'][0]['final_result'],
        //       data['questionwiseanalytic'][0]['short_diffculttype']),
        //   _SalesData(
        //       '2',
        //       double.parse(data['questionwiseanalytic'][1]['time_taken']),
        //       data['questionwiseanalytic'][1]['final_result'],
        //       data['questionwiseanalytic'][1]['short_diffculttype']),
        //   _SalesData(
        //       '3',
        //       double.parse(data['questionwiseanalytic'][2]['time_taken']),
        //       data['questionwiseanalytic'][2]['final_result'],
        //       data['questionwiseanalytic'][2]['short_diffculttype']),
        //   _SalesData(
        //       '4',
        //       double.parse(data['questionwiseanalytic'][3]['time_taken']),
        //       data['questionwiseanalytic'][3]['final_result'],
        //       data['questionwiseanalytic'][3]['short_diffculttype']),
        //   _SalesData(
        //       '5',
        //       double.parse(data['questionwiseanalytic'][4]['time_taken']),
        //       data['questionwiseanalytic'][4]['final_result'],
        //       data['questionwiseanalytic'][4]['short_diffculttype']),
        //   _SalesData(
        //       '6',
        //       double.parse(data['questionwiseanalytic'][5]['time_taken']),
        //       data['questionwiseanalytic'][5]['final_result'],
        //       data['questionwiseanalytic'][5]['short_diffculttype']),
        //   _SalesData(
        //       '7',
        //       double.parse(data['questionwiseanalytic'][6]['time_taken']),
        //       data['questionwiseanalytic'][6]['final_result'],
        //       data['questionwiseanalytic'][6]['short_diffculttype']),
        //   _SalesData(
        //       '8',
        //       double.parse(data['questionwiseanalytic'][7]['time_taken']),
        //       data['questionwiseanalytic'][7]['final_result'],
        //       data['questionwiseanalytic'][7]['short_diffculttype']),
        //   _SalesData(
        //       '9',
        //       double.parse(data['questionwiseanalytic'][8]['time_taken']),
        //       data['questionwiseanalytic'][8]['final_result'],
        //       data['questionwiseanalytic'][8]['short_diffculttype']),
        //   _SalesData(
        //       '10',
        //       double.parse(data['questionwiseanalytic'][9]['time_taken']),
        //       data['questionwiseanalytic'][9]['final_result'],
        //       data['questionwiseanalytic'][9]['short_diffculttype']),
        // _SalesData(
        //     '11',
        //     double.parse(data['questionwiseanalytic'][10]['time_taken']),
        //     data['questionwiseanalytic'][10]['final_result'],
        //     data['questionwiseanalytic'][10]['short_diffculttype']),
        // _SalesData(
        //     '12',
        //     double.parse(data['questionwiseanalytic'][11]['time_taken']),
        //     data['questionwiseanalytic'][11]['final_result'],
        //     data['questionwiseanalytic'][11]['short_diffculttype']),
        // _SalesData(
        //     '13',
        //     double.parse(data['questionwiseanalytic'][12]['time_taken']),
        //     data['questionwiseanalytic'][12]['final_result'],
        //     data['questionwiseanalytic'][12]['short_diffculttype']),
        // _SalesData(
        //     '14',
        //     double.parse(data['questionwiseanalytic'][13]['time_taken']),
        //     data['questionwiseanalytic'][13]['final_result'],
        //     data['questionwiseanalytic'][13]['short_diffculttype']),
        // _SalesData(
        //     '15',
        //     double.parse(data['questionwiseanalytic'][14]['time_taken']),
        //     data['questionwiseanalytic'][14]['final_result'],
        //     data['questionwiseanalytic'][14]['short_diffculttype']),
        // ];
      });
      /* chartData = [
        ChartData('Easy', double.parse(data['easy_right_per'].toString())),
        ChartData('Medium', double.parse(data['average_right_per'].toString())),
        ChartData('Hard', double.parse(data['diffcult_right_per'].toString())),
      ];*/
      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Widget chapter1List(Size deviceSize) {
    return FutureBuilder(
      future: _chapterData,
      builder: (context, snapshot) {
        print(snapshot.data.toString());
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return Column(mainAxisSize: MainAxisSize.min, children: [
              Expanded(
                child: Container(
                  width: deviceSize.width,
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          bottomLeft: const Radius.circular(20.0),
                          bottomRight: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0))),
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                  padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 20),
                  child: Column(children: [
                    Container(
                      child: Text("Question Wise Time Analysis",
                          style: normalText6),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          // Chart title
                          zoomPanBehavior: _zoomPanBehavior,
                          legend: Legend(isVisible: true),
                          // Enable tooltip
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <ChartSeries<_SalesData, String>>[
                            BarSeries<_SalesData, String>(
                                dataSource: datas,
                                xValueMapper: (_SalesData sales, _) =>
                                    sales.year,
                                yValueMapper: (_SalesData sales, _) =>
                                    sales.sales,
                                xAxisName: "Questions",
                                yAxisName: "Time(s)",
                                name: 'Time(s)',
                                trackPadding: 10,
                                trackColor: Color(0xff2E2A4A),
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true),
                                dataLabelMapper: (_SalesData sales, _) =>
                                    sales.short_diffculttype,
                                pointColorMapper: (_SalesData sales, _) =>
                                    sales.status == "W"
                                        ? Color(0xffFF3E3E)
                                        : Color(0xff57E56E),
                                color: Color(0xffFF3E3E),
                                enableTooltip: true,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))
                          ]),
                    ),
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Correct", style: correct),
                            SizedBox(
                              width: 20.0,
                            ),
                            Text("InCorrect", style: incorrect)
                          ]),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("(E) Easy", style: normalText10),
                            Text("(M) Medium", style: normalText10),
                            Text("(D) Difficult", style: normalText10)
                          ]),
                    ),
                  ]),
                ),
              ),
            ]);
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
                      color:
                          index.isEven ? Color(0xff017EFF) : Color(0xffFFC700),
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

  Color colorName() {
    Color color;

    for (int i = 0; i < datas.length; i++) {
      if (datas[i].status == "W") {
        color = Color(0xff57E56E);
      } else {
        color = Color(0xffFF3E3E);
      }
    }
    return color;
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
          child: Text("My Performance", style: normalText6),
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
          decoration: BoxDecoration(
            color: Color(0xff2E2A4A),
          ),
          child: Container(child: chapter1List(deviceSize))),
    );
  }

  Container buildCircle(
    Color color,
    String s,
    double d, {
    double width = 100,
    double height = 100,
  }) {
    return Container(
      alignment: Alignment.center,
      width: width,
      height: height,
      child: InkWell(
        child: new Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(20.0),
          //I used some padding without fixed width and height
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            // You can use like this way or like the below line
            //                borderRadius: new BorderRadius.circular(30.0),
            color: color,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(s, style: normalText3),
                  SizedBox(
                    height: 5,
                  ),
                  Text(d.round().toString() + "%", style: normalText3),
                ]),
          ),
          alignment: Alignment.center,
          // You can add a Icon instead of text also, like below.
          //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
        ),
      ),
    );
  }
}

class Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path.combine(
      PathOperation.difference,
      Path()
        ..addOval(
          Rect.fromCircle(
            center: size.center(Offset(0, 0)),
            radius: 25.0,
          ),
        ),
      Path()
        ..addOval(
          Rect.fromCircle(
            center: size.center(Offset(10, 30)),
            radius: 25.0,
          ),
        ),
    );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class ChartData {
  ChartData(this.name, this.value);

  final String name;
  final double value;
}

class _SalesData {
  _SalesData(this.year, this.sales, this.status, this.short_diffculttype);

  final String year;
  final double sales;
  final String status;
  final String short_diffculttype;
}
