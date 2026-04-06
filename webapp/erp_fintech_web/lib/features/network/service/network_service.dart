import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../utility/global_variables.dart';

// THIS IS THE SWISS OFFICE PROJECT

class NetworkService {
  static const String baseUrl = "http://erpapi.rcinz.com";
  static const String productionGstBaseUrl = "https://api.whitebooks.in";

  //static const String baseUrl = "http://localhost:8000";

  Future<http.StreamedResponse> get(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("auth_token");
    var headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };
    var request = http.Request('GET', Uri.parse(baseUrl + url));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<http.StreamedResponse> post(String url, dynamic requestBody) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("auth_token");
    var headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };
    var request = http.Request('POST', Uri.parse(baseUrl + url));
    request.body = jsonEncode(requestBody);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<http.StreamedResponse> delete(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("auth_token");
    var headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };
    var request = http.Request('DELETE', Uri.parse(baseUrl + url));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<http.StreamedResponse> put(String url, dynamic requestBody) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("auth_token");
    var headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };
    var request = http.Request('PUT', Uri.parse(baseUrl + url));
    request.body = jsonEncode(requestBody);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<bool> isTokenValid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("auth_token");
    if (token != null) {
      return !JwtDecoder.isExpired(token);
    }
    return false;
  }

  Future<http.StreamedResponse> authorizeGst(dynamic requestBody, String url) async {
    Map<String, String> headers = {
      'accept': '*/*',
      'username': requestBody['usrname'],
      'password': requestBody['pwd'],
      'ip_address': requestBody['ipAddress'],
      'client_id': requestBody['clId'],
      'client_secret': requestBody['clSec'],
      'gstin': requestBody['gstin']
    };

    var request = http.Request(
        'GET',
        Uri.parse(
            '$url/einvoice/authenticate?email=${requestBody['email']}'));
    request.bodyFields = {};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return response;
  }


  void logError(dynamic errorMap) async {
    String? ipAddress = await getPublicIpAddress();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginId = prefs.getString("currentLoginId");
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse("$baseUrl/user/error-logs/"));
    request.body = jsonEncode({
      "error_code": errorMap['errorCode'],
      "error_message": errorMap['errorMsg'].toString(),
      "api_endpoint": errorMap['endpoint'],
      "ip_address": ipAddress,
      "user_id" : loginId,
      "api_payload" : errorMap['featureName'] != null ? GlobalVariables.requestBody[errorMap['featureName']] : errorMap['payload']
    });
    request.headers.addAll(headers);
    http.StreamedResponse resp = await request.send();
  }

  Future<String?> getPublicIpAddress() async {
    try {
      final response = await http.get(Uri.parse('https://api.ipify.org'));
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      print('Error fetching IP: $e');
    }
    return null;
  }
}
