import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class GrQtyClearProvider with ChangeNotifier {
  static const String featureName = "grQtyClear";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<dynamic> grQtyClearPending = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget(String details) async {
    var data = jsonDecode(details);
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"grdId","name":"ID","isMandatory":true,"inputType":"number", "default" : "${data['grdId']}"},{"id":"recqty","name":"Received Quantity","isMandatory":true,"inputType":"number", "default" : "${data['grQty']}"},{"id":"rejqty","name":"Rejected Quantity","isMandatory":true,"inputType":"number", "default" : 0}]';

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
          controller: controller));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/add-gr-qty-clear/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void getGrQtyClearPending() async {
    grQtyClearPending.clear();
    http.StreamedResponse response =
    await networkService.get("/get-gr-qty-clear-pending/");
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      grQtyClearPending = data;
    }
    notifyListeners();
  }

}
