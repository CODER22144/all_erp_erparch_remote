import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class ProductionPlanProvider with ChangeNotifier {
  static const String featureName = "ProductionPlan";
  static const String reportFeature = "ProductionPlanReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  List<dynamic> ppRep = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  TextEditingController editController = TextEditingController();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"ppId","name":"Plan ID","isMandatory":true,"inputType":"text","maxCharacter":6},{"id":"matno","name":"Material No.","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"qty","name":"Quantity","isMandatory":true,"inputType":"number"}]';

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
        await networkService.post("/add-production-plan/", payload);
    return response;
  }

  void initReportWidget() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"ppId","name":"Plan ID","isMandatory":true,"inputType":"text","maxCharacter":6},{"id":"repId", "name":"Rep Type", "isMandatory":true, "inputType":"dropdown", "dropdownMenuItem" : "/pp-rep-type/"}]';

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
        await formService.generateDynamicForm(formFieldDetails, reportFeature);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void getReport() async {
    ppRep.clear();
    http.StreamedResponse response = await networkService.post(
        "/production-plan-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      ppRep = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }
}
