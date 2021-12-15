import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/services/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:screenshot/screenshot.dart';

import 'package:shared_preferences/shared_preferences.dart';



class CreateQuestion extends StatefulWidget {


  @override
  _ChangePageState createState() => _ChangePageState();
}

class _ChangePageState extends State<CreateQuestion> {
  Future<dynamic> _chapterData;
  bool _loading = false;
  var access_token;
  var mcqController = TextEditingController(text: "0");
  var mcqController2 = TextEditingController(text: "0");
  var mcqController3 = TextEditingController(text: "0");
  var detailController = TextEditingController(text: "0");
  var detailController2 = TextEditingController(text: "0");
  var detailController3 = TextEditingController(text: "0");
  bool showList = false;
  bool valuefirst = false;
  String user_id = "";
  String class_id = "";
  String board_id = "";
  String payment = '';
  String total_test_quetion = '';
  String _mobile = "";
  String email_id = '';
  String order_id = "";
  String profile_image = '';
  List<bool> isChecked = new List();
  List<bool> isChecked1 = new List();
  var _value = 0.0;
  var _value1 = 0.0;
  List<String> list = [];
  String chapter_id = "";
  String chapter_name = "";
  String type = "";
  String value1="0";
  String value2="0";

  var _type5="";
  var _type="";
  var _type3="";
  String selectedRegion6 ;
  String selectedRegion;
  String selectedRegion3 = "";
  String catData5 = "";
  String catData = "";
  String catData3 = "";
  Future _batchData;
  Future _boardData;
  Future _classData;

  int mcq_total=0;
  int detail_total=0;
  int mcq1=0;
  int mcq2=0;
  int mcq3=0;
  int detail1=0;
  int detail2=0;
  int detail3=0;
  @override
  void initState() {
    super.initState();
    _getUser();
  }

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        email_id = prefs.getString('email_id').toString();
        _mobile = prefs.getString('mobile_no').toString();
        user_id = prefs.getString('user_id').toString();
        profile_image = prefs.getString('profile_image').toString();


      });
    });
  }
  var result;

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
  TextStyle normalText2 = GoogleFonts.montserrat(
      fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xff2E2A4A));
  TextStyle normalText1 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w300, color: Color(0xff22215B));
  Widget chapterList(Size deviceSize) {
    return Column(

        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: deviceSize.width,

            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    bottomLeft: const Radius.circular(10.0),
                    bottomRight: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0))),
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
            child:
                  Column(children: [
                    Container(
                      child: Text("No. of Questions", style: normalText6),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 5,right: 5),
                      child: Row(
                          children: <Widget>[
                            Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.09,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xff567DF4),
                                    Color(0xff567DF4),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '0',
                                    // snapshot.data['cart_quantity'] > 0 ? 'Go to Basket' : 'Add to Basket',
                                    style: TextStyle(
                                        color:  Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.68,
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Color(0xFFe7bf2e),
                                  inactiveTrackColor:  Color(0xff567DF4),
                                  trackShape: RoundedRectSliderTrackShape(),
                                  trackHeight: 4.0,
                                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                  thumbColor: Color(0xFFe7bf2e),
                                  overlayColor: Colors.red.withAlpha(32),
                                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                                  tickMarkShape: RoundSliderTickMarkShape(),
                                  activeTickMarkColor: Color(0xFFe7bf2e),
                                  inactiveTickMarkColor:Color(0xFFe7bf2e),
                                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                                  valueIndicatorColor: Color(0xFFe7bf2e),
                                  valueIndicatorTextStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                child: Slider(
                                  value: _value,
                                  min: 0,
                                  max: 100,
                                  divisions: 10,
                                  label: '$_value',
                                  onChanged: (value) {
                                    setState(
                                          () {
                                        _value = value;

                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.09,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [

                                    Color(0xff567DF4),
                                    Color(0xff567DF4),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "100",
                                    // snapshot.data['cart_quantity'] > 0 ? 'Go to Basket' : 'Add to Basket',
                                    style: TextStyle(
                                        color:  Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ]
                      ),
                    ),

                  ]),

          ),


          Container(
            width: deviceSize.width,

            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    bottomLeft: const Radius.circular(10.0),
                    bottomRight: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0))),
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
            child:
            Column(children: [
              Container(
                child: Text("MCQ / Detailed %", style: normalText6),
              ),
              SizedBox(
                height: 10,
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 5,right: 5),
                child: Row(
                    children: <Widget>[
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width * 0.09,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xff567DF4),
                              Color(0xff567DF4),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '0',
                              // snapshot.data['cart_quantity'] > 0 ? 'Go to Basket' : 'Add to Basket',
                              style: TextStyle(
                                  color:  Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.68,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Color(0xFFe7bf2e),
                            inactiveTrackColor:  Color(0xff567DF4),
                            trackShape: RoundedRectSliderTrackShape(),
                            trackHeight: 4.0,
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                            thumbColor: Color(0xFFe7bf2e),
                            overlayColor: Colors.red.withAlpha(32),
                            overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                            tickMarkShape: RoundSliderTickMarkShape(),
                            activeTickMarkColor: Color(0xFFe7bf2e),
                            inactiveTickMarkColor:Color(0xFFe7bf2e),
                            valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                            valueIndicatorColor: Color(0xFFe7bf2e),
                            valueIndicatorTextStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          child: Slider(
                            value: _value1,
                            min: 0,
                            max: 100,
                            divisions: 100,
                            label: '$_value1',
                            onChanged: (value) {
                              setState(
                                    () {
                                  _value1 = value;

                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width * 0.09,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [

                              Color(0xff567DF4),
                              Color(0xff567DF4),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "100",
                              // snapshot.data['cart_quantity'] > 0 ? 'Go to Basket' : 'Add to Basket',
                              style: TextStyle(
                                  color:  Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                      ),
                    ]
                ),
              ),

            ]),

          ),
          Container(
            width: deviceSize.width,

            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    bottomLeft: const Radius.circular(10.0),
                    bottomRight: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0))),
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
            child:
            Column(children: [
              Container(
                child: Text("Select Topic", style: normalText6),
              ),
              SizedBox(
                height: 10,
              ),

              Container(
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

                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(

                          child: Text(
                              "Guarantee of Profit",
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

                    Expanded(
                      child: Container(
                        child: Text("10 MCQ/ 12 Detailed",
                            style: normalText1),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(right: 8.0, left: 5),
                            child: TextFormField(
                                controller: mcqController,

                                keyboardType: TextInputType.number,
                                cursorColor: Color(0xff000000),
                                textCapitalization: TextCapitalization.sentences,
                                validator: (value) {

                                  return null;
                                },
                                onSaved: (value) {
                                  mcqController.text = value;
                                },
                                onChanged: (value) {

                                  setState(() {
                                    mcq1=int.parse(mcqController.text);
                                    mcq2=int.parse(mcqController2.text);
                                    mcq3=int.parse(mcqController3.text);
                                    mcq_total= mcq1+mcq2+mcq3;
                                  });

                                },
                                decoration: InputDecoration(

                                    isDense: true,
                                    contentPadding: EdgeInsets.fromLTRB(10, 20, 30, 0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    counterText: "",

                                    hintStyle:
                                    TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                                    fillColor: Color(0xfff9f9fb),
                                    filled: true)),
                          ),

                          SizedBox(height: 5),
                          Text(
                              "MCQ",
                              style: normalText1
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(right: 8.0, left: 5),
                            child: TextFormField(
                                controller: detailController,

                                keyboardType: TextInputType.number,
                                cursorColor: Color(0xff000000),
                                textCapitalization: TextCapitalization.sentences,
                                validator: (value) {

                                  return null;
                                },
                                onSaved: (value) {
                                  detailController.text = value;
                                },
                                onChanged: (value) {


                                    setState(() {
                                      detail1=int.parse(mcqController.text);
                                      detail2=int.parse(mcqController2.text);
                                      detail3=int.parse(mcqController3.text);
                                      detail_total= detail1+detail2+detail3;
                                    });

                                },
                                decoration: InputDecoration(

                                    isDense: true,
                                    contentPadding: EdgeInsets.fromLTRB(10, 20, 20, 0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    counterText: "",

                                    hintStyle:
                                    TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                                    fillColor: Color(0xfff9f9fb),
                                    filled: true)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Detailed",
                            style: normalText1,
                          ),
                        ],
                      ),
                    ),
                  ]),
                ]),
              ),
              Container(
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

                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(

                          child: Text(
                              "Partners Capital Account",
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

                    Expanded(
                      child: Container(
                        child: Text("5 MCQ/ 6 Detailed",
                            style: normalText1),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(right: 8.0, left: 5),
                            child: TextFormField(
                                controller: mcqController2,

                                keyboardType: TextInputType.number,
                                cursorColor: Color(0xff000000),
                                textCapitalization: TextCapitalization.sentences,
                                validator: (value) {

                                  return null;
                                },
                                onSaved: (value) {
                                  mcqController2.text = value;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    mcq1=int.parse(mcqController.text);
                                    mcq2=int.parse(mcqController2.text);
                                    mcq3=int.parse(mcqController3.text);
                                    mcq_total= mcq1+mcq2+mcq3;
                                  });

                                },
                                decoration: InputDecoration(

                                    isDense: true,
                                    contentPadding: EdgeInsets.fromLTRB(10, 20, 30, 0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    counterText: "",

                                    hintStyle:
                                    TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                                    fillColor: Color(0xfff9f9fb),
                                    filled: true)),
                          ),

                          SizedBox(height: 5),
                          Text(
                              "MCQ",
                              style: normalText1
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(right: 8.0, left: 5),
                            child: TextFormField(
                                controller: detailController2,
                                maxLength: 10,
                                keyboardType: TextInputType.number,
                                cursorColor: Color(0xff000000),
                                textCapitalization: TextCapitalization.sentences,
                                validator: (value) {

                                  return null;
                                },
                                onSaved: (value) {
                                  detailController2.text = value;
                                },

                                onChanged: (value) {
                                  setState(() {
                                    detail1=int.parse(mcqController.text);
                                    detail2=int.parse(mcqController2.text);
                                    detail3=int.parse(mcqController3.text);
                                    detail_total= detail1+detail2+detail3;
                                  });

                                },
                                decoration: InputDecoration(

                                    isDense: true,
                                    contentPadding: EdgeInsets.fromLTRB(10, 20, 20, 0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    counterText: "",

                                    hintStyle:
                                    TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                                    fillColor: Color(0xfff9f9fb),
                                    filled: true)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Detailed",
                            style: normalText1,
                          ),
                        ],
                      ),
                    ),
                  ]),
                ]),
              ),
              Container(
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

                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(

                          child: Text(
                              "Remuneration to Partners",
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

                    Expanded(
                      child: Container(
                        child: Text("8 MCQ/ 8 Detailed",
                            style: normalText1),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(right: 8.0, left: 5),
                            child: TextFormField(
                                controller: mcqController3,
                                keyboardType: TextInputType.number,
                                cursorColor: Color(0xff000000),
                                textCapitalization: TextCapitalization.sentences,
                                validator: (value) {

                                  return null;
                                },
                                onSaved: (value) {
                                  mcqController.text = value;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    detail1=int.parse(mcqController.text);
                                    detail2=int.parse(mcqController2.text);
                                    detail3=int.parse(mcqController3.text);
                                    detail_total= detail1+detail2+detail3;
                                  });

                                },
                                decoration: InputDecoration(

                                    isDense: true,
                                    contentPadding: EdgeInsets.fromLTRB(10, 20, 30, 0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    counterText: "",

                                    hintStyle:
                                    TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                                    fillColor: Color(0xfff9f9fb),
                                    filled: true)),
                          ),

                          SizedBox(height: 5),
                          Text(
                              "MCQ",
                              style: normalText1
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(right: 8.0, left: 5),
                            child: TextFormField(
                                controller: detailController3,

                                keyboardType: TextInputType.number,
                                cursorColor: Color(0xff000000),
                                textCapitalization: TextCapitalization.sentences,
                                validator: (value) {

                                  return null;
                                },
                                onSaved: (value) {
                                  detailController3.text = value;
                                },
                                onChanged: (value) {

                                  setState(() {
                                    detail1=int.parse(mcqController.text);
                                    detail2=int.parse(mcqController2.text);
                                    detail3=int.parse(mcqController3.text);
                                    detail_total= detail1+detail2+detail3;
                                  });

                                },
                                decoration: InputDecoration(

                                    isDense: true,
                                    contentPadding: EdgeInsets.fromLTRB(10, 20, 20, 0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    counterText: "",

                                    hintStyle:
                                    TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                                    fillColor: Color(0xfff9f9fb),
                                    filled: true)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Detailed",
                            style: normalText1,
                          ),
                        ],
                      ),
                    ),
                  ]),
                ]),
              )

            ]),

          ),
        ]);
  }


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w300, color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));

  TextStyle next = GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
      letterSpacing: 1);

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
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,

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
          child: Text("Create Test", style: normalText6),
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
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Container(
          child: Container(

              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[

                  const SizedBox(height: 10.0),
                 Expanded(child: Container(
                      padding: EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 5),

                      decoration: BoxDecoration(
                        color: Color(0xff2E2A4A),

                      ),
                      child: ListView(
                          children: <Widget>[


                          Container(child: chapterList(deviceSize))
                          ]))),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            child: Center(
                              child: Container(
                                color: Colors.white,
                                height: 60,
                                width: MediaQuery.of(context).size.width * 0.50,
                                // padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'MCQ',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 12),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                     mcq_total.toString(),
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Container(
                                color: Colors.white,
                                height: 60,
                                width: MediaQuery.of(context).size.width * 0.50,
                                // padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Detailed',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 12),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "123",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Center(
                              child: GestureDetector(

                                child: Container(
                                  height: 60,
                                  color: Color(0xff017EFF),
                                  width: MediaQuery.of(context).size.width * 0.50,
                                  // padding: EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Start",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              )),
        ),
      ),
    );
  }
}
