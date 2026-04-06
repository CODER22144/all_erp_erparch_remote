import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class BusinessPartnerOnBoardProvider with ChangeNotifier {
  static const String featureName = "BusinessPartnerOnBoard";
  static const String reportFeature = "BusinessPartnerOnBoardReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  TextEditingController editController = TextEditingController();

  List<dynamic> bpOnBoardReport = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  String jsonData =
      '[{"id":"bpCode","name":"BP Code","inputType":"text","isMandatory":true,"maxCharacter":10},{"id":"bpGSTIN","name":"BP GSTIN","inputType":"text","isMandatory":false,"maxCharacter":15},{"id":"bpName","name":"BP Name","inputType":"text","isMandatory":true,"maxCharacter":100},{"id":"bpAdd","name":"BP Address","inputType":"text","isMandatory":true,"maxCharacter":100},{"id":"bpAdd1","name":"BP Address Line 1","inputType":"text","isMandatory":false,"maxCharacter":100},{"id":"bpCity","name":"BP City","inputType":"text","isMandatory":true,"maxCharacter":50},{"id":"bpState","name":"BP State","inputType":"dropdown","isMandatory":true, "dropdownMenuItem":"/get-states/"},{"id":"bpZipCode","name":"BP Zip Code","inputType":"text","isMandatory":true,"maxCharacter":6},{"id":"bpCountry","name":"BP Country","inputType":"dropdown","isMandatory":true,"maxCharacter":2, "dropdownMenuItem":"/get-countries/"},{"id":"bpPhone","name":"BP Phone","inputType":"text","isMandatory":true,"maxCharacter":10},{"id":"bpWhatsApp","name":"BP WhatsApp","inputType":"text","isMandatory":false,"maxCharacter":10},{"id":"bpEmail","name":"BP Email","inputType":"text","isMandatory":true,"maxCharacter":50},{"id":"contactPerson","name":"Contact Person","inputType":"text","isMandatory":true,"maxCharacter":50},{"id":"designation","name":"Designation","inputType":"text","isMandatory":true,"maxCharacter":20}]';

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

  Future<Map<String, dynamic>> getBpByCode() async {
    http.StreamedResponse response =
    await networkService.post("/get-bp-on-board/", {"bpCode": editController.text});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEditWidget() async {
    Map<String, dynamic> editMapData = await getBpByCode();
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
        "/update-bp-on-board/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response =
    await networkService.post("/add-bp-on-board/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> deleteObMaterial() async {
    http.StreamedResponse response =
    await networkService.post("/delete-bp-on-board/", {"matno" : editController.text});
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"bpName","name":"Business Partner Name","isMandatory":true,"inputType":"text", "maxCharacter" : 100},{"id":"bpState","name":"State","isMandatory":false,"inputType":"dropdown", "dropdownMenuItem" : "/get-states/"}]';

    for (var element in jsonDecode(jsonData)) {
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets = await formService.generateDynamicForm(
        formFieldDetails, reportFeature);
    reportWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getBpOnBoardReport() async {
    bpOnBoardReport.clear();
    http.StreamedResponse response = await networkService.post("/bp-on-board-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      bpOnBoardReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

}