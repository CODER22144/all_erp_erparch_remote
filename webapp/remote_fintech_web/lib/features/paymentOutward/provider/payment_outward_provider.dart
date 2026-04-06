import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';
import '../../utility/models/forms_UI.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:http/http.dart' as http;

class PaymentOutwardProvider with ChangeNotifier {
  static const featureName = 'paymentOutward';
  static const reportFeature = 'paymentOutwardReport';

  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  List<FormUI> formFieldDetails = [];

  TextEditingController editController = TextEditingController();

  List<dynamic> payOutRep = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  List<dynamic> paymentOutAdvance = [];
  List<dynamic> paymentInAdvance = [];

  void getPendingPaymentOutAdvance() async {
    paymentOutAdvance.clear();
    http.StreamedResponse response =
        await networkService.get("/get-pay-out-advance/");
    if (response.statusCode == 200) {
      paymentOutAdvance = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  String jsonData =
      '[{"id":"Dt","name":"Date","isMandatory":true,"inputType":"datetime"},{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"crCode","name":"CR Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"amount","name":"Amount","isMandatory":true,"inputType":"number"},{"id":"mop","name":"Mode of Payment","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-mop/"},{"id":"refNo","name":"Reference No","isMandatory":false,"inputType":"text","maxCharacter":30},{"id":"refDate","name":"Reference Date","isMandatory":false,"inputType":"datetime"},{"id":"narration","name":"Narration","isMandatory":false,"inputType":"text","maxCharacter":200}]';

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
    http.StreamedResponse response = await networkService
        .post("/get-payment-outward/", {"payId": editController.text});
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

  Future<http.StreamedResponse> addPaymentOutwardClear() async {
    http.StreamedResponse response =
        await networkService.post("/add-pay-outward-clear/", {});
    return response;
  }

  Future<http.StreamedResponse> processAddFormInfo(bool manual) async {
    var payload = manual
        ? [GlobalVariables.requestBody[featureName]]
        : GlobalVariables.requestBody[featureName];
    http.StreamedResponse response =
        await networkService.post("/add-payment-outward/", payload);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-payment-outward/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"payId","name":"Pay ID","isMandatory":false,"inputType":"text","maxCharacter":20},{"id":"lcode","name":"Party Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"adjusted","name":"Adjusted","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/"},{"id":"fromDate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"toDate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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

  void getPaymentOutwardReport() async {
    payOutRep.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-payment-outward-report/",
        GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      payOutRep = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  // SEARCH PAYMENT INWARD ADVANCE
  void getPendingPaymentInAdvance() async {
    paymentInAdvance.clear();
    http.StreamedResponse response =
    await networkService.get("/get-pay-inw-advance/");
    if (response.statusCode == 200) {
      paymentInAdvance = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  Future<http.StreamedResponse> addPaymentInClear() async {
    http.StreamedResponse response =
    await networkService.post("/add-pay-inw-clear/", {});
    return response;
  }

}
