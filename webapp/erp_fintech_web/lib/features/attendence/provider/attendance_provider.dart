import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../network/service/network_service.dart';
import 'package:http/http.dart' as http;

import '../../utility/global_variables.dart';
import '../../utility/models/forms_UI.dart';
import '../../utility/services/generate_form_service.dart';

class AttendanceProvider with ChangeNotifier {
  static String featureName = "attendance";

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  List<dynamic> attendanceReport = [];
  String jsonData =
      '[{"id":"userId","name":"User Id","isMandatory":false,"inputType":"text"},{"id":"fromDate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"toDate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

  List<Widget> widgetList = [];
  List<FormUI> formFieldDetails = [];

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    for (var element in jsonDecode(jsonData)) {
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> getAttendanceReport() async {
    http.StreamedResponse response = await networkService.post(
        "/attendance-report/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void setReport(dynamic data) {
    attendanceReport = data;
    notifyListeners();
  }
}
