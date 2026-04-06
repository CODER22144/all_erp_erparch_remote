import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../camera/service/camera_service.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class BpBreakupProvider with ChangeNotifier {
  static const String featureName = "BpBreakup";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  TextEditingController editController = TextEditingController();
  TextEditingController editController2 = TextEditingController();

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  List<dynamic> bpBreakupReport = [];

  List<List<TextEditingController>> rowControllers = [];
  List<List<TextEditingController>> rowControllers2 = [];

  List<SearchableDropdownMenuItem<String>> units = [];
  List<SearchableDropdownMenuItem<String>> bpCodes = [];
  List<SearchableDropdownMenuItem<String>> rmType = [];

  String jsonData =
      '[{"id":"rmType","name":"Material Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/raw-material/"},{"id":"profit","name":"Profit","isMandatory":true,"inputType":"number"},{"id":"rejection","name":"Rejection","isMandatory":true,"inputType":"number"},{"id":"icc","name":"ICC","isMandatory":true,"inputType":"number"},{"id":"overhead","name":"Overhead","isMandatory":true,"inputType":"number"},{"id":"processing","name":"Processing","isMandatory":true,"inputType":"number"},{"id":"csId","name":"Cost Status","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-cost-status/"}]';

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

    bpCodes = await formService.getDropdownMenuItem("/get-bp-ob/");

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255,
          controller: controller,
          defaultValue: element['default']));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<Map<String, dynamic>> getByIdBpBreakup() async {
    http.StreamedResponse response = await networkService.post(
        "/get-bp-breakup/",
        {"bpCode": editController.text, "matno": editController2.text});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEditWidget() async {
    Map<String, dynamic> editMapData = await getByIdBpBreakup();
    GlobalVariables.requestBody[featureName] = editMapData;
    formFieldDetails.clear();
    widgetList.clear();

    bpCodes = await formService.getDropdownMenuItem("/get-bp-ob/");

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

  void initDetailWidget() async {
    List<List<String>> tableRows = [
      ['', '', '', '', '', '', '', '']
    ];

    rowControllers = tableRows
        .map((row) =>
            row.map((field) => TextEditingController(text: field)).toList())
        .toList();

    units = await formService.getDropdownMenuItem("/get-material-unit/");
    rmType = await formService.getDropdownMenuItem("/get-rm-type/");
    bpCodes = await formService.getDropdownMenuItem("/get-bp-ob/");

    notifyListeners();
  }

  void initProcessingWidget() async {
    List<List<String>> tableRows = [
      ['', '', '', '']
    ];

    rowControllers2 = tableRows
        .map((row) =>
            row.map((field) => TextEditingController(text: field)).toList())
        .toList();

    bpCodes = await formService.getDropdownMenuItem("/get-bp-ob/");

    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/add-bp-breakup/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> addMaterialAssemblyDetails(
      List<List<String>> detailsTab, bool manualOrder) async {
    List<Map<String, dynamic>> matAssembly = [];
    for (int i = 0; i < detailsTab.length; i++) {
      matAssembly.add({
        "bpCode": detailsTab[i][0],
        "matno": detailsTab[i][7],
        "partno": detailsTab[i][1],
        "qty": detailsTab[i][2],
        "pLength": detailsTab[i][3],
        "unit": detailsTab[i][4],
        "tno": detailsTab[i][5],
        "rmType": detailsTab[i][6]
      });
    }

    var payload = manualOrder
        ? matAssembly
        : GlobalVariables.requestBody['BpBreakupDetails'];

    http.StreamedResponse response =
        await networkService.post("/add-bp-breakup-details/", payload);
    return response;
  }

  Future<http.StreamedResponse> addMaterialAssemblyProcessing(
      List<List<String>> detailsTab, bool manualOrder) async {
    List<Map<String, dynamic>> matAssembly = [];
    for (int i = 0; i < detailsTab.length; i++) {
      matAssembly.add({
        "bpCode": detailsTab[i][0],
        "matno": detailsTab[i][1],
        "pId": detailsTab[i][2],
        "lqty": detailsTab[i][3],
      });
    }

    var payload = manualOrder
        ? matAssembly
        : GlobalVariables.requestBody['BPBreakupProcessing'];

    http.StreamedResponse response =
        await networkService.post("/add-bp-breakup-processing/", payload);
    return response;
  }

  void setDrawing(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.getBlobUrl(blob, name);
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["drawing"] = blobUrl;
    }
    notifyListeners();
  }

  void setPic(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.getBlobUrl(blob, name);
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["pic"] = blobUrl;
    }
    notifyListeners();
  }

  void setAsDrawing(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.getBlobUrl(blob, name);
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["asdrawing"] = blobUrl;
    }
    notifyListeners();
  }

  void addRowController() {
    rowControllers.add([
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ]);
    notifyListeners();
  }

  void deleteRowController(int index) {
    rowControllers.removeAt(index);
    notifyListeners();
  }

  void addRowController2() {
    rowControllers2.add([
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ]);
    notifyListeners();
  }

  void deleteRowController2(int index) {
    rowControllers2.removeAt(index);
    notifyListeners();
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-bp-breakup/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void getBpBreakupReport() async {
    bpBreakupReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-bp-breakup-report/", {"bpCode": editController.text, "matno": editController2.text});
    if (response.statusCode == 200) {
      bpBreakupReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  Future<List<SearchableDropdownMenuItem<String>>> getMaterials(
      String? bpCode) async {
    var data =
        await formService.getDropdownMenuItem("/get-ob-mat-dropdown/$bpCode/");
    return data;
  }

  Future<List<SearchableDropdownMenuItem<String>>> getBpProcessing(
      String? bpCode) async {
    var data =
        await formService.getDropdownMenuItem("/get-bp-processing/$bpCode/");
    return data;
  }

  void getBpCodes() async {
    bpCodes = await formService.getDropdownMenuItem("/get-bp-ob/");
    notifyListeners();
  }
}
