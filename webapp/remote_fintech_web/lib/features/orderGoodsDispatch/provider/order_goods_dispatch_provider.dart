import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class OrderGoodsDispatchProvider with ChangeNotifier {
  static const String featureName = "OrderGoodsDispatch";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  List<dynamic> pendingReport = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  String jsonData =
      '[{"id":"No","name":"Doc. No","isMandatory":true,"inputType":"text","maxCharacter":16},{"id":"Dt","name":"Date","isMandatory":true,"inputType":"datetime"},{"id":"carId","name":"Car ID","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-carrier/"},{"id":"mof","name":"Mode of Freight","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-mof/"},{"id":"TransMode","name":"Transport Mode","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-trans-mode/"},{"id":"TransId","name":"Transport ID","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"TransName","name":"Transport Name","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"Distance","name":"Distance","isMandatory":true,"inputType":"number"},{"id":"TransDocNo","name":"Transport Doc. No","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"TransDocDt","name":"Transport Doc. Date","isMandatory":false,"inputType":"datetime"},{"id":"VehNo","name":"Vehicle No","isMandatory":true,"inputType":"text","maxCharacter":20},{"id":"VehType","name":"Vehicle Type","isMandatory":true,"inputType":"text","maxCharacter":1}]';

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
        .post("/add-order-goods-dispatch/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void getOrderPending() async {
    pendingReport.clear();
    http.StreamedResponse response =
    await networkService.get("/get-order-goods-dispatch-pending/");
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      pendingReport = data;
    }
    notifyListeners();
  }
}
