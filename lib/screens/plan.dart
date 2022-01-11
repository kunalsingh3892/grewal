import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grewal/api/payment_plans_api.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/components/progress_bar.dart';
import 'package:grewal/screens/subject_list.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/color_constants.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class MyPlan extends StatefulWidget {
  final Object argument;

  const MyPlan({Key key, this.argument}) : super(key: key);

  @override
  _MyPlanState createState() => _MyPlanState();
}

class _MyPlanState extends State<MyPlan> {
  Razorpay _razorpay;
  bool _loading = false;
  bool isEnabled1 = true;
  bool isEnabled2 = false;
  bool isEnabled3 = false;
  bool isEnabled4 = false;
  bool isLoadingForPlan = true;
  TextStyle normalText = GoogleFonts.inter(
      fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff2E2A4A));
  TextStyle normalText1 = GoogleFonts.inter(
      fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xff2E2A4A));
  TextStyle normalText2 = GoogleFonts.inter(
      fontSize: 15, fontWeight: FontWeight.w300, color: Color(0xff2E2A4A));
  TextStyle normalText4 = GoogleFonts.inter(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText9 = GoogleFonts.inter(
      decoration: TextDecoration.lineThrough,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Color(0xff2E2A4A));
  TextStyle normalText3 = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );
  final nameController = TextEditingController();
  String signupid = "";
  String order_id = "";
  double amount = 0;
  var disc_amount = 0;
  var base_amount = 0;
  var currentTime;
  String mobile = "";
  String currency = "";
  String base_price = "";
  String email = "";
  String out = "";
  String user_id = "";
  double discount_amount = 0;
  bool dis_show = false;
  String api_token = "";
  List subPlansList = [];
  bool payment_status;
  bool payment_status2;
  List details = [];
  bool coupenApplied = false;
  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    order_id = data['order_id'];
    signupid = data['signupid'];
    mobile = data['mobile'];
    email = data['email'];
    out = data['out'];
    currentTime = DateTime.now();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    Preference().getPreferences().then((prefs) {
      setState(() {
        payment_status = prefs.getBool('payment_status');
        payment_status2 = prefs.getBool('payment_status2');
        print(payment_status);
        print(payment_status2);
      });
    });
    PaymentPlansAPI().getSubcriptionPlanNew().then((value) {
      if (value.length > 0) {
        setState(() {
          subPlansList.clear();

          if (out == "out") {
            value.forEach((element) {
              if (value.indexOf(element) == 0) {
                element['selected'] = false;
                element['cutPlanInd'] = "500";
                subPlansList.add(element);
              } else if (value.indexOf(element) == 1) {
                element['selected'] = false;
                element['cutPlanInd'] = "800";
                subPlansList.add(element);
              }
            });
          } else {
            value.forEach((element) {
              if (value.indexOf(element) == 0 && !payment_status) {
                element['selected'] = false;
                element['cutPlanInd'] = "500";
                subPlansList.add(element);
              } else if (value.indexOf(element) == 1 && !payment_status2) {
                element['selected'] = false;
                element['cutPlanInd'] = "800";
                subPlansList.add(element);
              }
            });
          }

          isLoadingForPlan = false;
        });
      }
    });
    _getUser();
  }

  TextStyle normalText10 = GoogleFonts.montserrat(
      fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        user_id = prefs.getString('user_id').toString();
        // disc_amount = prefs.getInt('disc_amount');
        // base_amount = prefs.getInt('base_amount');
        currency = prefs.getString('currency');
        api_token = prefs.getString('api_token').toString();
        // if (disc_amount == 0) {
        //   amount = prefs.getInt('base_amount');
        // } else {
        //   amount = prefs.getInt('amount');
        // }

        print(user_id);
        _getTime();

        //  _homeData();
      });
    });
  }

  String _dropdownValue = "";
  void _getTime() {
    setState(() {
      var formatter = new DateFormat('yyyy-MM-dd');
      _dropdownValue = formatter.format(currentTime);
      print(_dropdownValue);
    });
  }

  Future _homeData() async {
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/subcriptionplan"),
      body: {
        "user_id": user_id,
      },
      headers: headers,
    );
    print({
      "user_id": user_id,
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        amount = data['Response']['pay_amount'];
      });

      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Success: " + response.orderId.toString());
    print("Success: " + response.paymentId.toString());
    print("Success: " + response.signature.toString());

    print(jsonEncode({
      "user_id": user_id.toString(),
      "razorpay_payment_id": response.paymentId.toString(),
      "details": details
    }));
    var response1 = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/payment-success"),
      body: jsonEncode({
        "user_id": user_id.toString(),
        "razorpay_payment_id": response.paymentId.toString(),
        "details": details
      }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $api_token',
      },
    );
    print(response1.body);
    print(response1.statusCode);

    print(response1.body);

    if (response1.statusCode == 200) {
      var data = json.decode(response1.body);
      print(data);
      var errorCode = data['ErrorCode'];
      var errorMessage = data['ErrorMessage'];
      if (errorCode == 0) {
        displayModalBottomSheet(context, response.paymentId.toString());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('logged_in', true);
        // prefs.setString('user_id', data['Response']['id'].toString());
        // prefs.setString('name', data['Response']['name']);
        // prefs.setString('school_id', data['Response']['school_id'].toString());
        // prefs.setString('email_id', data['Response']['email']);
        // prefs.setString('mobile_no', data['Response']['mobile'].toString());
        // prefs.setString('profile_image', data['profile'].toString());
        // prefs.setString('class_id', data['Response']['class_id'].toString());
        // prefs.setString('board_id', data['Response']['board_id'].toString());
      } else {
        showAlertDialog(context, ALERT_DIALOG_TITLE, errorMessage);
      }
    }
  }

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    print("ERROR: " + response.message);
    // final msg = jsonEncode({
    //   "signup_id": signupid,
    //   "order_id": order_id,
    //   "payment_time": currentTime.toString(),
    //   "trancation_id": "",
    //   "status": "failed",
    //   "amount": amount.toString()
    // });
    // Map<String, String> headers = {
    //   'Accept': 'application/json',
    //   'Authorization': 'Bearer $api_token',
    // };
    // var response1 = await http.post(
    //   new Uri.https(BASE_URL, API_PATH + "/payment_success"),
    //   body: {
    //     "signup_id": signupid,
    //     "order_id": order_id,
    //     "payment_time": currentTime.toString(),
    //     "trancation_id": "",
    //     "status": "failed",
    //     "amount": amount.toString()
    //   },
    //   headers: headers,
    // );
    // print(msg);

    var response1 = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/payment-success"),
      body: {
        "user_id": user_id.toString(),
        "razorpay_payment_id": "",
        "details": jsonEncode(details)
      },
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $api_token',
      },
    );
    print(response1.body);
    print(response1.statusCode);
    if (response1.statusCode == 200) {
      var data = json.decode(response1.body);
      print(data);
      var errorCode = data['ErrorCode'];
      var errorMessage = data['ErrorMessage'];
      if (errorCode == 0) {
        Fluttertoast.showToast(
            msg: "ERROR: " +
                response.code.toString() +
                " - " +
                response.message);
      } else {
        showAlertDialog(context, ALERT_DIALOG_TITLE, errorMessage);
      }
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName);
    print("EXTERNAL_WALLET: " + response.walletName);
  }

  void displayModalBottomSheet(context, String tran_id) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        builder: (BuildContext bc) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              height: MediaQuery.of(context).size.height * 0.60,
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(20.0),
                      topRight: const Radius.circular(20.0))),
              child: new Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(child: Container()),
                    Container(
                      child: IconButton(
                        icon: const Icon(
                          Icons.clear,
                          size: 20,
                          color: Colors.black,
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ]),
                  Center(
                    child: Image(
                      image: AssetImage("assets/images/credit_card.png"),
                      height: 80.0,
                      width: 100.0,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Payment Confirmation",
                          style: normalText1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Your payment has been made",
                          style: normalText2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "successfully. Your transaction id is",
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: normalText2,
                    ),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      tran_id,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: normalText2,
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(right: 10.0, left: 10),
                      child: ButtonTheme(
                        height: 28.0,
                        child: RaisedButton(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          textColor: Colors.white,
                          color: Color(0xff017EFF),
                          onPressed: () async {
                            Navigator.pushNamed(context, '/dashboard');
                            //  Navigator.pushNamed(context, '/login-with-logo');
                          },
                          child: Text(
                            "Go to App Dashboard",
                            style: TextStyle(fontSize: 16, letterSpacing: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            );
          });
        });
  }

  void openCheckout(num amount) async {
    var options = {
      'key': 'rzp_live_yk3tz7r3hBjLID',
      'amount': amount,
      "currency": "INR",
      'name': "Grewal E-Learning Services Pvt Ltd",
      'description': "Payment for Grewal E-Learning Services Pvt Ltd",
      'timeout': 180, // in seconds
      "theme": {"color": "#2E2A4A"},
      // "image": "https://example.com/your_logo",
      'prefill': {'contact': mobile, 'email': email},
      /* "method": {
        "netbanking": true,
        "card": true,
        "wallet": false,
        "upi": false
      },*/
      "options": {
        "checkout": {
          "method": {"netbanking": "1", "card": "1", "upi": "1", "wallet": "1"}
        }
      },
      'external': {
        'wallets': ['paytm']
      },
      'redirect': true
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error " + e.toString());
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Widget CustomDialog(
      {String title,
      String description,
      String buttonText,
      String applyButtonText,
      String planId}) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(
          context, title, description, buttonText, applyButtonText, planId),
    );
  }

  TextStyle normalText11 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  dialogContent(BuildContext context, String title, String description,
      String buttonText, String applyButtonText, String planId) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 16.0 * 8,
            bottom: 30.0,
            left: 16.0,
            right: 16.0,
          ),
          margin: EdgeInsets.only(top: 10.0),
          decoration: new BoxDecoration(
            color: Colors.white, //Colors.black.withOpacity(0.3),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: normalText11,
              ),
              SizedBox(height: 16.0),
              Container(
                margin: const EdgeInsets.only(right: 8.0, left: 8),
                child: TextFormField(
                    controller: nameController,
                    //  maxLength: 10,
                    keyboardType: TextInputType.text,
                    cursorColor: Color(0xff000000),
                    textCapitalization: TextCapitalization.sentences,
                    onSaved: (value) {
                      nameController.text = value;
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
                        hintText: description,
                        hintStyle:
                            TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                        fillColor: Color(0xfff9f9fb),
                        filled: true)),
              ),
              SizedBox(height: 24.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: FlatButton(
                          color: Color(0xff017EFF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          onPressed: () {
                            Navigator.of(context).pop(); // To close the dialog
                          },
                          child: Text(
                            buttonText,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: FlatButton(
                          color: Color(0xff017EFF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          onPressed: () async {
                            ProgressBarLoading().showLoaderDialog(context);
                            if (nameController.text != "") {
                              Map<String, String> headers = {
                                'Accept': 'application/json',
                                'Authorization': 'Bearer $api_token',
                              };
                              var response1 = await http.post(
                                new Uri.https(
                                    BASE_URL, API_PATH + "/applycouponnew"),
                                body: {
                                  "user_id": user_id.toString(),
                                  "coupon_code": nameController.text,
                                  "apply_date": _dropdownValue,
                                  "plan_id": planId.toString()
                                },
                                headers: headers,
                              );
                              print(jsonEncode({
                                "user_id": user_id.toString(),
                                "coupon_code": nameController.text,
                                "apply_date": _dropdownValue,
                                "plan_id": planId.toString()
                              }));
                              Navigator.of(context).pop();
                              if (response1.statusCode == 200) {
                                Navigator.of(context).pop();
                                var data = json.decode(response1.body);
                                print(data);
                                var errorCode = data['ErrorCode'];
                                var errorMessage = data['ErrorMessage'];
                                if (errorCode == 0) {
                                  Fluttertoast.showToast(
                                      msg: "Coupon Applied Successfully");
                                  setState(() {
                                    coupenApplied = true;
                                    amount = double.parse(data['Response']
                                            ['finalamount_paid_amount']
                                        .toString());
                                    discount_amount = double.parse(
                                        data['Response']['discountamount']
                                            .toString());
                                    nameController.text = "";
                                    dis_show = true;
                                    details.clear();

                                    List te = data['Response']['details'];

                                    te.forEach((element) {
                                      details.add({
                                        "term_id":
                                            element["term_id"].toString(),
                                        "price": element["price"].toString()
                                      });
                                    });

                                    print(details);
                                  });

                                  // if (data['Response']
                                  //         ['finalamount_paid_amount'] ==
                                  //     0) {
                                  //   List selectedPlansArray = [];
                                  //   subPlansList.forEach((element) {
                                  //     if (element['selected']) {
                                  //       selectedPlansArray.add({
                                  //         "term_id": element['id'].toString(),
                                  //         "price": element['amount'].toString()
                                  //       });
                                  //     }
                                  //   });

                                  //   final msg = jsonEncode({
                                  //     "signup_id": signupid,
                                  //     "order_id": order_id,
                                  //     "payment_time": currentTime.toString(),
                                  //     "trancation_id": currentTime.toString(),
                                  //     "amount": "0"
                                  //   });
                                  //   Map<String, String> headers = {
                                  //     'Accept': 'application/json',
                                  //     'Authorization': 'Bearer $api_token',
                                  //   };
                                  //   var response1 = await http.post(
                                  //     new Uri.https(BASE_URL,
                                  //         API_PATH + "/payment_success"),
                                  //     body: msg,
                                  //     headers: headers,
                                  //   );
                                  //   print(msg);

                                  //   if (response1.statusCode == 200) {
                                  //     var data = json.decode(response1.body);
                                  //     print(data);
                                  //     var errorCode = data['ErrorCode'];
                                  //     var errorMessage = data['ErrorMessage'];
                                  //     if (errorCode == 0) {
                                  //       SharedPreferences prefs =
                                  //           await SharedPreferences
                                  //               .getInstance();
                                  //       prefs.setBool('logged_in', true);
                                  //       prefs.setString('user_id',
                                  //           data['Response']['id'].toString());
                                  //       prefs.setString(
                                  //           'name', data['Response']['name']);
                                  //       prefs.setString(
                                  //           'school_id',
                                  //           data['Response']['school_id']
                                  //               .toString());
                                  //       prefs.setString('email_id',
                                  //           data['Response']['email']);
                                  //       prefs.setString(
                                  //           'mobile_no',
                                  //           data['Response']['mobile']
                                  //               .toString());
                                  //       prefs.setString('profile_image',
                                  //           data['profile'].toString());
                                  //       prefs.setString(
                                  //           'class_id',
                                  //           data['Response']['class_id']
                                  //               .toString());
                                  //       prefs.setString(
                                  //           'board_id',
                                  //           data['Response']['board_id']
                                  //               .toString());
                                  //       Navigator.of(context).pop();
                                  //       Navigator.pushNamed(
                                  //           context, '/dashboard');
                                  //     } else {
                                  //       showAlertDialog(context,
                                  //           ALERT_DIALOG_TITLE, errorMessage);
                                  //     }
                                  //   }
                                  // } else {
                                  //   Navigator.of(context).pop();
                                  // }
                                } else {
                                  showAlertDialog(context, ALERT_DIALOG_TITLE,
                                      errorMessage);
                                }
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Invalid code. Enter again.");
                            }
                          },
                          child: Text(
                            applyButtonText,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
        Positioned(
          left: 16.0,
          right: 16.0,
          child: Container(
            width: 120,
            height: 120,
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/illustration.png',
            ),
          ),
        ),
      ],
    );
  }

  _getFinalAmountForPayment() {
    double totalAmount = 0;
    subPlansList.forEach((element) {
      if (element['selected']) {
        totalAmount = totalAmount + double.parse(element['amount']);
      }
    });
    setState(() {
      amount = totalAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              },
            ),
          ]),
        ),
        flexibleSpace: Container(
          height: 100,
          color: Colors.white,
        ),
        // centerTitle: true,
        title: Container(
          //  margin: EdgeInsets.only(right: 30),
          child: Text('My Plan', style: normalText),
        ),

        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    /*   onTap: (){
                          setState(() {
                            isEnabled1 = true;
                            isEnabled2 = false;
                            isEnabled3 = false;
                            isEnabled4 = false;

                          });
                        },*/
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 30.0, top: 20.0, right: 10, bottom: 20),
                      child: Container(
                        /*  width: 151,
                            height: 176,*/
                        decoration: BoxDecoration(
                            color: planbg1,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: planbg1)),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 20.0, right: 10, bottom: 20),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 26.0),
                                child: Center(
                                  child: Container(
                                    width: 78,
                                    height: 67.01,
                                    child: new Image.asset(
                                        'assets/images/plan_photo1.png'),
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 14.76),
                                child: Center(
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Test Series \n (MCQ, A/R, \n Case Study)",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        /*  Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6.0, top: 18.99),
                                              child: Container(
                                                width: 5,
                                                height: 10,
                                                child: new Image.asset(
                                                    'assets/images/arrow_next.png'),
                                              ),
                                            ),*/
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    /* onTap: (){
                          setState(() {
                            isEnabled2 = true;
                            isEnabled1 = false;
                            isEnabled3 = false;
                            isEnabled4 = false;

                          });
                        },*/
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 10.0, right: 30, bottom: 10),
                      child: Container(
                        /* width: 151,
                            height: 176,*/
                        decoration: BoxDecoration(
                            color: planbg2,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: planbg2)),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 20.0, right: 10, bottom: 20),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 26.0),
                                child: Center(
                                  child: Container(
                                    width: 78,
                                    height: 67.01,
                                    child: new Image.asset(
                                        'assets/images/plan_photo2.png'),
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 14.76),
                                child: Center(
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Ask your \n Doubt \n",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        /* Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6.0, top: 18.99),
                                              child: Container(
                                                width: 5,
                                                height: 10,
                                                child: new Image.asset(
                                                    'assets/images/arrow_next.png'),
                                              ),
                                            ),*/
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    /*  onTap: (){
                          setState(() {
                            isEnabled1 = false;
                            isEnabled2 = false;
                            isEnabled3 = true;
                            isEnabled4 = false;

                          });
                        },*/
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 30.0, top: 20.0, right: 10, bottom: 10),
                      child: Container(
                        /* width: 151,
                            height: 176,*/
                        decoration: BoxDecoration(
                            color: planbg3,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: planbg3)),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 20.0, right: 10, bottom: 20),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 26.0),
                                child: Center(
                                  child: Container(
                                    width: 78,
                                    height: 67.01,
                                    child: new Image.asset(
                                        'assets/images/plan_photo3.png'),
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 14.76),
                                child: Center(
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Model Test \n Papers \n (weekly)",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        /* Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6.0, top: 18.99),
                                              child: Container(
                                                width: 5,
                                                height: 10,
                                                child: new Image.asset(
                                                    'assets/images/arrow_next.png'),
                                              ),
                                            ),*/
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    /*  onTap: (){
                          setState(() {
                            isEnabled1 = false;
                            isEnabled2 = false;
                            isEnabled3 = false;
                            isEnabled4 = true;

                          });
                        },*/
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 20.0, right: 30, bottom: 10),
                      child: Container(
                        /*  width: 151,
                            height: 176,*/
                        decoration: BoxDecoration(
                            color: planbg4,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: planbg4)),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 20.0, right: 10, bottom: 20),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 26.0),
                                child: Center(
                                  child: Container(
                                    width: 78,
                                    height: 67.01,
                                    child: new Image.asset(
                                        'assets/images/plan_photo4.png'),
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 14.76),
                                child: Center(
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Interactive \n Dashboard \n",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        /*Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6.0, top: 18.99),
                                              child: Container(
                                                width: 5,
                                                height: 10,
                                                child: new Image.asset(
                                                    'assets/images/arrow_next.png'),
                                              ),
                                            ),*/
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            InkWell(
              child: Container(
                margin: const EdgeInsets.only(right: 8.0, left: 8),
                child: Container(
                    child: isLoadingForPlan
                        ? Center(
                            child: Row(
                              children: [
                                CircularProgressIndicator(),
                                Text("Subscription Plans Loading"),
                              ],
                            ),
                          )
                        : subPlansList.length == 0
                            ? Center(
                                child: Text("No subscription plans"),
                              )
                            : Column(
                                children: [
                                  Text(
                                    "Term wise subscription plans list",
                                    style: normalText4,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    children: subPlansList
                                        .map((e) => Card(
                                              elevation: 10,
                                              color: Colors.teal[50],
                                              child: ListTile(
                                                trailing: Checkbox(
                                                    value: e['selected'],
                                                    onChanged: (v) {
                                                      setState(() {
                                                        e['selected'] =
                                                            !e['selected'];
                                                        _getFinalAmountForPayment();
                                                      });
                                                    }),
                                                title:
                                                    Text(e['term'].toString()),
                                                subtitle: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Pricing: ",
                                                      style: normalText4,
                                                    ),
                                                    SizedBox(width: 5.0),
                                                    currency == "INR"
                                                        ? Text(
                                                            "₹ " +
                                                                e["cutPlanInd"]
                                                                    .toString(),
                                                            style: normalText9,
                                                          )
                                                        : Text(
                                                            "₹ " +
                                                                "2000"
                                                                    .toString(),
                                                            style: normalText9,
                                                          ),
                                                    SizedBox(width: 5.0),
                                                    Text(
                                                      "₹ " +
                                                          e['amount']
                                                              .toString(),
                                                      style: normalText4,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  )
                                ],
                              )
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       "Term 2 Pricing: ",
                    //       style: normalText4,
                    //     ),
                    //     SizedBox(width: 5.0),
                    //     currency == "INR"
                    //         ? Text(
                    //             "₹ " + "500".toString(),
                    //             style: normalText9,
                    //           )
                    //         : Text(
                    //             "₹ " + "2000".toString(),
                    //             style: normalText9,
                    //           ),
                    //     SizedBox(width: 5.0),
                    //     Text(
                    //       "₹ " + base_amount.toString(),
                    //       style: normalText4,
                    //     )
                    //   ],
                    // ),
                    ),
              ),
            ),
            const SizedBox(height: 5.0),
            // InkWell(
            //   child: Container(
            //     margin: const EdgeInsets.only(right: 8.0, left: 8),
            //     child: Container(
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text(
            //             "Referral Discount: ₹ " + disc_amount.toString(),
            //             style: normalText4,
            //           ) /*:Text(
            //                 "Discount of referral: "+disc_amount.toString()+" "+currency,
            //                 style: normalText4,
            //               ),*/
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 5.0),
            // dis_show
            //     ? Container(
            //         margin: const EdgeInsets.only(right: 8.0, left: 8),
            //         child: Container(
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Text(
            //                 "Coupon Discount: ₹ " + discount_amount.toString(),
            //                 style: normalText4,
            //               ) /*:Text(
            //                 "Discount of referral: "+disc_amount.toString()+" "+currency,
            //                 style: normalText4,
            //               ),*/
            //             ],
            //           ),
            //         ),
            //       )
            //     : Container(),
            const SizedBox(height: 10.0),
            Container(
              width: MediaQuery.of(context).size.height * 0.80,
              margin: const EdgeInsets.only(right: 20.0, left: 20),
              child: ButtonTheme(
                height: 28.0,
                child: RaisedButton(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  textColor: Colors.white,
                  color: Color(0xff017EFF),
                  onPressed: () async {
                    List selected = [];
                    subPlansList.forEach((e) {
                      selected.add(e['selected']);
                    });
                    if (selected.contains(true)) {
                      List planId = [];
                      subPlansList.forEach((e) {
                        if (e['selected']) {
                          planId.add(e['id'].toString());
                        }
                      });
                      print(planId.join(",").toString() + " plan id");
                      print(coupenApplied);
                      if (!coupenApplied) {
                        print("insude");
                        Map<String, String> headers = {
                          'Accept': 'application/json',
                          'Authorization': 'Bearer $api_token',
                        };
                        var res = await http.post(
                          new Uri.https(BASE_URL, API_PATH + "/applycouponnew"),
                          body: {
                            "user_id": user_id.toString(),
                            "coupon_code": "",
                            "apply_date": _dropdownValue,
                            "plan_id": planId.join(",").toString()
                          },
                          headers: headers,
                        );

                        print(jsonEncode({
                          "user_id": user_id.toString(),
                          "coupon_code": "",
                          "apply_date": _dropdownValue,
                          "plan_id": planId.join(",").toString()
                        }));
                        print(res.body);
                        if (jsonDecode(res.body)['ErrorCode'] == 0) {
                          print("if");
                          setState(() {
                            amount = double.parse(
                                jsonDecode(res.body)['Response']
                                        ['finalamount_paid_amount']
                                    .toString());
                            discount_amount = double.parse(
                                jsonDecode(res.body)['Response']
                                        ['discountamount']
                                    .toString());
                            details.clear();

                            List te =
                                jsonDecode(res.body)['Response']['details'];

                            te.forEach((element) {
                              details.add({
                                "term_id": element["term_id"].toString(),
                                "price": element["price"].toString()
                              });
                            });

                            print(details);
                          });
                        }
                        openCheckout(num.parse(amount.toString()) * 100);
                      } else {
                        openCheckout(num.parse(amount.toString()) * 100);
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please select a plan",
                          gravity: ToastGravity.CENTER,
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white);
                    }
                    // displayModalBottomSheet(context,"");
                  },
                  child: Text(
                    "Continue & Pay ₹ " + amount.toString(),
                    style: TextStyle(fontSize: 16, letterSpacing: 1),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            out == "out"
                ? Column(children: [
                    Container(
                      width: MediaQuery.of(context).size.height * 0.80,
                      margin: const EdgeInsets.only(right: 20.0, left: 20),
                      child: ButtonTheme(
                        height: 28.0,
                        child: RaisedButton(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          textColor: Colors.white,
                          color: Color(0xff017EFF),
                          onPressed: () async {
                            Navigator.pushNamed(context, '/dashboard');
                          },
                          child: Text(
                            "Continue with Free Trial",
                            style: TextStyle(fontSize: 16, letterSpacing: 1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                  ])
                : Container(),
            InkWell(
              onTap: () {
                List selected = [];
                subPlansList.forEach((e) {
                  selected.add(e['selected']);
                });

                if (selected.contains(true)) {
                  List planId = [];
                  subPlansList.forEach((e) {
                    if (e['selected']) {
                      planId.add(e['id'].toString());
                    }
                  });
                  print(planId.join(",").toString() + " plan id");
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    useSafeArea: true,
                    useRootNavigator: true,
                    builder: (BuildContext context) => CustomDialog(
                        title: "Apply Coupon",
                        description: "Enter Coupon Code",
                        buttonText: "Cancel",
                        applyButtonText: "Apply",
                        planId: planId.join(",").toString()),
                  );
                } else {
                  Fluttertoast.showToast(
                      msg: "Please select a plan for applying coupon code.",
                      gravity: ToastGravity.CENTER,
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white);
                }
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8.0, left: 8),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Do you have coupon code?",
                        style: normalText3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/privacy-policy');
                      },
                      child: Row(children: <Widget>[
                        Text("Privacy Policy", style: normalText10)
                      ]),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/refund-policies');
                      },
                      child: Row(children: <Widget>[
                        Text("Refund Policy", style: normalText10)
                      ]),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/t-c');
                      },
                      child: Row(children: <Widget>[
                        Text("Terms and Conditions", style: normalText10)
                      ]),
                    ),
                  ]),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
