import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class SalesOrderAdvanceProvider with ChangeNotifier {
  static const String featureName = "salesOrderAdvance";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  List<List<TextEditingController>> rowControllers = [];
  List<SearchableDropdownMenuItem<String>> bpCodes = [];
  Map<String, List<SearchableDropdownMenuItem<String>>> shipCodes = {};

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    bpCodes.clear();
    String jsonData =
        '[{"id":"carId","name":"Carrier","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-carrier/"},{"id":"poNo","name":"PO No.","isMandatory":false,"inputType":"text","maxCharacter":30},{"id":"poDate","name":"PO Date","isMandatory":false,"inputType":"datetime"},{"id":"transmode","name":"Mode Of Transport","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-trans-mode/"},{"id":"privateMark","name":"Private Mark","isMandatory":false,"inputType":"text","maxCharacter":20},{"id":"mop","name":"Mode Of Payemnt","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-mop/"},{"id":"mof","name":"Freight Mode","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-mof/"}]';

    bpCodes = await formService.getDropdownMenuItem("/get-business-partner/");

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
    initDetailsTab();
    getShippingByBpCode();
  }

  Future<http.StreamedResponse> processFormInfo(
      List<List<String>> tableRows, bool isManual) async {
    List<Map<String, dynamic>> orderDetails = [];
    for (int i = 0; i < tableRows.length; i++) {
      orderDetails.add({
        "icode": tableRows[i][0],
        "qty": tableRows[i][1],
      });
    }
    if (isManual) {
      GlobalVariables.requestBody[featureName]['orderdetails'] = orderDetails;
    }
    http.StreamedResponse response = await networkService.post(
        "/add-sale-order-adv/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void initDetailsTab() {
    List<List<String>> tableRows = [['','']];
    rowControllers = tableRows
        .map((row) =>
        row.map((field) => TextEditingController(text: field)).toList())
        .toList();
  }

  void deleteRowController(int index) {
    rowControllers.removeAt(index);
    notifyListeners();
  }

  void addRowController() {
    rowControllers.add([
      TextEditingController(),
      TextEditingController(),
    ]);
    notifyListeners();
  }

  void getShippingByBpCode() async {
    shipCodes.clear();
    http.StreamedResponse response = await networkService.get("/get-shipping/");
    if (response.statusCode == 200) {
      var respData = jsonDecode(await response.stream.bytesToString());
      for (var data in respData) {
        if (shipCodes.containsKey(data['bpCode'])) {
          shipCodes[data['bpCode']]?.add(SearchableDropdownMenuItem(
              label: data['shipName'],
              child: Text(data['shipName']),
              value: data['shipCode'].toString()));
        } else {
          shipCodes[data['bpCode']] = [];
          shipCodes[data['bpCode']]?.add(SearchableDropdownMenuItem(
              label: data['shipName'],
              child: Text(data['shipName']),
              value: data['shipCode'].toString()));
        }
      }
    }
    notifyListeners();
  }
}
