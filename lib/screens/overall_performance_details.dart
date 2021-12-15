import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math' as math;

import '../constants.dart';

class OverAllDetails extends StatefulWidget {
  final Object argument;

  const OverAllDetails({Key key, this.argument}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

const double degrees2Radians = math.pi / 180.0;

class _SettingsState extends State<OverAllDetails> {
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
  TextStyle normalText15 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white);
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
  TextStyle right = GoogleFonts.montserrat(
      fontSize: 21, fontWeight: FontWeight.w600, color: Color(0xff017EFF));
  TextStyle incorrect = GoogleFonts.montserrat(
      fontSize: 21, fontWeight: FontWeight.w600, color: Color(0xffFF3131));
  TextStyle wrong = GoogleFonts.montserrat(
      fontSize: 21, fontWeight: FontWeight.w600, color: Color(0xffFF317B));
  TextStyle normalText3 = GoogleFonts.montserrat(
      fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white);

  final completeController = TextEditingController();

  String user_id = "";
  String chapter_id = "";
  String chapter_name = "";
  String type = "";
  String question_id = "";
  String profile_image = '';
  ZoomPanBehavior _zoomPanBehavior;
  String api_token = "";
  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    question_id = data['question_id'];
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
        _requestPermission();
      });
    });
  }

  Widget _networkImage(url) {
    return Image(
      image: NetworkImage(url),
    );
  }
  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);

  }
  List<bool> showExpand = new List();
  List<String> _value1 = new List();
  List<SalesData> chartData = [];
  List<ChartData> salesData = [];
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
      new Uri.https(BASE_URL, API_PATH + "/questiontypeperformanceoverview"),
      body: {
        "user_id": user_id,
        "questiontype_id": question_id,
      },
      headers: headers,
    );
    print({
      "user_id": user_id,
      "questiontype_id": question_id,
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data['diffculty_level_wise'].length == 1) {
        chartData = [
          SalesData(
              data['diffculty_level_wise'][0]['diffculty_name'],
              double.parse(
                  data['diffculty_level_wise'][0]['total_right_percentage']),
              double.parse(
                  data['diffculty_level_wise'][0]['total_wrong_percentage']),
              data['diffculty_level_wise'][0]['total_right_question'],
              data['diffculty_level_wise'][0]['total_wrong_question']),
        ];
      } else if (data['diffculty_level_wise'].length == 2) {
        chartData = [
          SalesData(
              data['diffculty_level_wise'][0]['diffculty_name'],
              double.parse(
                  data['diffculty_level_wise'][0]['total_right_percentage']),
              double.parse(
                  data['diffculty_level_wise'][0]['total_wrong_percentage']),
              data['diffculty_level_wise'][0]['total_right_question'],
              data['diffculty_level_wise'][0]['total_wrong_question']),
          SalesData(
              data['diffculty_level_wise'][1]['diffculty_name'],
              double.parse(
                  data['diffculty_level_wise'][1]['total_right_percentage']),
              double.parse(
                  data['diffculty_level_wise'][1]['total_wrong_percentage']),
              data['diffculty_level_wise'][1]['total_right_question'],
              data['diffculty_level_wise'][1]['total_wrong_question']),
        ];
      } else {
        chartData = [
          SalesData(
              data['diffculty_level_wise'][0]['diffculty_name'],
              double.parse(
                  data['diffculty_level_wise'][0]['total_right_percentage']),
              double.parse(
                  data['diffculty_level_wise'][0]['total_wrong_percentage']),
              data['diffculty_level_wise'][0]['total_right_question'],
              data['diffculty_level_wise'][0]['total_wrong_question']),
          SalesData(
              data['diffculty_level_wise'][1]['diffculty_name'],
              double.parse(
                  data['diffculty_level_wise'][1]['total_right_percentage']),
              double.parse(
                  data['diffculty_level_wise'][1]['total_wrong_percentage']),
              data['diffculty_level_wise'][1]['total_right_question'],
              data['diffculty_level_wise'][1]['total_wrong_question']),
          SalesData(
              data['diffculty_level_wise'][2]['diffculty_name'],
              double.parse(
                  data['diffculty_level_wise'][2]['total_right_percentage']),
              double.parse(
                  data['diffculty_level_wise'][2]['total_wrong_percentage']),
              data['diffculty_level_wise'][2]['total_right_question'],
              data['diffculty_level_wise'][2]['total_wrong_question']),
        ];
      }

      salesData = [
        ChartData(
            data['question_type_wise'][0]['questiontype_name'],
            double.parse(
                data['question_type_wise'][0]['total_right_percentage']),
            double.parse(
                data['question_type_wise'][0]['total_wrong_percentage']),
            data['question_type_wise'][0]['total_right_question'],
            data['question_type_wise'][0]['total_wrong_question']),
      ];
      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  TableRow _getDataRow1(result, data) {
    var index = data.indexOf(result);

    return TableRow(
      decoration: BoxDecoration(color: kDarkWhite),
      children: [
        Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
          alignment: Alignment.center,
          child: Container(
              child: AutoSizeText(result['topic_name'],
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: normalText7)),
        ),
        Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
            alignment: Alignment.center,
            child: Container(
                child: AutoSizeText(result['total_wrong_question'].toString(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: normalText2))),
        Material(
          color: Colors.transparent,
          child: InkWell(
            child: Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                alignment: Alignment.center,
                child: Container(
                    child: AutoSizeText(
                        result['total_right_question'].toString(),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: normalText2))),
          ),
        ),
        Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
            alignment: Alignment.center,
            child: Container(
                child: AutoSizeText(result['total_question'].toString(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: normalText2))),
      ],
    );
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
                                            Text("Total Time Taken",
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
                                                  Text("Total time taken",
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
                                                  Text("Average time taken",
                                                      style: normalText2)
                                                ]),
                                          ),
                                        ]),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: Container(
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                        "${snapshot.data['time_taken'][0]['total_time_taken_minut'].toString()}" +
                                                            ":" +
                                                            "${snapshot.data['time_taken'][0]['total_time_taken_second'].toString()}",
                                                        style: normalText6)
                                                  ]),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20.0,
                                          ),
                                          Container(
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                      "${snapshot.data['time_taken'][0]['average_time_taken'].toString()}",
                                                      style: normalText6)
                                                ]),
                                          ),
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ]),
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
                          child: Text("Difficulty Level Wise Analysis",
                              style: normalText6),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            child: SfCartesianChart(
                                // zoomPanBehavior: _zoomPanBehavior,
                                tooltipBehavior: TooltipBehavior(enable: true),
                                primaryXAxis: CategoryAxis(),
                                series: <ChartSeries>[
                              StackedBar100Series<SalesData, String>(
                                  dataSource: chartData,
                                  dataLabelSettings: DataLabelSettings(
                                      isVisible: true, showCumulativeValues: true),
                                  dataLabelMapper: (SalesData sales, _) =>
                                      sales.right1.toString()+ " ("+sales.right.toString()+"%"+") ",
                                  xValueMapper: (SalesData sales, _) => sales.name,
                                  yValueMapper: (SalesData sales, _) => sales.right,
                                  pointColorMapper: (SalesData sales, _) =>
                                      Color(0xff57E56E),
                                  width: 0.5,
                                  spacing: 0.1),
                              StackedBar100Series<SalesData, String>(
                                  dataSource: chartData,
                                  dataLabelSettings: DataLabelSettings(
                                      isVisible: true, showCumulativeValues: true),
                                  dataLabelMapper: (SalesData sales, _) =>
                                      sales.wrong1.toString()+ " ("+sales.wrong.toString()+"%"+") ",
                                  xValueMapper: (SalesData sales, _) => sales.name,
                                  yValueMapper: (SalesData sales, _) => sales.wrong,
                                  pointColorMapper: (SalesData sales, _) =>
                                      Color(0xffFF3E3E),
                                  width: 0.5,
                                  spacing: 0.1)
                            ])),
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
                          child: Text(
                              "Question Type Wise Analysis (${snapshot.data['question_type_wise'][0]['questiontype_name'].toString()})",
                              style: normalText6),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            child: SfCartesianChart(
                                //  zoomPanBehavior: _zoomPanBehavior,
                                tooltipBehavior: TooltipBehavior(enable: true),
                                primaryXAxis: CategoryAxis(),
                                series: <ChartSeries>[
                              StackedColumnSeries<ChartData, String>(
                                  groupName: 'Group A',
                                  dataLabelSettings: DataLabelSettings(
                                      isVisible: true, showCumulativeValues: true),
                                  dataLabelMapper: (ChartData sales, _) =>
                                      sales.right1.toString()+ " ("+sales.right.toString()+"%"+") ",
                                  enableTooltip:true,
                                  dataSource: salesData,
                                  width: 0.5,
                                  pointColorMapper: (ChartData sales, _) =>
                                      Color(0xff017EFF),
                                  xValueMapper: (ChartData sales, _) => sales.name,
                                  yValueMapper: (ChartData sales, _) =>
                                      sales.right),
                              StackedColumnSeries<ChartData, String>(
                                  groupName: 'Group B',
                                  dataLabelSettings: DataLabelSettings(
                                      isVisible: true, showCumulativeValues: true),
                                  dataLabelMapper: (ChartData sales, _) =>
                                      sales.wrong1.toString()+ " ("+sales.wrong.toString()+"%"+") ",
                                  enableTooltip:true,
                                  dataSource: salesData,
                                  width: 0.5,
                                  pointColorMapper: (ChartData sales, _) =>
                                      Color(0xffFF317B),
                                  xValueMapper: (ChartData sales, _) => sales.name,
                                  yValueMapper: (ChartData sales, _) =>
                                      sales.wrong),
                            ])),
                        Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Right", style: right),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Text("Wrong", style: wrong)
                              ]),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Text("Topic Wise Analysis", style: normalText15),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Column(children: <Widget>[
                        Container(
                          child: Column(children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 12, right: 10),
                              child: Table(
                                border: TableBorder.symmetric(
                                    inside: BorderSide(
                                      width: 0.2,
                                      color: Color(0xff2E2A4A),
                                    ),
                                    outside: BorderSide(width: 0.2)),
                                // defaultColumnWidth: FixedColumnWidth(130),
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                columnWidths: {
                                  0: FlexColumnWidth(300.0),
                                  1: FlexColumnWidth(100.0),
                                  2: FlexColumnWidth(100.0),
                                  3: FlexColumnWidth(100.0),
                                },
                                children: [
                                  TableRow(
                                      decoration:
                                          BoxDecoration(color: Color(0xff017EFF)),
                                      children: [
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 8,
                                                bottom: 8),
                                            alignment: Alignment.center,
                                            child: AutoSizeText('Topic',
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style: normalText3)),
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 8,
                                                bottom: 8),
                                            alignment: Alignment.center,
                                            child: AutoSizeText('W',
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style: normalText3)),
                                        Container(
                                            padding: EdgeInsets.all(5),
                                            alignment: Alignment.center,
                                            child: AutoSizeText('R',
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style: normalText3)),
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 8,
                                                bottom: 8),
                                            alignment: Alignment.center,
                                            child: AutoSizeText('Grand Total',
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style: normalText3)),
                                      ]),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 12, right: 10),
                              child: Table(
                                border: TableBorder.symmetric(
                                    inside: BorderSide(
                                      width: 0.2,
                                      color: Color(0xff2E2A4A),
                                    ),
                                    outside: BorderSide(
                                      width: 0.2,
                                      color: Color(0xff2E2A4A),
                                    )),
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                columnWidths: {
                                  0: FlexColumnWidth(300.0),
                                  1: FlexColumnWidth(100.0),
                                  2: FlexColumnWidth(100.0),
                                  3: FlexColumnWidth(100.0),
                                },
                                children: List.generate(
                                    snapshot.data['topic_wise_array'].length,
                                    (index) => _getDataRow1(
                                        snapshot.data['topic_wise_array'][index],
                                        snapshot.data['topic_wise_array'])),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 12, right: 10),
                              child: Table(
                                border: TableBorder.symmetric(
                                    inside: BorderSide(
                                      width: 0.3,
                                      color: Color(0xff2E2A4A),
                                    ),
                                    outside: BorderSide(width: 0.3)),
                                // defaultColumnWidth: FixedColumnWidth(130),
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                columnWidths: {
                                  0: FlexColumnWidth(300.0),
                                  1: FlexColumnWidth(100.0),
                                  2: FlexColumnWidth(100.0),
                                  3: FlexColumnWidth(100.0),
                                },
                                children: [
                                  TableRow(
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                      children: [
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 8,
                                                bottom: 8),
                                            alignment: Alignment.center,
                                            child: AutoSizeText('Grand Total',
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black))),
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 8,
                                                bottom: 8),
                                            alignment: Alignment.center,
                                            child: AutoSizeText(
                                                snapshot.data[
                                                        'total_typewrong_question']
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black))),
                                        Container(
                                            padding: EdgeInsets.all(5),
                                            alignment: Alignment.center,
                                            child: AutoSizeText(
                                                snapshot.data[
                                                        'total_typeright_question']
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black))),
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 8,
                                                bottom: 8),
                                            alignment: Alignment.center,
                                            child: AutoSizeText(
                                                (snapshot.data[
                                                            'total_typewrong_question'] +
                                                        snapshot.data[
                                                            'total_typeright_question'])
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black))),
                                      ]),
                                ],
                              ),
                            ),
                          ]),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("W - Wrong", style: normalText15),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Text("R - Right", style: normalText15)
                              ]),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ]),
                    ),

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
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(false);
        Navigator.pushNamed(context, '/dashboard');
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xff2E2A4A),
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
            child: Text("Performance Details", style: normalText6),
          ),
          flexibleSpace: Container(
            height: 100,
            color: Color(0xffffffff),
          ),
          actions: <Widget>[
            InkWell(
              onTap: (){

                _takeScreenshot();


              },
              child: Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(Icons.download,color:Color(0xff2E2A4A) ,),
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
          color: Color(0xff2E2A4A),
          child:  Container(
              padding: EdgeInsets.only(bottom: 5),
              child: chapterList(deviceSize),
            ),
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.name, this.right, this.wrong, this.right1, this.wrong1);

  final String name;
  final double right;
  final double wrong;
  final int right1;
  final int wrong1;
}

class ChartData {
  ChartData(this.name, this.right, this.wrong, this.right1, this.wrong1);

  final String name;
  final double right;
  final double wrong;
  final int right1;
  final int wrong1;
}
