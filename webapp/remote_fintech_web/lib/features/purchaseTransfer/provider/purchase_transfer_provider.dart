import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class PurchaseTransferProvider with ChangeNotifier {
  static const String featureName = "PurchaseTransfer";
  static const String reportFeature = "purchasePaymentReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];

  List<dynamic> billPending = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget(String details) async {
    var data = jsonDecode(details);
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    String jsonData =
        '[{"id":"transId","name":"Transaction ID","isMandatory":true,"inputType":"text", "default" : "${data['transId']}"},{"id":"vtype","name":"Voucher Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-voucher-type/", "default" : "${data['vtype']}"},{"id":"mop","name":"Mode of Payment","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-mop/", "default" : "R", "readOnly" : true},{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/", "default" : "${data['lcode']}"},{"id":"crdrCode","name":"CR/DR Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/", "default" : "${data['transCode']}"},{"id":"amount","name":"Amount","isMandatory":true,"inputType":"text", "default" : "${data['bamount']}"},{"id":"naration","name":"Naration","isMandatory":true,"inputType":"text", "default" : "${data['paynaration']}"}]';

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
          readOnly: element['readOnly'] ?? false,
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/add-purchase-transfer/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  void initClearWidget(String details) async {
    var data = jsonDecode(details);
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    String jsonData =
        '[{"id":"ptId","name":"Purchase Transfer ID","isMandatory":true,"inputType":"number"},{"id":"transId","name":"Transaction ID","isMandatory":true,"inputType":"text"},{"id":"vtype","name":"Voucher Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-voucher-type/"},{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"crdrCode","name":"CR/DR Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"amount","name":"Amount","isMandatory":true,"inputType":"text"},{"id":"clnaration","name":"Naration","isMandatory":true,"inputType":"text"}]';

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          controller: controller,
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> addPurchaseTransferClear() async {
    http.StreamedResponse response = await networkService.post(
        "/add-sale-transfer-clear/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"lcode","name":"Party Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"fdate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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

  void getBillPendingReport() async {
    http.StreamedResponse response = await networkService.post(
        "/get-payment-bill-pending/",
        GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      billPending = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }
}
