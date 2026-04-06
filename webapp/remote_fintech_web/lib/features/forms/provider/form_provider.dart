import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class FormProvider with ChangeNotifier {
  static const String featureName = "jsonForm";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  List<dynamic> formsRep = [];
  TextEditingController editController = TextEditingController();

  String jsonData =
      '[{"id":"form_id","name":"Form Id","isMandatory":true,"inputType":"text", "maxCharacter" : 25},{"id":"form_description","name":"Description","isMandatory":true,"inputType":"text"},{"id":"form_data","name":"Form Json","isMandatory":true,"inputType":"text", "maxCharacter" : 5000}]';

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
          maxCharacter: element['maxCharacter'] ?? 255,
          defaultValue: element['default'],
          controller: TextEditingController()));
    }
    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response =
    await networkService.post("/save-json/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response =
    await networkService.post("/update-json/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void getAllForms() async {
    formsRep.clear();
    http.StreamedResponse response = await networkService.get(
        "/get-all-json/");
    if (response.statusCode == 200) {
      formsRep = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void getByIdForm() async {
    formsRep.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-all-json/", {"form_id" : editController.text});
    if (response.statusCode == 200) {
      formsRep = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

}
