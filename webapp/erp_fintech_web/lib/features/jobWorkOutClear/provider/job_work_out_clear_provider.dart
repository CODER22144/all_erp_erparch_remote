import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class JobWorkOutClearProvider with ChangeNotifier {
  static const String featureName = "JobWorkOutClear";
  static const String reportFeature = "JobWorkOutClearReport";
  static const String pendingFeature = "JobWorkOutClearPendingReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];

  List<dynamic> jwocRep = [];
  List<dynamic> jwocPendingRep = [];

  List<DataRow> jwocRows = [];

  TextEditingController editingController = TextEditingController();

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"dt","name":"Date","isMandatory":true,"inputType":"datetime"},{"id":"docno","name":"Document No.","isMandatory":true,"inputType":"number"},{"id":"grno","name":"GR No.","isMandatory":false,"inputType":"number"},{"id":"billNo","name":"Bill No.","isMandatory":false,"inputType":"text", "maxCharacter" : 16},{"id":"billDate","name":"Bill Date","isMandatory":false,"inputType":"datetime"},{"id":"matno","name":"Material No.","isMandatory":true,"inputType":"text", "maxCharacter" : 15},{"id":"qty","name":"Quantity","isMandatory":true,"inputType":"text"},{"id":"rate","name":"Rate","isMandatory":true,"inputType":"number"}]';

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

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService
        .post("/add-jw-clear/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"docno","name":"Document No.","isMandatory":false,"inputType":"number"},{"id":"matno","name":"Material No.","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"fromDate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"toDate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

    for (var element in jsonDecode(jsonData)) {
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          controller: TextEditingController(),
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, reportFeature);
    reportWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getJobWorkOutClearReport() async {
    jwocRep.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-jw-clear-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      jwocRep = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void initPendingReport() async {
    GlobalVariables.requestBody[pendingFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"docno","name":"Document No.","isMandatory":false,"inputType":"number"},{"id":"bpCode","name":"Party Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id" : "type", "name" : "Type (P)", "isMandatory" : true, "inputType" : "text", "default" : "P"},{"id":"fDate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tDate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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
        await formService.generateDynamicForm(formFieldDetails, pendingFeature);
    reportWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getJobWorkOutClearPendingReport() async {
    jwocPendingRep.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-jw-clear-pending/", GlobalVariables.requestBody[pendingFeature]);
    if (response.statusCode == 200) {
      jwocPendingRep = jsonDecode(await response.stream.bytesToString());
    }
    getTableRows();
  }

  void getTableRows() {
    jwocRows.clear();
    DataRow emptyRow = const DataRow(cells: [
      DataCell(SizedBox()),
      DataCell(SizedBox()),
      DataCell(SizedBox()),
      DataCell(SizedBox()),
      DataCell(SizedBox()),
      DataCell(SizedBox()),
      DataCell(SizedBox()),
      DataCell(SizedBox()),
    ]);

    for (var data in jwocPendingRep) {
      jwocRows.add(DataRow(cells: [
        DataCell(Text("${data['docno']}")),
        DataCell(Text("${data['dtDate']}")),
        DataCell(Text("${data['bpCode']} - ${data['bpName']}")),
        DataCell(Text("${data['City']} - ${data['StateName']}")),
        DataCell(Text("${data['matnoReturn']}")),
        DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal("${data['qty']}")))),
        DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal("${data['clQty']}")))),
        DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal("${data['bqty']}")))),
      ]));

      if(data['Clears'] != null) {
        double sum = 0;
        jwocRows.add(const DataRow(cells: [
          DataCell(Text("ID", style: TextStyle(fontWeight: FontWeight.bold))),
          DataCell(Text("Bill no.", style: TextStyle(fontWeight: FontWeight.bold))),
          DataCell(Text("Bill Date", style: TextStyle(fontWeight: FontWeight.bold))),
          DataCell(Align(alignment: Alignment.centerRight,child: Text("Qty", style: TextStyle(fontWeight: FontWeight.bold)))),
          DataCell(SizedBox()),
          DataCell(SizedBox()),
          DataCell(SizedBox()),
          DataCell(SizedBox()),
        ]));
        for (var clData in data['Clears']) {
          sum += parseEmptyStringToDouble("${clData['qty']}");
          jwocRows.add(DataRow(cells: [
            DataCell(Text("${clData['clId']}")),
            DataCell(Text("${clData['billNo']}")),
            DataCell(Text("${clData['billDate']}")),
            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal("${clData['qty']}")))),
            const DataCell(SizedBox()),
            const DataCell(SizedBox()),
            const DataCell(SizedBox()),
            const DataCell(SizedBox()),
          ]));
        }
        jwocRows.add(DataRow(cells: [
          const DataCell(SizedBox()),
          const DataCell(SizedBox()),
          const DataCell(Text("Total", style: TextStyle(fontWeight: FontWeight.bold))),
          DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal(sum.toString()), style: const TextStyle(fontWeight: FontWeight.bold)))),
          const DataCell(SizedBox()),
          const DataCell(SizedBox()),
          const DataCell(SizedBox()),
          const DataCell(SizedBox()),
        ]));
      }

      jwocRows.add(emptyRow);
    }

    notifyListeners();
  }
}
