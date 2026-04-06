import 'dart:convert';

import 'package:fintech_new_web/features/network/service/network_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:go_router/go_router.dart';

import '../../utility/global_variables.dart';
import '../../utility/models/forms_UI.dart';
import '../../utility/services/generate_form_service.dart';

class AuthProvider with ChangeNotifier {
  static const String featureName = "orgCompany";
  static const String userFeatureName = "users";
  static const String groupFeatureName = "orgCompanyGroups";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  List<dynamic> orgComp = [];
  List<dynamic> roles = [];
  List<dynamic> users = [];

  List<SearchableDropdownMenuItem<String>> compGroups = [];

  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  List<Widget> mainMenu = [];

  Map<String, Icon> icons = {
    "material": const Icon(Icons.add_shopping_cart_outlined),
    "purchase": const Icon(Icons.ac_unit_outlined),
    "home": const Icon(Icons.build_circle_outlined),
    "report": const Icon(Icons.file_open_outlined),
    "sale": const Icon(Icons.shopping_cart_outlined),
    "finance": const Icon(Icons.currency_rupee_outlined),
    "master": const Icon(Icons.receipt_long_outlined),
    "document": const Icon(Icons.upload_file_outlined),
  };

  Map<String, dynamic> userInfo = {};

  void initUserInfo() async {
    userInfo.clear();
    http.StreamedResponse response = await networkService.get("/user/current/");
    if (response.statusCode == 200) {
      userInfo = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void generateMenu(BuildContext context) async {
    http.StreamedResponse response = await networkService.get("/menu/");
    if (response.statusCode == 200) {
      List<dynamic> resp = jsonDecode(await response.stream.bytesToString());
      mainMenu = resolveMenu(resp, context);
    }
    notifyListeners();
  }

  List<Widget> resolveMenu(List<dynamic> menuItems, BuildContext context) {
    List<Widget> navbar = [];
    for (var data in menuItems) {
      if (data['subMenu'] != null) {
        navbar.add(ExpansionTile(
          title: Text(data['menuName']),
          leading: icons[data['icon']],
          children: resolveMenu(data['subMenu'], context),
        ));
      } else {
        navbar.add(ListTile(
          title: Text(data['menuName']),
          leading: icons[data['icon']],
          onTap: () {
            if (data['paramType'] == 'extra') {
              context.pushNamed(data['menu_route'],
                  extra: jsonDecode(data['paramValue'])['data']);
            } else if (data['paramType'] == null) {
              context.pushNamed(data['menu_route']);
            } else if (data['paramType'] == 'query') {
              context.pushNamed(data['menu_route'],
                  queryParameters: jsonDecode(data['paramValue']));
            }
          },
        ));
      }
    }

    return navbar;
  }

  void reset() {
    usernameController.clear();
    passwordController.clear();
    notifyListeners();
  }

  Future<http.StreamedResponse> login() async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request(
        'POST', Uri.parse('${NetworkService.baseUrl}/user/jwt-login/'));
    request.bodyFields = {
      'userId': usernameController.text,
      'password': passwordController.text
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<http.StreamedResponse> verifyOtp(String otp) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request(
        'POST', Uri.parse('${NetworkService.baseUrl}/user/two-factor-login/'));
    request.bodyFields = {
      'userId': usernameController.text,
      'password': passwordController.text,
      "otp_token": otp
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<http.StreamedResponse> register_2FA() async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request(
        'POST', Uri.parse('${NetworkService.baseUrl}/user/register-2fa/'));
    request.bodyFields = {
      'userId': usernameController.text,
      'password': passwordController.text,
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return response;
  }

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    String jsonData =
        r'[{"id":"cid","name":"Company ID","isMandatory":true,"inputType":"text","maxCharacter":5},{"id":"company_name","name":"Company Name","isMandatory":true,"inputType":"text","maxCharacter":100}]';

    for (var element in jsonDecode(jsonData)) {
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          controller: TextEditingController(),
          defaultValue: element['default'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          regex: element['regex'],
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/user/add-company/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void initUserWidget() async {
    GlobalVariables.requestBody[userFeatureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    String jsonData =
        '[{"id":"userId","name":"User ID","isMandatory":true,"inputType":"text","maxCharacter":50}, {"id":"password","name":"Password","isMandatory":true,"inputType":"text","maxCharacter":50},{"id":"first_name","name":"First Name","isMandatory":true,"inputType":"text","maxCharacter":100},{"id":"last_name","name":"Last Name","isMandatory":true,"inputType":"text","maxCharacter":100},{"id":"email","name":"Email","isMandatory":true,"inputType":"text","maxCharacter":60}, {"id" : "cgId", "name" : "Company Group", "isMandatory" : false, "inputType" : "dropdown", "dropdownMenuItem" : "/user/get-all-org-company-group/"}]';

    for (var element in jsonDecode(jsonData)) {
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          controller: TextEditingController(),
          defaultValue: element['default'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          regex: element['regex'],
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets = await formService.generateDynamicForm(
        formFieldDetails, userFeatureName);
    widgetList.addAll(widgets);
    getRoles();
    notifyListeners();
  }

  void getRoles() async {
    roles.clear();
    http.StreamedResponse response = await networkService.get("/user/roles/");
    if (response.statusCode == 200) {
      roles = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  Future<http.StreamedResponse> processUserFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/user/create/", GlobalVariables.requestBody[userFeatureName]);
    return response;
  }

  void getAllOrgCompanyByUser() async {
    orgComp.clear();
    http.StreamedResponse response =
        await networkService.get("/user/get-all-org-company/");
    if (response.statusCode == 200) {
      orgComp = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void getAllOrgCompanyByGroupId() async {
    orgComp.clear();
    http.StreamedResponse response =
    await networkService.get("/user/get-all-org-company-by-group/");
    if (response.statusCode == 200) {
      orgComp = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  Future<http.StreamedResponse> updateUserCid(String? cid) async {
    http.StreamedResponse response =
        await networkService.post("/user/update-cid/", {"cid": cid});
    return response;
  }

  Future<http.StreamedResponse> updateUserCompanyGroup(String? cgId, String userId) async {
    http.StreamedResponse response = await networkService
        .post("/user/update-company-group/", {"cgId": cgId, "userId" : userId});
    return response;
  }

  void initGroupWidget() async {
    GlobalVariables.requestBody[groupFeatureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    String jsonData =
        '[{"id":"group_id","name":"Group ID","isMandatory":true,"inputType":"text","maxCharacter":2},{"id":"group_description","name":"Description","isMandatory":true,"inputType":"text","maxCharacter":100}]';

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

    List<Widget> widgets = await formService.generateDynamicForm(
        formFieldDetails, groupFeatureName);
    widgetList.addAll(widgets);
    getAllOrgCompanyByUser();
  }

  Future<http.StreamedResponse> processGroupFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/user/add-company-group/",
        GlobalVariables.requestBody[groupFeatureName]);
    return response;
  }

  void getAllUsers() async {
    users.clear();
    compGroups.clear();
    http.StreamedResponse response = await networkService.get("/user/all/");
    if (response.statusCode == 200) {
      users = jsonDecode(await response.stream.bytesToString());
    }
    compGroups = await formService
        .getDropdownMenuItem("/user/get-all-org-company-group/");
    notifyListeners();
  }
}
