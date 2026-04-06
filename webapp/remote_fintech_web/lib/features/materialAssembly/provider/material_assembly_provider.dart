import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../billReceipt/screen/hyperlink.dart';
import '../../camera/service/camera_service.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class MaterialAssemblyProvider with ChangeNotifier {
  static const String featureName = "materialAssembly";
  static const String reportFeature = "materialAssemblyReport";
  static const String repFeature = "materialAssemblyCostingReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  TextEditingController editController = TextEditingController();

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  List<List<TextEditingController>> rowControllers = [];
  List<List<TextEditingController>> rowControllers2 = [];

  List<SearchableDropdownMenuItem<String>> rmType = [];
  List<SearchableDropdownMenuItem<String>> units = [];
  List<SearchableDropdownMenuItem<String>> workProcess = [];
  List<SearchableDropdownMenuItem<String>> resources = [];

  List<DataColumn> costColumns = [];
  List<DataRow> costRows = [];

  List<dynamic> matAssCostRep = [];

  String jsonData =
      '[{"id":"matno","name":"Material no.","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"rmType","name":"Raw Material Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/raw-material/"},{"id":"profit","name":"Profit","isMandatory":true,"inputType":"number", "default" : 0},{"id":"rejection","name":"Rejection","isMandatory":true,"inputType":"number", "default" : 0},{"id":"overhead","name":"Overhead","isMandatory":true,"inputType":"number", "default" : 0},{"id":"processing","name":"Processing","isMandatory":true,"inputType":"number", "default" : 0},{"id":"icc","name":"ICC","isMandatory":true,"inputType":"number", "default" : 0},{"id":"revisionNo","name":"Revision No.","isMandatory":true,"inputType":"text","maxCharacter":10},{"id":"csId","name":"Cost Status","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-cost-status/"},{"id":"stdPack","name":"Stdandard Pack","isMandatory":false,"inputType":"number"},{"id":"mstPack","name":"Master Pack","isMandatory":false,"inputType":"number"},{"id":"jamboPack","name":"Jambo Pack","isMandatory":false,"inputType":"number"},{"id":"grossWeight","name":"Gross Weight","isMandatory":false,"inputType":"number"},{"id":"netWeight","name":"Net Weight","isMandatory":false,"inputType":"number"}]';

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
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255,
          controller: controller,
          defaultValue: element['default']));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<Map<String, dynamic>> getByIdMaterialAssembly() async {
    http.StreamedResponse response =
    await networkService.post("/get-material-assembly/", {"matno": editController.text});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEditWidget() async {
    Map<String, dynamic> editMapData = await getByIdMaterialAssembly();
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


  void initDetailWidget() async {
    List<List<String>> tableRows = [
      ['', '', '', '', '', '', '']
    ];

    rowControllers = tableRows
        .map((row) =>
        row.map((field) => TextEditingController(text: field)).toList())
        .toList();

    units = await formService.getDropdownMenuItem("/get-material-unit/");
    rmType = await formService.getDropdownMenuItem("/get-rm-type/");
    notifyListeners();
  }

  void initProcessingWidget() async {
    List<List<String>> tableRows = [
      ['', '', '', '', '', '']
    ];

    rowControllers2 = tableRows
        .map((row) =>
        row.map((field) => TextEditingController(text: field)).toList())
        .toList();

    workProcess = await formService.getDropdownMenuItem("/get-work-process/");
    resources = await formService.getDropdownMenuItem("/get-all-resources/");
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response =
    await networkService.post("/add-material-assembly/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> addMaterialAssemblyDetails(
      List<List<String>> detailsTab, bool manualOrder) async {
    List<Map<String, dynamic>> matAssembly = [];
    for (int i = 0; i < detailsTab.length; i++) {
      matAssembly.add({
        "matno" : detailsTab[i][0],
        "partno" : detailsTab[i][1],
        "qty" : detailsTab[i][2],
        "pLength" : detailsTab[i][3],
        "unit" : detailsTab[i][4],
        "tno" : detailsTab[i][5],
        "rmType" : detailsTab[i][6]
      });
    }

    var payload = manualOrder ? matAssembly : GlobalVariables.requestBody['MaterialAssemblyDetails'];

    http.StreamedResponse response =
    await networkService.post("/add-material-assembly-details/", payload);
    return response;
  }

  Future<http.StreamedResponse> addMaterialAssemblyProcessing(
      List<List<String>> detailsTab, bool manualOrder) async {
    List<Map<String, dynamic>> matAssembly = [];
    for (int i = 0; i < detailsTab.length; i++) {
      matAssembly.add({
        "matno" : detailsTab[i][0],
        "wpId" : detailsTab[i][1],
        "orderBy" : detailsTab[i][2],
        "rId" : detailsTab[i][3],
        "rQty" : detailsTab[i][4],
        "dayProduction" : detailsTab[i][5]
      });
    }

    var payload = manualOrder ? matAssembly : GlobalVariables.requestBody['MaterialAssemblyProcessing'];

    http.StreamedResponse response =
    await networkService.post("/add-material-assembly-processing/", payload);
    return response;
  }

  void setDrawing(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.getBlobUrl(blob, name);
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["drawing"] = blobUrl;
    }
    notifyListeners();
  }

  void setPic(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.getBlobUrl(blob, name);
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["pic"] = blobUrl;
    }
    notifyListeners();
  }

  void setAsDrawing(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.getBlobUrl(blob, name);
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["asdrawing"] = blobUrl;
    }
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
      TextEditingController(),
    ]);
    notifyListeners();
  }

  void deleteRowController(int index) {
    rowControllers.removeAt(index);
    notifyListeners();
  }

  void addRowController2() {
    rowControllers2.add([
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ]);
    notifyListeners();
  }

  void deleteRowController2(int index) {
    rowControllers2.removeAt(index);
    notifyListeners();
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-material-assembly/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"matno","name":"Material No.","isMandatory":true,"inputType":"text", "maxCharacter" : 15}]';

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

  void initAssemblyCostingReport() async {
    String jsonData =
        '[{"id":"csId","name":"Cost Status","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-cost-status/"},{"id":"fmatno","name":"From Material No.","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"tmatno","name":"To Material No.","isMandatory":false,"inputType":"text","maxCharacter":15}]';
    GlobalVariables.requestBody[repFeature] = {};
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
    await formService.generateDynamicForm(formFieldDetails, repFeature);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void getPbCostingReport() async {
    matAssCostRep.clear();
    http.StreamedResponse response = await networkService.post(
        "/material-assembly-costing/", GlobalVariables.requestBody[repFeature]);
    if (response.statusCode == 200) {
      matAssCostRep = jsonDecode(await response.stream.bytesToString());
    }
    assemblyCostingTable();
  }

  void assemblyCostingTable() async {
    costColumns = [];
    costRows = [];

    for (int i = 0; i < matAssCostRep.length; i++) {
      var data = matAssCostRep[i];

      costColumns = const [
        DataColumn(
            label: Text("Description",
                style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label: Text("Drawing", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label:
            Text("Rate(%)", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label: Text("Basic Cost",
                style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label:
            Text("Amount", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label:
            Text("Total", style: TextStyle(fontWeight: FontWeight.bold))),
      ];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var cid = prefs.getString("currentLoginCid");
      costRows.addAll([
        DataRow(cells: [
          DataCell(Hyperlink(
              text: data['matno'],
              url: "/mat-assembly-breakup/${data['matno']}/$cid/")),
          DataCell(Text("RV: ${data['revisionNo'] ?? ''}")),
          DataCell(Text("REJ: ${data['rejection'] ?? '0.00'}")),
          DataCell(Text("RMC: ${data['asamount'] ?? '0.00'}")),
          DataCell(Text("REJ: ${data['rejamount'] ?? '0.00'}")),
          DataCell(Text("TOT: ${data['tamount'] ?? '0.00'}"))
        ]),
        DataRow(cells: [
          DataCell(Text("${data['chrDescription'] ?? ''}")),
          DataCell(Row(children: [
            const Text("PIC: "),
            Visibility(
              visible: data['pic'] != null && data['pic'] != "",
              child: InkWell(
                child: const Icon(
                  Icons.file_present_outlined,
                  color: Colors.green,
                ),
                onTap: () async {
                  final Uri uri = Uri.parse(
                      "${NetworkService.baseUrl}${data['pic']}");
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                  } else {
                    throw 'Could not launch';
                  }
                },
              ),
            )
          ])),
          DataCell(Text("ICC: ${data['icc'] ?? '0.00'}")),
          DataCell(Text("F: ${data['processing'] ?? '0.00'}")),
          DataCell(Text("ICC: ${data['iccamount'] ?? '0.00'}")),
          const DataCell(Text("")),
        ]),
        DataRow(cells: [
          DataCell(Text("${data['rmType']}")),
          DataCell(Row(children: [
            const Text("DR: "),
            Visibility(
              visible: data['drawing'] != null && data['drawing'] != "",
              child: InkWell(
                child: const Icon(
                  Icons.file_present_outlined,
                  color: Colors.green,
                ),
                onTap: () async {
                  final Uri uri = Uri.parse(
                      "${NetworkService.baseUrl}${data['drawing']}");
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                  } else {
                    throw 'Could not launch';
                  }
                },
              ),
            )
          ])),
          DataCell(Text("OH: ${data['overhead'] ?? '0.00'}")),
          DataCell(Text("LB: ${data['pramount'] ?? '0.00'}")),
          DataCell(Text("OH: ${data['overheadamount'] ?? '0.00'}")),
          const DataCell(Text("")),
        ]),
        DataRow(cells: [
          DataCell(Text("Status: ${data['csId']}")),

          DataCell(Row(children: [
            const Text("ADR: "),
            Visibility(
              visible: data['asdrawing'] != null && data['asdrawing'] != "",
              child: InkWell(
                child: const Icon(
                  Icons.file_present_outlined,
                  color: Colors.green,
                ),
                onTap: () async {
                  final Uri uri = Uri.parse(
                      "${NetworkService.baseUrl}${data['asdrawing']}");
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                  } else {
                    throw 'Could not launch';
                  }
                },
              ),
            )
          ])),
          DataCell(Text("PR: ${data['profit'] ?? '0.00'}")),
          const DataCell(Text("")),
          DataCell(Text("PR: ${data['profitamount'] ?? '0.00'}")),
          const DataCell(Text(""))
        ]),
        const DataRow(cells: [
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text(""))
        ]),
      ]);
    }
    notifyListeners();
  }


}