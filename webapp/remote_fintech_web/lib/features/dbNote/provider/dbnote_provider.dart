import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class DbNoteProvider with ChangeNotifier {
  static const String featureName = "DbNote";
  static const String masterDetailFeatureName = "DbnoteItemDetails";
  static const String reportFeature = "dbNoteReport";
  static const String clearFeature = "dbNoteClear";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  List<dynamic> report = [];
  List<dynamic> dbNotePostPending = [];
  List<DataRow> rows = [];

  List<List<TextEditingController>> rowControllers = [];

  List<SearchableDropdownMenuItem<String>> materialUnit = [];
  List<SearchableDropdownMenuItem<String>> hsnCodes = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"Dt","name":"Document Date","isMandatory":true,"inputType":"datetime"},{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"drId","name":"Documnet Reason","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-doc-reason/"},{"id":"daId","name":"Document Against","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-doc-against/"},{"id":"crCode","name":"Credit Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"}]';

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

    materialUnit.clear();
    hsnCodes.clear();
    materialUnit = await formService.getDropdownMenuItem("/get-material-unit/");
    hsnCodes = await formService.getDropdownMenuItem("/get-hsn/");
    List<List<String>> tableRows = [
      ['', '', '', '', '', '', '1', '0', '', '0', '0','0','0','0','0']
    ];
    rowControllers = tableRows
        .map((row) =>
        row.map((field) => TextEditingController(text: field)).toList())
        .toList();
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo(
      List<List<String>> tableRows, bool manual) async {
    List<Map<String, dynamic>> inwardDetails = [];
    var payload;
    if (manual) {
      for (int i = 0; i < tableRows.length; i++) {
        inwardDetails.add({
          "vtype": tableRows[i][0] == "" ? null : tableRows[i][0],
          "matno": tableRows[i][1] == "" ? null : tableRows[i][1],
          "OrgInvNo": tableRows[i][2] == "" ? null : tableRows[i][2],
          "OrgInvDate": tableRows[i][3] == "" ? null : tableRows[i][3],
          "PrdDesc": tableRows[i][4],
          "HsnCd": tableRows[i][5] == "" ? null : tableRows[i][5],
          "Qty": tableRows[i][6],
          "UnitPrice": tableRows[i][7],
          "Unit": tableRows[i][8],
          "AssAmt": tableRows[i][9],
          "Discount": tableRows[i][10],
          "GstRt": tableRows[i][11],
          "GstAmt": tableRows[i][12],
          "TotAmt": tableRows[i][14]
        });
      }

      GlobalVariables.requestBody[featureName]['DbnoteItemDetails'] = inwardDetails;
      payload = [GlobalVariables.requestBody[featureName]];
    } else {
      payload = GlobalVariables.requestBody[featureName];
    }
    http.StreamedResponse response = await networkService.post(
        "/add-dbnote/", payload);
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id" : "docId", "name" : "Document ID", "isMandatory" : false, "inputType" : "number"},{"id" : "No", "name" : "Document No.", "isMandatory" : false, "inputType" : "text", "maxCharacter" : 16},{"id" : "RegRev", "name" : "Reg Rev.", "isMandatory" : false, "inputType" : "text", "maxCharacter" : 1},{"id":"lcode","name":"Party Code","isMandatory":false,"inputType":"dropdown", "dropdownMenuItem" : "/get-ledger-codes/"},{"id":"FDt","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"TDt","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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

  void getDbNoteReport() async {
    report.clear();
    http.StreamedResponse response = await networkService.post(
        "/db-note-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      report = jsonDecode(await response.stream.bytesToString());
    }
    getRows();
  }

  void getRows() {
    List<double> totals = [0, 0, 0, 0, 0, 0, 0, 0, 0];
    rows.clear();

    for (var data in report) {
      totals[0] = totals[0] + parseEmptyStringToDouble('${data['SumQty']}');
      totals[1] = totals[1] + parseEmptyStringToDouble('${data['SumTotAmt']}');
      totals[2] = totals[2] + parseEmptyStringToDouble('${data['SumDiscount']}');
      totals[3] = totals[3] + parseEmptyStringToDouble('${data['SumAssAmt']}');
      totals[5] = totals[5] + parseEmptyStringToDouble('${data['IgstAmt']}');
      totals[6] = totals[6] + parseEmptyStringToDouble('${data['CgstAmt']}');
      totals[7] = totals[7] + parseEmptyStringToDouble('${data['SgstAmt']}');
      totals[4] = totals[4] + parseEmptyStringToDouble('${data['SumGstAmt']}');
      totals[8] = totals[8] + parseEmptyStringToDouble('${data['SumTotVal']}');

      rows.add(DataRow(cells: [
        DataCell(Text('${data['No'] ?? "-"}')),
        DataCell(Text('${data['DDt'] ?? "-"}')),
        DataCell(Text('${data['lcode'] ?? "-"}\n${data['LglNm']}')),
        DataCell(Text('${data['Addr1'] ?? "-"} ${data['Addr2'] ?? ""}\n${data['Loc'] ?? "-"} - ${data['Stcd'] ?? "-"}')),
        DataCell(Text('${data['Pin'] ?? "-"}')),
        DataCell(Text('${data['Gstin'] ?? "-"}')),
        DataCell(Text('${data['drId'] ?? "-"} | ${data['daId'] ?? "-"}')),
        DataCell(Text('${data['crCode'] ?? ""}\n${data['crlname']?? ""}')),
        DataCell(Text('${data['SupTyp'] ?? "-"}')),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['SumQty']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['SumTotAmt']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['SumDiscount']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['SumAssAmt']}')))),

        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['IgstAmt']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['CgstAmt']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['SgstAmt']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['SumGstAmt']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['SumTotVal']}')))),
      ]));
    }

    rows.add(DataRow(cells: [
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${totals[0]}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${totals[1]}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${totals[2]}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${totals[3]}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),

      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${totals[5]}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${totals[6]}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${totals[7]}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${totals[4]}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${totals[8]}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
    ]));

    notifyListeners();
  }

  void deleteRowController(int index) {
    rowControllers.removeAt(index);
    notifyListeners();
  }

  void addRowController() {
    rowControllers.add([
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(text: "1"),
      TextEditingController(text: "0"),
      TextEditingController(),
      TextEditingController(text: "0"),
      TextEditingController(text: "0"),
      TextEditingController(text: "0"),
      TextEditingController(text: "0"),
      TextEditingController(text: "0"),
      TextEditingController(text: "0"),
    ]);
    notifyListeners();
  }

  void getDbNotePostPending() async {
    dbNotePostPending.clear();
    http.StreamedResponse response = await networkService.get("/get-dbnote-pending/");
    if(response.statusCode == 200) {
      dbNotePostPending = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  Future<http.StreamedResponse> processClearFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/add-dbnote-clear/",{});
    return response;
  }

}
