import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';


class AdditionalOrderProvider with ChangeNotifier {
  String featureName = "additionalOrder";
  String reportFeature = "additionalOrderReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  DataTable table =
  DataTable(columns: const [DataColumn(label: Text(""))], rows: const []);

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id": "poId","name": "Order Id","isMandatory": true,"inputType": "number"},{"id": "matno","name": "Material Number","isMandatory": true,"inputType": "text","maxCharacter" : 15},{"id": "poQty","name": "Quantity","isMandatory": true,"inputType": "number"},{"id": "remark","name": "Remark","isMandatory": true,"inputType": "text","maxCharacter" : 100}]';

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
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/additional-purchase-order/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"poId","name":"Purchase Order Id","isMandatory":false,"inputType":"text"},{"id":"fromDate","name":"From Date","isMandatory":false,"inputType":"datetime"},{"id":"toDate","name":"To Date","isMandatory":false,"inputType":"datetime"}]';

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
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<dynamic> getAdditionalPurchaseOrderReport() async {
    http.StreamedResponse response = await networkService.post(
        "/additional-purchase-order-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void nestedTable() async {
    var purchaseOrderReport = await getAdditionalPurchaseOrderReport();
    List<DataRow> rows = [];
    int counter = 0;

    DataRow emptyRowNamed = const DataRow(cells: [
      DataCell(Text("")),
      DataCell(Text("")),
      DataCell(Text("")),
      DataCell(Text("")),
      DataCell(Text("")),
      DataCell(Text("")),
      DataCell(Text("")),
    ]);

    DataRow headerRow = const DataRow(cells: [
      DataCell(
          Text("Material No.", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(
          Text("Description", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child:
          Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Text("Rate", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text("Amount", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text("HSN Code", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
    ]);

    DataRow columnHeader = const DataRow(cells: [
      DataCell(Text("Order Id", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(
          Text("Order Date", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text("Business Partner",
          style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text("City", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text("State", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(
          Text("Carrier Name", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
    ]);

    for (var data in purchaseOrderReport) {
      rows.add(DataRow(cells: [
        DataCell(InkWell(
          onTap: () {},
          child: Text(
            '${data['poId'] ?? "-"}',
          ),
        )),
        DataCell(Text('${data['poDate'] ?? "-"}')),
        DataCell(Text('${data['bpName'] ?? "-"}')),
        DataCell(Text('${data['bpCity'] ?? "-"}')),
        DataCell(Text('${data['stateName'] ?? "-"}')),
        DataCell(Text('${data['carrierName'] ?? "-"}')),
        const DataCell(Text("")),
      ]));
      rows.add(headerRow);
      for (var poData in data['pod']) {
        rows.add(DataRow(cells: [
          DataCell(Text('${poData['matno'] ?? "-"}')),
          DataCell(Text('${poData['matDescription'] ?? "-"}')),
          DataCell(Align(
              alignment: Alignment.centerRight,
              child: Text('${poData['poQty'] ?? "-"}'))),
          DataCell(Align(
              alignment: Alignment.centerRight,
              child: Text('${poData['poRate'] ?? "-"}'))),
          DataCell(Align(
              child: Text(
                '${poData['poAmount'] ?? "-"}',
                textAlign: TextAlign.right,
              ))),
          DataCell(Text('${poData['hsnCode'] ?? "-"}')),
          const DataCell(Text('')),
        ]));
      }
      rows.add(DataRow(cells: [
        const DataCell(Text('')),
        const DataCell(
            Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text('${data['poQty'] ?? "-"}',
                style: const TextStyle(fontWeight: FontWeight.bold)))),
        const DataCell(Text('')),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text('${data['poAmount'] ?? "-"}',
                style: const TextStyle(fontWeight: FontWeight.bold)))),
        const DataCell(Text('')),
        const DataCell(Text('')),
      ]));
      counter = counter + 1;
      if (counter != purchaseOrderReport.length) {
        rows.add(emptyRowNamed);
        rows.add(columnHeader);
      }
    }

    table = DataTable(columns: const [
      DataColumn(
          label:
          Text("Order Id", style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("Order Date",
              style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("Business Partner",
              style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("City", style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("State", style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("Carrier Name",
              style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("", style: TextStyle(fontWeight: FontWeight.bold))),
    ], rows: rows);

    notifyListeners();
  }
}