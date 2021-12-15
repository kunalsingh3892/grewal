import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/color_constants.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../constants.dart';


class OlyTestList extends StatefulWidget {


  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<OlyTestList> {
  bool _value = false;
  Future _chapterData;
  bool isLoading = false;
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff2E2A4A));
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w300, color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  final completeController = TextEditingController();

  String user_id = "";
  String chapter_id = "";
  String chapter_name = "";
  String type = "";
  String profile_image = '';
  String payment = '';
  String total_test_quetion = '';
  String _mobile = "";
  String email_id = '';
  String order_id = "";
  String api_token = "";
  String amount = "";
  Razorpay _razorpay;
  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _getUser();
  }

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        email_id = prefs.getString('email_id').toString();
        _mobile = prefs.getString('mobile_no').toString();
        user_id = prefs.getString('user_id').toString();
        order_id = prefs.getString('order_id').toString();
        profile_image = prefs.getString('profile_image').toString();
        api_token = prefs.getString('api_token').toString();
        _chapterData = _getChapterData();
      });
    });
  }
  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {

    print("Success: " + response.orderId.toString());
    print("Success: " + response.paymentId.toString());
    print("Success: " + response.signature.toString());


    final msg = jsonEncode({
      "student_id":user_id,
      "trancation_id":response.paymentId.toString(),
      "status":"success",
      "amount":amount.toString()
    });
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response1 = await http.post(
      new Uri.https(
          BASE_URL, API_PATH + "/olympiad_student_payment"),
      body: {
        "student_id":user_id,
        "trancation_id":response.paymentId.toString(),
        "status":"success",
        "amount":amount.toString()
      },
      headers: headers,
    );
    print(msg);

    if (response1.statusCode == 200) {
      var data = json.decode(response1.body);
      print(data);
      var errorCode = data['ErrorCode'];
      var errorMessage = data['ErrorMessage'];
      if (errorCode == 0) {

        setState(() {
          _chapterData = _getChapterData();
        });


      } else {

        showAlertDialog(
            context, ALERT_DIALOG_TITLE, errorMessage);
      }
    }



  }

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {

    print("ERROR: " + response.message);
    final msg = jsonEncode({
      "student_id":user_id,
      "trancation_id":"",
      "status":"fail",
      "amount":amount.toString()
    });
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response1 = await http.post(
      new Uri.https(
          BASE_URL, API_PATH + "/olympiad_student_payment"),
      body: {
        "student_id":user_id,
        "trancation_id":"",
        "status":"fail",
        "amount":amount.toString()
      },
      headers: headers,
    );
    print(msg);

    if (response1.statusCode == 200) {
      var data = json.decode(response1.body);
      print(data);
      var errorCode = data['ErrorCode'];
      var errorMessage = data['ErrorMessage'];
      if (errorCode == 0) {

        setState(() {
          _chapterData = _getChapterData();
        });


      } else {

        showAlertDialog(
            context, ALERT_DIALOG_TITLE, errorMessage);
      }
    }


  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName);
    print("EXTERNAL_WALLET: " + response.walletName);
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

  Widget _networkImage(url) {
    return Image(
      image: NetworkImage(url),
    );
  }

  Future _getChapterData() async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/test-list-olympiad"),
      body: {
        "user_id": user_id,

      },
      headers: headers,
    );

    print(jsonEncode({
      "user_id": user_id,

    }));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if(data['ErrorCode']==0){
        setState(() {
          amount=data['pay_amount'].toString();
        });

      }


      print(data);

      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Widget chapterList(Size deviceSize) {
    return FutureBuilder(
      future: _chapterData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if(snapshot.data['ErrorCode']==0) {
            if(snapshot.data['pay_status']!="false") {
              if (snapshot.data['Response'].length != 0) {
                return Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snapshot.data['Response'].length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/section-list',
                              arguments: <String, String>{
                                'test_id': snapshot
                                    .data['Response'][index]['id']
                                    .toString(),
                              },
                            );
                          },
                          child: Column(children: <Widget>[
                            Stack(children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5),
                                color: Color(0xffF9F9FB),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Center(
                                        child: Container(
                                          //  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                          height: 50,
                                          width: 50,
                                          decoration: new BoxDecoration(
                                            // color: Color(0xffF6F6F6),
                                              borderRadius: new BorderRadius
                                                  .only(
                                                  topLeft:
                                                  const Radius.circular(5.0),
                                                  bottomLeft:
                                                  const Radius.circular(5.0),
                                                  bottomRight:
                                                  const Radius.circular(5.0),
                                                  topRight: const Radius
                                                      .circular(
                                                      5.0))),
                                          child: CircleAvatar(
                                            backgroundColor: Color(0xff017EFF),
                                            radius: 40,
                                            child: Image(
                                              image: AssetImage(
                                                'assets/images/ribbon.png',
                                              ),
                                              height: 22.0,
                                              width: 22.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                          /*   child: Center(
                                                      child: Text(
                                                        snapshot
                                                            .data['Response'][index]['chapter_name'][0]
                                                            .toUpperCase(),
                                                        style: TextStyle(fontSize: 30.0,
                                                            color: Color(0xff017EFF),),
                                                      ),
                                                    ),*/
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                      snapshot.data['Response']
                                                      [index]['name'],
                                                      maxLines: 2,
                                                      softWrap: true,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      style: normalText5),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              child: Text(
                                                  snapshot
                                                      .data['Response'][index]
                                                  ['date'],
                                                  maxLines: 1,
                                                  softWrap: true,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  style: normalText7),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Icon(
                                        Icons.arrow_right,
                                        color: Color(0xff017EFF),
                                        size: 20,
                                      )
                                    ]),
                              ),

                            ]),


                          ]),
                        );
                      }),
                );
              }
              else {
                return _emptyOrders();
              }
            }
            else{
              return _payment(snapshot.data['pay_amount'].toString());
            }
          }
          else{
            return _emptyOrders2();
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
            'NO TEST FOUND!',
            style:
            TextStyle(fontSize: 20, letterSpacing: 1, color: Color(0xff2E2A4A)),
          )),
    );
  }
  void openCheckout( num amount) async {
    var options = {
      'key': 'rzp_test_MhKrOdDQM8C8PL',
      'amount': amount,
      "currency": "INR",
      'name': "Grewal E-Learning Services Pvt Ltd",
      'description': "Payment for Grewal E-Learning Services Pvt Ltd",
      'timeout': 180, // in seconds
      "theme": {
        "color": "#2E2A4A"
      },
      // "image": "https://example.com/your_logo",
      'prefill': {'contact': _mobile, 'email': email_id},
      /* "method": {
        "netbanking": true,
        "card": true,
        "wallet": false,
        "upi": false
      },*/
      'external': {
        'wallets': ['paytm']
      },
      'redirect': true
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }
  Widget _payment(String payAmount) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 5.0),
        Container(
          width: MediaQuery.of(context).size.height * 0.80,
          margin: const EdgeInsets.only(right: 20.0, left: 20),
          child: ButtonTheme(
            height: 28.0,
            child: RaisedButton(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              textColor: Colors.white,
              color: Color(0xff017EFF),
              onPressed: () async {
                openCheckout(num.parse(payAmount.toString())*100);

              },
              child: Text(
                "Pay ₹${payAmount.toString()}",
                style: TextStyle(fontSize: 16, letterSpacing: 1),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15.0),
      ]
    );
  }

  Widget _emptyOrders2() {
    return Center(
      child: Container(
          child: Text(
            'Server Error!',
            style:
            TextStyle(fontSize: 20, letterSpacing: 1, color: Color(0xff2E2A4A)),
          )),
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
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/dashboard');
                },
              ),
            ]),
          ),
          centerTitle: true,
          title: Container(
            child: Text("Olympiad Test Lists", style: normalText6),
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
          inAsyncCall: isLoading,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: deviceSize.width * 0.02,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    /* Container(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(children: <Widget>[
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: new TextField(
                                enabled: true,
                                controller: completeController,
                                decoration: InputDecoration(
                                  fillColor: Color(0xfff9f9fb),
                                  filled: true,
                                  contentPadding:
                                  EdgeInsets.fromLTRB(10, 30, 30, 0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),

                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  counterText: "",
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Color(0xff200E32),
                                    size: 24,
                                  ),
                                  hintStyle: TextStyle(
                                      color: Color(0xffBBBFC3), fontSize: 16),
                                  hintText: 'Search your tests... ',
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.black,
                                textCapitalization: TextCapitalization.none,
                              ),
                            ),
                          ),
                        ),

                      ]),
                    ),*/
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 5,top: 10),
                        child: chapterList(deviceSize),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              )),
        ));
  }
}
