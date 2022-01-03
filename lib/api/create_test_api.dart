// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:async';
import 'package:grewal/constants.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MCQLevelTestAPI {
  String api_token = "";
  Future getToken() async {
    Preference().getPreferences().then((value) {
      api_token = value.getString("api_token").toString();
    });
  }

  Future<List> getSetList(String student_id, String chapter_id) async {
    await getToken();
    var response = await http
        .post(new Uri.https(BASE_URL, API_PATH + "/set-list"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + api_token.toString(),
    }, body: {
      "user_id": student_id,
      "chapter_id": chapter_id
    });
    print(response.body);
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return [];
  }

  Future<Map> getTestQuestions(
      String student_id, String chapter_id, String set_id) async {
    await getToken();
    var response = await http.post(
        new Uri.https(BASE_URL, API_PATH + "/start-level-test"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + api_token.toString(),
        },
        body: {
          "student_id": student_id,
          "chapter_id": chapter_id,
          "set_id": set_id
        });

    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return {};
  }

  Future<List> getTopicListChapterWise(String chapter_id) async {
    await getToken();

    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/topiclistchapterwise"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + api_token.toString(),
      },
      body: {
        "chapter_id": chapter_id,
      },
    );

    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return [];
  }

  Future<Map> createSubjectiveTest(Map map) async {
    await getToken();

    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/subjective-test-create"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + api_token.toString(),
      },
      body: jsonEncode(map),
    );

    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body);
    }
    return {"ErrorCode": "123"};
  }

  Future<List> getSubjectiveTestList(String userId) async {
    await getToken();

    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/subjective-test-list"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + api_token.toString(),
      },
      body: {"student_id": userId.toString()},
    );
    print(jsonEncode({"student_id": userId.toString()}));
    print(response.body);

    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return [];
  }

  Future<int> getTotalQuestionCountofTest(String userId, String testId) async {
    await getToken();

    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/check-result"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + api_token.toString(),
      },
      body: {"test_id": testId.toString(), "user_id": userId.toString()},
    );

    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'].length;
    }
    return 0;
  }
}
