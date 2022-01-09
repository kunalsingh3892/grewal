import 'dart:convert';

import 'package:grewal/constants.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PaymentPlansAPI {
  String api_token = "";
  String user_id = "";
  Future getToken() async {
    Preference().getPreferences().then((value) {
      api_token = value.getString("api_token").toString();
      user_id = value.getString('user_id').toString();
    });
  }

  Future<List> getSubcriptionPlanNew() async {
    await getToken();
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/subcriptionplannew"),
      headers: {
        'Accept': 'application/json',
        // 'Authorization': 'Bearer ' + api_token.toString(),
      },
      body: {"user_id": user_id},
    );
    print(response.body);
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return [];
  }
}
