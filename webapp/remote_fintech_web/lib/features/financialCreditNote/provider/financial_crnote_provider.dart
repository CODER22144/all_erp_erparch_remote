import 'dart:convert';

import 'package:fintech_new_web/features/common/widgets/custom_text_field.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class FinancialCrnoteProvider with ChangeNotifier {
  static const String featureName = "financialCrnote";
  static const String reportFeature = "financialCrnoteReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  TextEditingController editController = TextEditingController();

  List<dynamic> fcnRep = [];
  List<dynamic> crNotePostPending = [];

  TextEditingController totalAmountController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController rtod = TextEditingController();
  TextEditingController rtodController = TextEditingController();

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  String jsonData =
      '[{"id":"No","name":"Serial no.","isMandatory":false,"inputType":"number"},{"id":"Dt","name":"Transaction Date","isMandatory":true,"inputType":"datetime"},{"id":"fcnType","name":"Credit Note Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-crn-type/"},{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"dbCode","name":"Debit Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"naration","name":"Naration","isMandatory":true,"inputType":"text","maxCharacter":100}]';

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
    initCustomObject({});
  }

  void initEditWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    Map<String, dynamic> editMapData = await getByIdFcn();
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
    initCustomObject(editMapData);
  }

  void initCustomObject(Map<String, dynamic> editMapData) async {
    // List<SearchableDropdownMenuItem<String>> rateTod = await getTodRate();
    widgetList.addAll([
      Container(
        padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "*",
                style: TextStyle(color: Colors.red),
              )
            ],
            text: "Amount",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      CustomTextField(
          field: FormUI(
              id: "amount",
              name: "Amount",
              isMandatory: true,
              inputType: "number",
              controller: amountController,
              defaultValue: editMapData['amount'] ?? 0.00),
          feature: featureName,
          inputType: TextInputType.number,
          customMethod: calculateTotalAmount),
      Container(
        padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "*",
                style: TextStyle(color: Colors.red),
              )
            ],
            text: "Tod Rate",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      CustomTextField(
        field: FormUI(
            id: "rtod",
            name: "Tod Rate",
            isMandatory: true,
            inputType: "number",
            controller: rtodController,
            defaultValue: editMapData['rtod'] ?? 0.00),
        feature: featureName,
        customMethod: calculateTotalAmount,
        inputType: TextInputType.text,
      ),
      Container(
        padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "*",
                style: TextStyle(color: Colors.red),
              )
            ],
            text: "Total Amount",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      CustomTextField(
          field: FormUI(
              id: "tamount",
              name: "Total Amount",
              isMandatory: true,
              inputType: "number",
              controller: totalAmountController,
              defaultValue: editMapData['tamount'] ?? 0,
              readOnly: true),
          feature: featureName,
          inputType: TextInputType.number)
    ]);
    notifyListeners();
  }

  void calculateTotalAmount() {
    totalAmountController.text = (parseEmptyStringToDouble(
                GlobalVariables.requestBody[featureName]["amount"].toString()) *
            parseEmptyStringToDouble(
                GlobalVariables.requestBody[featureName]["rtod"].toString()) *
            0.01)
        .toStringAsFixed(2);
    GlobalVariables.requestBody[featureName]['tamount'] =
        totalAmountController.text;
  }

  Future<List<SearchableDropdownMenuItem<String>>> getTodRate() async {
    List<SearchableDropdownMenuItem<String>> discountType = [];
    http.StreamedResponse response = await networkService.get("/get-tod-rate/");
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      for (var element in data) {
        discountType.add(SearchableDropdownMenuItem(
            value: "${element["rtod"]}",
            child: Text("${element["rtod"]}"),
            label: "${element["rtod"]}"));
      }
    }
    return discountType;
  }

  Future<http.StreamedResponse> processFormInfo(bool manual) async {
    var payload = manual ? [GlobalVariables.requestBody[featureName]] : GlobalVariables.requestBody[featureName];
    http.StreamedResponse response = await networkService.post(
        "/create-financial-crnote/", payload);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-financial-crnote/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<Map<String, dynamic>> getByIdFcn() async {
    http.StreamedResponse response =
        await networkService.post("/get-fcn/", {"No": editController.text});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"lcode","name":"Ledger Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"dbCode","name":"Debit Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"fdate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

    for (var element in jsonDecode(jsonData)) {
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          controller: TextEditingController(),
          defaultValue: element['default'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, reportFeature);
    reportWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getFcnRep() async {
    fcnRep.clear();
    http.StreamedResponse response = await networkService.post(
        "/fiac-crnote-rep/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      fcnRep = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void getCrNotePostPending() async {
    crNotePostPending.clear();
    http.StreamedResponse response = await networkService.get("/get-fiac-crnote-pending/");
    if(response.statusCode == 200) {
      crNotePostPending = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  Future<http.StreamedResponse> processClearFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/add-fiac-crnote-clear/",{});
    return response;
  }

}
