import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';
import '../../utility/models/forms_UI.dart';
import '../../utility/services/common_utility.dart';
import '../../utility/services/generate_form_service.dart';

import 'package:http/http.dart' as http;

class LedgerProvider with ChangeNotifier {
  static const String reportFeature = "ledger";
  static const String trialReportFeature = "trial";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  Map<String, dynamic> ledgerRep = {};
  List<DataRow> rows = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initReportWidget() async {
    String jsonData =
        '[{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"fromDate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"toDate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    widgetList.clear();

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          controller: controller,
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255,
          defaultValue: element['default']));
    }
    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, reportFeature);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void initTrialWidget() async {
    String jsonData =
        '[{"id":"agCode","name":"Group Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ac-groups/"},{"id":"fromDate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"toDate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

    GlobalVariables.requestBody[trialReportFeature] = {};
    formFieldDetails.clear();
    widgetList.clear();

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          controller: controller,
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? ""));
    }
    List<Widget> widgets = await formService.generateDynamicForm(
        formFieldDetails, trialReportFeature);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void getLedgerReport() async {
    ledgerRep.clear();
    http.StreamedResponse response = await networkService.post(
        "/ledger-rep/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      ledgerRep = jsonDecode(await response.stream.bytesToString());
    }
    getRows();
  }

  void getRows() {
    rows.clear();
    for (var data in ledgerRep['Ledger']) {
      rows.add(DataRow(cells: [
        DataCell(Text('${data['tranDate'] ?? ""}')),
        DataCell(Text('${data['narration'] ?? ""}')),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['drAmount'] ?? ""}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['crAmount'] ?? ""}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['RunningBalance'] ?? ""}')))),
        DataCell(Text('${data['BalanceType'] ?? ""}')),
      ]));
    }

    rows.add(DataRow(cells: [
      const DataCell(SizedBox()),
      const DataCell(Text("TOTAL", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${ledgerRep['Totals']['TotalDebit'] ?? ""}'), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${ledgerRep['Totals']['TotalCredit'] ?? ""}'), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${ledgerRep['Totals']['TotalBalance'] ?? ""}'), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Text("${ledgerRep['Totals']['BalanceType']}", style: const TextStyle(fontWeight: FontWeight.bold))),
    ]));
    notifyListeners();
  }
}
