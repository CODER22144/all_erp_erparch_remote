import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class BusinessPartnerTaxInfoProvider with ChangeNotifier {
  static const String featureName = "businessPartnerTaxInfo";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  String jsonData =
      '[{"id": "bpCode","name": "Business Partner Code","isMandatory": true,"inputType": "text","maxCharacter": 10},{"id": "crDays","name": "Credit Days","isMandatory": true,"inputType": "number"},{"id": "paymentTerm","name": "Payment Term","isMandatory": false,"inputType": "text","maxCharacter": 100},{"id": "packing","name": "Packing","isMandatory": false,"inputType": "dropdown","dropdownMenuItem": "/get-yesno/"},{"id": "freight","name": "Mode Of Freight","isMandatory": false,"inputType": "dropdown","dropdownMenuItem": "/get-mof/"},{"id": "insurance","name": "Insurance","isMandatory": false,"inputType": "dropdown","dropdownMenuItem": "/get-yesno/"},{"id": "insurancePaid","name": "Insurance Paid","isMandatory": false,"inputType": "dropdown","dropdownMenuItem": "/get-yesno/"},{"id": "cin","name": "CIN","isMandatory": false,"inputType": "text","maxCharacter": 20},{"id": "pan","name": "PAN","isMandatory": false,"inputType": "text","maxCharacter": 10},{"id": "tan","name": "TAN","isMandatory": false,"inputType": "text","maxCharacter": 20},{"id": "pfno","name": "PF No.","isMandatory": false,"inputType": "text","maxCharacter": 20},{"id": "esino","name": "ESI No.","isMandatory": false,"inputType": "text","maxCharacter": 20},{"id": "mop","name": "Mode of Payment","isMandatory": false,"inputType": "dropdown","dropdownMenuItem": "/get-mop/"},{"id": "bankAcNo","name": "Bank Account No.","isMandatory": false,"inputType": "text","maxCharacter": 20},{"id": "bankAcType","name": "Bank Account Type","isMandatory": false,"inputType": "text","maxCharacter": 20},{"id": "bankAcName","name": "Bank Account Name","isMandatory": false,"inputType": "text","maxCharacter": 50},{"id": "bankName","name": "Bank Name","isMandatory": false,"inputType": "text","maxCharacter": 50},{"id": "bankBranch","name": "Branch Name","isMandatory": false,"inputType": "text","maxCharacter": 100},{"id": "ifscCode","name": "IFSC Code","isMandatory": false,"inputType": "text","maxCharacter": 11},{"id": "swiftCode","name": "SwiftCode","isMandatory": false,"inputType": "text","maxCharacter": 20}]';

  void reset() {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
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

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/add-business-partner-tax-info/",
        [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<Map<String, dynamic>> getByIdBusinessPartner(String id) async {
    http.StreamedResponse response = await networkService
        .post("/get-bp-tax-info/", {"taxId" : id});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEditWidget(String id) async {
    Map<String, dynamic> editMapData = await getByIdBusinessPartner(id);
    GlobalVariables.requestBody[featureName] = editMapData;
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
          controller: controller,
          defaultValue: editMapData[element['id']]));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-bp-tax-info/",
        GlobalVariables.requestBody[featureName]);
    return response;
  }
}
