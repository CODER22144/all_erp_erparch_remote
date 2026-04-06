import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

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
      '[{"id":"lcode","name":"Ledger Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"Gstin","name":"Gstin","isMandatory":false,"inputType":"text"},{"id":"LglNm","name":"Legal Name","isMandatory":true,"inputType":"text"},{"id":"Addr1","name":"Address (Home/Street)","isMandatory":true,"inputType":"text"},{"id":"Addr2","name":"Address (Locality/Area)","isMandatory":false,"inputType":"text"},{"id":"Loc","name":"Location","isMandatory":true,"inputType":"text"},{"id":"Stcd","name":"State Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-states/"},{"id":"Pin","name":"Pincode","isMandatory":true,"inputType":"text","maxCharacter":6},{"id":"CntCode","name":"Country Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-countries/"},{"id":"Phone","name":"Phone","isMandatory":false,"inputType":"text","maxCharacter":10}]';

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
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    Map<String, dynamic> editMapData = await getByIdBpShipping();
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
    var payload = manual ? [GlobalVariables.requestBody[featureName]] : GlobalVariables.requestBody[featureName];
    http.StreamedResponse response = await networkService.post(
        "/add-bp-shipping/", payload);
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
        '[{"id":"lcode","name":"Ledger Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"}]';

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
        "/customer-shipping-rep/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      shippingReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }
}
