import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../camera/service/camera_service.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class TaClaimProvider with ChangeNotifier {
  static const String featureName = "taClaim";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  List<dynamic> claimReport = [];

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"from_Place","name":"From Place","isMandatory":true,"inputType":"text","maxCharacter":20},{"id":"to_Place","name":"To Place","isMandatory":true,"inputType":"text","maxCharacter":20},{"id":"distCovered","name":"Distance Covered","isMandatory":true,"inputType":"number","default":0},{"id":"mediumTransport","name":"Mode Of Transportation","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-transport-medium/"},{"id":"fare","name":"Fare","isMandatory":true,"inputType":"number","default":0},{"id":"da","name":"DA","isMandatory":true,"inputType":"number","default":0},{"id":"lConveyance","name":"Local Conveyance","isMandatory":true,"inputType":"number","default":0},{"id":"oConveyance","name":"Other Conveyance","isMandatory":true,"inputType":"number","default":0},{"id":"otherAmount","name":"Other Amount","isMandatory":true,"inputType":"number","default":0},{"id":"otherDescription","name":"Other Description","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"facilityName","name":"Facility Name","isMandatory":false,"inputType":"text","maxCharacter":50},{"id":"facilityPhone","name":"Facility Phone No.","isMandatory":false,"inputType":"text","maxCharacter":50}]';

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

  void initReportWidget() async {
    String jsonData =
        '[{"id":"userId","name":"User Id","isMandatory":false,"inputType":"text"},{"id":"fromDate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"toDate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';
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

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/add-claim/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> getClaimReport() async {
    http.StreamedResponse response = await networkService.post(
        "/claim-report/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void setImagePath(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.getBlobUrl(blob, name);
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["DocProof"] = blobUrl;
    }
    notifyListeners();
  }

  void setReport(dynamic data) {
    claimReport = data;
    notifyListeners();
  }
}
