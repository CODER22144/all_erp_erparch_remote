import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../camera/service/camera_service.dart';
import '../../common/widgets/custom_dropdown_field.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class LineRejectionProvider with ChangeNotifier {
  static const String featureName = "LineRejection";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  List<dynamic> rejPending = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  List<SearchableDropdownMenuItem<String>> bpCodes = [];

  TextEditingController editController = TextEditingController();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"bpCode","name":"Business Partner","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-business-partner/"},{"id":"matno","name":"Material No.","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"qty","name":"Quantity","isMandatory":true,"inputType":"number"}]';

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255,
          controller: controller));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void getBpCodes() async {
    bpCodes = await formService.getDropdownMenuItem("/get-business-partner/");
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/add-line-rejection/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  void getLineRejectionPending() async {
    rejPending.clear();
    http.StreamedResponse response = await networkService
        .post("/line-rejection-pending/", {"bpCode": editController.text.isEmpty ? null : editController.text});
    if (response.statusCode == 200) {
      rejPending = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }
}
