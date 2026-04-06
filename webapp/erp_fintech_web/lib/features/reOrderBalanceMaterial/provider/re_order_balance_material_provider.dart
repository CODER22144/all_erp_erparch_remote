import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';
import '../../utility/services/generate_form_service.dart';

class ReOrderBalanceMaterialProvider with ChangeNotifier {
  static const String featureName = "reOrderBalanceMaterial";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  List<dynamic> orderBalanceReport = [];

  void initReportWidget() async {
    String jsonData =
        '[{"id":"orderId","name":"Order ID","isMandatory":false,"inputType":"number"},{"id":"bpCode","name":"Business Partner","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-business-partner/"},{"id":"fromDate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"toDate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          controller: controller,
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255));
    }
    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void getMaterialReport() async {
    orderBalanceReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/reorder-balance-material/", GlobalVariables.requestBody[featureName]);
    if (response.statusCode == 200) {
      orderBalanceReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  Future<List<dynamic>> getOrderBalance(String orderId) async {
    http.StreamedResponse response =
        await networkService.get("/get-order-balance/$orderId/");
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    }
    return [];
  }
}
