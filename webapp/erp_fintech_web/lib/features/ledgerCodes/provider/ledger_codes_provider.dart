import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class LedgerCodesProvider with ChangeNotifier {
  static const String featureName = "ledgerCodes";
  static const String reportFeature = "ledgerCodesReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  List<SearchableDropdownMenuItem<String>> partyCodes = [];

  List<dynamic> ledgerReport = [];
  List<dynamic> ledgerReportSearched = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  String jsonData =
      '[{"id": "lcode", "name": "Ledger Code", "isMandatory": true, "inputType": "text" }, { "id": "lTitle", "name": "Ledger Title", "isMandatory": true, "inputType": "dropdown", "dropdownMenuItem": "/get-ledger-title/" }, { "id": "lName", "name": "Ledger Name", "isMandatory": true, "inputType": "text" }, {"id" : "crdrCode", "name" : "CR/DR Code","isMandatory" : false, "inputType" : "dropdown", "dropdownMenuItem" : "/get-ledger-codes/"} ,{ "id": "agCode", "name": "Account Group", "isMandatory": true, "inputType": "dropdown", "dropdownMenuItem": "/get-account-groups/" }, { "id": "lType", "name": "Ledger Type", "isMandatory": true, "inputType": "dropdown", "dropdownMenuItem": "/get-ledger-type/" }, { "id": "slId", "name": "Supply Type", "isMandatory": true, "inputType": "dropdown", "dropdownMenuItem": "/get-supply-type/" }, { "id": "stId", "name": "Supplier Type", "isMandatory": true, "inputType": "dropdown", "dropdownMenuItem": "/get-supplier-type/" },{"id": "tcs","name": "TCS","isMandatory": true,"inputType": "dropdown","dropdownMenuItem": "/get-yesno/"}, {"id": "tdsCode","name": "TDS Code","isMandatory": true,"inputType": "dropdown","dropdownMenuItem": "/get-tds/"}, {"id": "rc","name": "Reverse Charge","isMandatory": true,"inputType": "dropdown","dropdownMenuItem": "/get-yesno/"} ,{ "id": "lStatus", "name": "Ledger Status", "isMandatory": true, "inputType": "dropdown", "dropdownMenuItem": "/get-ledger-status/" }, { "id": "lRemark", "name": "Remarks", "isMandatory": false, "inputType": "text"}]';

  void reset() {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
  }

  void getPartyCodes() async {
    partyCodes = await formService.getDropdownMenuItem("/get-ledger-codes/");
    notifyListeners();
  }

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

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

  Future<Map<String, dynamic>> getByIdPartyCode(String partyCode) async {
    http.StreamedResponse response =
    await networkService.get("/get-ledger-code/$partyCode/");
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEditWidget(String partyCode) async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    Map<String, dynamic> editMapData = await getByIdPartyCode(partyCode);
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
        .post("/add-ledger-codes/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService
        .post("/update-ledger-codes/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"lStatus","name":"Ledger Status","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-status/"},{"id":"lName","name":"Ledger Name","isMandatory":false,"inputType":"text","maxCharacter":50},{"id":"agCode","name":"Acc. Group","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-account-groups/"},{"id":"lType","name":"Ledger Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-type/"},{"id":"slId","name":"Supply Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-supply-type/"},{"id":"stId","name":"Supplier Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-supplier-type/"},{"id":"tcs","name":"TCS","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/"},{"id":"tdsCode","name":"TDS Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-tds/"},{"id":"rc","name":"Reverse Charge","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/"}]';

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

  void getLedgerReport() async {
    ledgerReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-ledger-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      ledgerReport = jsonDecode(await response.stream.bytesToString());
      ledgerReportSearched = ledgerReport;
    }
    notifyListeners();
  }

  void search(String target, List<String> fields) {
    if (target.length >= 3) {
      ledgerReportSearched = ledgerReport.where((item) {
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
      ledgerReportSearched = ledgerReport;
    }

    notifyListeners();
  }

}
