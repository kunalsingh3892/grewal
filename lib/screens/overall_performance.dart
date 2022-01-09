import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/api/data_list.dart';
import 'package:grewal/components/indicator.dart';
import 'package:grewal/components/progress_bar.dart';
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

class OverAllPerformance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsState();
}

const double degrees2Radians = math.pi / 180.0;

class _SettingsState extends State<OverAllPerformance> {
  bool _value = false;
  Future _chapterData;
  bool isLoading = false;
  String api_token = "";
  TextStyle normalText5 = GoogleFonts.montserrat(
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
      fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white);

  final completeController = TextEditingController();

  String user_id = "";
  String chapter_id = "";
  String chapter_name = "";
  String type = "";
  String test_id = "";
  String profile_image = '';
  List<ChartData> chartData = [];
  List subjectList = [];
  List chaptersList = [];
  bool isLoad1 = false;
  @override
  void initState() {
    super.initState();

    _tooltipBehavior = TooltipBehavior(enable: true);
    _getUser();

    DataListOfSubjects().getSubjectsList().then((value) {
      if (value.length > 0) {
        setState(() {
          subjectList.addAll(value);
          print(subjectList);
        });
      }
    });
  }

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        user_id = prefs.getString('user_id').toString();
        profile_image = prefs.getString('profile_image').toString();
        api_token = prefs.getString('api_token').toString();
      });
    });
  }

  TooltipBehavior _tooltipBehavior;

  Future _getPerformanceData(String chapter_id) async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/questiontypeperformance"),
      body: {"user_id": user_id, "chapter_id": chapter_id},
      headers: headers,
    );
    print({"user_id": user_id});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['question_type'].length != 0) {
        setState(() {
          if (data['question_type'].length == 3) {
            chartData = [
              ChartData(
                  data['question_type'][0]['questiontype_name'],
                  double.parse(data['question_type'][0]['total_percentage']),
                  data['question_type'][0]['total_question'].toString(),
                  data['question_type'][0]['question_type_id'].toString(),
                  Color(0xff017EFF)),
              ChartData(
                  data['question_type'][1]['questiontype_name'],
                  double.parse(data['question_type'][1]['total_percentage']),
                  data['question_type'][1]['total_question'].toString(),
                  data['question_type'][1]['question_type_id'].toString(),
                  Color(0xffFFC700)),
              ChartData(
                  data['question_type'][2]['questiontype_name'],
                  double.parse(data['question_type'][2]['total_percentage']),
                  data['question_type'][2]['total_question'].toString(),
                  data['question_type'][2]['question_type_id'].toString(),
                  Color(0xff4CE364)),
            ];
          } else if (data['question_type'].length == 2) {
            chartData = [
              ChartData(
                  data['question_type'][0]['questiontype_name'],
                  double.parse(data['question_type'][0]['total_percentage']),
                  data['question_type'][0]['total_question'].toString(),
                  data['question_type'][0]['question_type_id'].toString(),
                  Color(0xff017EFF)),
              ChartData(
                  data['question_type'][1]['questiontype_name'],
                  double.parse(data['question_type'][1]['total_percentage']),
                  data['question_type'][1]['total_question'].toString(),
                  data['question_type'][1]['question_type_id'].toString(),
                  Color(0xffFFC700)),
            ];
          } else {
            chartData = [
              ChartData(
                  data['question_type'][0]['questiontype_name'],
                  double.parse(data['question_type'][0]['total_percentage']),
                  data['question_type'][0]['total_question'].toString(),
                  data['question_type'][0]['question_type_id'].toString(),
                  Color(0xff017EFF)),
            ];
          }
        });
      }

      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  int _currentSliderValue = 2;

  int touchedIndex = -1;
  TextStyle normalText15 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white);

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
    return SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            // color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  DropdownButtonFormField(
                      validator: (value) => value == null ? "Required" : null,
                      isDense: true,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(),
                          labelText: 'Select Subject',
                          isDense: true,
                          fillColor: Colors.white,
                          filled: true),
                      isExpanded: true,
                      elevation: 8,
                      items: subjectList.map((e) {
                        return DropdownMenuItem(
                          child: Text(e['subject_name'].toString()),
                          value: e,
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          isLoad1 = true;
                        });
                        ProgressBarLoading().showLoaderDialog(context);
                        DataListOfSubjects()
                            .getChapterList(val['id'].toString())
                            .then((value) {
                          Navigator.of(context).pop();
                          if (value.length > 0) {
                            setState(() {
                              chaptersList.clear();
                              chaptersList.addAll(value);
                              print(chaptersList);
                              setState(() {
                                isLoad1 = false;
                              });
                            });
                          }
                        });
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  isLoad1
                      ? Text("Loading...")
                      : DropdownButtonFormField(
                          validator: (value) =>
                              value == null ? "Required" : null,
                          isDense: true,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(),
                              labelText: 'Select Chapter',
                              isDense: true,
                              fillColor: Colors.white,
                              filled: true),
                          isExpanded: true,
                          elevation: 8,
                          value: null,
                          items: chaptersList.map((e) {
                            return DropdownMenuItem(
                              child: Text(e['chapter_name'].toString()),
                              value: e,
                            );
                          }).toList(),
                          onChanged: (val) {
                            ProgressBarLoading().showLoaderDialog(context);
                            setState(() {
                              _chapterData =
                                  _getPerformanceData(val['id'].toString());
                            });
                            Navigator.of(context).pop();
                          }),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: deviceSize.width,
          height: deviceSize.height * 0.50,
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  bottomLeft: const Radius.circular(20.0),
                  bottomRight: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0))),
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 20),
          child: ListView(children: [
            Column(children: [
              Container(
                child: Text("Question Wise Analysis", style: normalText6),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: SfCircularChart(
                    tooltipBehavior: _tooltipBehavior,
                    legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        height: "150",
                        padding: 20,
                        orientation: LegendItemOrientation.vertical,
                        textStyle: normalText5),
                    series: <CircularSeries>[
                      DoughnutSeries<ChartData, String>(
                        animationDuration: 2000,
                        enableSmartLabels: true,
                        enableTooltip: true,
                        explode: true,
                        dataSource: chartData,
                        onPointTap: (ChartPointDetails details) {
                          print(details.pointIndex);
                          if (details.pointIndex == 0) {
                            for (int i = 0; i < chartData.length; i++) {
                              if (details.pointIndex == i) {
                                print(chartData[i].z);
                                Navigator.pushNamed(
                                  context,
                                  '/overall-performance-details',
                                  arguments: <String, String>{
                                    'question_id': chartData[i].z.toString(),
                                  },
                                );
                              }
                            }
                          } else if (details.pointIndex == 1) {
                            for (int i = 0; i < chartData.length; i++) {
                              if (details.pointIndex == i) {
                                print(chartData[i].z);
                                Navigator.pushNamed(
                                  context,
                                  '/overall-performance-details',
                                  arguments: <String, String>{
                                    'question_id': chartData[i].z.toString(),
                                  },
                                );
                              }
                            }
                          } else if (details.pointIndex == 2) {
                            for (int i = 0; i < chartData.length; i++) {
                              if (details.pointIndex == i) {
                                print(chartData[i].z);
                                Navigator.pushNamed(
                                  context,
                                  '/overall-performance-details',
                                  arguments: <String, String>{
                                    'question_id': chartData[i].z.toString(),
                                  },
                                );
                              }
                            }
                          }
                        },
                        selectionBehavior: SelectionBehavior(
                          enable: true,
                        ),
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                        ),
                        dataLabelMapper: (ChartData sales, _) =>
                            sales.y1.toString() +
                            " (" +
                            sales.y.toString() +
                            "%" +
                            ") ",
                        pointColorMapper: (ChartData data, _) => data.color,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        radius: "100",
                        innerRadius: "40",
                      )
                    ]),
              ),
            ]),
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
        FutureBuilder(
          future: _chapterData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data['question_type'].length != 0) {
                return Container(
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
                                snapshot.data['Response'].length,
                                (index) => _getDataRow1(
                                    snapshot.data['Response'][index],
                                    snapshot.data['Response'])),
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
                );
              } else {
                return _emptyOrders();
              }
            } else {
              return Center(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Please select chapter",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )));
            }
          },
        )
      ]),
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
                  Navigator.pushNamed(context, '/dashboard');
                },
              ),
            ]),
          ),
          centerTitle: true,
          title: Container(
            child: FittedBox(
                child: Text("Over All Performance", style: normalText6)),
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
          color: Color(0xff2E2A4A),
          child: Container(
            padding: EdgeInsets.only(bottom: 5),
            child: chapterList(deviceSize),
          ),
        ),
      ),
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

class ChartData {
  ChartData(this.x, this.y, this.y1, this.z, [this.color]);
  final String x;
  final double y;
  final String y1;
  final String z;
  final Color color;
}
