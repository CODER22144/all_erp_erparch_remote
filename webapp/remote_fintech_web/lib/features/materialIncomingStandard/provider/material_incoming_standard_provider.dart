import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class MaterialIncomingStandardProvider with ChangeNotifier {
  static const String featureName = "MaterialIncomingStandard";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  List<dynamic> materialIncStand = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  String jsonData =
      '[{"id":"matno","name":"Material no.","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"misSno","name":"Serial No.","isMandatory":true,"inputType":"number"},{"id":"testType","name":"Test Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-test-type/"},{"id":"isnpItem","name":"Inspect Item","isMandatory":true,"inputType":"text","maxCharacter":30},{"id":"instName","name":"Instance Name","isMandatory":false,"inputType":"text","maxCharacter":20},{"id":"lLimit","name":"Lower Limit","isMandatory":true,"inputType":"text","maxCharacter":40},{"id":"hLimit","name":"Higher Limit","isMandatory":true,"inputType":"text","maxCharacter":40}]';

  void initWidget() async {
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

  Future<http.StreamedResponse> processFormInfo(bool manual) async {
    var payload = manual ? [GlobalVariables.requestBody[featureName]] : GlobalVariables.requestBody[featureName];
    http.StreamedResponse response = await networkService
        .post("/add-mat-inc-std/", payload);
    return response;
  }

  void getMaterialIncomingStandardReport() async {
    materialIncStand.clear();
    http.StreamedResponse response =
    await networkService.get("/get-mat-inc-std/");
    if (response.statusCode == 200) {
      materialIncStand = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }
}