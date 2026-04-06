import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../camera/service/camera_service.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class JournalVoucherProvider with ChangeNotifier {
  static const String featureName = "JVoucher";
  static const String reportFeature = "JVoucherReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];

  List<dynamic> jVoucherReport = [];

  TextEditingController editController = TextEditingController();

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  String jsonData =
      '[{"id":"Dt","name":"Transaction Date","isMandatory":true,"inputType":"datetime"},{"id":"dbCode","name":"Debit Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"crCode","name":"Credit Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"naration","name":"Naration","isMandatory":true,"inputType":"text","maxCharacter":100},{"id":"amount","name":"Amount","isMandatory":true,"inputType":"number"}]';

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

  Future<Map<String, dynamic>> getByIdJVoucher() async {
    http.StreamedResponse response =
    await networkService.post("/get-jvoucher/", {"transId" : editController.text});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEditWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    Map<String,dynamic> editMapData = await getByIdJVoucher();
    GlobalVariables.requestBody[featureName] = editMapData;

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          controller: controller,
          defaultValue: editMapData[element['id']],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo(bool manual) async {
    var payload = manual ? [GlobalVariables.requestBody[featureName]] : GlobalVariables.requestBody[featureName];
    http.StreamedResponse response = await networkService
        .post("/add-jvoucher/", payload);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService
        .post("/update-jvoucher/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id" : "dbCode", "name" : "Debit Code", "isMandatory" : false, "inputType" : "dropdown", "dropdownMenuItem" : "/get-ledger-code/"},{"id" : "crCode", "name" : "Credit Code", "isMandatory" : false, "inputType" : "dropdown", "dropdownMenuItem" : "/get-ledger-code/"},{"id":"fdate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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

  void getJVoucherReport() async {
    http.StreamedResponse response = await networkService.post(
        "/jvoucher-rep/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      jVoucherReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void setImagePath(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.uploadDocuments(blob, name, "/upload-jvoucher/", "JV");
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["DocProof"] = blobUrl;
    }
    notifyListeners();
  }

}
