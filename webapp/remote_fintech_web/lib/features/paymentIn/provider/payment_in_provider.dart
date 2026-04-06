import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';
import '../../utility/models/forms_UI.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:http/http.dart' as http;

class PaymentInProvider with ChangeNotifier {
  static const featureName = 'PaymentIn';
  static const reportFeature = 'PaymentInReport';

  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  List<FormUI> formFieldDetails = [];

  TextEditingController editController = TextEditingController();

  List<dynamic> payInRep = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  String jsonData = '[{"name":"Date","id":"Dt","isMandatory":true,"inputType":"datetime"},{"name":"Party Code","id":"lcode","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"name":"Debit Code","id":"dbCode","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"name":"Amount","id":"amount","isMandatory":true,"inputType":"number"},{"name":"Mode of Payment","id":"mop","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-mop/"},{"name":"Reference No","id":"refNo","isMandatory":false,"inputType":"text","maxCharacter":30},{"name":"Reference Date","id":"refDate","isMandatory":false,"inputType":"datetime"},{"name":"Narration","id":"narration","isMandatory":false,"inputType":"text","maxCharacter":200}]';

  void initWidget() async {
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
          controller: controller));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<Map<String, dynamic>> getByIdPaymentOutward() async {
    http.StreamedResponse response =
    await networkService.post("/get-payment-in/", {"payId" : editController.text});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEditWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    Map<String, dynamic> editMapData = await getByIdPaymentOutward();
    GlobalVariables.requestBody[featureName] = editMapData;

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255,
          defaultValue: editMapData[element['id']],
          controller: controller));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo(bool manual) async {
    var payload = manual ? [GlobalVariables.requestBody[featureName]] :GlobalVariables.requestBody[featureName];
    http.StreamedResponse response = await networkService.post(
        "/add-payment-in/", payload);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-payment-in/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData = '[{"id":"payId","name":"Pay ID","isMandatory":false,"inputType":"text","maxCharacter":20},{"name":"lcode","id":"Party Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"fromDate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"toDate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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

  void getPaymentInReport() async {
    payInRep.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-payment-in-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      payInRep = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }


}
