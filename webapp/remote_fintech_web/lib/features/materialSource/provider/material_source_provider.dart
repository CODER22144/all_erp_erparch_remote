import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class MaterialSourceProvider with ChangeNotifier {
  static const String featureName = "materialSource";
  static const String reportFeature = "materialSourceReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  TextEditingController editController = TextEditingController();
  TextEditingController bpController = TextEditingController();

  List<SearchableDropdownMenuItem<String>> businessPartner = [];

  DataTable table =
      DataTable(columns: const [DataColumn(label: Text(""))], rows: const []);

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  String jsonData =
      '[{"id": "matno","name": "Material Code","isMandatory": true,"inputType": "text"},  {"id": "bpCode","name": "Business Partner Code","isMandatory": true,"inputType": "dropdown","dropdownMenuItem": "/get-business-partner/"},{"id": "matDescription","name": "Material Description","isMandatory": true,"inputType": "text","maxCharacter": 100},{"id" : "hsnCode", "name" : "HSN Code", "isMandatory" : true, "inputType":"text", "maxCharacter": 10},{"id": "bpPartNo","name": "Business Partner Part No.","isMandatory": false,"inputType": "text","maxCharacter": 30},{"id": "puUnit","name": "Material Unit","isMandatory": true,"inputType": "dropdown","dropdownMenuItem": "/get-material-unit/"  },{"id": "bpRate","name": "Rate","isMandatory": true,"inputType": "number","maxCharacter": 16},{"id": "rateType","name": "Rate Type","isMandatory": true,"inputType": "dropdown","dropdownMenuItem": "/get-rate-type/"},{"id": "rateEf","name": "Rate EF","isMandatory": true,"inputType": "datetime","maxCharacter": 12},{"id": "moq","name": "MOQ","isMandatory": true,"inputType": "number"},{"id": "leadTime","name": "Lead Time","isMandatory": true,"inputType": "number"},{"id": "bpRating","name": "Business Partner Rating","isMandatory": true,"inputType": "number"}]';

  void reset() {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    notifyListeners();
  }

  void setBpController(String value) {
    bpController.text = value;
    notifyListeners();
  }

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

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

  Future<http.StreamedResponse> processFormInfo(bool manualOrder) async {
    var payload = manualOrder
        ? [GlobalVariables.requestBody[featureName]]
        : GlobalVariables.requestBody[featureName];
    http.StreamedResponse response =
        await networkService.post("/add-material-source/", payload);
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"fmatno","name":"From Material No.","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"tmatno","name":"To Material No.","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"bpCode","name":"Business Partner Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-business-partner/"},{"id":"rateType","name":"Rate Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-rate-type/"}]';

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

  Future<dynamic> getMaterialSourceReport() async {
    http.StreamedResponse response = await networkService.post(
        "/get-material-source-report/",
        GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void nestedTable() async {
    table =
        DataTable(columns: const [DataColumn(label: Text(""))], rows: const []);
    var purchaseOrderReport = await getMaterialSourceReport();
    List<DataRow> rows = [];

    for (var data in purchaseOrderReport) {
      rows.add(DataRow(cells: [
        DataCell(Text('${data['matno'] ?? "-"}')),
        DataCell(Text('${data['matDescription'] ?? "-"}')),
        DataCell(Text('${data['bpPartNo'] ?? "-"}')),
        DataCell(Text('${data['bpCode'] ?? "-"}')),
        DataCell(Text('${data['hsnCode'] ?? "-"}')),
        DataCell(Text('${data['bpRate'] ?? "-"}')),
        DataCell(Text('${data['puUnit'] ?? "-"}')),
        DataCell(Text('${data['rateType'] ?? "-"}')),
        DataCell(Text('${data['moq'] ?? "-"}')),
        DataCell(Text('${data['rateEf'] ?? "-"}')),
        DataCell(Text('${data['leadTime'] ?? "-"}')),
        DataCell(Text('${data['bpRating'] ?? "-"}')),
      ]));
    }

    table = DataTable(columns: const [
      DataColumn(
          label: Text("Material No.",
              style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("Description",
              style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label:
              Text("Part No.", style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("Business Partner",
              style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label:
              Text("HSN Code", style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("Rate", style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("Unit", style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label:
              Text("Rate Type", style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("MOQ", style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("Rate EF", style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label:
              Text("Lead Time", style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("Partner Rating",
              style: TextStyle(fontWeight: FontWeight.bold))),
    ], rows: rows);

    notifyListeners();
  }

  Future<Map<String, dynamic>> getByIdMaterialSource() async {
    http.StreamedResponse response = await networkService.post(
        "/get-material-source-details/",
        {"bpCode": bpController.text, "matno": editController.text});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEditWidget() async {
    Map<String, dynamic> editMapData = await getByIdMaterialSource();
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

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-material-source/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void getBusinessPartner() async {
    businessPartner =
        await formService.getDropdownMenuItem("/get-business-partner/");
    notifyListeners();
  }
}
