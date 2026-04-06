import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class HsnProvider with ChangeNotifier {
  static const String featureName = "hsn";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<dynamic> hsnReport = [];
  List<dynamic> acGroups = [];
  List<dynamic> acGroupSearched = [];

  TextEditingController editController = TextEditingController();

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  String jsonData =
      '[{"id":"hsnCode","name":"HSN Code","isMandatory":true,"inputType":"text","maxCharacter":10},{"id":"hsnShortDescription","name":"Short Description","isMandatory":true,"inputType":"text","maxCharacter":50},{"id":"hsnDescription","name":"Long Description","isMandatory":true,"inputType":"text","maxCharacter":500},{"id":"isService","name":"Is Service ?","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/"},{"id":"gstTaxRate","name":"GST Tax Rate","isMandatory":true,"inputType":"dropdown", "dropdownMenuItem" : "/get-gst-tax-rate/"}]';

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

  Future<Map<String, dynamic>> getByIdHsnCode(String hsnCode) async {
    http.StreamedResponse response =
    await networkService.get("/get-hsn-code/$hsnCode/");
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEditWidget() async {
    Map<String, dynamic> editMapData = await getByIdHsnCode(editController.text);
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
    http.StreamedResponse response = await networkService
        .post("/add-hsn/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService
        .post("/update-hsn/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void getHsnReport() async {
    hsnReport.clear();
    http.StreamedResponse response =
    await networkService.get("/get-all-hsn/");
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      hsnReport = data;
    }
    notifyListeners();
  }

  void getAcGroupsReport() async {
    acGroups.clear();
    http.StreamedResponse response =
    await networkService.get("/get-ac-groups/");
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      acGroups = data;
      acGroupSearched = acGroups;
    }
    notifyListeners();
  }

  void search(String target, List<String> fields) {
    if (target.length >= 3) {
      acGroupSearched = acGroups.where((item) {
        return fields.any((field) {
          var value = item;

          for (var key in field.split('.')) {
            if (value is Map && value.containsKey(key)) {
              value = value[key];
            } else {
              return false;
            }
          }
          return value.toString().toLowerCase().contains(target.toLowerCase());
        });
      }).toList();
    } else {
      acGroupSearched = acGroups;
    }

    notifyListeners();
  }

}
