import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../camera/service/camera_service.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class WireSizeProvider with ChangeNotifier {
  static const String featureName = "wireSize";
  static const String reportFeature = "wireSizeTL";
  static const String repFeature = "wireSizeReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<SearchableDropdownMenuItem<String>> colorCodes = [];

  TextEditingController materialController = TextEditingController();
  dynamic wireSizeDesc = {};
  List<dynamic> listWireSizeDetails = [];
  List<dynamic> wsReport = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    colorCodes = await formService.getDropdownMenuItem("/get-color-code/");
    http.StreamedResponse response =
        await networkService.get("/get-wire-size/${materialController.text}/");
    List<dynamic> respData = [];
    var wireSizeDetails = {};

    if (response.statusCode == 200) {
      respData = jsonDecode(await response.stream.bytesToString());
      wireSizeDetails = respData.isNotEmpty ? respData[0] : {};
    }

    String jsonData =
        '[{"id":"matno","name":"Material No.","isMandatory":false,"inputType":"text","readOnly":true, "default" : "${materialController.text ?? ''}"}, {"id":"csId","name":"CS ID","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-cost-status/", "default" : "${wireSizeDetails['csId'] ?? ''}"}]';

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
    notifyListeners();
  }

  void getColorCodes() async {
    colorCodes = await formService.getDropdownMenuItem("/get-color-code/");
    notifyListeners();
  }

  void setJointDrawing(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.getBlobUrl(blob, name);
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["jointDrawing"] = blobUrl;
    }
    notifyListeners();
  }

  void setMaterialDrawing(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.getBlobUrl(blob, name);
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["matDrawing"] = blobUrl;
    }
    notifyListeners();
  }

  Future<http.StreamedResponse> addWireSizeMaster() async {
    GlobalVariables.requestBody[featureName]['matno'] = materialController.text;
    http.StreamedResponse response = await networkService.post(
        "/add-wire-size-details/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void getWireSizeDetailsByMatno() async {
    listWireSizeDetails.clear();
    http.StreamedResponse response = await networkService
        .get("/get-wire-size-details/${materialController.text}/");

    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      listWireSizeDetails = data[0]['wsd'];
      wireSizeDesc = data[0];
    }
    notifyListeners();
  }

  Future<http.StreamedResponse> deleteFullWireSizeDetails(String matno) async {
    http.StreamedResponse response = await networkService
        .post("/delete-full-wire-size-details/", {"matno": matno});
    return response;
  }

  Future<http.StreamedResponse> deleteSpecificWireSizeDetails(
      String wireno) async {
    http.StreamedResponse response = await networkService
        .post("/delete-wire-size-details/", {"wireno": wireno});
    return response;
  }

  Future<http.StreamedResponse> addWireSizeDetailsOnly(
      List<List<String>> tableRows, bool manual) async {
    List<Map<String, dynamic>> wireSizeDetails = [];
    for (int i = 0; i < tableRows.length; i++) {
      wireSizeDetails.add({
        "wireNo": tableRows[i][0],
        "matno": tableRows[i][1],
        "partNo": tableRows[i][2],
        "colNo": tableRows[i][3],
        "wlength": tableRows[i][4],
        "leftSL": tableRows[i][5] == "" ? null : tableRows[i][5],
        "leftPL": tableRows[i][6] == "" ? null : tableRows[i][6],
        "rightSL": tableRows[i][7] == "" ? null : tableRows[i][7],
        "rightPL": tableRows[i][8] == "" ? null : tableRows[i][8],
        "leftTL": tableRows[i][9] == "" ? null : tableRows[i][9],
        "rightTL": tableRows[i][10] == "" ? null : tableRows[i][10],
        "leftCap": tableRows[i][11] == "" ? null : tableRows[i][11],
        "rightCap": tableRows[i][12] == "" ? null : tableRows[i][12],
        "leftSleeve": tableRows[i][13] == "" ? null : tableRows[i][13],
        "rightSleeve": tableRows[i][14] == "" ? null : tableRows[i][14],
        "jWireNo": tableRows[i][15] == "" ? null : tableRows[i][15],
        "jTL": tableRows[i][16] == "" ? null : tableRows[i][16]
      });
    }
    wireSizeDetails = manual
        ? wireSizeDetails
        : GlobalVariables.requestBody[featureName]['WireSizeDetails'];
    http.StreamedResponse response = await networkService.post(
        "/add-wire-size-details-only/", wireSizeDetails);
    return response;
  }

  void initEditWidget(dynamic editData) async {
    GlobalVariables.requestBody[featureName] = jsonDecode(editData);
    formFieldDetails.clear();
    widgetList.clear();

    var data = jsonDecode(editData);
    data['matno'] = wireSizeDesc['matno'];

    String jsonData =
        '[{"id":"wireNo","name":"Wire No","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"matno","name":"Material No","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"partNo","name":"Part No","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"colNo","name":"Column No","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"wlength","name":"Wire Length","isMandatory":true,"inputType":"number"},{"id":"leftSL","name":"Left SL","isMandatory":false,"inputType":"number"},{"id":"leftPL","name":"Left PL","isMandatory":false,"inputType":"number"},{"id":"rightSL","name":"Right SL","isMandatory":false,"inputType":"number"},{"id":"rightPL","name":"Right PL","isMandatory":false,"inputType":"number"},{"id":"leftTL","name":"Left TL","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"rightTL","name":"Right TL","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"leftCap","name":"Left Cap","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"rightCap","name":"Right Cap","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"leftSleeve","name":"Left Sleeve","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"rightSleeve","name":"Right Sleeve","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"jWireNo","name":"Junction Wire No","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"jTL","name":"Junction TL","isMandatory":false,"inputType":"text","maxCharacter":15}]';

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
          defaultValue: data[element['id']]));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-wire-size-details/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void initMasterEditWidget(String editData) async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    var data = jsonDecode(editData);

    String jsonData =
        '[{"id":"matno","name":"Material No.","isMandatory":false,"inputType":"text","readOnly":true, "default" : "${data['matno'] ?? ''}"}, {"id":"csId","name":"CS ID","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-cost-status/", "default" : "${data['csId'] ?? ''}"}]';

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
    notifyListeners();
  }

  Future<http.StreamedResponse> processMasterUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-wire-size/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Widget viewDrawing(String docUrl) {
    return ElevatedButton(
        onPressed: () async {
          final Uri uri = Uri.parse("${NetworkService.baseUrl}$docUrl");
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
          } else {
            throw 'Could not launch $docUrl';
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: HexColor("#0038a8"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3), // Square shape
          ),
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        ),
        child: const Text(
          "Drawing",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ));
  }

  void initReportWidget() async {
    String jsonData =
        '[{"id":"matno","name":"Material No.","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"repId","name":"Wire Rep Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/wire-rep/"},{"id":"soId","name":"Wire Sort Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/wire-sort-type/"}]';
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

  void initWireSizeReportWidget() async {
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

  void getWireSizeReport() async {
    wsReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/ws-report/", GlobalVariables.requestBody[repFeature]);
    if (response.statusCode == 200) {
      wsReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }
}
