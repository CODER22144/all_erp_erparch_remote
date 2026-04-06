import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../camera/service/camera_service.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class CompanyProvider with ChangeNotifier {
  static const String featureName = "company";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  List<dynamic> compRep = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  TextEditingController editController = TextEditingController();

  String jsonData =
      '[{"id": "compGstin","name": "GSTIN","isMandatory": false,"inputType": "text","maxCharacter": 15},{"id" : "legalName","name" : "Legal Name","isMandatory" : true,"inputType" : "text","maxCharacter" : 100},{"id" : "tradeName","name" : "Trade Name","isMandatory" : false,"inputType" : "text","maxCharacter" : 100},{"id" : "compAdd","name" : "Address","isMandatory" : true,"inputType" : "text","maxCharacter" : 100},{"id" : "compAdd1","name" : "Address 1","isMandatory" : false,"inputType" : "text","maxCharacter" : 100},{"id" : "compCity","name" : "City","isMandatory" : true,"inputType" : "text","maxCharacter" : 50},{"id" : "compZipCode","name" : "Zipcode","isMandatory" : true,"inputType" : "text","maxCharacter" : 6},{"id" : "compStateCode","name" : "State","isMandatory" : true,"inputType" : "dropdown","dropdownMenuItem" : "/get-states/"},{"id" : "compCountryCode","name" : "Country","isMandatory" : true,"inputType" : "dropdown","dropdownMenuItem" : "/get-countries/", "default" : "IN"},{"id" : "compPhone","name" : "Phone","isMandatory" : true,"inputType" : "number","maxCharacter" : 10},{"id" : "compEmail","name" : "Email","isMandatory" : true,"inputType" : "text","maxCharacter" : 100},{"id" : "compCIN","name" : "CIN","isMandatory" : false,"inputType" : "text","maxCharacter" : 21},{"id" : "compPAN","name" : "PAN","isMandatory" : true,"inputType" : "text","maxCharacter" : 10},{"id" : "bankCode","name" : "Bank Code","isMandatory" : true,"inputType" : "text","maxCharacter" : 10},{"id" : "bankName","name" : "Bank Name","isMandatory" : false,"inputType" : "text","maxCharacter" : 50},{"id" : "accountNo","name" : "Account No.","isMandatory" : false,"inputType" : "text","maxCharacter" : 20},{"id" : "ifscCode","name" : "IFSC Code","isMandatory" : false,"inputType" : "text","maxCharacter" : 11},{"id" : "adCode","name" : "AD Code","isMandatory" : false,"inputType" : "text","maxCharacter" : 15},{"id" : "swiftCode","name" : "Swift Code","isMandatory" : false,"inputType" : "text","maxCharacter" : 10},{"id" : "clientCode","name" : "Client Code","isMandatory" : true,"inputType" : "text","maxCharacter" : 10}, {"id" : "productCode","name" : "Product Code","isMandatory" : true,"inputType" : "text","maxCharacter" : 10}]';

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    for (var element in jsonDecode(jsonData)) {

      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          controller: TextEditingController(),
          defaultValue: element['default'],
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

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService
        .post("/update-company/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void setMediaPath(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.uploadDocuments(blob, name, "/upload-company/", "UC");
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["compMediaPath"] = blobUrl;
    }
    notifyListeners();
  }

  void setLogo(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.uploadDocuments(blob, name, "/upload-company/", "UC");
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["compLogo"] = blobUrl;
    }
    notifyListeners();
  }

  void setBrandLogo(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.uploadDocuments(blob, name, "/upload-company/", "UC");
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["compBrandLogo"] = blobUrl;
    }
    notifyListeners();
  }

  void setDocLogo(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.uploadDocuments(blob, name, "/upload-company/", "UC");
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["compDocLogo"] = blobUrl;
    }
    notifyListeners();
  }

  void setCompMedia(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.uploadDocuments(blob, name, "/upload-company/", "UC");
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["compMedia"] = blobUrl;
    }
    notifyListeners();
  }

  void setSignImage(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.uploadDocuments(blob, name, "/upload-company/", "UC");
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["signImage"] = blobUrl;
    }
    notifyListeners();
  }

  void getCompanyReport() async {
    compRep.clear();
    http.StreamedResponse response = await networkService.get(
        "/get-company/");
    if (response.statusCode == 200) {
      compRep = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  Widget viewDoc(String? docUrl, String label) {
    return Visibility(
      visible: checkForEmptyOrNullString(docUrl),
      child: ElevatedButton(
          onPressed: () async {
            final Uri uri = Uri.parse("${NetworkService.baseUrl}$docUrl");
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
            } else {
              throw 'Could not launch $docUrl';
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: HexColor("#0038a8"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3), // Square shape
            ),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          ),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
  }

  void initEditWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    Map<String, dynamic> editMapData = await getByIdCompany();
    GlobalVariables.requestBody[featureName] = editMapData;

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255,
          defaultValue: editMapData[element['id']],
          controller: controller));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<Map<String, dynamic>> getByIdCompany() async {
    http.StreamedResponse response = await networkService
        .post("/get-company-id/", {"cid": editController.text});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }


}
