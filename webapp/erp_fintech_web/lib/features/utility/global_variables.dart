import 'dart:ui';

import 'package:hexcolor/hexcolor.dart';
import 'dart:ui' as ui;

import 'package:http/http.dart' as http;

import '../network/service/network_service.dart';

class GlobalVariables {
  static Map<String, dynamic> requestBody = {};
  static Color backgroundColor = HexColor("#EBEBEB");
  static Color themeColor = HexColor("#cb352e");
  static double deviceWidth =
      ui.window.physicalSize.width / ui.window.devicePixelRatio;
  static double deviceHeight =
      ui.window.physicalSize.height / ui.window.devicePixelRatio;
  static http.MultipartRequest multipartRequest = http.MultipartRequest(
      'POST', Uri.parse('${NetworkService.baseUrl}/upload/'));
}
