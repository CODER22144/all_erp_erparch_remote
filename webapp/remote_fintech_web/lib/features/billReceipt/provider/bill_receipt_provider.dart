import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../camera/service/camera_service.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class BillReceiptProvider with ChangeNotifier {
  static const String featureName = "billReceipt";
  static const String pendingReportFeature = "billReceiptPending";
  static const String reportFeature = "billReceiptPending";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  List<dynamic> billReceiptList = [];
  List<dynamic> brReport = [];
  TextEditingController editBrController = TextEditingController();

  String jsonData =
      '[{"id": "bt","name": "Bill Type","isMandatory": true,"inputType": "dropdown","dropdownMenuItem": "/get-bill-type/"},{"id": "bpName","name": "Business Partner Name","isMandatory": true,"inputType": "text","maxCharacter": 200},{"id": "billNo","name": "Bill No.","isMandatory": false,"inputType": "text","maxCharacter": 16},{"id": "billDate","name": "Bill Date","isMandatory": false,"inputType": "datetime"},{"id": "billAmount","name": "Bill Amount","isMandatory": true,"inputType": "number"},{"id": "ewaybillno","name": "Eway Bill No.","isMandatory": false,"inputType": "text","maxCharacter": 15},{"id": "transmode","name": "Mode Of Transport","isMandatory": true,"inputType": "dropdown","dropdownMenuItem": "/get-trans-mode/"},{"id": "carrierName","name": "Carrier Name","isMandatory": false,"inputType": "text","maxCharacter": 50},{"id": "vehicleNo","name": "Vehicle No.","isMandatory": false,"inputType": "text","maxCharacter": 20},{"id": "dcgrNo","name": "Docket/GR No.","isMandatory": false,"inputType": "text","maxCharacter": 200},{"id": "dcgrDate","name": "Docket/GR Date","isMandatory": false,"inputType": "datetime"},{"id": "nopkt","name": "No. Of Packets","isMandatory": true,"inputType": "number", "default" : 0}]';

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    GlobalVariables.requestBody[featureName]["docImage"] = null;
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
    formFieldDetails.clear();
    widgetList.clear();
    GlobalVariables.requestBody[featureName] = {};
    Map<String, dynamic> editDataMap = await getByIdBr();
    GlobalVariables.requestBody[featureName] = editDataMap;


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
          defaultValue: editDataMap[element['id']]));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void initPendingReport() async {
    GlobalVariables.requestBody[pendingReportFeature] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"bt","name":"Bill Type","isMandatory":false,"inputType":"dropdown", "dropdownMenuItem":"/get-bill-type/"}]';

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
        formFieldDetails, pendingReportFeature);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void setImagePath(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.uploadDocuments(blob, name, "/upload-br/", "BR");
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["docImage"] = blobUrl;
    }
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo(bool manual) async {
    var payload = manual ? [GlobalVariables.requestBody[featureName]] : GlobalVariables.requestBody[featureName];
    http.StreamedResponse response = await networkService
        .post("/create-br/", payload);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService
        .post("/update-br/", GlobalVariables.requestBody[featureName]);
    return response;
  }


  void getPostedBillReceipt() async {
    billReceiptList.clear();
    http.StreamedResponse response = await networkService.get(
        "/get-bt-br/${GlobalVariables.requestBody[pendingReportFeature]['bt']}/");
    if (response.statusCode == 200) {
      billReceiptList = jsonDecode(await response.stream.bytesToString());
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> getByIdBr() async {
    http.StreamedResponse response =
        await networkService.get("/get-br/${editBrController.text}/");
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    }
    return {};
  }

  Future<bool> deleteBr(data) async {
    http.StreamedResponse response =
        await networkService.post("/delete-br/$data/", {});
    if (response.statusCode == 204) {
      return true;
    } else {
      var message = jsonDecode(await response.stream.bytesToString());
      networkService.logError({
        "errorCode" : message['errorCode'] ?? "",
        "errorMsg" : message['message'] ?? "",
        "endpoint" : "/delete-br/",
        "featureName" : null,
        "payload" : {"brId" : data}
      });
    }
    return false;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"brid","name":"BR ID","isMandatory":false,"inputType":"number"},{"id": "bt","name": "Bill Type","isMandatory": false,"inputType": "dropdown","dropdownMenuItem": "/get-bill-type/"},{"id": "repType","name": "Report Type(P/R)","isMandatory": true,"inputType": "text", "default" : "P"},{"id":"fromDate","name":"From Date","isMandatory":true,"inputType":"datetime"}, {"id":"toDate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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
        await formService.generateDynamicForm(formFieldDetails, reportFeature);
    reportWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getBrReport() async {
    brReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/br-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      brReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }
}
