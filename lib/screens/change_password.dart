import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/services/shared_preferences.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ChangePassword extends StatefulWidget {
  @override
  _LoginWithLogoState createState() => _LoginWithLogoState();
}

class _LoginWithLogoState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final rePassController = TextEditingController();
  String profile_image = '';
  bool _loading = false;
  bool _isHidden = true;
  bool _isHidden1 = true;
  bool _isHidden2 = true;
  bool _autoValidate = false;
  String user_id = "";
  String api_token = "";
  void initState() {
    super.initState();
    _getUser();
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

  Widget _networkImage1(url) {
    return Container(
      /* margin: EdgeInsets.only(
        right: 8,
        left: 8,
      ),*/
      /* width: 60,
      height: 60,*/
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

  Widget _loginContent1() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 10.0),
          Container(
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: TextFormField(
                controller: oldPassController,
                obscureText: _isHidden,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff000000),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter old password';
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
                    hintText: 'Enter Old Password',
                    hintStyle:
                        TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                    fillColor: Color(0xfff9f9fb),
                    filled: true)),
          ),
          const SizedBox(height: 15.0),
          Container(
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: TextFormField(
                controller: newPassController,
                obscureText: _isHidden1,
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
                          _isHidden1 = !_isHidden1;
                        });
                      },
                      child: Container(
                          padding: EdgeInsets.all(16),
                          child: _isHidden1
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
                    hintText: 'Enter New Password',
                    hintStyle:
                        TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                    fillColor: Color(0xfff9f9fb),
                    filled: true)),
          ),
          const SizedBox(height: 15.0),
          Container(
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: TextFormField(
                controller: rePassController,
                obscureText: _isHidden2,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff000000),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please re enter password';
                  } else if (value != newPassController.text) {
                    return 'Password not matched';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _isHidden2 = !_isHidden2;
                        });
                      },
                      child: Container(
                          padding: EdgeInsets.all(16),
                          child: _isHidden2
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
                    hintText: 'Confirm password',
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
                      "user_id": user_id,
                      "old_password": oldPassController.text,
                      "new_password": newPassController.text,
                      "confirm_password": rePassController.text
                    });
                    Map<String, String> headers = {
                      'Accept': 'application/json',
                      'Authorization': 'Bearer $api_token',
                    };
                    var response = await http.post(
                      new Uri.https(BASE_URL, API_PATH + "/change-password"),
                      body: {
                        "user_id": user_id,
                        "old_password": oldPassController.text,
                        "new_password": newPassController.text,
                        "confirm_password": rePassController.text
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
                        Navigator.of(context).pop();
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
                child: Text(
                  "Update Password",
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
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
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
                        Container(
                          padding: const EdgeInsets.only(top: 60, right: 22),
                          child: Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 16,
                              child: _networkImage1(
                                profile_image,
                              ),
                            ),
                          ),
                        ),
                      ]),
                  Positioned(
                    right: 0.0,
                    left: 20.0,
                    top: 0.0,
                    bottom: 0.0,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Change Password",
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
