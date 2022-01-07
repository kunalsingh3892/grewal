import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/services/shared_preferences.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;

import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import '../constants.dart';

class CreateMCQ extends StatefulWidget {
  final Object argument;

  const CreateMCQ({Key key, this.argument}) : super(key: key);

  @override
  _LoginWithLogoState createState() => _LoginWithLogoState();
}

class _LoginWithLogoState extends State<CreateMCQ> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final chapterController = TextEditingController();

  bool showDrop = false;
  bool _loading = false;
  bool _isHidden = true;
  bool isEnabled1 = true;

  bool isEnabled2 = false;

  Future _diffData;
  Future _chapData;
  Future _topicData;
  List<Region> _region = [];
  List<Region3> _region3 = [];
  List<Region4> _region4 = [];
  var _type = "";

  var _type3 = "";
  var _type4 = "";
  String selectedRegion;
  String selectedRegion3;
  String selectedRegion4;
  String catData = "";
  String catData3 = "";
  String catData4 = "";
  bool _autoValidate = false;

  String chapter_id = "";
  String chapter_name = "";
  String type = "";
  String user_id = "";
  String class_id = "";
  String board_id = "";
  List<Animal> _animals = [];
  List<Animal1> _animals1 = [];
  List<Animal2> _animals2 = [];
  var _items;
  var _items1;
  var _items2;
  List<Animal> _selectedAnimals = [];
  List<Animal1> _selectedAnimals1 = [];
  List<Animal2> _selectedAnimals2 = [];

  final _multiSelectKey = GlobalKey<FormFieldState>();
  final _multiSelectKey1 = GlobalKey<FormFieldState>();
  final _multiSelectKey2 = GlobalKey<FormFieldState>();
  String profile_image = '';
  String selectedChapterId = "";
  String selectedTopicId = "";
  String selectedLeveId = "";
  String api_token = "";
  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    chapter_id = data['chapter_id'];
    chapter_name = data['chapter_name'];
    type = data['type'];
    _getUser();
  }

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        user_id = prefs.getString('user_id').toString();
        class_id = prefs.getString('class_id').toString();
        board_id = prefs.getString('board_id').toString();
        profile_image = prefs.getString('profile_image').toString();
        api_token = prefs.getString('api_token').toString();
        if (type == "outside") {
          _chapData = _getChapterCategories();
        }
        if (type == "inside") {
          _topicData = _getTopicCategories(chapter_id);
        }
        _diffData = _getDifficultCategories();
      });
    });
  }

  Future _getDifficultCategories() async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/question-level"),
      body: "",
      headers: headers,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      print(result);

      for (int i = 0; i < result.length; i++) {
        _animals.add(Animal(
            id: result[i]['id'].toString(),
            name: result[i]['type'].toString()));
      }
      setState(() {
        _items = _animals
            .map((animal) => MultiSelectItem<Animal>(animal, animal.name))
            .toList();
        _selectedAnimals = _animals;
      });

      /* if (mounted) {
        setState(() {

          catData = jsonEncode(result);

          final json = JsonDecoder().convert(catData);

          _region = (json).map<Region>((item) => Region.fromJson(item)).toList();
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

        });

      }*/

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future _getChapterCategories() async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/chapter"),
      body: {"board_id": board_id, "class_id": class_id, "subject_id": "8"},
      headers: headers,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      for (int i = 0; i < result.length; i++) {
        _animals1.add(Animal1(
            id: result[i]['id'].toString(),
            name: result[i]['chapter_name'].toString()));
      }
      setState(() {
        _items1 = _animals1
            .map((animal) => MultiSelectItem<Animal1>(animal, animal.name))
            .toList();
        _selectedAnimals1 = _animals1;
      });

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future _getTopicCategories(String type) async {
    _selectedAnimals2.clear();
    _animals2.clear();
    print(type.toString());
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $api_token',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/topic"),
      body: {"chapter_id": type.toString()},
      headers: headers,
    );
    print({"chapter_id": type.toString()});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      var result = data['Response'];
      var errocode = data['ErrorCode'];
      if (errocode == 0) {
        for (int i = 0; i < result.length; i++) {
          _animals2.add(Animal2(
              id: result[i]['id'].toString(),
              name: result[i]['name'].toString()));
        }
        setState(() {
          /* _items2 = _animals2
              .map((animal) => MultiSelectItem<Animal2>(animal, animal.name))
              .toList();*/
          _selectedAnimals2 = _animals2;
          //  showDrop=true;
        });

        /*if (mounted) {
          setState(() {
            showDrop=true;
            catData4 = jsonEncode(result);

            final json = JsonDecoder().convert(catData4);
            _region4 =
                (json).map<Region4>((item) => Region4.fromJson(item)).toList();
            List<String> item = _region4.map((Region4 map) {
              for (int i = 0; i < _region4.length; i++) {
                if (selectedRegion4 == map.THIRD_LEVEL_NAME) {
                  _type4 = map.THIRD_LEVEL_ID;

                  print(selectedRegion4);
                  return map.THIRD_LEVEL_ID;
                }
              }
            }).toList();
            //if (selectedRegion4 == "") {
            selectedRegion4 = _region4[0].THIRD_LEVEL_NAME;
            _type4 = _region4[0].THIRD_LEVEL_ID;
            // }

          });
        }*/
      } else {
        Fluttertoast.showToast(msg: "No Topic Found");
        setState(() {
          //    selectedRegion4 = null;
          showDrop = false;
        });
      }

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  TextStyle normalText1 = GoogleFonts.inter(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  );

  TextStyle normalText2 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w300,
    color: Colors.white,
  );
  TextStyle normalText3 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  TextStyle next = GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
      letterSpacing: 1);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          backgroundColor: Color(0xff2E2A4A),
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
                        color: index.isEven
                            ? Color(0xff017EFF)
                            : Color(0xffFFC700),
                      ),
                    );
                  },
                  size: 30.0,
                ),
              ),
            )),
            child: SingleChildScrollView(
              child: Container(
                  child: Container(
                      padding: EdgeInsets.all(30),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            board_id != "14"
                                ? Column(children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(top: 50),
                                      child: Image.asset(
                                        'assets/images/intro_2.png',
                                        width: 180,
                                        height: 180,
                                      ),
                                    ),
                                    const SizedBox(height: 25.0),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                          "This test comprises of easy, medium and difficult questions.",
                                          style: normalText1),
                                    ),
                                    const SizedBox(height: 25.0),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text("MCQ- 9 Questions.",
                                          style: normalText2),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                          "Assertion / Reasoning- 2 Questions.",
                                          style: normalText2),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                          "Case based Questions- 1 (4 Questions).",
                                          style: normalText2),
                                    ),
                                    const SizedBox(height: 25.0),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                          "Time to complete this test - 30 Minutes.",
                                          style: normalText3),
                                    ),
                                  ])
                                : Column(children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(top: 50),
                                      child: Image.asset(
                                        'assets/images/intro_2.png',
                                        width: 180,
                                        height: 180,
                                      ),
                                    ),
                                    const SizedBox(height: 25.0),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                          "This test comprises of easy, medium and difficult questions.",
                                          style: normalText1),
                                    ),
                                    const SizedBox(height: 25.0),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text("MCQ- 11 Questions.",
                                          style: normalText2),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                          "Case based Questions- 1 (4 Questions).",
                                          style: normalText2),
                                    ),
                                    const SizedBox(height: 25.0),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                          "Time to complete this test - 30 Minutes.",
                                          style: normalText3),
                                    ),
                                  ]),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(
                                  right: 8.0, left: 8, bottom: 20),
                              child: ButtonTheme(
                                height: 28.0,
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.80,
                                child: RaisedButton(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  textColor: Colors.white,
                                  color: Color(0xff017EFF),
                                  onPressed: () async {
                                    // if (type == "inside") {
                                    setState(() {
                                      _loading = true;
                                    });
                                    final msg = jsonEncode({
                                      "type": type == "outside" ? "1" : "0",
                                      "student_id": user_id,
                                      "chapter": chapter_id,
                                    });
                                    Map<String, String> headers = {
                                      'Accept': 'application/json',
                                      'Authorization': 'Bearer $api_token',
                                    };
                                    var response = await http.post(
                                      new Uri.https(BASE_URL,
                                          API_PATH + "/test-create-random"),
                                      body: {
                                        "type": type == "outside" ? "1" : "0",
                                        "student_id": user_id,
                                        "chapter": chapter_id,
                                      },
                                      headers: headers,
                                    );
                                    print(jsonEncode({
                                      "type": type == "outside" ? "1" : "0",
                                      "student_id": user_id,
                                      "chapter": chapter_id,
                                    }));

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

                                        Fluttertoast.showToast(
                                            msg: errorMessage);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pushNamed(
                                          context,
                                          '/test-correct',
                                          arguments: <String, String>{
                                            'test_id':
                                                data['test_id'].toString(),
                                            'type': "",
                                          },
                                        );
                                      } else {
                                        setState(() {
                                          _loading = false;
                                        });
                                        showAlertDialog(context,
                                            ALERT_DIALOG_TITLE, errorMessage);
                                      }
                                    }
                                  },
                                  child: Text("Start Test", style: next),
                                ),
                              ),
                            ),
                          ]))),
            ),
          )),
    );
  }
}

class Region {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region({this.THIRD_LEVEL_ID, this.THIRD_LEVEL_NAME});

  factory Region.fromJson(Map<String, dynamic> json) {
    return new Region(
        THIRD_LEVEL_ID: json['id'].toString(), THIRD_LEVEL_NAME: json['type']);
  }
}

class Region3 {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region3({this.THIRD_LEVEL_ID, this.THIRD_LEVEL_NAME});

  factory Region3.fromJson(Map<String, dynamic> json) {
    return new Region3(
      THIRD_LEVEL_ID: json['id'].toString(),
      THIRD_LEVEL_NAME: json['chapter_name'],
    );
  }
}

class Region4 {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region4({this.THIRD_LEVEL_ID, this.THIRD_LEVEL_NAME});

  factory Region4.fromJson(Map<String, dynamic> json) {
    return new Region4(
      THIRD_LEVEL_ID: json['id'].toString(),
      THIRD_LEVEL_NAME: json['name'],
    );
  }
}

class Animal {
  final String id;
  final String name;

  Animal({
    this.id,
    this.name,
  });
}

class Animal1 {
  final String id;
  final String name;

  Animal1({
    this.id,
    this.name,
  });
}

class Animal2 {
  final String id;
  final String name;

  Animal2({
    this.id,
    this.name,
  });
}
