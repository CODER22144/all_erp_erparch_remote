import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class DlChallanProvider with ChangeNotifier {
  static const String featureName = "DlChallan";
  static const String reportFeature = "DlChallanReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];

  List<dynamic> dlChallanReport = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"bpCode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"ctId","name":"Challan Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-challan-type/"},{"id":"matnoReturn","name":"Return Material","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"qty","name":"Quantity","isMandatory":false,"inputType":"number","default":0}]';

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

  Future<http.StreamedResponse> processFormInfo(
      List<List<String>> tableRows) async {
    List<Map<String, dynamic>> inwardDetails = [];
    for (int i = 0; i < tableRows.length; i++) {
      inwardDetails.add({
        "matno": tableRows[i][0] == "" ? null : tableRows[i][0],
        "qty" : tableRows[i][1] == "" ? null : tableRows[i][1],
      });
    }
    GlobalVariables.requestBody[featureName]['DlChallanDetails'] = inwardDetails;
    http.StreamedResponse response = await networkService.post(
        "/add-dl-challan/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"bpCode","name":"Party Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"}, {"id":"matno","name":"Material No.","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"fdate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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

  void getDlChallanReport() async {
    dlChallanReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-dl-challan-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      dlChallanReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }
}
