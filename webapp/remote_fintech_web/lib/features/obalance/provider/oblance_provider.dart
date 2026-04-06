import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class OBalanceProvider with ChangeNotifier {
  static const String featureName = "obalance";
  static const String reportFeature = "obalanceReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  TextEditingController editController = TextEditingController();

  List<dynamic> obalanceReport = [];
  List<DataRow> rows = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  String jsonData =
      '[{"id": "obId","name": "Opening Balance","isMandatory": true,"inputType": "dropdown","dropdownMenuItem": "/get-obId/"},{"id": "lcode","name": "Party Code","isMandatory": true,"inputType": "dropdown","dropdownMenuItem": "/get-ledger-codes/"},{"id": "billNo","name": "Bill No.","isMandatory": false,"inputType": "text","maxCharacter": 30},{"id": "billDate","name": "Bill Date","isMandatory": false,"inputType": "datetime"},{"id": "naration","name": "Naration","isMandatory": false,"inputType": "text","maxCharacter": 100},{"id": "balId","name": "Balance Type","isMandatory": true,"inputType": "dropdown","dropdownMenuItem": "/get-obalance-type/"},{"id": "amount","name": "Amount","isMandatory": true,"inputType": "number", "default" : 0}]';

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

  void initEditWidget() async {
    Map<String, dynamic> editMapData = await getByIdBusinessPartner();
    GlobalVariables.requestBody[featureName] = editMapData;
    formFieldDetails.clear();
    widgetList.clear();

    for (var element in jsonDecode(jsonData)) {
      TextEditingController editController = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
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
        .post("/add-obalance/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService
        .put("/update-obalance/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<Map<String, dynamic>> getByIdBusinessPartner() async {
    http.StreamedResponse response =
        await networkService.get("/get-obalance/${editController.text}/");
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"obId","name":"OBalance ID","isMandatory":false,"inputType":"dropdown", "dropdownMenuItem" : "/get-obId/"},{"id":"lcode","name":"Party Code","isMandatory":false,"inputType":"dropdown", "dropdownMenuItem" : "/get-ledger-codes/"}]';

    for (var element in jsonDecode(jsonData)) {
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets = await formService.generateDynamicForm(
        formFieldDetails, reportFeature);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void getOBalanceReport() async {
    obalanceReport.clear();
    http.StreamedResponse response = await networkService.post("/obalance-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      obalanceReport = jsonDecode(await response.stream.bytesToString());
    }
    getRows();
  }

  void getRows() {
    rows.clear();
    List<double> sums = [0,0];
    for(var data in obalanceReport) {
      sums[0] += parseEmptyStringToDouble(data['dbamount']);
      sums[1] += parseEmptyStringToDouble(data['cramount']);
      rows.add(DataRow(cells: [
        DataCell(Text('${data['transId'] ?? ""}')),
        DataCell(Text('${data['obId'] ?? ""}')),
        DataCell(Text('${data['lcode'] ?? ""}')),
        DataCell(Text('${data['lName'] ?? ""}')),
        DataCell(Text('${data['billNo'] ?? ""}')),
        DataCell(Text('${data['billDate'] ?? ""}')),
        DataCell(Text('${data['naration'] ?? ""}')),
        DataCell(Text('${data['balId'] ?? ""}')),
        DataCell(Align(alignment: Alignment.centerRight,child: Text('${data['dbamount'] ?? ""}'))),
        DataCell(Align(alignment: Alignment.centerRight,child: Text('${data['cramount'] ?? ""}'))),
        const DataCell(SizedBox()),
      ]));
    }

    rows.add(DataRow(cells: [
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(Text("Total", style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      DataCell(Align(alignment: Alignment.centerRight,child: Text(sums[0].toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(alignment: Alignment.centerRight,child: Text(sums[1].toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)))),
      const DataCell(SizedBox()),
    ]));
    notifyListeners();
  }
}
