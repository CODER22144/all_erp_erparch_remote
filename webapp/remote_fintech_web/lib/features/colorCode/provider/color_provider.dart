import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class ColorProvider with ChangeNotifier {
  static const String featureName = "colour";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  TextEditingController editController = TextEditingController();
  List<dynamic> colorReport = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  String jsonData =
      '[{"id":"colNo","name":"Colour no.","isMandatory":true,"inputType":"text","maxCharacter":8},{"id":"colName","name":"Colour Name","isMandatory":true,"inputType":"text","maxCharacter":50}]';

  void reset() {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
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

  Future<Map<String, dynamic>> getByIdHsnCode(String colNo) async {
    http.StreamedResponse response =
        await networkService.post("/get-color/", {"colNo": colNo});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEditWidget() async {
    Map<String, dynamic> editMapData =
        await getByIdHsnCode(editController.text);
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
        .post("/add-color/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-color/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void getColorReport() async {
    colorReport.clear();
    http.StreamedResponse response = await networkService.get("/color-report/");
    if (response.statusCode == 200) {
      colorReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  // List<Widget> testWidgetList = [];


  // void getTest() {
  //   for (var data in jsonDecode(jsonStringData)) {
  //     testWidgetList.add(DataTable(
  //       columns: data.keys
  //           .map(
  //             (key) => DataColumn(
  //               label: Text(
  //                 key,
  //                 style: const TextStyle(fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //           )
  //           .toList(),
  //       rows: data.map((row) {
  //         return DataRow(
  //           cells: data.keys.map((key) {
  //             final value = row[key];
  //             return DataCell(
  //               Text(value != null ? value.toString() : '-'),
  //             );
  //           }).toList(),
  //         );
  //       }).toList(),
  //     ));
  //   }
  //   notifyListeners();
  // }

  // void buildDynamicDataTable() {
  //   String jsonString =
  //       '[{"GSTIN" : "1809986576", "name" : "Name1", "newKey" : "newValue"},{"id" : "2", "name" : "Name2", "age": 24, "company" : "Swiss"}, {"id" : "3", "name" : "Name3", "rollNo" : 189, "course" : "B. Tech", "key5" : "value5"}]';
  //
  //   // Safely convert to List<Map<String, dynamic>>
  //   final List<dynamic> jsonData =
  //   jsonDecode(jsonString).map((e) => Map<String, dynamic>.from(e)).toList();
  //
  //   // Collect all unique keys
  //   for (var row in jsonData) {
  //   final Set<String> columnKeys = {};
  //
  //     columnKeys.addAll(row.keys);
  //     final List<String> columns = columnKeys.toList();
  //
  //     testWidgetList.add(DataTable(
  //       columnSpacing: 20,
  //       columns: columns
  //           .map(
  //             (key) => DataColumn(
  //           label: Text(
  //             key,
  //             style: const TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //       )
  //           .toList(),
  //       rows: [DataRow(
  //         cells: columns.map((key) {
  //           final value = row[key];
  //           return DataCell(
  //             Text(value?.toString() ?? '-'),
  //           );
  //         }).toList(),
  //       )],
  //     ));
  //   }
  //   notifyListeners();
  // }

}
