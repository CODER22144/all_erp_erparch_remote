import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class FinancialYearProvider with ChangeNotifier {
  static const String featureName = "FinancialYear";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];

  TextEditingController editController = TextEditingController();

  List<dynamic> FyRep = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  String jsonData =
      '[{"id":"Fy","name":"Financial Year","isMandatory":true,"inputType":"text"},{"id":"SDate","name":"Start Date","isMandatory":true,"inputType":"datetime"},{"id":"EDate","name":"End Date","isMandatory":true,"inputType":"datetime"},{"id":"IsActive","name":"Is Active","isMandatory":true,"inputType":"dropdown", "dropdownMenuItem" : "/get-tf/"}]';

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
          maxCharacter: element['maxCharacter'] ?? 255,
          defaultValue: element['default'],
          controller: TextEditingController()));
    }
    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<Map<String, dynamic>> getByIdFy() async {
    http.StreamedResponse response =
    await networkService.post("/get-fy-id/", {"Fy" : editController.text});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEditWidget() async {
    formFieldDetails.clear();
    widgetList.clear();
    GlobalVariables.requestBody[featureName] = {};

    Map<String, dynamic> editMapData = await getByIdFy();
    GlobalVariables.requestBody[featureName] = editMapData;

    for (var element in jsonDecode(jsonData)) {
      TextEditingController editController = TextEditingController();
      formFieldDetails.add(FormUI(
        id: element['id'],
        name: element['name'],
        isMandatory: element['isMandatory'],
        inputType: element['inputType'],
        dropdownMenuItem: element['dropdownMenuItem'] ?? "",
        maxCharacter: element['maxCharacter'] ?? 255,
        controller: editController,
        children: element['children'] ?? [],
        defaultValue: editMapData[element['id']],
      ));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo(bool manual) async {
    http.StreamedResponse response =
    await networkService.post("/add-financial-year/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-financial-year/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void getFyReport() async {
    FyRep.clear();
    http.StreamedResponse response = await networkService.get(
        "/get-fy/");
    if (response.statusCode == 200) {
      FyRep = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }
}
