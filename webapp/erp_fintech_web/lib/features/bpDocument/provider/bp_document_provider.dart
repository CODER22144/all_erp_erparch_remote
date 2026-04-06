import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class BusinessPartnerDocumentProvider with ChangeNotifier {
  String featureName = "businessPartnerDocument";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id": "bpCode","name": "Business Partner Code","isMandatory": true,"inputType": "text","maxCharacter": 10  },  {"id": "bpRegform","name": "Registration Form","isMandatory": true,"inputType": "fileUpload"  },  {"id": "gstreg06","name": "Registration Form 6","isMandatory": true,"inputType": "fileUpload"  },  {"id": "mcaMasterData","name": "Master Data","isMandatory": true,"inputType": "fileUpload"  },  {"id": "paymentProof","name": "Payment Proof","isMandatory": true,"inputType": "fileUpload"  },  {"id": "panCard","name": "PAN Card","isMandatory": true,"inputType": "fileUpload"  },  {"id": "aadharCard","name": "Aadhar Card","isMandatory": true,"inputType": "fileUpload"},{"id": "msmeNo","name": "MSME No.","isMandatory": true,"inputType": "fileUpload"},{"id": "msmeCertificate","name": "MSME Cartificate","isMandatory": true,"inputType": "fileUpload"},{"id": "balanceSheet","name": "Balance Sheet","isMandatory": true,"inputType": "fileUpload"}]';

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("auth_token");
    GlobalVariables.multipartRequest.headers.addAll({
      'Content-Type': 'application/x-www-form-urlencoded',
      "Authorization": "Bearer $token"
    });
    GlobalVariables.multipartRequest.fields
        .addAll({"bpCode": GlobalVariables.requestBody[featureName]["bpCode"]});
    http.StreamedResponse response =
        await GlobalVariables.multipartRequest.send();
    return response;
  }
}
