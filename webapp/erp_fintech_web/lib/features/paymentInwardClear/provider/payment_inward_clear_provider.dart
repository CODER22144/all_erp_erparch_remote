import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class PaymentInwardClearProvider with ChangeNotifier {
  static const String featureName = "paymentInwardClear";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget(String details) async {
    var data = jsonDecode(details);
    String jsonData =
        '[{"id":"payId","name":"Payment Id","isMandatory":true,"inputType":"number", "default" : "${data['docno']}"},{"id":"transId","name":"Transaction Id","isMandatory":true,"inputType":"dropdown", "dropdownMenuItem" : "/get-payment-pending-lcode/${data['lcode']}/"},{"id":"vtype","name":"Voucher Type","isMandatory":true,"inputType":"text", "maxCharacter" : 1, "default" : "${data['ptype']}"},{"id":"amount","name":"Amount","isMandatory":true,"inputType":"number", "default" : "${data['bamount']}"},{"id":"clnaration","name":"Naration","isMandatory":true,"inputType":"text","maxCharacter":100}]';

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
          defaultValue: element['default'],
          controller: controller,
          readOnly: element['readOnly'] ?? false));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }


  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/add-payment-inward-clear/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }
}
