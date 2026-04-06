import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class OpeningProvider with ChangeNotifier {
  static const String featureName = "Opening";
  static const String reportFeature = "OpeningReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];

  TextEditingController editController = TextEditingController();
  List<dynamic> openReport = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  String jsonData =
      '[{"id" : "lcode", "name" : "Party Code", "isMandatory" : true, "inputType" : "dropdown", "dropdownMenuItem" : "/get-ledger-codes/"},{"id" : "Fy", "name" : "Financial Year", "isMandatory" : true, "inputType" : "text", "readOnly" : true}, {"id" : "DrAmt", "name" : "DR Amount", "isMandatory" : true, "inputType" : "number"},{"id" : "CrAmt", "name" : "CR Amount", "isMandatory" : true, "inputType" : "number"}]';

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    http.StreamedResponse response =
        await networkService.get("/get-current-fy/");
    String curFy = "";
    if(response.statusCode == 200) {
      curFy = jsonDecode(await response.stream.bytesToString())[0]['Fy'];
    }

    for (var element in jsonDecode(jsonData)) {
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          controller: TextEditingController(),
          readOnly: element['readOnly'] ?? false,
          defaultValue: element['id'] == 'Fy' ? curFy: null,
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<Map<String, dynamic>> getByIdOpening() async {
    http.StreamedResponse response = await networkService
        .post("/get-opening/", {"ObId": editController.text});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEditWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    Map<String, dynamic> editMapData = await getByIdOpening();
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
          defaultValue: editMapData[element['id']]));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo(bool manual) async {
    var payload = manual
        ? [GlobalVariables.requestBody[featureName]]
        : GlobalVariables.requestBody[featureName];
    http.StreamedResponse response =
        await networkService.post("/add-opening/", payload);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-opening/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id" : "ObId", "name" : "ID", "isMandatory" : false, "inputType" : "number"},{"id" : "lcode", "name" : "Party Code", "isMandatory" : false, "inputType" : "dropdown", "dropdownMenuItem" : "/get-ledger-codes/"},{"id" : "Fy", "name" : "Financial Year", "isMandatory" : true, "inputType" : "text"}]';

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

  void getOpeningReport() async {
    openReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/opening-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      openReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }
}
