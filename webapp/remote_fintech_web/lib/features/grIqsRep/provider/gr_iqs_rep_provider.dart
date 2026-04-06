import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class GrIqsRepProvider with ChangeNotifier {
  static const String featureName = "grIqsRep";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<dynamic> grIqsPending = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"grdId","name":"ID","isMandatory":true,"inputType":"number"},{"id":"machineno","name":"Machine No","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"lotSize","name":"Lot Size","isMandatory":true,"inputType":"number"},{"id":"sampleSize","name":"Sample Size","isMandatory":true,"inputType":"number"},{"id":"defect","name":"Defect","isMandatory":false,"inputType":"text","maxCharacter":40},{"id":"defectDescription","name":"Defect Description","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"suggestion","name":"Suggestion","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"testType","name":"Test Type","isMandatory":true,"inputType":"text","maxCharacter":30},{"id":"testItem","name":"Test Item","isMandatory":true,"inputType":"text","maxCharacter":30},{"id":"testName","name":"Test Name","isMandatory":false,"inputType":"text","maxCharacter":30},{"id":"instName","name":"Instrument Name","isMandatory":false,"inputType":"text","maxCharacter":30},{"id":"lowerLimit","name":"Lower Limit","isMandatory":true,"inputType":"text","maxCharacter":20},{"id":"higherLimit","name":"Higher Limit","isMandatory":true,"inputType":"text","maxCharacter":20},{"id":"ov1","name":"Observation 1","isMandatory":false,"inputType":"text","maxCharacter":20},{"id":"ov2","name":"Observation 2","isMandatory":false,"inputType":"text","maxCharacter":20},{"id":"ov3","name":"Observation 3","isMandatory":false,"inputType":"text","maxCharacter":20},{"id":"ov4","name":"Observation 4","isMandatory":false,"inputType":"text","maxCharacter":20},{"id":"ov5","name":"Observation 5","isMandatory":false,"inputType":"text","maxCharacter":20},{"id":"ov6","name":"Observation 6","isMandatory":false,"inputType":"text","maxCharacter":20},{"id":"ov7","name":"Observation 7","isMandatory":false,"inputType":"text","maxCharacter":20},{"id":"ov8","name":"Observation 8","isMandatory":false,"inputType":"text","maxCharacter":20},{"id":"ov9","name":"Observation 9","isMandatory":false,"inputType":"text","maxCharacter":20},{"id":"ov10","name":"Observation 10","isMandatory":false,"inputType":"text","maxCharacter":20},{"id":"remark","name":"Remark","isMandatory":true,"inputType":"text","maxCharacter":100},{"id":"qcStatus","name":"QC Status","isMandatory":true,"inputType":"number"},{"id":"checkedBy","name":"Checked By","isMandatory":true,"inputType":"number"}]';

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
    http.StreamedResponse response = await networkService.post(
        "/add-gr-iqs-rep/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void getGrIqsPending() async {
    grIqsPending.clear();
    http.StreamedResponse response =
    await networkService.get("/get-gr-iqs-pending/");
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      grIqsPending = data;
    }
    notifyListeners();
  }

}
