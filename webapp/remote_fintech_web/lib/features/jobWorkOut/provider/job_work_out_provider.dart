import 'dart:convert';

import 'package:fintech_new_web/features/common/widgets/custom_text_field.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class JobWorkOutProvider with ChangeNotifier {
  static const String featureName = "JobWorkOut";
  static const String reportFeature = "JobWorkOutReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];

  List<dynamic> jobWorkoutReport = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  TextEditingController matController = TextEditingController();
  TextEditingController qtyController = TextEditingController();

  List<List<TextEditingController>> rowControllers = [];

  void initWidget() async {
    matController.clear();
    qtyController.clear();
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"bpCode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"jpId","name":"Job Process","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-job-process/"},{"id":"goodsType","name":"Goods Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-jw-goods-type/"},{"id":"reqId","name":"Req ID","isMandatory":false,"inputType":"dropdown", "dropdownMenuItem" : "/get-req-job-work-pending/"},{"id":"transMode","name":"Trans Mode","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-trans-mode/"},{"id":"carId","name":"Carrier","isMandatory":false,"inputType":"dropdown", "dropdownMenuItem" : "/get-carrier/"},{"id":"grNo","name":"Gr No.","isMandatory":false,"inputType":"text","maxCharacter":25},{"id":"grDate","name":"Gr Date","isMandatory":false,"inputType":"datetime"},{"id":"vehicleNo","name":"Vehicle No","isMandatory":false,"inputType":"number","maxCharacter":15},{"id":"ewbno","name":"Eway Bill No.","isMandatory":false,"inputType":"text","maxCharacter":15}]';

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
         eventTrigger: element['id'] == 'reqId' ? autoFillDetailsByReqId : null));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    initCustomObject();
  }

  void initCustomObject() {
    widgetList.insert(
        4,
        CustomTextField(
            field: FormUI(
                id: "matnoReturn",
                name: "Material no.",
                isMandatory: true,
                inputType: "text",
                controller: matController,
                maxCharacter: 15,
                readOnly: true),
            feature: featureName,
            inputType: TextInputType.text));
    widgetList.insert(
      5,
      CustomTextField(
          field: FormUI(
              id: "qty",
              name: "Qty",
              isMandatory: true,
              inputType: "text",
              controller: qtyController,
              readOnly: true),
          feature: featureName,
          inputType: TextInputType.text),
    );
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo(
      List<List<String>> tableRows) async {
    List<Map<String, dynamic>> jobWorkOutDetails = [];
    for (int i = 0; i < tableRows.length; i++) {
      jobWorkOutDetails.add({
        "matno": tableRows[i][0] == "" ? null : tableRows[i][0],
        "qty": tableRows[i][1] == "" ? null : tableRows[i][1],
      });
    }
    GlobalVariables.requestBody[featureName]['JobWorkOutDetails'] =
        jobWorkOutDetails;
    http.StreamedResponse response = await networkService.post(
        "/add-job-work-out/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> addJobWorkOut() async {
    http.StreamedResponse response = await networkService.post(
        "/add-job-work-out-auto/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void autoFillDetailsByReqId() async {
    var reqId = GlobalVariables.requestBody[featureName]['reqId'];
    if (reqId != null && reqId != "") {
      http.StreamedResponse response =
          await networkService.post("/get-req-id/", {"reqId": reqId});
      if (response.statusCode == 200) {
        var details = jsonDecode(await response.stream.bytesToString())[0];
        matController.text = details['matno'];
        qtyController.text = details['qty'];

        GlobalVariables.requestBody[featureName]['matnoReturn'] =
            details['matno'];
        GlobalVariables.requestBody[featureName]['qty'] = details['qty'];
      }
    }
    notifyListeners();
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"bpCode","name":"Party Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"}, {"id":"matno","name":"Material No.","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"fdate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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

  void getJobWorkoutReport() async {
    jobWorkoutReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-job-workout-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      jobWorkoutReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void initDetailsTab(List<List<String>> tableRows) {
    rowControllers = tableRows
        .map((row) => row.map((field) => TextEditingController(text: field)).toList())
        .toList();
    notifyListeners();
  }

  void deleteRowController(int index) {
    rowControllers.removeAt(index);
    notifyListeners();
  }

  void addRowController() {
    rowControllers.add([
      TextEditingController(),
      TextEditingController(),
    ]);
    notifyListeners();
  }
}
