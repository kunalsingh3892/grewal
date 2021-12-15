import 'dart:convert';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/color_constants.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class UpdateProfile extends StatefulWidget {
  final String modal;

  UpdateProfile(this.modal);
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String user_id = "";
  Future<dynamic> _profiles;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  var dobController;
  final addressController = TextEditingController();
  var otherController;
  bool _autoValidate = false;
  Future _boardData;
  Future _classData;
  Future _countryData;
  Future _stateData;
  Future _cityData;
  Future _schoolData;
  List<Region> _region = [];
  List<Region2> _region2 = [];
  List<Region3> _region3 = [];
  List<Region4> _region4 = [];
  List<Region5> _region5 = [];
  List<Region6> _region6 = [];
  var _type = "";
  var _type2 = "";

  var _type3 = "";
  var _type4 = "";
  var _type5 = "";
  var _type6 = "";
  String selectedRegion = "";
  String selectedRegion2;
  String selectedRegion3 = "";
  String selectedRegion4;
  String selectedRegion5;
  String selectedRegion6 = "";
  String catData = "";
  String catData2 = "";
  String catData3 = "";
  String catData4 = "";
  String catData5 = "";
  String catData6 = "";

  bool show = false;

  void initState() {
    super.initState();
    _getUser();
  }

  String profile_image = '';
  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        user_id = prefs.getString('user_id').toString();
        profile_image = prefs.getString('profile_image').toString();
        api_token = prefs.getString('api_token').toString();
        _profiles = _profileData();
      });
    });
  }

  String api_token = "";
  Future _getBoardCategories() async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/board"),
      body: "",
      headers: headers,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      print(result);
      if (mounted) {
        setState(() {
          catData = jsonEncode(result);

          final json = JsonDecoder().convert(catData);
          _region =
              (json).map<Region>((item) => Region.fromJson(item)).toList();
          List<String> item = _region.map((Region map) {
            for (int i = 0; i < _region.length; i++) {
              if (selectedRegion == map.THIRD_LEVEL_NAME) {
                _type = map.THIRD_LEVEL_ID;

                print(selectedRegion);
                return map.THIRD_LEVEL_ID;
              }
            }
          }).toList();
          if (selectedRegion == "") {
            selectedRegion = _region[0].THIRD_LEVEL_NAME;
            _type = _region[0].THIRD_LEVEL_ID;
          }
          _classData = _getClassCategories();
        });
      }

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future _getClassCategories() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/standard"),
      body: "",
      headers: headers,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      if (mounted) {
        setState(() {
          catData3 = jsonEncode(result);

          final json = JsonDecoder().convert(catData3);
          _region3 =
              (json).map<Region3>((item) => Region3.fromJson(item)).toList();
          List<String> item = _region3.map((Region3 map) {
            for (int i = 0; i < _region3.length; i++) {
              if (selectedRegion3 == map.THIRD_LEVEL_NAME) {
                _type3 = map.THIRD_LEVEL_ID;

                print(selectedRegion3);
                return map.THIRD_LEVEL_ID;
              }
            }
          }).toList();
          if (selectedRegion3 == "") {
            selectedRegion3 = _region3[0].THIRD_LEVEL_NAME;
            _type3 = _region3[0].THIRD_LEVEL_ID;
          }
        });
      }

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future _getCountryCategories() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/country"),
      body: "",
      headers: headers,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      if (mounted) {
        setState(() {
          catData4 = jsonEncode(result);

          final json = JsonDecoder().convert(catData4);
          _region4 =
              (json).map<Region4>((item) => Region4.fromJson(item)).toList();
          List<String> item = _region4.map((Region4 map) {
            for (int i = 0; i < _region4.length; i++) {
              if (selectedRegion4 == map.THIRD_LEVEL_NAME) {
                _type4 = map.THIRD_LEVEL_ID;
                if (selectedRegion4 == "" || selectedRegion4 == null) {
                  selectedRegion4 = _region4[0].THIRD_LEVEL_ID;
                }
                print(selectedRegion4);
                return map.THIRD_LEVEL_NAME;
              }
            }
          }).toList();
          /* if (selectedRegion4 == "") {
            selectedRegion4 = _region4[0].THIRD_LEVEL_NAME;
          }*/
          if (_type4 != "") {
            _stateData = _getStateCategories(_type4);
          }
        });
      }

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future _getStateCategories(String country_id) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/state"),
      body: {"country_id": country_id},
      headers: headers,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      if (mounted) {
        setState(() {
          catData2 = jsonEncode(result);

          final json = JsonDecoder().convert(catData2);
          _region2 =
              (json).map<Region2>((item) => Region2.fromJson(item)).toList();
          List<String> item = _region2.map((Region2 map) {
            for (int i = 0; i < _region2.length; i++) {
              if (selectedRegion2 == map.THIRD_LEVEL_NAME) {
                _type2 = map.THIRD_LEVEL_ID;
                if (selectedRegion2 == "" || selectedRegion2 == null) {
                  selectedRegion2 = _region2[0].THIRD_LEVEL_ID;
                }
                print(selectedRegion2);
                return map.THIRD_LEVEL_NAME;
              }
            }
          }).toList();
          if (selectedRegion2 == "") {
            selectedRegion2 = _region2[0].THIRD_LEVEL_NAME;
          }
          if (_type2 != "") {
            _cityData = _getCityCategories(_type2);
          }
        });
      }

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future _getCityCategories(String state_id) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/city"),
      body: {"state_id": state_id},
      headers: headers,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      if (mounted) {
        setState(() {
          catData5 = jsonEncode(result);

          final json = JsonDecoder().convert(catData5);
          _region5 =
              (json).map<Region5>((item) => Region5.fromJson(item)).toList();
          List<String> item = _region5.map((Region5 map) {
            for (int i = 0; i < _region5.length; i++) {
              if (selectedRegion5 == map.THIRD_LEVEL_NAME) {
                _type5 = map.THIRD_LEVEL_ID;

                print(selectedRegion5);
                return map.THIRD_LEVEL_ID;
              }
            }
          }).toList();
          // if (selectedRegion5 == "") {
          //  selectedRegion5 = _region5[0].THIRD_LEVEL_NAME;
          //   _type5 = _region5[0].THIRD_LEVEL_ID;
          //}
        });
      }

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  /*Future _getSchoolCategories() async {

    Map<String, String> headers = {
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.http(BASE_URL, API_PATH + "/school"),
      body:"",
      headers: headers,

    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      if (mounted) {
        setState(() {
          catData6 = jsonEncode(result);

          final json = JsonDecoder().convert(catData6);
          _region6 =
              (json).map<Region6>((item) => Region6.fromJson(item)).toList();
          List<String> item = _region6.map((Region6 map) {
            for (int i = 0; i < _region6.length; i++) {
              if (selectedRegion6 == map.THIRD_LEVEL_NAME) {
                _type6 = map.THIRD_LEVEL_ID;

                print(selectedRegion6);
                return map.THIRD_LEVEL_ID;
              }
            }
          }).toList();
        //  if (selectedRegion6 == "") {
            selectedRegion6 = _region6[0].THIRD_LEVEL_NAME;
            _type6 = _region6[0].THIRD_LEVEL_ID;
         // }

        });
      }

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }*/
  Future _profileData() async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/profile"),
      body: {"user_id": user_id},
      headers: headers,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      setState(() {
        dobController =
            TextEditingController(text: data['Response']['date_of_birth']);
        otherController =
            TextEditingController(text: data['Response']['school_name']);
        selectedRegion = data['Response']['board_name'];
        selectedRegion2 = data['Response']['state_name'];
        selectedRegion3 = data['Response']['class'];
        selectedRegion4 = data['Response']['country_name'];
        selectedRegion5 =
            data['Response']['city_name'].toString().toUpperCase();

        print(selectedRegion5);

        /*if(data['Response']['school_id'].toString()=="-1"){
         selectedRegion6="Other";
         show=true;
       }
       else{
         selectedRegion6=data['Response']['school_name'];
         show=false;
       }*/
      });
      _boardData = _getBoardCategories();
      //  _schoolData=_getSchoolCategories();
      _countryData = _getCountryCategories();
      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));

  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    otherController.dispose();
    dobController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Widget _nameWidget(_initialValue) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0, left: 8),
      child: TextFormField(
          initialValue: _initialValue,
          //  maxLength: 10,
          keyboardType: TextInputType.text,
          cursorColor: Color(0xff000000),
          textCapitalization: TextCapitalization.sentences,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter Name';
            }
            return null;
          },
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
              hintText: 'Enter Your Name',
              hintStyle: TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
              fillColor: Color(0xfff9f9fb),
              filled: true)),
    );
  }

  Widget _emailWidget(_initialValue) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0, left: 8),
      child: TextFormField(
          initialValue: _initialValue,
          //  maxLength: 10,
          keyboardType: TextInputType.text,
          cursorColor: Color(0xff000000),
          enabled: false,
          textCapitalization: TextCapitalization.sentences,
          /* validator: (value) {
            if (value.isEmpty) {
              return 'Please enter email';
            }
            return null;
          },*/
          onSaved: (value) {
            emailController.text = value;
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
              hintText: 'Enter Your Email',
              hintStyle: TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
              fillColor: Color(0xfff9f9fb),
              filled: true)),
    );
  }

  Widget _phoneWidget(_initialValue) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0, left: 8),
      child: TextFormField(
          initialValue: _initialValue,
          //  maxLength: 10,
          keyboardType: TextInputType.text,
          cursorColor: Color(0xff000000),
          enabled: false,
          textCapitalization: TextCapitalization.sentences,
          /*  validator: (value) {
            if (value.isEmpty) {
              return 'Please enter mobile no.';
            }
            return null;
          },*/
          onSaved: (value) {
            mobileController.text = value;
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
              hintText: 'Enter Your Mobile No.',
              hintStyle: TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
              fillColor: Color(0xfff9f9fb),
              filled: true)),
    );
  }

  var finalDate;
  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      finalDate = order;
      var formatter = new DateFormat('dd-MMM-yyyy');
      String formatted = formatter.format(finalDate);
      print(formatted);
      dobController.text = formatted.toString();
    });
  }

  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData(
              primaryColor: Color(0xff017EFF),
              accentColor: Color(0xff017EFF),
              primarySwatch: MaterialColor(
                0xff017EFF,
                const <int, Color>{
                  50: const Color(0xff017EFF),
                  100: const Color(0xff017EFF),
                  200: const Color(0xff017EFF),
                  300: const Color(0xff017EFF),
                  400: const Color(0xff017EFF),
                  500: const Color(0xff017EFF),
                  600: const Color(0xff017EFF),
                  700: const Color(0xff017EFF),
                  800: const Color(0xff017EFF),
                  900: const Color(0xff017EFF),
                },
              )),
          child: child,
        );
      },
    );
  }

  Widget _dobWidget(_initialValue) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0, left: 8),
      child: InkWell(
        onTap: () {
          callDatePicker();
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: TextFormField(
            controller: dobController,
            enabled: false,
            keyboardType: TextInputType.text,
            cursorColor: Color(0xff000000),
            textCapitalization: TextCapitalization.sentences,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter dob';
              }
              return null;
            },
            onSaved: (value) {
              dobController.text = value;
            },
            onChanged: (String value) {
              dobController.text = value;
            },
            decoration: InputDecoration(
                suffixIcon: Container(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Color(0xff017EFF),
                    )),
                suffixIconConstraints: BoxConstraints(
                  minWidth: 20,
                  minHeight: 15,
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
                hintText: 'Enter Your DOB',
                hintStyle: TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                fillColor: Color(0xfff9f9fb),
                filled: true)),
      ),
    );
  }

  Widget _addressWidget(_initialValue) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0, left: 8),
      child: TextFormField(
          initialValue: _initialValue != "null" ? _initialValue : "India",
          //  maxLength: 10,
          keyboardType: TextInputType.text,
          cursorColor: Color(0xff000000),
          textCapitalization: TextCapitalization.sentences,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter address';
            }
            return null;
          },
          onSaved: (value) {
            addressController.text = value;
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
              hintText: 'Enter Your Address',
              hintStyle: TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
              fillColor: Color(0xfff9f9fb),
              filled: true)),
    );
  }

  Widget _otherWidget(_initialValue) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0, left: 8),
      child: TextFormField(
          initialValue: _initialValue,
          //  maxLength: 10,
          keyboardType: TextInputType.text,
          cursorColor: Color(0xff000000),
          textCapitalization: TextCapitalization.sentences,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter school name';
            }
            return null;
          },
          onSaved: (value) {
            otherController.text = value;
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
              hintText: 'Enter School Name',
              hintStyle: TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
              fillColor: Color(0xfff9f9fb),
              filled: true)),
    );
  }

  File _image;
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: Color(0xFF2E2A4A),
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(
                        Icons.photo_library,
                        color: Colors.white,
                      ),
                      title: new Text(
                        'Photo Library',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: Colors.white,
                    ),
                    title: new Text(
                      'Camera',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget profileList(Size deviceSize) {
    return FutureBuilder(
      future: _profiles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var errorCode = snapshot.data['ErrorCode'];
          var response = snapshot.data['Response'];
          if (errorCode == 0) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListView(
                primary: false,
                shrinkWrap: true,
                children: <Widget>[
                  Column(children: <Widget>[
                    const SizedBox(height: 25.0),
                    InkWell(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: _image != null
                          ? Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffffffff),
                                image: DecorationImage(
                                  image: NetworkImage(response['profile']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  _image,
                                  fit: BoxFit.cover,
                                  width: 90,
                                  height: 90,
                                ),
                              ),
                            )
                          : Stack(children: [
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffffffff),
                                  image: DecorationImage(
                                    image: NetworkImage(response['profile']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    height: 22,
                                    width: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 1,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      color: Color(0xffFF317B),
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  )),
                            ]),
                    ),
                    const SizedBox(height: 25.0),
                    _nameWidget(response['name']),
                    const SizedBox(height: 15.0),
                    _emailWidget(response['email']),
                    const SizedBox(height: 15.0),
                    _phoneWidget(response['mobile'].toString()),
                    const SizedBox(height: 15.0),
                    _dobWidget(response['date_of_birth'] != null
                        ? response['date_of_birth'].toString()
                        : "01-01-2001"),
                    const SizedBox(height: 15.0),
                    _addressWidget(response['address'].toString()),
                    const SizedBox(height: 15.0),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(right: 8.0, left: 8),
                      padding: EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        color: Color(0xfff9f9fb),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.0,
                            color: Color(0xfff9f9fb),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: EdgeInsets.only(right: 0, left: 3),
                          child: new DropdownButton<String>(
                            isExpanded: true,
                            hint: new Text(
                              "Select Board",
                              style: TextStyle(color: Color(0xffBBBFC3)),
                            ),
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                            ),
                            value: selectedRegion,
                            isDense: true,
                            onChanged:
                                null /*(newValue) {
                              setState(() {
                                selectedRegion = newValue;
                                List<String> item = _region.map((Region map) {
                                  for (int i = 0; i < _region.length; i++) {
                                    if (selectedRegion == map.THIRD_LEVEL_NAME) {
                                      _type = map.THIRD_LEVEL_ID;
                                      return map.THIRD_LEVEL_ID;
                                    }
                                  }
                                }).toList();


                              });
                            }*/
                            ,
                            items: _region.map((Region map) {
                              return new DropdownMenuItem<String>(
                                value: map.THIRD_LEVEL_NAME,
                                child: new Text(map.THIRD_LEVEL_NAME,
                                    style:
                                        new TextStyle(color: Colors.black87)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(right: 5.0, left: 8),
                      padding: EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        color: Color(0xfff9f9fb),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.0,
                            color: Color(0xfff9f9fb),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: EdgeInsets.only(right: 0, left: 3),
                          child: new DropdownButton<String>(
                            isExpanded: true,
                            hint: new Text(
                              "Select Country",
                              style: TextStyle(color: Color(0xffBBBFC3)),
                            ),
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                            ),
                            value: selectedRegion4,
                            isDense: true,
                            onChanged: (newValue) {
                              setState(() {
                                selectedRegion4 = newValue;
                                List<String> item = _region4.map((Region4 map) {
                                  for (int i = 0; i < _region4.length; i++) {
                                    if (selectedRegion4 ==
                                        map.THIRD_LEVEL_NAME) {
                                      _type4 = map.THIRD_LEVEL_ID;
                                      return map.THIRD_LEVEL_ID;
                                    }
                                  }
                                }).toList();
                                _type2 = "";
                                selectedRegion2 = null;
                                _type5 = "";
                                selectedRegion5 = null;
                                _stateData = _getStateCategories(_type4);
                              });
                            },
                            items: _region4.map((Region4 map) {
                              return new DropdownMenuItem<String>(
                                value: map.THIRD_LEVEL_NAME,
                                child: new Text(map.THIRD_LEVEL_NAME,
                                    style:
                                        new TextStyle(color: Colors.black87)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(right: 8.0, left: 8),
                      padding: EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        color: Color(0xfff9f9fb),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.0,
                            color: Color(0xfff9f9fb),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: EdgeInsets.only(right: 0, left: 3),
                          child: new DropdownButton<String>(
                            isExpanded: true,
                            hint: new Text(
                              "Select Class",
                              style: TextStyle(color: Color(0xffBBBFC3)),
                            ),
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                            ),
                            value: selectedRegion3,
                            isDense: true,
                            onChanged:
                                null /*(newValue) {
                              setState(() {
                                selectedRegion3 = newValue;
                                List<String> item = _region3.map((Region3 map) {
                                  for (int i = 0; i < _region3.length; i++) {
                                    if (selectedRegion3 == map.THIRD_LEVEL_NAME) {
                                      _type3 = map.THIRD_LEVEL_ID;
                                      return map.THIRD_LEVEL_ID;
                                    }
                                  }
                                }).toList();


                              });
                            }*/
                            ,
                            items: _region3.map((Region3 map) {
                              return new DropdownMenuItem<String>(
                                value: map.THIRD_LEVEL_NAME,
                                child: new Text(map.THIRD_LEVEL_NAME,
                                    style:
                                        new TextStyle(color: Colors.black87)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(right: 8.0, left: 8),
                      padding: EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        color: Color(0xfff9f9fb),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.0,
                            color: Color(0xfff9f9fb),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: EdgeInsets.only(right: 0, left: 3),
                          child: new DropdownButton<String>(
                            isExpanded: true,
                            hint: new Text(
                              "Select State",
                              style: TextStyle(color: Color(0xffBBBFC3)),
                            ),
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                            ),
                            value: selectedRegion2,
                            isDense: true,
                            onChanged: (newValue) {
                              setState(() {
                                selectedRegion2 = newValue;
                                List<String> item = _region2.map((Region2 map) {
                                  for (int i = 0; i < _region2.length; i++) {
                                    if (selectedRegion2 ==
                                        map.THIRD_LEVEL_NAME) {
                                      _type2 = map.THIRD_LEVEL_ID;
                                      return map.THIRD_LEVEL_ID;
                                    }
                                  }
                                }).toList();
                                _type5 = "";
                                selectedRegion5 = null;
                                _cityData = _getCityCategories(_type2);
                              });
                            },
                            items: _region2.map((Region2 map) {
                              return new DropdownMenuItem<String>(
                                value: map.THIRD_LEVEL_NAME,
                                child: new Text(map.THIRD_LEVEL_NAME,
                                    style:
                                        new TextStyle(color: Colors.black87)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(right: 8.0, left: 8),
                      padding: EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        color: Color(0xfff9f9fb),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.0,
                            color: Color(0xfff9f9fb),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: EdgeInsets.only(right: 0, left: 3),
                          child: new DropdownButton<String>(
                            isExpanded: true,
                            hint: new Text(
                              "Select City",
                              style: TextStyle(color: Color(0xffBBBFC3)),
                            ),
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                            ),
                            value: selectedRegion5,
                            isDense: true,
                            onChanged: (newValue) {
                              setState(() {
                                selectedRegion5 = newValue;
                                List<String> item = _region5.map((Region5 map) {
                                  for (int i = 0; i < _region5.length; i++) {
                                    if (selectedRegion5 ==
                                        map.THIRD_LEVEL_NAME) {
                                      _type5 = map.THIRD_LEVEL_ID;
                                      return map.THIRD_LEVEL_ID;
                                    }
                                  }
                                }).toList();
                              });
                            },
                            items: _region5.map((Region5 map) {
                              return new DropdownMenuItem<String>(
                                value: map.THIRD_LEVEL_NAME,
                                child: new Text(map.THIRD_LEVEL_NAME,
                                    style:
                                        new TextStyle(color: Colors.black87)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    /*const SizedBox(height: 15.0),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(right: 8.0, left: 8),
                      padding: EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        color: Color(0xfff9f9fb),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.0,
                            color: Color(0xfff9f9fb),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: EdgeInsets.only(right: 0, left: 3),
                          child: new DropdownButton<String>(
                            isExpanded: true,
                            hint: new Text(
                              "Select School",
                              style: TextStyle(color: Color(0xffBBBFC3)),
                            ),
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                            ),
                            value: selectedRegion6,
                            isDense: true,
                            onChanged: (newValue) {
                              setState(() {
                                selectedRegion6 = newValue;
                                List<String> item = _region6.map((Region6 map) {
                                  for (int i = 0; i < _region6.length; i++) {
                                    if (selectedRegion6 == map.THIRD_LEVEL_NAME) {
                                      _type6 = map.THIRD_LEVEL_ID;
                                      return map.THIRD_LEVEL_ID;
                                    }
                                  }
                                }).toList();


                               */ /* if(_type6.toString()!="-1"){
                                  show=false;
                                }
                                else{
                                  show=true;
                                }*/ /*
                              });
                            },
                            items: _region6.map((Region6 map) {
                              return new DropdownMenuItem<String>(
                                value: map.THIRD_LEVEL_NAME,
                                child: new Text(map.THIRD_LEVEL_NAME,
                                    style: new TextStyle(color: Colors.black87)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),*/
                    const SizedBox(height: 15.0),
                    // show?
                    _otherWidget(response['school_name'].toString()),
                    const SizedBox(height: 30.0),
                    Container(
                      width: MediaQuery.of(context).size.height * 0.80,
                      margin: const EdgeInsets.only(right: 15.0, left: 15),
                      child: ButtonTheme(
                        height: 28.0,
                        child: RaisedButton(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 80),
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
                              String base64Image = "";
                              if (_image != null) {
                                base64Image =
                                    base64Encode(_image.readAsBytesSync());
                              }
                              final msg = jsonEncode({
                                "user_id": user_id,
                                "name": nameController.text,
                                "date_of_birth": dobController.text,
                                "profile": base64Image,
                                "address": addressController.text,
                                "country": _type4.toString(),
                                "state": _type2.toString(),
                                "city": _type5.toString(),
                                "school_name": otherController.text
                              });
                              Map<String, String> headers = {
                                'Accept': 'application/json',
                                'Authorization': 'Bearer $api_token',
                              };
                              var response = await http.post(
                                new Uri.https(BASE_URL,
                                    API_PATH + "/student-update-profile"),
                                body: {
                                  "user_id": user_id,
                                  "name": nameController.text,
                                  "date_of_birth": dobController.text,
                                  "profile": base64Image,
                                  "address": addressController.text,
                                  "country": _type4.toString(),
                                  "state": _type2.toString(),
                                  "city": _type5.toString(),
                                  "school_name": otherController.text
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
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  setState(() {
                                    _loading = false;

                                    prefs.setString(
                                        'name', data['user_profile']['name']);
                                    prefs.setString('profile_image',
                                        data['profileimage'].toString());
                                  });

                                  Fluttertoast.showToast(msg: errorMessage);
                                  Navigator.pushNamed(
                                    context,
                                    '/dashboard',
                                  );
                                } else {
                                  setState(() {
                                    _loading = false;
                                  });
                                  showAlertDialog(context, ALERT_DIALOG_TITLE,
                                      errorMessage);
                                }
                              }
                            } else {
                              setState(() {
                                _autoValidate = true;
                              });
                            }
                          },
                          child: Text(
                            "Update ",
                            style: TextStyle(fontSize: 16, letterSpacing: 1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 45.0),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 20),
                      child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            color: regularwhite,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          width: 134,
                          height: 5,
                        ),
                      ),
                    ),
                  ])
                ],
              ),
            );
          } else {
            return Container();
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
                      color:
                          index.isEven ? Color(0xff017EFF) : Color(0xffFFC700),
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
    return Scaffold(
      backgroundColor: profilebg,
      appBar: widget.modal != ""
          ? AppBar(
              elevation: 0.0,
              leading: widget.modal != ""
                  ? Row(children: <Widget>[
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
                    ])
                  : Row(children: <Widget>[
                      IconButton(
                        icon: Image(
                          image: AssetImage("assets/images/list_icon.png"),
                          height: 20.0,
                          width: 10.0,
                          color: Color(0xff2E2A4A),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ]),
              centerTitle: true,
              title: Container(
                child: Text("My Profile", style: normalText6),
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
            )
          : null,
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
        child: Container(
          child: Form(
            key: _formKey,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: profileList(deviceSize),
          ),
        ),
      ),
    );
  }
}

class Region {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region({this.THIRD_LEVEL_ID, this.THIRD_LEVEL_NAME});

  factory Region.fromJson(Map<String, dynamic> json) {
    return new Region(
        THIRD_LEVEL_ID: json['id'].toString(), THIRD_LEVEL_NAME: json['name']);
  }
}

class Region2 {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region2({this.THIRD_LEVEL_ID, this.THIRD_LEVEL_NAME});

  factory Region2.fromJson(Map<String, dynamic> json) {
    return new Region2(
      THIRD_LEVEL_ID: json['id'].toString(),
      THIRD_LEVEL_NAME: json['StateName'],
    );
  }
}

class Region3 {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region3({this.THIRD_LEVEL_ID, this.THIRD_LEVEL_NAME});

  factory Region3.fromJson(Map<String, dynamic> json) {
    return new Region3(
      THIRD_LEVEL_ID: json['id'].toString(),
      THIRD_LEVEL_NAME: json['class'],
    );
  }
}

class Region4 {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;
  final String THIRD_LEVEL_CODE;

  Region4({this.THIRD_LEVEL_ID, this.THIRD_LEVEL_NAME, this.THIRD_LEVEL_CODE});

  factory Region4.fromJson(Map<String, dynamic> json) {
    return new Region4(
      THIRD_LEVEL_ID: json['id'].toString(),
      THIRD_LEVEL_NAME: json['CountryName'],
      THIRD_LEVEL_CODE: json['CountryCode'],
    );
  }
}

class Region5 {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region5({
    this.THIRD_LEVEL_ID,
    this.THIRD_LEVEL_NAME,
  });

  factory Region5.fromJson(Map<String, dynamic> json) {
    return new Region5(
      THIRD_LEVEL_ID: json['id'].toString(),
      THIRD_LEVEL_NAME: json['CityName'].toString().toUpperCase(),
    );
  }
}

class Region6 {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region6({this.THIRD_LEVEL_ID, this.THIRD_LEVEL_NAME});

  factory Region6.fromJson(Map<String, dynamic> json) {
    return new Region6(
      THIRD_LEVEL_ID: json['id'].toString(),
      THIRD_LEVEL_NAME: json['school_name'],
    );
  }
}
