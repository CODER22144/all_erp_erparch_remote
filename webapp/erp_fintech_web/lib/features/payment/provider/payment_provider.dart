import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';
import '../../utility/services/generate_form_service.dart';

class PaymentProvider with ChangeNotifier {
  static const String featureName = "payment";
  static const String reportFeature = "paymentReport";
  static const String outwardReportFeature = "outwardReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  TextEditingController editController = TextEditingController();
  List<SearchableDropdownMenuItem<String>> partyCodes = [];
  List<dynamic> billPending = [];
  List<dynamic> billPendingExport = [];
  List<dynamic> outwardPaymentReport = [];

  List<DataRow> rows = [];
  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void reset() {
    editController.clear();
    editController.text = "";
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    notifyListeners();
  }

  void getPartyCodes() async {
    partyCodes = await formService.getDropdownMenuItem("/get-ledger-codes/");
    notifyListeners();
  }

  void initWidget(String partyCode) async {
    var data = jsonDecode(partyCode);
    String jsonData =
        '[{"id":"mop","name":"Mode of Payment","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-mop/", "default" : "B"},{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/", "default" : "${data['lcode']}", "readOnly" : true},{"id":"crdrCode","name":"CR/DR Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/", "default" : "${data['crdrCode']}"},{"id":"naration","name":"Naration","isMandatory":false,"inputType":"text","maxCharacter":100, "default" : "${data['paynaration']}"},{"id":"transId","name":"Transaction ID","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-bill-pending-by-lcode/${data['lcode']}/","default":"${data['transId']}","readOnly":true},{"id":"vtype","name":"Voucher Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-voucher-type/","maxCharacter":100,"default":"${data['vtype']}","readOnly":true},{"id":"amount","name":"Amount","isMandatory":true,"inputType":"number","default":"${data['bamount']}"}]';

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

  void initEditWidget() async {
    String jsonData =
        '[{"id":"tdate","name":"Transaction Date","isMandatory":true,"inputType":"datetime"},{"id":"payType","name":"Pay Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-pay-type/"},{"id":"mop","name":"Mode of Payment","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-mop/"},{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"crdrCode","name":"CR/DR Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"amount","name":"Amount","isMandatory":true,"inputType":"number"},{"id":"naration","name":"Naration","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"adjusted","name":"Adjusted","isMandatory":true,"inputType":"number"},{"id":"unadjusted","name":"UnAdjusted","isMandatory":true,"inputType":"number"}]';

    Map<String, dynamic> editMapData = await getByIdPaymentInfo();
    GlobalVariables.requestBody[featureName] = editMapData;
    formFieldDetails.clear();
    widgetList.clear();

    for (var element in jsonDecode(jsonData)) {
      TextEditingController editController = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: false,
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255,
          controller: editController,
          defaultValue: editMapData[element['id']]));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService
        .post("/add-payment/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-payment/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<Map<String, dynamic>> getByIdPaymentInfo() async {
    http.StreamedResponse response =
        await networkService.get("/get-payment/${editController.text}/");
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
        '[{"id":"lcode","name":"Party Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"pdays","name":"Days","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-days/"}]';

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
    billPending.clear();
    billPendingExport.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-payment-bill-pending/",
        GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      billPending = jsonDecode(await response.stream.bytesToString());
      billPendingExport = billPending;
      billPending = flattenGroupedWithTotals(billPending);
    }
    notifyListeners();
  }

  List<Map<String, dynamic>> flattenGroupedWithTotals(List<dynamic> data) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    // Group by lcode
    for (var item in data) {
      final lcode = item['lcode'];
      grouped.putIfAbsent(lcode, () => []).add(item);
    }

    final List<Map<String, dynamic>> finalList = [];

    List<double> sums = [0,0,0];

    grouped.forEach((lcode, entries) {
      double amountSum = 0;
      double payAmountSum = 0;
      double bAmountSum = 0;

      entries.insert(0, {"transId" : lcode, "dDate" : entries[0]['lName']});
      for (var item in entries) {
        double amount = parseEmptyStringToDouble(item['amount'].toString());
        double payamount = parseEmptyStringToDouble(item['payamount'].toString());
        double bamount = parseEmptyStringToDouble(item['bamount'].toString());

        amountSum += amount;
        payAmountSum += payamount;
        bAmountSum += bamount;

        if(bAmountSum != 0) {
          item['run'] = bAmountSum.toStringAsFixed(2);
        }
        finalList.add(item);
      }

      finalList.add({
        'billNo': 'Total',
        'amount': amountSum.toStringAsFixed(2),
        'payamount': payAmountSum.toStringAsFixed(2),
        'bamount': bAmountSum.toStringAsFixed(2),
      });
      sums[0] += amountSum;
      sums[1] += payAmountSum;
      sums[2] += bAmountSum;
      finalList.add({});
    });

    finalList.add({
      'billNo': 'Grand Total',
      'amount': sums[0].toStringAsFixed(2),
      'payamount': sums[1].toStringAsFixed(2),
      'bamount': sums[2].toStringAsFixed(2),
    });

    return finalList;
  }

  void initOutwardReport() async {
    GlobalVariables.requestBody[outwardReportFeature] = {};
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
    await formService.generateDynamicForm(formFieldDetails, outwardReportFeature);
    reportWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getOutwardPaymentReport() async {
    outwardPaymentReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/payment-outward-report/",
        GlobalVariables.requestBody[outwardReportFeature]);
    if (response.statusCode == 200) {
      outwardPaymentReport = jsonDecode(await response.stream.bytesToString());
    }
    getRows();
  }

  void getRows() {
    List<double> totals = [0, 0, 0];
    rows.clear();

    for (var data in outwardPaymentReport) {
      totals[0] = totals[0] + parseEmptyStringToDouble('${data['amount']}');
      totals[1] = totals[1] + parseEmptyStringToDouble('${data['adjusted']}');
      totals[2] = totals[2] + parseEmptyStringToDouble('${data['unadjusted']}');

      rows.add(DataRow(cells: [
        DataCell(Text('${data['payId'] ?? "-"}')),
        DataCell(Text('${data['tdate'] ?? "-"}')),
        DataCell(Text('${data['payType'] ?? "-"}')),
        DataCell(Text('${data['transId'] ?? "-"}')),
        DataCell(Text('${data['vtype'] ?? "-"}')),
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
      const DataCell(SizedBox()),
      const DataCell(Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${totals[0]}'), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${totals[1]}'), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${totals[2]}'), style: const TextStyle(fontWeight: FontWeight.bold)))),
      const DataCell(SizedBox()),
    ]));

    notifyListeners();
  }

  Future<dynamic> getInwardClear(String transId, String vType) async {
    http.StreamedResponse response = await networkService
        .post("/get-inward-clear/", {"transId": transId, "vType": vType});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    }
  }
}
