import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';
import '../../utility/models/forms_UI.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:http/http.dart' as http;

class BankTestProvider with ChangeNotifier {
  static const featureName = 'BankTest';

  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  List<FormUI> formFieldDetails = [];

  TextEditingController editController = TextEditingController();

  List<dynamic> payInRep = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  String jsonData = "";

  void initWidget() async {
    http.StreamedResponse response = await networkService
        .post("/get-form-comp/", {"formName": "BankDetails"});

    if (response.statusCode == 200) {
      jsonData = await response.stream.bytesToString();
    }




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
          defaultValue: element['default'],
          controller: controller));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response =
    await networkService.post("/add-bank-test/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }



}
