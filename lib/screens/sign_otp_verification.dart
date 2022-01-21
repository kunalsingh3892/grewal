import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grewal/components/general.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class SignOTPVerification extends StatefulWidget {
  final Object argument;

  const SignOTPVerification({Key key, this.argument}) : super(key: key);

  @override
  _LoginWithLogoState createState() => _LoginWithLogoState();
}

class _LoginWithLogoState extends State<SignOTPVerification> {
  final _formKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();

  // ..text = "123456";
  bool _autoValidate = false;

  // ignore: close_sinks
  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  bool _loading = false;
  bool _isHidden = true;

  String signupid = "";
  String send_type = "";
  String mobile = "";
  String email = "";
  String country = "";
  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    send_type = data['send_type'];
    signupid = data['signupid'];
    mobile = data['mobile'];
    email = data['email'];
    country = data['country'];
  }

  Widget _loginContent1() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 10.0),
          Form(
            key: formKey,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50),
                child: PinCodeTextField(
                  appContext: context,
                  pastedTextStyle: TextStyle(
                    color: Color(0xfff9f9fb),
                    fontWeight: FontWeight.bold,
                  ),
                  length: 4,
                  // obscureText: true,
                  //  obscuringCharacter: '*',

                  // blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  validator: (v) {
                    if (v.length < 4) {
                      return "Please fill all values";
                    } else {
                      return null;
                    }
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 50,
                    activeFillColor: Color(0xfff9f9fb),
                    disabledColor: Color(0xfff9f9fb),
                    inactiveColor: Color(0xfff9f9fb),
                    activeColor: Color(0xfff9f9fb),
                    selectedColor: Color(0xffBBBFC3),
                    inactiveFillColor: Color(0xfff9f9fb),
                    selectedFillColor: Color(0xfff9f9fb),
                  ),
                  cursorColor: Colors.black,
                  animationDuration: Duration(milliseconds: 300),
                  enableActiveFill: true,
                  errorAnimationController: errorController,
                  controller: textEditingController,
                  keyboardType: TextInputType.number,

                  onCompleted: (v) {
                    print("Completed");
                  },
                  // onTap: () {
                  //   print("Pressed");
                  // },
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              hasError ? "*Please fill up all the cells properly" : "",
              style: TextStyle(
                  color: Color(0xff017EFF),
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 10.0),
          InkWell(
            onTap: () async {
              setState(() {
                _loading = true;
              });
              final msg = jsonEncode({
                "mobile": mobile,
              });
              Map<String, String> headers = {
                'Accept': 'application/json',
              };
              var response = await http.post(
                new Uri.https(BASE_URL, API_PATH + "/resend_otp"),
                body: {
                  "mobile": mobile,
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
                if (errorCode == "0") {
                  setState(() {
                    _loading = false;
                  });
                  var otp = data['otp'];
                  Fluttertoast.showToast(msg: "Otp Send ");
                } else {
                  setState(() {
                    _loading = false;
                  });
                  showAlertDialog(context, ALERT_DIALOG_TITLE, errorMessage);
                }
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8.0, left: 8),
              child: Center(
                child: Text(
                  "Resend OTP",
                  style: TextStyle(
                      decoration: TextDecoration.underline, fontSize: 16),
                ),
              ),
            ),
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
                      "signup_id": signupid,
                      "otp": currentText,
                    });
                    Map<String, String> headers = {
                      'Accept': 'application/json',
                    };
                    var response = await http.post(
                      new Uri.https(
                          BASE_URL, API_PATH + "/student_signup_otp_varify"),
                      body: {
                        "signup_id": signupid,
                        "otp": currentText,
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

                        prefs.setString(
                            'user_id', data['Response']['id'].toString());
                        prefs.setString('order_id',
                            data['Response']['order_id'].toString());
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
                        prefs.setString(
                            'api_token', data['Response']['api_token']);
                        if (data['Response']['institute_id'] != null) {
                          prefs.setString('institute_id',
                              data['Response']['institute_id'].toString());
                        } else {
                          prefs.setString('institute_id', "0");
                        }
                        Navigator.pushNamed(
                          context,
                          '/plan',
                          arguments: <String, String>{
                            'order_id': data['order_id'].toString(),
                            'signupid': signupid.toString(),
                            'mobile': mobile,
                            'email': email,
                            'out': 'out'
                          },
                        );

                        //    Navigator.pushNamed(context, '/plan');
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
                child: Text(
                  "Verify OTP",
                  style: TextStyle(fontSize: 16, letterSpacing: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    color: index.isEven ? Color(0xff017EFF) : Color(0xffFFC700),
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
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
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
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    left: 20.0,
                    top: 0.0,
                    bottom: 20.0,
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Column(
                          //  crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Enter the 4-digit code",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21.0,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: /*send_type == "mobile"
                                  ?*/
                                  country == "6"
                                      ? Text(
                                          "sent to $mobile and your registered email.",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 21.0,
                                          ),
                                        )
                                      : Text(
                                          "sent to your registered email.",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 21.0,
                                          ),
                                        )
                              /*: Text(
                                      "sent to $email",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 21.0,
                                      ),
                                    )*/
                              ,
                            ),
                          ]),
                    ),
                  ),
                ]),
              ),
              Container(
                child: Form(
                  key: _formKey,
                  child: _loginContent1(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
