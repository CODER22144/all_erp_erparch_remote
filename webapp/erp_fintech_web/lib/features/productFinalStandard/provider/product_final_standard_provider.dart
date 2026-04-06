import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class ProductFinalStandardProvider with ChangeNotifier {
  static const String featureName = "ProductFinalStandard";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  String jsonData =
      '[{"id":"matno","name":"Material No.","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"pfsSno","name":"Serial No.","isMandatory":true,"inputType":"number"},{"id":"testType","name":"Test Type","isMandatory":true,"inputType":"text","maxCharacter":30},{"id":"isnpItem","name":"Is Np Item","isMandatory":true,"inputType":"text","maxCharacter":30},{"id":"instName","name":"Instance Name","isMandatory":false,"inputType":"text","maxCharacter":20},{"id":"lLimit","name":"Lower Limit","isMandatory":true,"inputType":"text","maxCharacter":40},{"id":"hLimit","name":"Higher Limit","isMandatory":true,"inputType":"text","maxCharacter":40}]';

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
          maxCharacter: element['maxCharacter'] ?? 255,
          controller: controller));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo(bool manual) async {
    var payload = manual
        ? [GlobalVariables.requestBody[featureName]]
        : GlobalVariables.requestBody[featureName];
    http.StreamedResponse response =
        await networkService.post("/add-pbu-final-standard/", payload);
    return response;
  }
}
