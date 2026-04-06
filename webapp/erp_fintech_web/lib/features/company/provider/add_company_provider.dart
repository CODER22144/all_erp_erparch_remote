import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class AddCompanyProvider with ChangeNotifier {
  static const String featureName = "company";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id": "compGstin","name": "GSTIN","isMandatory": false,"inputType": "text","maxCharacter": 15},{"id" : "legalName","name" : "Legal Name","isMandatory" : true,"inputType" : "text","maxCharacter" : 100},{"id" : "tradeName","name" : "Trade Name","isMandatory" : false,"inputType" : "text","maxCharacter" : 100},{"id" : "compAdd","name" : "Address","isMandatory" : true,"inputType" : "text","maxCharacter" : 100},{"id" : "compAdd1","name" : "Address 1","isMandatory" : false,"inputType" : "text","maxCharacter" : 100},{"id" : "compCity","name" : "City","isMandatory" : true,"inputType" : "text","maxCharacter" : 50},{"id" : "compZipCode","name" : "Zipcode","isMandatory" : true,"inputType" : "text","maxCharacter" : 6},{"id" : "compStateCode","name" : "State","isMandatory" : true,"inputType" : "dropdown","dropdownMenuItem" : "/get-states/"},{"id" : "compPhone","name" : "Phone","isMandatory" : true,"inputType" : "number","maxCharacter" : 10},{"id" : "compEmail","name" : "Email","isMandatory" : true,"inputType" : "text","maxCharacter" : 100},{"id" : "compCIN","name" : "CIN","isMandatory" : false,"inputType" : "text","maxCharacter" : 21},{"id" : "compPAN","name" : "PAN","isMandatory" : true,"inputType" : "text","maxCharacter" : 10},{"id" : "bankName","name" : "Bank Name","isMandatory" : false,"inputType" : "text","maxCharacter" : 50},{"id" : "accountNo","name" : "Account No.","isMandatory" : false,"inputType" : "text","maxCharacter" : 20},{"id" : "ifscCode","name" : "IFSC Code","isMandatory" : false,"inputType" : "text","maxCharacter" : 11},{"id" : "adCode","name" : "AD Code","isMandatory" : false,"inputType" : "text","maxCharacter" : 15},{"id" : "swiftCode","name" : "Swift Code","isMandatory" : false,"inputType" : "text","maxCharacter" : 10}]';

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
        .post("/create-company/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }
}
