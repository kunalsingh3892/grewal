import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grewal/components/general.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class GetOTP extends StatefulWidget {
  @override
  _LoginWithLogoState createState() => _LoginWithLogoState();
}

class _LoginWithLogoState extends State<GetOTP> {
  final _formKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();
  bool _autoValidate = false;
  bool _loading = false;
  bool _isHidden = true;

  Widget _loginContent1() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 10.0),
          Container(
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: TextFormField(
                controller: mobileController,
                //   maxLength: 10,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff000000),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter mobile number/email id';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    /* prefixIcon: Container(
                      padding: EdgeInsets.all(16),
                      margin: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: 16,
                        height: 12,
                        child: Image.asset(
                          'assets/images/person.png',
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
                    counterText: "",
                    hintText: 'Your mobile number/email id',
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
                    });
                    Map<String, String> headers = {
                      'Accept': 'application/json',
                    };
                    var response = await http.post(
                      new Uri.https(BASE_URL, API_PATH + "/forgot-password"),
                      body: {
                        "email": mobileController.text,
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
                        var otp = data['otp'];
                        Fluttertoast.showToast(msg: "Otp Send ");
                        Navigator.pushNamed(
                          context,
                          '/otp-verification',
                          arguments: <String, String>{
                            'mobile': mobileController.text,
                          },
                        );
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
                  "Get OTP",
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
                    bottom: 0.0,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Continue with Email/Mobile No.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21.0,
                        ),
                      ),
                    ),
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
    );
  }
}
