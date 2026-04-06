import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';
import '../../utility/models/forms_UI.dart';
import '../../utility/services/generate_form_service.dart';

import 'package:http/http.dart' as http;

class ReverseChargeProvider with ChangeNotifier {
  static const String featureName = "reverseCharge";
  static const String reportFeature = "reverseChargeReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    String jsonData =
        '[{"id":"docDate","name":"Doc. Date","isMandatory":true,"inputType":"datetime"},{"id":"transId","name":"Transaction Id","isMandatory":false,"inputType":"number"},{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"billNo","name":"Bill No.","isMandatory":true,"inputType":"text","maxCharacter":30},{"id":"billDate","name":"Bill Date","isMandatory":true,"inputType":"datetime"},{"id":"slId","name":"Supply Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-supply-type/"},{"id":"stId","name":"Supplier Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-supplier-type/"},{"id":"naration","name":"Narration","isMandatory":false,"inputType":"text","maxCharacter":50},{"id":"hsnCode","name":"Hsn Code","isMandatory":false,"inputType":"text","maxCharacter":10},{"id":"qty","name":"Quantity","isMandatory":true,"inputType":"number"},{"id":"rate","name":"Rate","isMandatory":true,"inputType":"number"},{"id":"amount","name":"Amount","isMandatory":true,"inputType":"number"},{"id":"discountAmount","name":"Discount Amount","isMandatory":true,"inputType":"number"},{"id":"rgst","name":"GST Rate","isMandatory":true,"inputType":"number"}, {"id":"gstAmount","name":"GST Amount","isMandatory":true,"inputType":"number"}]';

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          controller: controller,
          defaultValue: element['default'],
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/add-reverse-charge/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    widgetList.clear();

    String jsonData =
        '[{"id":"slId","name":"Supply Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-supply-type/"},{"id":"lcode","name":"Ledger Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"fdate","name":"From Date","isMandatory":false,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":false,"inputType":"datetime"}]';

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          controller: controller,
          defaultValue: element['default'],
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, reportFeature);
    widgetList.addAll(widgets);
    notifyListeners();
  }
}