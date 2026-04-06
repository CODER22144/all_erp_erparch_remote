import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/custom_dropdown_field.dart';
import '../../common/widgets/custom_text_field.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class PaymentInwardProvider with ChangeNotifier {
  static const String featureName = "PaymentInward";
  static const String clearFeature = "CrNoteClear";
  static const String reportFeature = "PaymentInwardReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  List<SearchableDropdownMenuItem<String>> partyCodes = [];

  List<dynamic> unadjPaymentInward = [];
  List<dynamic> paymentInwardReport = [];

  List<DataRow> rows = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  List<SearchableDropdownMenuItem<String>> voucherType = [];
  SearchableDropdownController<String> voucherTypeController =
      SearchableDropdownController<String>();
  TextEditingController bamountController = TextEditingController();

  String jsonData =
      '[{"id":"mop","name":"Mode Of Payment","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-mop/"},{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"crdrCode","name":"CR/DR Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"amount","name":"Amount","isMandatory":true,"inputType":"number"},{"id":"naration","name":"Naration","isMandatory":true,"inputType":"text"}]';

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
          controller: controller,
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/add-payment-inward/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<http.StreamedResponse> addCrNoteClear() async {
    http.StreamedResponse response = await networkService
        .post("/add-crnote-clear/", [GlobalVariables.requestBody[clearFeature]]);
    return response;
  }

  void getUnadjustedPaymentInward() async {
    unadjPaymentInward.clear();
    http.StreamedResponse response =
        await networkService.get("/get-unadjusted-payment-inward/");
    if (response.statusCode == 200) {
      unadjPaymentInward = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void initClearWidget(String details) async {
    voucherTypeController.clear();
    bamountController.clear();
    var data = jsonDecode(details);
    String jsonData =
        '[{"id":"payId","name":"Doc No.","isMandatory":true,"inputType":"number", "default" : "${data['docno']}"},{"id":"amount","name":"Amount","isMandatory":true,"inputType":"number", "default" : "${data['bamount']}"},{"id":"clnaration","name":"Naration","isMandatory":false,"inputType":"text","maxCharacter":100}]';

    GlobalVariables.requestBody[clearFeature] = {};
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
        await formService.generateDynamicForm(formFieldDetails, clearFeature);
    widgetList.addAll(widgets);
    initCustomWidget(data['lcode']);
  }

  void initCustomWidget(String lcode) async {
    voucherType = await formService.getDropdownMenuItem("/get-pay-pending-type/");
    var transIdItems = await formService
        .getDropdownMenuItem("/get-payment-pending-lcode/$lcode/");
    widgetList.addAll([
      CustomDropdownField(
          field: FormUI(
              id: "transId",
              name: "Transaction ID",
              isMandatory: true,
              inputType: "dropdown"),
          customFunction: getVoucherTypeBylcode,
          dropdownMenuItems: transIdItems,
          feature: clearFeature),
      CustomDropdownField(
          field: FormUI(
              id: "vtype",
              name: "Voucher Type",
              isMandatory: true,
              inputType: "dropdown",
              controller: voucherTypeController,
              readOnly: true),
          dropdownMenuItems: voucherType,
          feature: clearFeature),
      CustomTextField(
          field: FormUI(
              id: "bamount",
              name: "Balance Amount",
              isMandatory: false,
              inputType: "number",
              controller: bamountController,
              readOnly: true),
          feature: clearFeature,
          inputType: TextInputType.number)
    ]);
    notifyListeners();
  }

  void getVoucherTypeBylcode() async {
    String transId = GlobalVariables.requestBody[clearFeature]['transId'];
    var split = transId.split("|");
    if (transId != null && transId != "") {
      http.StreamedResponse response =
          await networkService.post("/get-payment-pending-transId/", {"transId" : split[1], "vType" : split[0]});
      if (response.statusCode == 200) {
        var details = jsonDecode(await response.stream.bytesToString())[0];
        var vType = findDropdownMenuItem(voucherType, details['vtype']);
        voucherTypeController.selectedItem.value = vType;
        bamountController.text = details['bamount'];
        GlobalVariables.requestBody[clearFeature]['vtype'] = details['vtype'];
        GlobalVariables.requestBody[clearFeature]['transId'] = details['transId'];
      }
    }
    notifyListeners();
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"lcode","name":"Party Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"fdate","name":"From Date","isMandatory":false,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":false,"inputType":"datetime"}]';

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

  void getPaymentInwardReport() async {
    paymentInwardReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/payment-inward-report/",
        GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      paymentInwardReport = jsonDecode(await response.stream.bytesToString());
    }
    getRows();
  }

  void getRows() {
    List<double> totals = [0, 0, 0];
    rows.clear();

    for (var data in paymentInwardReport) {
      totals[0] = totals[0] + parseEmptyStringToDouble('${data['amount']}');
      totals[1] = totals[1] + parseEmptyStringToDouble('${data['adjusted']}');
      totals[2] = totals[2] + parseEmptyStringToDouble('${data['unadjusted']}');

      rows.add(DataRow(cells: [
        DataCell(Text('${data['payId'] ?? "-"}')),
        DataCell(Text('${data['tdate'] ?? "-"}')),
        DataCell(Text('${data['mop'] ?? "-"}')),
        DataCell(Text('${data['lcode'] ?? "-"}')),
        DataCell(Text('${data['lname'] ?? "-"}')),
        DataCell(Text('${data['crdrCode'] ?? "-"}')),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['amount']}')))),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['adjusted']}')))),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['unadjusted']}')))),
        DataCell(Text('${data['naration'] ?? "-"}')),
      ]));
    }

    rows.add(DataRow(cells: [
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(SizedBox()),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${totals[0]}'), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${totals[1]}'), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${totals[2]}'), style: const TextStyle(fontWeight: FontWeight.bold)))),
      const DataCell(SizedBox()),
    ]));

    notifyListeners();
  }

  Future<http.StreamedResponse> postPaymentInward(String date) async {
    http.StreamedResponse response = await networkService
        .post("/post-payment-inward/", {"fromDate" : date});
    return response;
  }

  Future<List<dynamic>> getBankStatementByDate(String date) async {
    http.StreamedResponse response = await networkService
        .post("/bank-statement-transDate/", {"fromDate" : date});
    if(response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    }
    return [];
  }

  Future<http.StreamedResponse> addPaymentInwardClear(Map<String, dynamic> requestBody) async {
    http.StreamedResponse response = await networkService
        .post("/add-payment-inward-clear/", [requestBody]);
    return response;
  }


}
