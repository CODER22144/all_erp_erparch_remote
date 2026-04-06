import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class MaterialAssemblyTechDetailsProvider with ChangeNotifier {
  static const String featureName = "MaterialAssemblyTechDetails";
  static const String reportFeature = "MaterialAssemblyTechDetailsReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  TextEditingController editController = TextEditingController();

  List<dynamic> obReport = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  String jsonData =
      '[{"id":"matno","name":"Material no.","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"qc","name":"QC","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"cp","name":"CP","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"fmea","name":"FMEA","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"pfd","name":"PFD","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"ccr","name":"CCR","isMandatory":false,"inputType":"text","maxCharacter":100}]';

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
    await networkService.post("/get-material-assembly-tech-details/", {"matno": editController.text});
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
        "/update-material-assembly-tech-details/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response =
    await networkService.post("/add-material-assembly-tech-details/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> deleteObMaterial() async {
    http.StreamedResponse response =
    await networkService.post("/delete-material-assembly-tech-details/", {"matno" : editController.text});
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '';

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
    http.StreamedResponse response = await networkService.post("/material-assembly-tech-details-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      obReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

}