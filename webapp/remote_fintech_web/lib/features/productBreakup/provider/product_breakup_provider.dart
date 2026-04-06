import 'dart:convert';

import 'package:fintech_new_web/features/billReceipt/screen/hyperlink.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../camera/service/camera_service.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class ProductBreakupProvider with ChangeNotifier {
  static const String featureName = "productBreakup";
  static const String reportFeature = "productBreakupReport";
  static const String repFeature = "pbCostingReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  List<SearchableDropdownMenuItem<String>> workProcess = [];
  List<SearchableDropdownMenuItem<String>> rmType = [];
  List<SearchableDropdownMenuItem<String>> resources = [];
  List<SearchableDropdownMenuItem<String>> units = [];

  List<dynamic> breakupReport = [];
  List<dynamic> pbCostingReport = [];
  TextEditingController materialController = TextEditingController();
  dynamic productBreakupMap = {};
  List<dynamic> productBreakupDetailsList = [];
  List<dynamic> productBreakupProcessingList = [];

  List<DataColumn> columns = [];
  List<DataRow> rows = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void setMaterial(String value) {
    materialController.text = value;
    notifyListeners();
  }

  void reset() {
    materialController.text = "";
    materialController.clear();
    notifyListeners();
  }

  void resetEdit() {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    notifyListeners();
  }

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    http.StreamedResponse response =
        await networkService.get("/get-pbu-matno/${materialController.text}/");
    List<dynamic> respData = [];
    var productBreakup = {};

    if (response.statusCode == 200) {
      respData = jsonDecode(await response.stream.bytesToString());
      productBreakup = respData.isNotEmpty ? respData[0] : {};
    }

    String jsonData =
        '[{"id":"matno","name":"Material No.","isMandatory":false,"inputType":"text","readOnly":true,"default":"${materialController.text ?? ''}"},{"id":"sDescription","name":"Short Description","isMandatory":true,"inputType":"text"},{"id":"lDescription","name":"Long Description","isMandatory":false,"inputType":"text"},{"id":"listRate","name":"List Rate","isMandatory":true,"inputType":"number"},{"id":"mrp","name":"MRP","isMandatory":true,"inputType":"number"},{"id":"oemRate","name":"OEM Rate","isMandatory":true,"inputType":"number"},{"id":"stdPack","name":"Standard Pack","isMandatory":true,"inputType":"number"},{"id":"mstPack","name":"Master Pack","isMandatory":true,"inputType":"number"},{"id":"jamboPack","name":"Jambo Pack","isMandatory":true,"inputType":"number"},{"id":"revisionNo","name":"Revision No.","isMandatory":false,"inputType":"text"},{"id":"grossWeight","name":"Gross Weight","isMandatory":true,"inputType":"number"},{"id":"netWeight","name":"Net Weight","isMandatory":true,"inputType":"number"},{"id":"processing","name":"Processing","isMandatory":true,"inputType":"number","default":0},{"id":"rejection","name":"Rejection","isMandatory":true,"inputType":"number","default":0},{"id":"icc","name":"ICC","isMandatory":true,"inputType":"number","default":0},{"id":"overhead","name":"Overhead","isMandatory":true,"inputType":"number","default":0},{"id":"profit","name":"Profit","isMandatory":true,"inputType":"number","default":0},{"id":"csId","name":"Cost Status","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-cost-status/"},{"id":"remarks","name":"Remarks","isMandatory":false,"inputType":"text"}]';

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
          controller: controller,
          readOnly: element['readOnly'] ?? false));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    getWorkProcess();
    getRmType();
    getAllResources();
    getUnits();
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    GlobalVariables.requestBody[featureName]['matno'] = materialController.text;
    http.StreamedResponse response = await networkService.post(
        "/add-pbu/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void getProductBreakupByMatno() async {
    productBreakupMap.clear();
    http.StreamedResponse response =
        await networkService.get("/get-pbu-matno/${materialController.text}/");

    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      productBreakupMap = data[0];
    }
    notifyListeners();
  }

  void getProductBreakupDetailsByMatno() async {
    productBreakupDetailsList.clear();
    http.StreamedResponse response = await networkService
        .get("/get-pbu-details-matno/${materialController.text}/");

    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      productBreakupDetailsList = data;
    }
    notifyListeners();
  }

  void getProductBreakupProcessingByMatno() async {
    productBreakupProcessingList.clear();
    http.StreamedResponse response = await networkService
        .get("/get-pbu-processing-matno/${materialController.text}/");

    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      productBreakupProcessingList = data;
    }
    notifyListeners();
  }

  Future<http.StreamedResponse> deleteProductBreakup(String matno) async {
    http.StreamedResponse response =
        await networkService.post("/delete-pbu/$matno/", {});
    return response;
  }

  Future<http.StreamedResponse> deleteProductBreakupDetails(
      String padId) async {
    http.StreamedResponse response =
        await networkService.post("/delete-pbu-details/$padId/", {});
    return response;
  }

  Future<http.StreamedResponse> deleteProductBreakupProcessing(
      String papId) async {
    http.StreamedResponse response =
        await networkService.post("/delete-pbu-processing/$papId/", {});
    return response;
  }

  Future<http.StreamedResponse> addProductBreakupProcessing(
      List<List<String>> detailsTab, bool manual) async {
    List<Map<String, dynamic>> partProcessing = [];
    for (int i = 0; i < detailsTab.length; i++) {
      partProcessing.add({
        "wpId": detailsTab[i][0],
        "orderBy": detailsTab[i][1],
        "rId": detailsTab[i][2],
        "rQty": detailsTab[i][3],
        "dayProduction": detailsTab[i][4],
        "matno": materialController.text
      });
    }
    if (!manual) {
      partProcessing = GlobalVariables.requestBody['ProductBreakupProcessing'];
    }
    http.StreamedResponse response =
        await networkService.post("/add-pbu-processing/", partProcessing);
    return response;
  }

  Future<http.StreamedResponse> addProductBreakupDetails(
      List<List<String>> tableRows, bool manual) async {
    List<Map<String, dynamic>> data = [];
    for (int i = 0; i < tableRows.length; i++) {
      data.add({
        "matno": materialController.text,
        "partNo": tableRows[i][0],
        "qty": tableRows[i][1],
        "pLength": tableRows[i][2] == "" ? null : tableRows[i][2],
        "unit": tableRows[i][3] == "" ? null : tableRows[i][3],
        "tno": tableRows[i][4] == "" ? null : tableRows[i][4],
        "rmType": tableRows[i][5]
      });
    }
    if (!manual) {
      data = GlobalVariables.requestBody['ProductBreakupDetails'];
    }
    http.StreamedResponse response =
        await networkService.post("/add-pbu-details/", data);
    return response;
  }

  void getWorkProcess() async {
    workProcess = await formService.getDropdownMenuItem("/get-work-process/");
    notifyListeners();
  }

  void getRmType() async {
    rmType = await formService.getDropdownMenuItem("/get-rm-type/");
    notifyListeners();
  }

  void getAllResources() async {
    resources = await formService.getDropdownMenuItem("/get-all-resources/");
    notifyListeners();
  }

  void getUnits() async {
    units = await formService.getDropdownMenuItem("/get-material-unit/");
    notifyListeners();
  }

  void initReport() async {
    String jsonData =
        '[{"id":"matno","name":"Material No.","isMandatory":true,"inputType":"text","maxCharacter":15}]';
    GlobalVariables.requestBody[reportFeature] = {};
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
    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, reportFeature);
    reportWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getProductBreakupReport() async {
    breakupReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/pbu-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      String respData = jsonDecode(await response.stream.bytesToString());
      breakupReport = jsonDecode(respData);
    }
    notifyListeners();
  }

  void initPbCostingReport() async {
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
    pbCostingReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/pb-costing/", GlobalVariables.requestBody[repFeature]);
    if (response.statusCode == 200) {
      pbCostingReport = jsonDecode(await response.stream.bytesToString());
    }
    pbCostingTable();
  }

  void pbCostingTable() async{

    columns = [];
    rows = [];


    for (int i = 0; i < pbCostingReport.length; i++) {
      var data = pbCostingReport[i];

      columns = const [
        DataColumn(label: Text("Description", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("Drawing", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("Doc", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("Pack", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("Weight", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("Rate", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("Rate(%)", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("Basic Cost", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("Amount", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("Total", style: TextStyle(fontWeight: FontWeight.bold))),
      ];


        SharedPreferences prefs = await SharedPreferences.getInstance();
        var cid = prefs.getString("currentLoginCid");


      rows.addAll([
        DataRow(cells: [
          DataCell(Hyperlink(text: data['matno'], url: "/product-breakup/${data['matno']}/$cid/")),
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
          DataCell(Row(children: [
            const Text("CP: "),
            Visibility(
              visible: data['cp'] != null && data['cp'] != "",
              child: InkWell(
                child: const Icon(
                  Icons.file_present_outlined,
                  color: Colors.green,
                ),
                onTap: () async {
                  final Uri uri = Uri.parse(
                      "${NetworkService.baseUrl}${data['cp']}");
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                  } else {
                    throw 'Could not launch';
                  }
                },
              ),
            )
          ])),
          DataCell(Text("SP: ${data['stdPack'] ?? ''}")),
          DataCell(Text("GW: ${data['grossWeight'] ?? ''}")),
          DataCell(Text("MRP: ${data['mrp'] ?? ''}")),
          DataCell(Text("REJ: ${data['rejection'] ?? '0.00'}")),
          DataCell(Text("RMC: ${data['asamount'] ?? '0.00'}")),
          DataCell(Text("REJ: ${data['rejamount'] ?? '0.00'}")),
          DataCell(Text("TOT: ${data['tamount'] ?? '0.00'}")),

        ]),


        DataRow(cells: [
          DataCell(Text("${data['chrDescription'] ?? ''}")),
          DataCell(Row(children: [
            const Text("D: "),
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
          DataCell(Row(children: [
            const Text("FMEA: "),
            Visibility(
              visible: data['fmea'] != null && data['fmea'] != "",
              child: InkWell(
                child: const Icon(
                  Icons.file_present_outlined,
                  color: Colors.green,
                ),
                onTap: () async {
                  final Uri uri = Uri.parse(
                      "${NetworkService.baseUrl}${data['fmea']}");
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                  } else {
                    throw 'Could not launch';
                  }
                },
              ),
            )
          ])),
          DataCell(Text("MP: ${data['mstPack'] ?? ''}")),
          DataCell(Text("NW: ${data['netWeight'] ?? ''}")),
          DataCell(Text("L: ${data['listRate'] ?? ''}")),
          DataCell(Text("ICC: ${data['icc'] ?? '0.00'}")),
          DataCell(Text("F: ${data['processing'] ?? '0.00'}")),
          DataCell(Text("ICC: ${data['iccamount'] ?? '0.00'}")),
          const DataCell(Text(""))
        ]),



        DataRow(cells: [
          DataCell(Text("${data['rmType']}")),
          DataCell(Row(children: [
            const Text("AD: "),
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
          DataCell(Row(children: [
            const Text("PFD: "),
            Visibility(
              visible: data['pfd'] != null && data['pfd'] != "",
              child: InkWell(
                child: const Icon(
                  Icons.file_present_outlined,
                  color: Colors.green,
                ),
                onTap: () async {
                  final Uri uri = Uri.parse(
                      "${NetworkService.baseUrl}${data['pfd']}");
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                  } else {
                    throw 'Could not launch';
                  }
                },
              ),
            )
          ])),
          DataCell(Text("JP: ${data['jamboPack'] ?? ''}")),
          DataCell(Text("RV: ${data['revisionNo'] ?? ''}")),
          DataCell(Text("OE: ${data['oerate'] ?? '0.00'}")),
          DataCell(Text("OH: ${data['overhead'] ?? '0.00'}")),
          DataCell(Text("LB: ${data['pramount'] ?? '0.00'}")),
          DataCell(Text("OH: ${data['overheadamount'] ?? '0.00'}")),
          const DataCell(Text(""))
        ]),
        DataRow(cells: [
          DataCell(Text("Status: ${data['csId']}")),
          DataCell(Row(children: [
            const Text("CD: "),
            Visibility(
              visible: data['vendrawing'] != null && data['vendrawing'] != "",
              child: InkWell(
                child: const Icon(
                  Icons.file_present_outlined,
                  color: Colors.green,
                ),
                onTap: () async {
                  final Uri uri = Uri.parse(
                      "${NetworkService.baseUrl}${data['vendrawing']}");
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                  } else {
                    throw 'Could not launch';
                  }
                },
              ),
            )
          ])),
          DataCell(Row(children: [
            const Text("CCR: "),
            Visibility(
              visible: data['ccr'] != null && data['ccr'] != "",
              child: InkWell(
                child: const Icon(
                  Icons.file_present_outlined,
                  color: Colors.green,
                ),
                onTap: () async {
                  final Uri uri = Uri.parse(
                      "${NetworkService.baseUrl}${data['ccr']}");
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                  } else {
                    throw 'Could not launch';
                  }
                },
              ),
            )
          ])),
          DataCell(Row(children: [
            const Text("QC: "),
            Visibility(
              visible: data['qcformat'] != null && data['qcformat'] != "",
              child: InkWell(
                child: const Icon(
                  Icons.file_present_outlined,
                  color: Colors.green,
                ),
                onTap: () async {
                  final Uri uri = Uri.parse(
                      "${NetworkService.baseUrl}${data['qcformat']}");
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                  } else {
                    throw 'Could not launch';
                  }
                },
              ),
            )
          ])),
          const DataCell(Text("")),
          const DataCell(Text("")),
          DataCell(Text("PR: ${data['profit'] ?? '0.00'}")),
          const DataCell(Text("")),
          DataCell(Text("PR: ${data['profitamount'] ?? '0.00'}")),
          const DataCell(Text("")),
        ]),
        const DataRow(cells: [
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
        ]),
      ]);
    }
    notifyListeners();
  }



  void initEditWidget() async {
    http.StreamedResponse response =
    await networkService.get("/get-pbu-matno/${materialController.text}/");

    Map<String, dynamic> editData = {};

    if(response.statusCode == 200) {
      editData = jsonDecode(await response.stream.bytesToString())[0];
    }

      GlobalVariables.requestBody[featureName] = editData;
      formFieldDetails.clear();
      widgetList.clear();

      String jsonData =
          '[{"id":"matno","name":"Material No.","isMandatory":false,"inputType":"text","readOnly":true},{"id":"sDescription","name":"Short Description","isMandatory":true,"inputType":"text"},{"id":"lDescription","name":"Long Description","isMandatory":false,"inputType":"text"},{"id":"listRate","name":"List Rate","isMandatory":true,"inputType":"number"},{"id":"mrp","name":"MRP","isMandatory":true,"inputType":"number"},{"id":"oemRate","name":"OEM Rate","isMandatory":true,"inputType":"number"},{"id":"stdPack","name":"Standard Pack","isMandatory":true,"inputType":"number"},{"id":"mstPack","name":"Master Pack","isMandatory":true,"inputType":"number"},{"id":"jamboPack","name":"Jambo Pack","isMandatory":true,"inputType":"number"},{"id":"revisionNo","name":"Revision No.","isMandatory":false,"inputType":"text"},{"id":"grossWeight","name":"Gross Weight","isMandatory":true,"inputType":"number"},{"id":"netWeight","name":"Net Weight","isMandatory":true,"inputType":"number"},{"id":"processing","name":"Processing","isMandatory":true,"inputType":"number","default":0},{"id":"rejection","name":"Rejection","isMandatory":true,"inputType":"number","default":0},{"id":"icc","name":"ICC","isMandatory":true,"inputType":"number","default":0},{"id":"overhead","name":"Overhead","isMandatory":true,"inputType":"number","default":0},{"id":"profit","name":"Profit","isMandatory":true,"inputType":"number","default":0},{"id":"csId","name":"Cost Status","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-cost-status/"},{"id":"remarks","name":"Remarks","isMandatory":false,"inputType":"text"}]';

      for (var element in jsonDecode(jsonData)) {
        TextEditingController controller = TextEditingController();
        formFieldDetails.add(FormUI(
            id: element['id'],
            name: element['name'],
            isMandatory: element['isMandatory'],
            inputType: element['inputType'],
            dropdownMenuItem: element['dropdownMenuItem'] ?? "",
            maxCharacter: element['maxCharacter'] ?? 255,
            defaultValue: editData[element['id']],
            controller: controller,
            readOnly: element['readOnly'] ?? false));
      }

      List<Widget> widgets =
      await formService.generateDynamicForm(formFieldDetails, featureName);
      widgetList.addAll(widgets);
      notifyListeners();
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-pbu/", GlobalVariables.requestBody[featureName]);
    return response;
  }
}
