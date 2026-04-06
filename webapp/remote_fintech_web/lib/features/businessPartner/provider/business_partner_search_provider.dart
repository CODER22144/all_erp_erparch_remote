import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class BusinessPartnerSearchProvider with ChangeNotifier {
  static const String featureName = 'businessPartnerSearch';
  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  List<dynamic> searchResponse = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"bpName","name": "Business Partner Name","isMandatory": true,"inputType": "text",  "maxCharacter": 100},{"id": "bpCity","name": "City","isMandatory": false,"inputType": "text","maxCharacter": 50},{"id": "bpPhone","name": "Phone No.","isMandatory": false,"inputType": "number","maxCharacter": 10}]';

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
    http.StreamedResponse response = await networkService.post(
        "/search-business-partner/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void setSearchResult(dynamic response) {
    searchResponse = response;
    notifyListeners();
  }
}
