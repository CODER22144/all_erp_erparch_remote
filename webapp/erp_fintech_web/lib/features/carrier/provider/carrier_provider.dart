import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../camera/service/camera_service.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class CarrierProvider with ChangeNotifier {
  static const String featureName = "Carrier";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  TextEditingController editController = TextEditingController();

  List<dynamic> carriers = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  String jsonData =
      '[{"id":"carId","name":"Carrier ID","isMandatory":true,"inputType":"number"},{"id":"carName","name":"Carrier Name","isMandatory":true,"inputType":"text","maxCharacter":50},{"id":"carGSTIN","name":"GSTIN","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"carAdd","name":"House Address","isMandatory":true,"inputType":"text","maxCharacter":100},{"id":"carrAdd1","name":"Street / Locality","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"carCity","name":"City","isMandatory":true,"inputType":"text","maxCharacter":50},{"id":"carStateName","name":"State","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-states/"},{"id":"carZipCode","name":"Zipcode","isMandatory":true,"inputType":"number","maxCharacter":6},{"id":"carCPerson","name":"Contact Person","isMandatory":false,"inputType":"text","maxCharacter":50},{"id":"carPhone","name":"Phone No.","isMandatory":false,"inputType":"text","maxCharacter":30}]';

  void reset() {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
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
    Map<String, dynamic> editMapData = await getByIdCarrier();
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
        "/add-carrier/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-carrier/",
        [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<Map<String, dynamic>> getByIdCarrier() async {
    http.StreamedResponse response = await networkService
        .get("/get-carrier/${editController.text}/");
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void getAllCarriers() async {
    carriers.clear();
    http.StreamedResponse response = await networkService
        .get("/get-carrier/");
    if (response.statusCode == 200) {
      carriers = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }
}
