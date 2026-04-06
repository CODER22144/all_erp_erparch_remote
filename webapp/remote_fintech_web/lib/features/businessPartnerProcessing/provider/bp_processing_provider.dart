import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class BpProcessingProvider with ChangeNotifier {
  static const String featureName = "BpProcessing";
  static const String reportFeature = "BpProcessingReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  TextEditingController editController = TextEditingController();
  TextEditingController editController2 = TextEditingController();

  List<dynamic> obReport = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  List<SearchableDropdownMenuItem<String>> bpCodes = [];

  String jsonData =
      '[{"id":"bpCode","name":"Business partner","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-bp-ob/"},{"id":"pId","name":"PId","isMandatory":true,"inputType":"text","maxCharacter":5},{"id":"proDescription","name":"Description","isMandatory":true,"inputType":"text","maxCharacter":30},{"id":"proRate","name":"Rate","isMandatory":true,"inputType":"text","maxCharacter":5}]';

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
    http.StreamedResponse response =
    await networkService.post("/get-bp-processing/", {"bpCode" : editController.text, "pId" : editController2.text});
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
        "/update-bp-processing/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response =
    await networkService.post("/add-bp-processing/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> deleteObMaterial() async {
    http.StreamedResponse response =
    await networkService.post("/delete-bp-processing/", {"bpCode" : editController.text});
    return response;
  }

  void getBpCodes() async {
    bpCodes = await formService.getDropdownMenuItem("/get-bp-ob/");
    notifyListeners();
  }

}