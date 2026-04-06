import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class ExportOrderProvider with ChangeNotifier {
  static const String featureName = "ExportOrder";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  TextEditingController editController = TextEditingController();
  List<dynamic> colorReport = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  String jsonData =
      '[{"id":"orderId","name":"Order Id","isMandatory":true,"inputType":"number"},{"id":"curCode","name":"Currency","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-currency/"},{"id":"conRate","name":"Conversion Rate","isMandatory":true,"inputType":"number"},{"id":"goodsDescription","name":"Goods Description","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"termOfDelivery","name":"Terms Of Delivery","isMandatory":false,"inputType":"text","maxCharacter":200},{"id":"lutno","name":"Lut No.","isMandatory":false,"inputType":"text","maxCharacter":30},{"id":"preCarriageMode","name":"Pre Carriage Mode","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"placeOfReceipt","name":"Place Of Receipt","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"","name":"Loading and Discharge Port","isMandatory":true,"inputType":"row","children":[{"id":"portOfLoading","name":"Loading Port","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"portOfDischarge","name":"Port Of Discharge","isMandatory":false,"inputType":"text","maxCharacter":100}]},{"id":"finalDestination","name":"Final Destination","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"","name":"Cost, Insurance & Freight","isMandatory":true,"inputType":"row","children":[{"id":"cost","name":"Cost","isMandatory":true,"inputType":"number"},{"id":"insurance","name":"Insurance","isMandatory":true,"inputType":"number"},{"id":"freight","name":"Freight","isMandatory":true,"inputType":"number"}]},{"id":"","name":"Packets, Gross & Net Weight","isMandatory":true,"inputType":"row","children":[{"id":"pkt","name":"No. Of Packet","isMandatory":true,"inputType":"number"},{"id":"gwt","name":"Gross Weight","isMandatory":true,"inputType":"number"},{"id":"nwt","name":"Net Weight","isMandatory":true,"inputType":"number"}]}]';

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
          maxCharacter: element['maxCharacter'] ?? 255,
         children: element['children'] ?? []));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<Map<String, dynamic>> getByIdExpOrder(String orderId) async {
    http.StreamedResponse response =
    await networkService.post("/get-export-order/", {"orderId" : orderId});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEditWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    Map<String, dynamic> editMapData = await getByIdExpOrder(editController.text);
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
          defaultValue: element['inputType'] == 'row' ? editMapData : editMapData[element['id']],
          children: element['children'] ?? []));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService
        .post("/add-export-order/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService
        .post("/update-export-order/", GlobalVariables.requestBody[featureName]);
    return response;
  }

}
