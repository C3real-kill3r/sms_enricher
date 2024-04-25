// create a post request to the backend endpoint
import 'dart:convert';
import 'package:http/http.dart' as http;

class APICalls {
  Future<bool> sendToBackend(List<dynamic> enrichedMessages, String endpointUrl,
      String userEmail, String organizationName, String userName) async {
    final response = await http.post(
      Uri.parse(endpointUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'enrichedMessages': jsonEncode(enrichedMessages),
        'userEmail': userEmail,
        'organizationName': organizationName,
        'userName': userName,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
