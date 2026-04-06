import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class InvenReqProvider with ChangeNotifier {
  static const String featureName = "InvenReq";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget(String reqMode) async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"dcode","name":"Department","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-department/"},{"id":"rtId","name":"Requirement Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-req-type/"},{"id":"mode","name":"Requirement Mode","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-req-mode/", "default" : "$reqMode", "readOnly" : true},{"id":"matno","name":"Material No.","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"qty","name":"Quantity","isMandatory":true,"inputType":"number", "default" : 0}]';

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255,
          defaultValue: element['default'],
          controller: controller,
          readOnly: element['readOnly'] ?? false));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> addRequirement() async {
    http.StreamedResponse response = await networkService.post(
        "/add-req/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> addRequirementDetails(
      List<List<String>> tableRows) async {
    List<Map<String, dynamic>> reqDetails = [];
    for (int i = 0; i < tableRows.length; i++) {
      reqDetails.add({
        "matno": tableRows[i][0] == "" ? null : tableRows[i][0],
        "qty": tableRows[i][1] == "" ? null : tableRows[i][1],
      });
    }
    GlobalVariables.requestBody[featureName]['ReqDetails'] = reqDetails;
    http.StreamedResponse response = await networkService.post(
        "/add-req-details/", GlobalVariables.requestBody[featureName]);
    return response;
  }


}
