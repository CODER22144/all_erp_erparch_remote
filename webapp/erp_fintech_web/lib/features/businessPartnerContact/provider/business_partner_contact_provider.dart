import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class BusinessPartnerContactProvider with ChangeNotifier {
  static const String featureName = "businessPartnerContact";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id": "bpCode","name": "Business Partner Code","isMandatory": true,"inputType": "text","maxCharacter": 10},{"id": "cno","name": "Contact No.","isMandatory": true,"inputType": "number","maxCharacter": 10},{"id": "cperson","name": "Contact Person","isMandatory": true,"inputType": "text","maxCharacter": 50},{"id": "designation","name": "Designation","isMandatory": true,"inputType": "text","maxCharacter": 20},{"id": "emailid","name": "Email ID","isMandatory": true,"inputType": "text","maxCharacter": 50}]';

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
        "/add-business-partner-contact/",
        [GlobalVariables.requestBody[featureName]]);
    return response;
  }
}
