import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../camera/service/camera_service.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class BillPayableProvider with ChangeNotifier {
  static const String featureName = "billPayable";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id": "tdate","name": "To Date","isMandatory": true,"inputType": "datetime"},{"id": "lcode","name": "Party Code","isMandatory": true,"inputType": "dropdown","dropdownMenuItem": "/get-ledger-codes/"},{"id": "dbCode","name": "Debit Code","isMandatory": true,"inputType": "dropdown","dropdownMenuItem": "/get-ledger-codes/"}, {"id" : "bpt", "name" : "Bill Payable Type", "isMandatory" : true, "inputType" : "dropdown", "dropdownMenuItem" : "/get-bill-payable-type/"},{"id": "billNo","name": "Bill No.","isMandatory": false,"inputType": "text","maxCharacter": 30},{"id": "billDate","name": "Bill Date","isMandatory": false,"inputType": "datetime"},{"id": "naration","name": "Naration","isMandatory": true,"inputType": "text","maxCharacter": 100},{"id": "amount","name": "Amount","isMandatory": true,"inputType": "number", "default": 0}]';

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
    http.StreamedResponse response = await networkService
        .post("/add-bill-payable/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  void setDocProof(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.getBlobUrl(blob, name);
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["DocProof"] = blobUrl;
    }
    notifyListeners();
  }
}
