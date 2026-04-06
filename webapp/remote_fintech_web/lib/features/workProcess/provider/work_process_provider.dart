import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class WorkProcessProvider with ChangeNotifier {
  static const String featureName = "WorkProcess";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  List<dynamic> workProcess = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  TextEditingController editingController = TextEditingController();

  String jsonData =
      '[{"id":"wpId","name":"Work Process ID","isMandatory":true,"inputType":"number"}, {"id":"wpName","name":"Work Process Name","isMandatory":true,"inputType":"text","maxCharacter":50}]';

  void reset() {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    notifyListeners();
  }

  void initWidget() async {
    String jsonData =
        '[{"id":"wpId","name":"Work Process ID","isMandatory":true,"inputType":"number"}, {"id":"wpName","name":"Work Process Name","isMandatory":true,"inputType":"text","maxCharacter":50}]';

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

  Future<Map<String, dynamic>> getByIdWorkProcess(String wpId) async {
    http.StreamedResponse response =
        await networkService.post("/get-by-id-work-process/", {"wpId": wpId});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEditWidget() async {
    String jsonData =
        '[{"id":"wpId","name":"Work Process ID","isMandatory":true,"inputType":"number", "readOnly" : true}, {"id":"wpName","name":"Work Process Name","isMandatory":true,"inputType":"text","maxCharacter":50}]';

    Map<String, dynamic> editMapData = await getByIdWorkProcess(editingController.text);
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
        "/add-work-process/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> processDeleteFormInfo(String wpId) async {
    http.StreamedResponse response =
        await networkService.post("/delete-work-process/", {"wpId": wpId});
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-work-process/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void getWorkProcessReport() async {
    workProcess.clear();
    http.StreamedResponse response =
        await networkService.get("/get-work-process/");
    if (response.statusCode == 200) {
      workProcess = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }
}
