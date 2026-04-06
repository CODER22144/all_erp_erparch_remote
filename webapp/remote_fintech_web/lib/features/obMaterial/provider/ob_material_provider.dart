import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class ObMaterialProvider with ChangeNotifier {
  static const String featureName = "OBMaterial";
  static const String reportFeature = "OBMaterialReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  TextEditingController editController = TextEditingController();

  List<dynamic> obReport = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  String jsonData =
      '[{"id":"matno","name":"Material no.","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"chrDescription","name":"Description","isMandatory":true,"inputType":"text","maxCharacter":500},{"id":"materialGroup","name":"Material Group","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-material-group/"},{"id":"brate","name":"Basic Rate","isMandatory":true,"inputType":"number"},{"id":"srate","name":"Scrap Rate","isMandatory":true,"inputType":"number"},{"id":"muUnit","name":"Unit","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-material-unit/"},{"id":"rmType","name":"Raw Material Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-rm-type/"},{"id":"mrp","name":"MRP","isMandatory":true,"inputType":"number"},{"id":"oerate","name":"OE Rate","isMandatory":true,"inputType":"number"}]';

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
    await networkService.post("/get-ob-material/", {"matno": editController.text});
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

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-ob-material/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> processFormInfo(bool manualOrder) async {
    var payload = manualOrder ? [GlobalVariables.requestBody[featureName]] : GlobalVariables.requestBody[featureName];
    http.StreamedResponse response =
    await networkService.post("/add-ob-material/", payload);
    return response;
  }

  Future<http.StreamedResponse> deleteObMaterial() async {
    http.StreamedResponse response =
    await networkService.post("/delete-ob-material/", {"matno" : editController.text});
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"fmatno","name":"From Material No.","isMandatory":true,"inputType":"text", "maxCharacter" : 15},{"id":"tmatno","name":"To Material No.","isMandatory":true,"inputType":"text", "maxCharacter" : 15},{"id":"materialGroup","name":"Material Group","isMandatory":false,"inputType":"dropdown", "dropdownMenuItem" : "/get-material-group/"}]';

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

  void getOBalanceReport() async {
    obReport.clear();
    http.StreamedResponse response = await networkService.post("/ob-mat-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      obReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

}