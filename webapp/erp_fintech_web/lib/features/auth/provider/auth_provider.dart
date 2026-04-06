import 'dart:convert';

import 'package:fintech_new_web/features/network/service/network_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  NetworkService networkService = NetworkService();
  TextEditingController emailController = TextEditingController();

  Map<String, dynamic> userInfo = {};

  void initUserInfo() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userData = prefs.getString("userData");
      if (userData != null) {
        userInfo = jsonDecode(userData);
      }
    notifyListeners();
  }

  void reset() {
    usernameController.clear();
    passwordController.clear();
    notifyListeners();
  }

  Future<http.StreamedResponse> login() async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request(
        'POST', Uri.parse('${NetworkService.baseUrl}/user/jwt-login/'));
    request.bodyFields = {
      'userId': usernameController.text,
      'password': passwordController.text
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<http.StreamedResponse> verifyOtp(String otp) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request(
        'POST', Uri.parse('${NetworkService.baseUrl}/user/two-factor-login/'));
    request.bodyFields = {
      'userId': usernameController.text,
      'password': passwordController.text,
      "otp_token": otp
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<http.StreamedResponse> register_2FA() async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request(
        'POST', Uri.parse('${NetworkService.baseUrl}/user/register-2fa/'));
    request.bodyFields = {
      'userId': usernameController.text,
      'password': passwordController.text,
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return response;
  }
}
