import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../camera/service/camera_service.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class OrderTransportProvider with ChangeNotifier {
  static const String featureName = "OrderTransport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<dynamic> pendingReport = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  String jsonData =
      '[{"id":"orderid","name":"Order Id","isMandatory":true,"inputType":"number", "readOnly":true},{"id":"grno","name":"Gr No.","isMandatory":true,"inputType":"text","maxCharacter":30},{"id":"grDate","name":"GR Date","isMandatory":true,"inputType":"datetime"},{"id":"carrierName","name":"Carrier Name","isMandatory":true,"inputType":"text","maxCharacter":50},{"id":"freight","name":"Freight","isMandatory":true,"inputType":"number"}]';

  void initWidget(String orderId) async {
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
          defaultValue: element['id'] == "orderid" ? orderId : element['default'],
          controller: controller,
          readOnly: element['readOnly'] ?? false));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService
        .post("/add-order-transport/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void setImagePath(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.getBlobUrl(blob, name);
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["grUrl"] = blobUrl;
    }
    notifyListeners();
  }

  void getOrderPending() async {
    pendingReport.clear();
    http.StreamedResponse response =
    await networkService.get("/get-order-transport-pending/");
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      pendingReport = data;
    }
    notifyListeners();
  }
}
