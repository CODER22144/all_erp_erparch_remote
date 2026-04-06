import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';
import '../../utility/models/forms_UI.dart';
import '../../utility/services/common_utility.dart';
import '../../utility/services/generate_form_service.dart';

import 'package:http/http.dart' as http;

class ReportProvider with ChangeNotifier {
  static const String reportFeature = "trialBalanceReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  Map<String, dynamic> tbRep = {};
  List<DataRow> rows = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initReportWidget() async {
    String jsonData =
        '[{"id":"agCode","name":"Group Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ac-groups/"},{"id":"fDate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"toDate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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

  void getTrialBalanceReport() async {
    tbRep.clear();
    http.StreamedResponse response = await networkService.post(
        "/trial-balance-rep/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      tbRep = jsonDecode(await response.stream.bytesToString());
    }
    getRows();
  }

  void getRows() {
    rows.clear();
    for (var data in tbRep['trial']) {
      rows.add(DataRow(cells: [
        DataCell(Text('${data['agCode'] ?? ""}', style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text('${data['agDescription'] ?? ""}', style: const TextStyle(fontWeight: FontWeight.bold))),
        const DataCell(SizedBox()),
        const DataCell(SizedBox()),
      ]));
      for (var data2 in data['trialdet']) {
        rows.add(DataRow(cells: [
          DataCell(Text('${data2['lcode'] ?? ""}')),
          DataCell(Text('${data2['lname'] ?? ""}')),
          DataCell(Align(
              alignment: Alignment.centerRight,
              child:
                  Text(parseDoubleUpto2Decimal('${data2['drAmount'] ?? ""}')))),
          DataCell(Align(
              alignment: Alignment.centerRight,
              child:
                  Text(parseDoubleUpto2Decimal('${data2['crAmount'] ?? ""}')))),
        ]));
      }

      rows.add(DataRow(cells: [
        const DataCell(SizedBox()),
        const DataCell(
            Text("TOTAL", style: TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['dbAmount'] ?? ""}'),
                style: const TextStyle(fontWeight: FontWeight.bold)))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['crAmount'] ?? ""}'),
                style: const TextStyle(fontWeight: FontWeight.bold)))),
      ]));
    }

    rows.add(DataRow(cells: [
      const DataCell(SizedBox()),
      const DataCell(
          Text("GRAND TOTAL", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${tbRep['totdbAmount'] ?? ""}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${tbRep['totcrAmount'] ?? ""}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
    ]));
    notifyListeners();
  }
}
