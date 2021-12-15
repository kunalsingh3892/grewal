import 'dart:convert';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/color_constants.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class AddSupport extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<AddSupport> {
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
  bool _autoValidate = false;
  final _formKey = GlobalKey<FormState>();
  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();
  String user_id = "";
  String chapter_id = "";
  String chapter_name = "";
  String type = "";
  String profile_image = '';
  bool _loading = false;
  Future _classData;
  List<Region3> _region3 = [];
  var _type3 = "";
  String api_token = "";
  String selectedRegion3;

  String catData3 = "";

  @override
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
        _classData = _getClassCategories();
      });
    });
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

  Future _getClassCategories() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/supporttype"),
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
              if (selectedRegion3 == map.THIRD_LEVEL_NAME) {}
            }
          }).toList();
          /*  if (selectedRegion3 == "") {
            selectedRegion3 = _region3[0].THIRD_LEVEL_NAME;
          }*/
        });
      }

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  TextStyle normalText3 = GoogleFonts.montserrat(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.underline,
      color: Color(0xff2E2A4A));

  Widget _randomContent() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
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
                    "Select Topic",
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
                  onChanged: (newValue) {
                    setState(() {
                      selectedRegion3 = newValue;
                      /*  List<String> item = _region3.map((Region3 map) {
                        for (int i = 0; i < _region3.length; i++) {
                          if (selectedRegion3 == map.THIRD_LEVEL_NAME) {
                            _type3 = map.THIRD_LEVEL_ID;
                            return map.THIRD_LEVEL_ID;
                          }
                        }
                      }).toList();*/
                    });
                  },
                  items: _region3.map((Region3 map) {
                    return new DropdownMenuItem<String>(
                      value: map.THIRD_LEVEL_NAME,
                      child: new Text(map.THIRD_LEVEL_NAME,
                          style: new TextStyle(color: Colors.black87)),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: TextFormField(
                controller: subjectController,
                //  maxLength: 10,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff000000),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter subject';
                  }
                  return null;
                },
                onSaved: (value) {
                  subjectController.text = value;
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
                    hintText: 'Subject',
                    hintStyle:
                        TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                    fillColor: Color(0xfff9f9fb),
                    filled: true)),
          ),
          const SizedBox(height: 20.0),
          Container(
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: TextFormField(
                controller: descriptionController,
                maxLines: 10,
                minLines: 10,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff000000),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter message';
                  }
                  return null;
                },
                onSaved: (value) {
                  descriptionController.text = value;
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
                    hintText: 'Message',
                    hintStyle:
                        TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                    fillColor: Color(0xfff9f9fb),
                    filled: true)),
          ),
          const SizedBox(height: 20.0),
          Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text("Add Attachment", style: normalText3)),
          const SizedBox(height: 5.0),
          InkWell(
              onTap: () {
                _showPicker(context);
              },
              child: _image == null
                  ? Container(
                      width: 90,
                      height: 90,
                      child: Image.asset(
                        "assets/images/add_photo.png",
                        color: Color(0xff017EFF),
                      ))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        _image,
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
                      ),
                    )),
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
                    if (selectedRegion3 != null) {
                      if (_image != null) {
                        setState(() {
                          _loading = true;
                        });
                        Map<String, String> headers = {
                          'Accept': 'application/json',
                          'Authorization': 'Bearer $api_token',
                        };
                        var uri = Uri.parse(URL + 'support');
                        final uploadRequest =
                            http.MultipartRequest('POST', uri);
                        final mimeTypeData = lookupMimeType(_image.path,
                            headerBytes: [0xFF, 0xD8]).split('/');

                        final file = await http.MultipartFile.fromPath(
                            'attachment', _image.path,
                            contentType:
                                MediaType(mimeTypeData[0], mimeTypeData[1]));
                        uploadRequest.headers.addAll(headers);
                        uploadRequest.files.add(file);
                        uploadRequest.fields['student_id'] = user_id;
                        uploadRequest.fields['type'] = selectedRegion3;
                        uploadRequest.fields['subject'] =
                            subjectController.text;
                        uploadRequest.fields['message'] =
                            descriptionController.text;

                        print(uploadRequest.fields);
                        try {
                          final streamedResponse = await uploadRequest.send();
                          final response =
                              await http.Response.fromStream(streamedResponse);
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

                              Fluttertoast.showToast(msg: errorMessage);
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                context,
                                '/support-list',
                              );
                            } else {
                              setState(() {
                                _loading = false;
                              });
                              showAlertDialog(
                                  context, ALERT_DIALOG_TITLE, errorMessage);
                            }
                          }
                        } catch (e) {
                          print(e);
                        }
                      } else {
                        setState(() {
                          _loading = true;
                        });
                        Map<String, String> headers = {
                          'Accept': 'application/json',
                          'Authorization': 'Bearer $api_token',
                        };
                        var uri = Uri.parse(URL + 'support');
                        final uploadRequest =
                            http.MultipartRequest('POST', uri);
                        uploadRequest.headers.addAll(headers);
                        uploadRequest.fields['student_id'] = user_id;
                        uploadRequest.fields['type'] = selectedRegion3;
                        uploadRequest.fields['subject'] =
                            subjectController.text;
                        uploadRequest.fields['message'] =
                            descriptionController.text;
                        uploadRequest.fields['attachment'] = "";

                        print(uploadRequest.fields);
                        try {
                          final streamedResponse = await uploadRequest.send();
                          final response =
                              await http.Response.fromStream(streamedResponse);
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

                              Fluttertoast.showToast(msg: errorMessage);
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                context,
                                '/support-list',
                              );
                            } else {
                              setState(() {
                                _loading = false;
                              });
                              showAlertDialog(
                                  context, ALERT_DIALOG_TITLE, errorMessage);
                            }
                          }
                        } catch (e) {
                          print(e);
                        }
                      }
                    } else {
                      Fluttertoast.showToast(msg: "Please Select Topic");
                    }
                  } else {
                    setState(() {
                      _autoValidate = true;
                    });
                  }
                },
                child: Text(
                  "Submit",
                  style: TextStyle(fontSize: 16, letterSpacing: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyOrders() {
    return Center(
      child: Container(
          child: Text(
        'NO TICKET FOUND!',
        style:
            TextStyle(fontSize: 20, letterSpacing: 1, color: Color(0xff2E2A4A)),
      )),
    );
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
                  Navigator.of(context).pop(false);
                },
              ),
            ]),
          ),
          centerTitle: true,
          title: Container(
            child: Text("Support", style: normalText6),
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
                      const SizedBox(height: 25.0),
                      Container(
                        child: Form(
                          key: _formKey,
                          autovalidateMode: _autoValidate
                              ? AutovalidateMode.always
                              : AutovalidateMode.disabled,
                          child: /*isEnabled1 ? _customContent() :*/ _randomContent(),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                )),
          ),
        ));
  }
}

class Region3 {
  // final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region3({this.THIRD_LEVEL_NAME});

  factory Region3.fromJson(Map<String, dynamic> json) {
    return new Region3(
      THIRD_LEVEL_NAME: json['type'],
    );
  }
}
