import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../camera/service/camera_service.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class AccountGroupProvider with ChangeNotifier {
  static const String featureName = "AccountGroup";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  TextEditingController editController = TextEditingController();

  List<dynamic> acGroups = [];
  List<dynamic> acGroupsSearched = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  String jsonData =
      '[{"id":"agCode","name":"Account Group Code","isMandatory":true,"inputType":"text","maxCharacter":5},{"id":"agDescription","name":"Description","isMandatory":true,"inputType":"text","maxCharacter":50},{"id":"mgCode","name":"Master Group Code","isMandatory":true,"inputType":"text","maxCharacter":5},{"id":"isTr","name":"is TR?","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/", "default" : "N"},{"id":"isPl","name":"is PL?","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/", "default" : "N"},{"id":"isBl","name":"is BL?","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/", "default" : "N"}]';

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    for (var element in jsonDecode(jsonData)) {
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          controller: TextEditingController(),
          defaultValue: element['default'],
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

  void initEditWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    Map<String, dynamic> editMapData = await getByIdAcGroup();
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

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService
        .post("/add-agGroup/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-agGroup/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<Map<String, dynamic>> getByIdAcGroup() async {
    http.StreamedResponse response = await networkService
        .post("/get-agGroup-id/", {"agCode": editController.text});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void getAccountGroupReport() async {
    acGroups.clear();
    http.StreamedResponse response = await networkService.get("/get-agGroup/");
    if (response.statusCode == 200) {
      acGroups = jsonDecode(await response.stream.bytesToString());
      acGroupsSearched = acGroups;
    }
    notifyListeners();
  }

  void search(String target, List<String> fields) {
    if (target.length >= 3) {
      acGroupsSearched = acGroupsSearched.where((item) {
        return fields.any((field) {
          var value = item;

          for (var key in field.split('.')) {
            if (value is Map && value.containsKey(key)) {
              value = value[key];
            } else {
              return false;
            }
          }
          return value.toString().toLowerCase().contains(target.toLowerCase());
        });
      }).toList();
    } else {
      acGroupsSearched = acGroups;
    }

    notifyListeners();
  }
}
