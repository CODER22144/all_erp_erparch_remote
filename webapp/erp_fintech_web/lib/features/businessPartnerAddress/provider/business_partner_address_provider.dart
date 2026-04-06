import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class BusinessPartnerAddressProvider with ChangeNotifier {
  static const String featureName = "businessPartnerAddress";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id": "bpCode","name": "Business Partner Code","isMandatory": true,"inputType": "text","maxCharacter" : 10},{"id": "bpaName","name": "Address Name","isMandatory": true,"inputType": "text","maxCharacter" : 100},{"id": "bpaAdd","name": "Address","isMandatory": true,"inputType": "text","maxCharacter" : 100},{"id": "bpaAdd1","name": "Address 2","isMandatory": false,"inputType": "text","maxCharacter" : 100},{"id": "bpaCity","name": "City","isMandatory": true,"inputType": "text","maxCharacter" : 50},{"id": "bpaState","name": "State","isMandatory": true,"inputType": "dropdown","dropdownMenuItem" : "/get-states/"},{"id": "bpaZipCode","name": "Zipcode","isMandatory": true,"inputType": "text","maxCharacter" : 6},{"id": "bpaCountry","name": "Country","isMandatory": true,"inputType": "dropdown","dropdownMenuItem" : "/get-countries/"},{"id": "bpaPhone","name": "Phone","isMandatory": true,"inputType": "number","maxCharacter" : 10},{"id": "bpaGSTIN","name": "GSTIN","isMandatory": false,"inputType": "text","maxCharacter" : 15}]';

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
        "/add-business-partner-address/",
        [GlobalVariables.requestBody[featureName]]);
    return response;
  }
}
