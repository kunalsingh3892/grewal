import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:in_app_update/in_app_update.dart';

import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';

import '../constants.dart';
import 'dashboard.dart';
import 'intro_screens.dart';
import 'reset_password.dart';
import 'get_otp.dart';
import 'login_with_logo.dart';
import 'otp_verification.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _loggedIn = false;
  bool _introIn = false;
  final splashDelay = 2;
  String appName, packageName, version, buildNumber;
  AppUpdateInfo _updateInfo;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  @override
  void initState() {
    super.initState();
    secureScreen();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;

      print("<<<<<<<<<<<" + appName);
      print("<<<<<<<<<<<" + packageName);
      print("<<<<<<<<<<<" + version);
      print("<<<<<<<<<<<" + buildNumber);
    });
    //  _versionCheck();
    // checkForUpdate();
    _checkLoggedIn();
    _loadWidget();
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  /*Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    }).catchError((e) {
      showSnack(e.toString());
    });
  }*/
  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  Future _versionCheck() async {
    Map<String, String> headers = {'Accept': 'application/json'};
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/version"),
      body: "",
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);

      if (int.parse(data['Response'][0]['android']) <= int.parse(buildNumber)) {
        _loadWidget();
      } else {
        _showCompulsoryUpdateDialog(
          context,
          "Please update the app to continue to version ${data['Response'][0]['android'] ?? ""}",
        );
      }
      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  _showCompulsoryUpdateDialog(context, String message) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "App Update Available";
        String btnLabel = "Update Now";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      btnLabel,
                    ),
                    isDefaultAction: true,
                    onPressed: _onUpdateNowClicked,
                  ),
                ],
              )
            : new AlertDialog(
                buttonPadding: EdgeInsets.all(10),
                backgroundColor: Color(0xff2E2A4A),
                title: Text(
                  title,
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
                content: Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      btnLabel,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _onUpdateNowClicked,
                  ),
                ],
              );
      },
    );
  }

  _onUpdateNowClicked() {
    StoreRedirect.redirect(androidAppId: packageName, iOSAppId: packageName);
  }

  _checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _isLoggedIn = prefs.getBool('logged_in');
    var _isIntroIn = prefs.getBool('intro_in');
    print(_isLoggedIn);
    print(_isIntroIn);
    if (_isLoggedIn == true) {
      setState(() {
        _loggedIn = _isLoggedIn;
        _introIn = _isIntroIn;
      });
    } else {
      setState(() {
        _loggedIn = false;
        if (_isIntroIn == null) {
          _introIn = false;
        } else {
          _introIn = _isIntroIn;
        }
      });
    }
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => homeOrLog()));
  }

  Widget homeOrLog() {
    if (this._loggedIn) {
      var obj = 0;
      return Dashboard();
    } else {
      if (_introIn == null) {
        return LoginWithLogo();
      } else if (_introIn == true) {
        return LoginWithLogo();
      } else {
        return IntroScreens();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Stack(alignment: Alignment.center, children: [
          Container(
            // color: Color(0xfff7f7f7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(children: [
                  Image.asset(
                    'assets/images/Vector6.png',
                    // fit: BoxFit.fill,
                  ),
                  Positioned(
                    bottom: 20.0,
                    right: 0.0,
                    left: 0.0,
                    top: 0.0,
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/grewal_academy.png',
                        width: 150,
                        height: 180,
                      ),
                    ),
                  ),
                ]),
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Image.asset(
                    'assets/images/splash_back.png',

                    // fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 300,
              height: 300,
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/blue_splash.png',
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
