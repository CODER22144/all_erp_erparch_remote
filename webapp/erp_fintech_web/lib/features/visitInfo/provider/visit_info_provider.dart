import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import '../../camera/service/camera_service.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';
import '../../utility/services/geo_location.dart';

class VisitInfoProvider with ChangeNotifier {
  static const String featureName = "visitInfo";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  TextEditingController editController = TextEditingController();

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  List<dynamic> visitReport = [];

  void initWidget() async {
    String jsonData =
        '[{"id":"bpName","name":"Business Partner Name","isMandatory":true,"inputType":"text","maxCharacter":100},{"id":"cperson","name":"Contact Person","isMandatory":true,"inputType":"text","maxCharacter":100},{"id":"cno","name":"Contact No.","isMandatory":true,"inputType":"text","maxCharacter":10},{"id":"popVisit","name":"Purpose Visit","isMandatory":true,"inputType":"text","maxCharacter":100},{"id":"brType","name":"Business Relation Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-business-relation-type/"},{"id":"bsecured","name":"Is Secured ?","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/"}]';
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

  void initReportWidget() async {
    String jsonData =
        '[{"id":"userId","name":"User Id","isMandatory":false,"inputType":"text"},{"id":"fromDate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"toDate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';
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

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService
        .post("/add-visit-info/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> getVisitReport() async {
    http.StreamedResponse response = await networkService.post(
        "/visit-info-report/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void setImagePath(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.getBlobUrl(blob, name);
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["liveImage"] = blobUrl;
    }
    notifyListeners();
  }

  void setReport(dynamic data) {
    visitReport = data;
    notifyListeners();
  }
}
