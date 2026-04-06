import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class CostResourceProvider with ChangeNotifier {
  static const String featureName = "CostResource";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  List<dynamic> resources = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  TextEditingController editingController = TextEditingController();

  void reset() {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    notifyListeners();
  }

  void initWidget() async {
    String jsonData =
        '[{"id":"rId","name":"Resource ID","isMandatory":true,"inputType":"number"},{"id":"rName","name":"Resource Name","isMandatory":true,"inputType":"text","maxCharacter":30},{"id":"wages","name":"Wages","isMandatory":true,"inputType":"number"}]';

    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          controller: controller,
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<Map<String, dynamic>> getByIdCostResource(String rId) async {
    http.StreamedResponse response =
    await networkService.post("/get-by-id-cost-resource/", {"rId": rId});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEditWidget() async {
    String jsonData =
        '[{"id":"rId","name":"Resource ID","isMandatory":true,"inputType":"number", "readOnly" : true},{"id":"rName","name":"Resource Name","isMandatory":true,"inputType":"text","maxCharacter":30},{"id":"wages","name":"Wages","isMandatory":true,"inputType":"number"}]';

    Map<String, dynamic> editMapData = await getByIdCostResource(editingController.text);
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
          readOnly: element['readOnly'] ?? false,
          defaultValue: editMapData[element['id']]));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/add-cost-resource/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> processDeleteFormInfo(String rId) async {
    http.StreamedResponse response =
    await networkService.post("/delete-cost-resource/", {"rId": rId});
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-cost-resource/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void getResource() async {
    resources.clear();
    http.StreamedResponse response =
    await networkService.get("/get-cost-resource/");
    if (response.statusCode == 200) {
      resources = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }
}
