import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class MaterialRepProvider with ChangeNotifier {
  static const String featureName = "materialRep";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<dynamic> materialRepResponse = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"matno","name":"Material no.","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"chrDescription","name":"Description","isMandatory":true,"inputType":"text","maxCharacter":500},{"id":"brate","name":"Basic Rate","isMandatory":true,"inputType":"number"},{"id":"srate","name":"Scrap Rate","isMandatory":true,"inputType":"number"},{"id":"mrp","name":"MRP","isMandatory":true,"inputType":"number"},{"id":"oerate","name":"OE Rate","isMandatory":true,"inputType":"number"},{"id":"muUnit","name":"Unit","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-material-unit/"},{"id":"materialGroup","name":"Material Group","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-material-group/"},{"id":"rmType","name":"Raw Material Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-rm-type/"}]';

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
        "/get-material-rep/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void setResponse(dynamic response) {
    materialRepResponse = response;
    notifyListeners();
  }
}
