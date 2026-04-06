import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class MaterialClassificationProvider with ChangeNotifier {
  static const String featureName = "materialClassification";
  static const String reportFeature = "materialClassificationReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];

  TextEditingController editController = TextEditingController();
  List<dynamic> matClassificationRep = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  String jsonData =
      '[{"id":"matno","name":"Material no.","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"brandId","name":"Brand","isMandatory":true,"inputType":"number"},{"id":"DepartmentId","name":"Department","isMandatory":true,"inputType":"number"},{"id":"psid","name":"Product Segment","isMandatory":true,"inputType":"number"},{"id":"categoryId","name":"Category","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-category/"},{"id":"subCategoryId","name":"Sub Category","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-sub-category/"},{"id":"pgId","name":"Product Group","isMandatory":false,"inputType":"number"}]';

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    for (var element in jsonDecode(jsonData)) {
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          controller: TextEditingController(),
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<Map<String, dynamic>> getByIdMatClassification() async {
    http.StreamedResponse response = await networkService.post(
        "/material-classification-report/",
        {"fmatno": editController.text, "tmatno": editController.text});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEditWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    Map<String, dynamic> editMapData = await getByIdMatClassification();
    GlobalVariables.requestBody[featureName] = editMapData;

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

  Future<http.StreamedResponse> processFormInfo(bool manual) async {
    var payload = manual
        ? [GlobalVariables.requestBody[featureName]]
        : GlobalVariables.requestBody[featureName];
    http.StreamedResponse response =
        await networkService.post("/add-material-classification/", payload);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-material-classification/",
        GlobalVariables.requestBody[featureName]);
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"fmatno","name":"From Material No.","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"tmatno","name":"To Material No.","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"categoryId","name":"Category","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-category/"},{"id":"subCategory","name":"Sub Category","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-sub-category/"}]';

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

  void getMaterialClassificationReport() async {
    matClassificationRep.clear();
    http.StreamedResponse response = await networkService.post(
        "/material-classification-report/",
        GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      matClassificationRep = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }
}
