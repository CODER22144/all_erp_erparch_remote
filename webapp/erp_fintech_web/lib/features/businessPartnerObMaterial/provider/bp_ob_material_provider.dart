import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class BpObMaterialProvider with ChangeNotifier {
  static const String featureName = "BpObMaterial";
  static const String reportFeature = "BpObMaterialReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  TextEditingController editController = TextEditingController();
  TextEditingController editController2 = TextEditingController();

  List<SearchableDropdownMenuItem<String>> bpCodes = [];

  List<dynamic> obReport = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  String jsonData =
      '[{"id":"bpCode","name":"Business partner","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-bp-ob/"},{"id":"matno","name":"Material no.","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"chrDescription","name":"Description","isMandatory":true,"inputType":"text","maxCharacter":500},{"id":"brate","name":"Basic Rate","isMandatory":true,"inputType":"number"},{"id":"muUnit","name":"Unit","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-material-unit/"}]';

  void reset() {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    notifyListeners();
  }

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

  Future<Map<String, dynamic>> getByIdObMaterial() async {
    http.StreamedResponse response = await networkService
        .post("/get-bp-ob-material/", {"bpCode": editController.text, "matno" : editController2.text});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEditWidget() async {
    Map<String, dynamic> editMapData = await getByIdObMaterial();
    GlobalVariables.requestBody[featureName] = editMapData;
    formFieldDetails.clear();
    widgetList.clear();

    for (var element in jsonDecode(jsonData)) {
      TextEditingController editController = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: false,
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255,
          controller: editController,
          defaultValue: editMapData[element['id']]));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-bp-ob-material/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> processFormInfo(bool manual) async {
    var payload = manual
        ? [GlobalVariables.requestBody[featureName]]
        : GlobalVariables.requestBody[featureName];
    http.StreamedResponse response =
        await networkService.post("/add-bp-ob-material/", payload);
    return response;
  }

  Future<http.StreamedResponse> deleteObMaterial() async {
    http.StreamedResponse response = await networkService
        .post("/delete-bp-ob-material/", {"bpmId": editController.text});
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"fmatno","name":"From Material No.","isMandatory":false,"inputType":"text", "maxCharacter" : 15},{"id":"tmatno","name":"To Material No.","isMandatory":false,"inputType":"text", "maxCharacter" : 15},{"id":"bpCode","name":"Business Partner","isMandatory":false,"inputType":"dropdown", "dropdownMenuItem" : "/get-bp-ob/"}]';

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
        await formService.generateDynamicForm(formFieldDetails, reportFeature);
    reportWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getBpOBMaterialReport() async {
    obReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-bp-ob-material-report/",
        GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      obReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void getBpCodes() async {
    bpCodes = await formService.getDropdownMenuItem("/get-bp-ob/");
    notifyListeners();
  }

  Future<List<SearchableDropdownMenuItem<String>>> getMaterials(
      String? bpCode) async {
    var data =
    await formService.getDropdownMenuItem("/get-ob-mat-dropdown/$bpCode/");
    return data;
  }
}
