import 'dart:convert';

import 'package:grewal/constants.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DataListOfSubjects {
  String api_token = "";
  String user_id = "";
  String class_id = "";
  String board_id = "";
  String order_id = "";
  Future getToken() async {
    Preference().getPreferences().then((value) {
      api_token = value.getString("api_token").toString();
      user_id = value.getString('user_id').toString();
      order_id = value.getString('order_id').toString();
      class_id = value.getString('class_id').toString();
      board_id = value.getString('board_id').toString();
    });
  }

  Future<List> getChapterList(String term) async {
    await getToken();
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/chapter"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + api_token.toString(),
      },
      body: {
        "board_id": board_id,
        "class_id": class_id,
        "subject_id": term,
        "student_id": user_id
      },
    );

    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return [];
  }

  Future<List> getSubjectsList() async {
    await getToken();
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/subject"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + api_token.toString(),
      },
      body: {"student_id": user_id},
    );
    print(response.body.toString() + " get");
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return [];
  }
}
