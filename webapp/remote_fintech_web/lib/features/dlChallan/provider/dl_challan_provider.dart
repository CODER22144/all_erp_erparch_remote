import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class DlChallanProvider with ChangeNotifier {
  static const String featureName = "DlChallan";
  static const String reportFeature = "DlChallanReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];

  List<dynamic> dlChallanReport = [];

  List<List<TextEditingController>> controllers = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"No","name":"Challan No","isMandatory":false,"inputType":"number"},{"id":"Dt","name":"Challan Date","isMandatory":true,"inputType":"datetime"},{"id":"lcode","name":"Party Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"taxApplies","name":"Tax Applies","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-tf/", "default" : 0},{"id":"movementReason","name":"Movement Reason","isMandatory":true,"inputType":"text","maxCharacter":30},{"id":"Remarks","name":"Remarks","isMandatory":false,"inputType":"text","maxCharacter":250},{"id":"prodNo","name":"Product No","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"qty","name":"Quantity","isMandatory":false,"inputType":"number","default":0},{"id":"transMode","name":"Transport Mode","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-trans-mode/"},{"id":"transId","name":"Transporter ID","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"vehicleNo","name":"Vehicle No","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"transDocNo","name":"Transport Doc No","isMandatory":false,"inputType":"text","maxCharacter":16},{"id":"transDocDate","name":"Transport Doc Date","isMandatory":false,"inputType":"datetime"},{"id":"ewayBillNo","name":"Eway Bill No","isMandatory":false,"inputType":"text","maxCharacter":20},{"id":"ewayBillDate","name":"Eway Bill Date","isMandatory":false,"inputType":"datetime"}]';

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
    List<List<String>> tableRows = [
      ['', '', '', '', '', '', '', '', '', '', '']
    ];
    controllers = tableRows
        .map((row) =>
        row.map((field) => TextEditingController(text: field)).toList())
        .toList();
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo(
      List<List<String>> tableRows) async {
    List<Map<String, dynamic>> inwardDetails = [];
    for (int i = 0; i < tableRows.length; i++) {
      inwardDetails.add({
        "matno": tableRows[i][0] == "" ? null : tableRows[i][0],
        "Qty" : tableRows[i][1] == "" ? null : tableRows[i][1],
      });
    }
    GlobalVariables.requestBody[featureName]['DeliveryChallanItemDetails'] = inwardDetails;
    http.StreamedResponse response = await networkService.post(
        "/add-dl-challan/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"lcode","name":"Party Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"}, {"id":"igstOnIntra","name":"Igst On Intra","isMandatory":false,"inputType":"dropdown","dropdownMenuitem":"/get-yesno/"},{"id":"fdate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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

  void getDlChallanReport() async {
    dlChallanReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-dl-challan-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      dlChallanReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void deleteRowController(int index) {
    controllers.removeAt(index);
    notifyListeners();
  }

  void addRowController() {
    controllers.add([
      TextEditingController(),
      TextEditingController(),
    ]);
    notifyListeners();
  }
}
