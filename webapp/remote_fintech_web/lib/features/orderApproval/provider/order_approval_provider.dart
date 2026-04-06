import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class OrderApprovalProvider with ChangeNotifier {
  static const String featureName = "orderApproval";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  List<dynamic> pendingReport = [];
  List<dynamic> holdOrderList = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  String jsonData =
      '[{"id":"orderid","name":"Order Id","isMandatory":true,"inputType":"number", "readOnly":true},{"id":"approval","name":"Approval","isMandatory":true,"inputType":"dropdown", "dropdownMenuItem" : "/get-approvals/"},{"id":"reasonDenied","name":"Reason of Denial","isMandatory":false,"inputType":"text","maxCharacter":100}]';

  void initWidget(String orderId) async {
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
          defaultValue: element['id'] == "orderid" ? orderId : element['default'],
          controller: controller,
          readOnly: element['readOnly'] ?? false));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService
        .post("/add-order-approval/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void getOrderPending() async {
    pendingReport.clear();
    http.StreamedResponse response =
    await networkService.get("/get-order-approval-pending/");
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      pendingReport = data;
    }
    notifyListeners();
  }

  void getOrderHoldDenied() async {
    holdOrderList.clear();
    http.StreamedResponse response =
    await networkService.get("/get-order-hold-denied/");
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      holdOrderList = data;
    }
    notifyListeners();
  }

}
