import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../camera/service/camera_service.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class BpShippingProvider with ChangeNotifier {
  static const String featureName = "BpShipping";
  static const String reportFeature = "BpShippingReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  TextEditingController editController = TextEditingController();

  List<dynamic> shippingReport = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  String jsonData =
      '[{"id":"shipCode","name":"Shipping code","isMandatory":true,"inputType":"number"},{"id":"bpCode","name":"Business Partner Code","isMandatory":true,"inputType":"text","maxCharacter":10},{"id":"shipName","name":"Shipping Name","isMandatory":true,"inputType":"text","maxCharacter":100},{"id":"shipAdd","name":"Address","isMandatory":true,"inputType":"text","maxCharacter":100},{"id":"shipAdd1","name":"Address 1","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"shipCity","name":"City","isMandatory":true,"inputType":"text","maxCharacter":50},{"id":"shipState","name":"State","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-states/"},{"id":"shipZipCode","name":"Zipcode","isMandatory":true,"inputType":"text","maxCharacter":6},{"id":"shipCountry","name":"Country","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-countries/"},{"id":"shipPhone","name":"Phone No.","isMandatory":false,"inputType":"text","maxCharacter":10},{"id":"shipGSTIN","name":"GSTIN","isMandatory":false,"inputType":"text","maxCharacter":15}]';

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

  void initEditWidget() async {
    Map<String, dynamic> editMapData = await getByIdBpShipping();
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

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/add-bp-shipping/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-bp-shipping/",
        [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<Map<String, dynamic>> getByIdBpShipping() async {
    http.StreamedResponse response = await networkService
        .get("/get-bp-shipping/${editController.text}/");
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"bpCode","name":"Business Partner Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-business-partner/"}]';

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

  void getShippingReport() async {
    shippingReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-shipping-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      shippingReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }
}
