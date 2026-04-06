import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../camera/service/camera_service.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class ResourceProvider with ChangeNotifier {
  static const String featureName = "resources";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  TextEditingController editController = TextEditingController();

  List<dynamic> resources = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  String jsonData =
      '[{"id":"resId","name":"Resource ID","isMandatory":true,"inputType":"number"},{"id":"resName","name":"Resource Name","isMandatory":true,"inputType":"text","maxCharacter":100},{"id":"resLoginUserId","name":"Resource Login ID","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/user/user-list/"},{"id":"resDesignation","name":"Designation","isMandatory":true,"inputType":"text","maxCharacter":50},{"id":"resAddress","name":"House Address","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"resAddress1","name":"Street/Locality","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"resSId","name":"State","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-states/"},{"id":"resCountryCode","name":"Country","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-countries/"},{"id":"resPinCode","name":"Pincode","isMandatory":false,"inputType":"text","maxCharacter":6},{"id":"resContactNo","name":"Contact No.","isMandatory":true,"inputType":"number","maxCharacter":10},{"id":"resAltContactNo","name":"Alternate Contact No.","isMandatory":false,"inputType":"text","maxCharacter":10},{"id":"resEmail","name":"Email","isMandatory":true,"inputType":"text","maxCharacter":100},{"id":"resAltEmail","name":"Alternate Email","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"isLeader","name":"Is Leader ?","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/"},{"id":"leaderId","name":"Leader ID","isMandatory":false,"inputType":"number"},{"id":"resStatus","name":"Status","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-working-status/"}]';

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

  void initEditWidget() async {
    Map<String, dynamic> editMapData = await getByIdResource();
    GlobalVariables.requestBody[featureName] = editMapData;
    formFieldDetails.clear();
    widgetList.clear();

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
    http.StreamedResponse response = await networkService.post(
        "/add-resources/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-resources/",
        [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<Map<String, dynamic>> getByIdResource() async {
    http.StreamedResponse response = await networkService
        .get("/get-resources/${editController.text}/");
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void setImagePath(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.getBlobUrl(blob, name);
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["resPhotoUrl"] = blobUrl;
    }
    notifyListeners();
  }

  void getResourceReport() async {
    resources.clear();
    http.StreamedResponse response = await networkService.get(
        "/get-all-res/");
    if (response.statusCode == 200) {
      resources = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }


}
