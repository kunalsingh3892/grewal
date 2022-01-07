import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/general.dart';

import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class LoginWithLogo extends StatefulWidget {
  @override
  _LoginWithLogoState createState() => _LoginWithLogoState();
}

TextStyle normalText5 = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xff2E2A4A),
    decoration: TextDecoration.underline);
TextStyle normalText2 = GoogleFonts.montserrat(
    fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
TextStyle normalText3 = GoogleFonts.montserrat(
    fontSize: 14, fontWeight: FontWeight.w700, color: Colors.blue);

TextStyle normalText1 = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    letterSpacing: 1);

class _LoginWithLogoState extends State<LoginWithLogo> {
  final _formKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  bool _loading = false;
  bool _isHidden = true;
  bool _autoValidate = false;
  String fcmToken = "";
  Stream<String> _tokenStream;
  StreamSubscription iosSubscription;
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getToken().then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
  }

  void setToken(String token) {
    print('FCM Token: $token');
    setState(() {
      fcmToken = token;
    });
  }

  Widget _loginContent1() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 25.0),
          Container(
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: TextFormField(
                controller: mobileController,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff000000),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Mobile Number';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 30, 30, 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    counterText: "",
                    hintText: 'Your mobile number/email id',
                    hintStyle:
                        TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                    fillColor: Color(0xfff9f9fb),
                    filled: true)),
          ),
          const SizedBox(height: 15.0),
          Container(
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: TextFormField(
                obscureText: _isHidden,
                controller: passwordController,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff000000),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _isHidden = !_isHidden;
                        });
                      },
                      child: Container(
                          padding: EdgeInsets.all(16),
                          child: _isHidden
                              ? Text(
                                  "Show",
                                  style: TextStyle(
                                      color: Color(0xff017EFF),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                )
                              : Text(
                                  "Hide",
                                  style: TextStyle(
                                      color: Color(0xff017EFF),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                )),
                    ),
                    /*   prefixIcon: Container(
                      padding: EdgeInsets.all(16),
                      margin: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: 16,
                        height: 12,
                        child: Image.asset(
                          'assets/images/key.png',
                        ),
                      ),
                    ),*/
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 30, 30, 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    hintText: 'Password',
                    hintStyle:
                        TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                    fillColor: Color(0xfff9f9fb),
                    filled: true)),
          ),
          const SizedBox(height: 30.0),
          Container(
            width: MediaQuery.of(context).size.height * 0.80,
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: ButtonTheme(
              height: 28.0,
              child: RaisedButton(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                textColor: Colors.white,
                color: Color(0xff017EFF),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    setState(() {
                      _loading = true;
                    });
                    final msg = jsonEncode({
                      "email": mobileController.text,
                      "password": passwordController.text,
                      "device_token": fcmToken
                    });
                    Map<String, String> headers = {
                      'Accept': 'application/json',
                    };
                    var response = await http.post(
                      new Uri.https(BASE_URL, API_PATH + "/student-login"),
                      body: {
                        "email": mobileController.text,
                        "password": passwordController.text,
                        "device_token": fcmToken
                      },
                      headers: headers,
                    );
                    print(msg);

                    if (response.statusCode == 200) {
                      setState(() {
                        _loading = false;
                      });
                      var data = json.decode(response.body);

                      print(data);
                      var errorCode = data['ErrorCode'];
                      var errorMessage = data['ErrorMessage'];
                      if (errorCode == 0) {
                        setState(() {
                          _loading = false;
                        });
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool('logged_in', true);
                        prefs.setString(
                            'user_id', data['Response']['id'].toString());
                        prefs.setString('name', data['Response']['name']);
                        prefs.setString('school_id',
                            data['Response']['school_id'].toString());
                        prefs.setString('email_id', data['Response']['email']);
                        prefs.setString(
                            'mobile_no', data['Response']['mobile'].toString());
                        prefs.setString(
                            'profile_image', data['profile_url'].toString());
                        prefs.setString('class_id',
                            data['Response']['class_id'].toString());
                        prefs.setString('board_id',
                            data['Response']['board_id'].toString());
                        prefs.setInt('amount', data['offer_price']);
                        prefs.setInt(
                            'base_amount', int.parse(data['base_price']));
                        prefs.setInt('disc_amount', data['dis_amt']);
                        prefs.setString('currency', data['currency']);
                        prefs.setString(
                            'api_token', data['Response']['api_token']);
                        prefs.setBool('payment_status',
                            data['payment_flag'] == 1 ? true : false);
                        prefs.setBool('payment_status2',
                            data['term_two'] == 1 ? true : false);

                        print(data['Response']['api_token']);
                        if (data['Response']['institute_id'] != null) {
                          prefs.setString('institute_id',
                              data['Response']['institute_id'].toString());
                        } else {
                          prefs.setString('institute_id', "0");
                        }
                        Navigator.pushNamed(context, '/dashboard');
                      } else {
                        setState(() {
                          _loading = false;
                        });
                        showAlertDialog(
                            context, ALERT_DIALOG_TITLE, errorMessage);
                      }
                    }
                  } else {
                    setState(() {
                      _autoValidate = true;
                    });
                  }
                },
                child: Text("Login", style: normalText1),
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/get-otp');
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8.0, left: 8),
              child: Center(
                child: Text("Forgot Password?", style: normalText5),
              ),
            ),
          ),
          /*const SizedBox(height: 40.0),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(right: 8.0, left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            //background color of box
                            BoxShadow(
                              color: Colors.grey.shade100,
                              blurRadius: 1.0,
                              // soften the shadow
                              spreadRadius: 2.0,
                              //extend the shadow
                              offset: Offset(
                                0.0,
                                // Move to right 10  horizontally
                                0.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: InkWell(
                            child: Image.asset(
                              'assets/images/flat_color_icons_google.png',
                              height: 27.68,
                              width: 27.68,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 20.0),
               InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            //background color of box
                            BoxShadow(
                              color: Colors.grey.shade100,
                              blurRadius: 1.0,
                              // soften the shadow
                              spreadRadius: 2.0,
                              //extend the shadow
                              offset: Offset(
                                0.0,
                                // Move to right 10  horizontally
                                0.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: InkWell(
                            child: Image.asset(
                              'assets/images/flat_color_icons_faacebook.png',
                              height: 27.68,
                              width: 27.68,
                            ),
                          ),
                        ),
                      ),

                  ),
                ],
              ),
            ),
          ),*/
          const SizedBox(height: 30.0),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/sign-up');
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8.0, left: 8),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: normalText2,
                    ),
                    Text(
                      " Sign up",
                      style: normalText3,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> onWillPop() {
    SystemNavigator.pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: _loading,
          progressIndicator: Center(
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
          )),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Stack(children: <Widget>[
                    Image(
                      image: AssetImage('assets/images/Vector6.png'),
                      // fit: BoxFit.fill,
                    ),
                    /*   Padding(
                        padding: const EdgeInsets.only(top: 60, left: 22),
                        child: Container(
                          width: 10,
                          height: 17,
                          child: Image(
                              image: AssetImage('assets/images/Icon.png'),
                              height: 20,
                              width: 10,
                              fit: BoxFit.fill),
                        ),
                      ),*/
                    Positioned(
                      right: 0.0,
                      left: 0.0,
                      top: 50.0,
                      bottom: 0.0,
                      child: Column(children: <Widget>[
                        Container(
                          alignment: Alignment.topCenter,
                          child: Image.asset(
                            'assets/images/grewal_academy.png',
                            width: 150,
                            height: 180,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Image.asset(
                              'assets/images/Group_29.png',
                              width: 200,
                              height: 200,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ]),
                ),
                Container(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _autoValidate
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    child: _loginContent1(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
