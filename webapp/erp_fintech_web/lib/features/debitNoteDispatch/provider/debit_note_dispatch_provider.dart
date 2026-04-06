import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';


class DebitNoteDispatchProvider with ChangeNotifier {
  String featureName = "debitNoteDispatch";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"docno","name":"Debit Note No.","isMandatory":true,"inputType":"number"},{"id":"dispDate","name":"Date Of Dispath","isMandatory":true,"inputType":"datetime"},{"id":"transportName","name":"Transport Name","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"vehicleNo","name":"Vehicle No.","isMandatory":false,"inputType":"text","maxCharacter":20},{"id":"ewayBillNo","name":"Eway Bill No.","isMandatory":false,"inputType":"text"}]';

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
        "/add-debit-note-dispatch/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }
}