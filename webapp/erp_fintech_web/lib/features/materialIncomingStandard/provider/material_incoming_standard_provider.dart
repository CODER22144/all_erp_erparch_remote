import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class MaterialIncomingStandardProvider with ChangeNotifier {
  static const String featureName = "MaterialIncomingStandard";
  static const String readingsFeature = "IncomingReadings";
  static const String reportFeature = "MaterialIncomingStandardReport";
  static const String readingReportFeature = "MaterilIncReadingReport";
  static const String qcPendingFeature = "qcPending";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];

  List<dynamic> materialIncStand = [];
  List<dynamic> qcPending = [];
  List<dynamic> incReport = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  List<DataRow> dataRows = [];
  List<DataRow> readingRows = [];

  String jsonData =
      '[{"id":"matno","name":"Material no.","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"misSno","name":"Serial No.","isMandatory":true,"inputType":"number"},{"id":"testType","name":"Test Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-test-type/"},{"id":"isnpItem","name":"Inspect Item","isMandatory":true,"inputType":"text","maxCharacter":30},{"id":"instName","name":"Instrument Name","isMandatory":false,"inputType":"text","maxCharacter":20},{"id":"sLimit","name":"Standard Limit","isMandatory":true,"inputType":"text","maxCharacter":20},{"id":"lLimit","name":"Lower Limit","isMandatory":true,"inputType":"text","maxCharacter":40},{"id":"hLimit","name":"Higher Limit","isMandatory":true,"inputType":"text","maxCharacter":40}]';

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

  Future<http.StreamedResponse> processFormInfo(bool manual) async {
    var payload = manual
        ? [GlobalVariables.requestBody[featureName]]
        : GlobalVariables.requestBody[featureName];
    http.StreamedResponse response =
        await networkService.post("/add-mat-inc-std/", payload);
    return response;
  }

  void initReportWidget() async {
    String jsonData =
        '[{"id":"fmatno","name":"From Material No.","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"tmatno","name":"To Material No.","isMandatory":true,"inputType":"text","maxCharacter":15}]';
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
          maxCharacter: element['maxCharacter'] ?? 255));
    }
    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, reportFeature);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void getMaterialIncomingStandardReport(BuildContext context) async {
    materialIncStand.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-mat-inc-std/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      materialIncStand = jsonDecode(await response.stream.bytesToString());
    }
    getRows(context);
  }

  void getRows(BuildContext context) {
    dataRows.clear();

    for (var data in materialIncStand) {
      bool flag = true;
      for (var item in data['items']) {
        dataRows.add(DataRow(cells: [
          flag
              ? DataCell(Text('${data['matno'] ?? "-"}',
                  style: const TextStyle(fontWeight: FontWeight.bold)))
              : const DataCell(SizedBox()),
          DataCell(Text('${item['misSno'] ?? "-"}')),
          DataCell(Text('${item['testType'] ?? "-"}')),
          DataCell(Text('${item['isnpItem'] ?? "-"}')),
          DataCell(Text('${item['instName'] ?? "-"}')),
          DataCell(Text('${item['sLimit'] ?? "-"}')),
          DataCell(Text('${item['lLimit'] ?? "-"}')),
          DataCell(Text('${item['hLimit'] ?? "-"}')),
          DataCell(ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)))),
            onPressed: () async {
              bool confirmation = await showConfirmationDialogue(
                  context,
                  "Do you want to Material Incoming Standard?",
                  "SUBMIT",
                  "CANCEL");
              if (confirmation) {
                NetworkService networkService = NetworkService();
                http.StreamedResponse response = await networkService.post(
                    "/delete-mat-inc-std/",
                    {"misId": '${item['misId'] ?? "-"}'});
                if (response.statusCode == 204) {
                  getMaterialIncomingStandardReport(context);
                }
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
            ),
          )),
        ]));
        flag = false;
      }
    }

    notifyListeners();
  }

  void initQcPending() async {
    GlobalVariables.requestBody[qcPendingFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();

    String jsonData =
        '[{"id":"fdate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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

    List<Widget> widgets = await formService.generateDynamicForm(
        formFieldDetails, qcPendingFeature);
    reportWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getQcPending() async {
    qcPending.clear();
    http.StreamedResponse response = await networkService.post(
        "/qc-pending/", GlobalVariables.requestBody[qcPendingFeature]);
    if (response.statusCode == 200) {
      qcPending = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void initReadingsWidget(String matno) async {
    materialIncStand.clear();
    http.StreamedResponse response = await networkService
        .post("/get-mat-inc-std/", {"fmatno": matno, "tmatno": matno});
    if (response.statusCode == 200) {
      materialIncStand =
          jsonDecode(await response.stream.bytesToString())[0]['items'];
    }

    GlobalVariables.requestBody[readingsFeature] = {};
    formFieldDetails.clear();
    widgetList.clear();

    String jsonData =
        '[{"id":"tdate","name":"Date","isMandatory":true,"inputType":"datetime"},{"id":"sSize","name":"Size","isMandatory":true,"inputType":"text"},{"id":"ps","name":"Pass","isMandatory":true,"inputType":"dropdown", "dropdownMenuItem" : "/get-tf/"},{"id":"defect","name":"Defect","isMandatory":false,"inputType":"text", "maxCharacter" : 40},{"id":"problem","name":"Problem","isMandatory":false,"inputType":"text", "maxCharacter" : 100},{"id":"suggestion","name":"Suggestion","isMandatory":false,"inputType":"text", "maxCharacter" : 100},{"id":"remark","name":"Remark","isMandatory":true,"inputType":"text", "maxCharacter" : 100}]';

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

    List<Widget> widgets = await formService.generateDynamicForm(
        formFieldDetails, readingsFeature);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processReadingPost(
      Map<String, dynamic> readings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usr = prefs.getString("currentLoginId");
    GlobalVariables.requestBody[readingsFeature]['userId'] = usr;
    GlobalVariables.requestBody[readingsFeature]['Reading'] =
        readings.values.toList();
    http.StreamedResponse response = await networkService.post(
        "/add-inc/", GlobalVariables.requestBody[readingsFeature]);
    return response;
  }

  void initReadingReportWidget() async {
    String jsonData =
        '[{"id" : "grno", "name" : "GR No.", "isMandatory" : false, "inputType" : "number"},{"id":"fmatno","name":"From Material No.","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"tmatno","name":"To Material No.","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"fdate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';
    GlobalVariables.requestBody[readingReportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          controller: controller,
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255));
    }
    List<Widget> widgets = await formService.generateDynamicForm(
        formFieldDetails, readingReportFeature);
    reportWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getIncomingReadingReport() async {
    incReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/inc-report/", GlobalVariables.requestBody[readingReportFeature]);
    if (response.statusCode == 200) {
      incReport = jsonDecode(await response.stream.bytesToString());
    }
    getReadingRows();
  }

  void getReadingRows() {
    DataRow headerRow = const DataRow(cells: [
      DataCell(Text('GRD ID', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text('Insp Item', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text('Insp Name', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text('R1', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text('R2', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text('R3', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text('R4', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text('R5', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text('R6', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text('R7', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text('R8', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text('R9', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text('R10', style: TextStyle(fontWeight: FontWeight.bold))),
    ]);

    DataRow emptyRow = const DataRow(cells: [
      DataCell(SizedBox()),
      DataCell(SizedBox()),
      DataCell(SizedBox()),
      DataCell(SizedBox()),
      DataCell(SizedBox()),
      DataCell(SizedBox()),
      DataCell(SizedBox()),
      DataCell(SizedBox()),
      DataCell(SizedBox()),
      DataCell(SizedBox()),
      DataCell(SizedBox()),
      DataCell(SizedBox()),
      DataCell(SizedBox()),
    ]);

    readingRows.clear();
    for (var data in incReport) {
      readingRows.add(DataRow(cells: [
        DataCell(Text('${data['grno'] ?? "-"}')),
        DataCell(Text('${data['dtdate'] ?? "-"}')),
        DataCell(Text('${data['matno'] ?? "-"}')),
        DataCell(Text('${data['grQty'] ?? "-"}')),
        DataCell(Text('${data['sSize'] ?? "-"}')),
        DataCell(Text('${data['pass'] ?? "-"}')),
        DataCell(Text('${data['defect'] ?? "-"}')),
        DataCell(Text('${data['problem'] ?? "-"}')),
        DataCell(Text('${data['suggestion'] ?? "-"}')),
        DataCell(Text('${data['remark'] ?? "-"}')),
        DataCell(Text('${data['userId'] ?? "-"}')),
        const DataCell(SizedBox()),
        const DataCell(SizedBox()),
      ]));

      readingRows.add(headerRow);

      for (var item in data['Reading']) {
        readingRows.add(DataRow(cells: [
          DataCell(Text('${item['grdId'] ?? "-"}')),
          DataCell(Text('${item['isnpItem'] ?? "-"}')),
          DataCell(Text('${item['instName'] ?? "-"}')),
          DataCell(Text('${item['r1'] ?? "-"}')),
          DataCell(Text('${item['r2'] ?? "-"}')),
          DataCell(Text('${item['r3'] ?? "-"}')),
          DataCell(Text('${item['r4'] ?? "-"}')),
          DataCell(Text('${item['r5'] ?? "-"}')),
          DataCell(Text('${item['r6'] ?? "-"}')),
          DataCell(Text('${item['r7'] ?? "-"}')),
          DataCell(Text('${item['r8'] ?? "-"}')),
          DataCell(Text('${item['r9'] ?? "-"}')),
          DataCell(Text('${item['r10'] ?? "-"}')),
        ]));
      }
      readingRows.add(emptyRow);
    }

    notifyListeners();
  }
}
