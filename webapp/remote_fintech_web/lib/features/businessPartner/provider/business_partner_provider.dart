import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class BusinessPartnerProvider with ChangeNotifier {
  static const String featureName = "businessPartner";
  static const String reportFeature = "businessPartnerSaleDiscount";
  static const String reportInfoFeature = "businessPartnerPaymentInfo";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  TextEditingController editController = TextEditingController();

  List<dynamic> bpSaleDiscount = [];
  List<dynamic> bpPaymentInfo = [];

  List<SearchableDropdownMenuItem<String>> bpCodes = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  String jsonData =
      '[{"id":"bpCode","name":"Business Partner Code","isMandatory":true,"inputType":"text"},{"id":"bpName","name":"BusinessPartnerName","isMandatory":true,"inputType":"text"},{"id":"bpTradeName","name":"Trade Name","isMandatory":false,"inputType":"text"},{"id":"ctid","name":"Company Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-company-type/"},{"id":"bpType","name":"Business Partner Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-business-partner-type/"},{"id":"bpGSTType","name":"Gst Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/gst-type/"},{"id":"bpGSTIN","name":"GSTIN","isMandatory":false,"inputType":"text"},{ "id": "slId", "name": "Supply Type", "isMandatory": true, "inputType": "dropdown", "dropdownMenuItem": "/get-supply-type/" }, { "id": "stId", "name": "Supplier Type", "isMandatory": true, "inputType": "dropdown", "dropdownMenuItem": "/get-supplier-type/" },{"id": "tdsCode","name": "TDS Code","isMandatory": true,"inputType": "dropdown","dropdownMenuItem": "/get-tds/"},{"id":"tcsEnabled","name":"TCS Enabled","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/"},{"id":"R_Tcs","name":"R_Tcs","isMandatory":true,"inputType":"number"},{"id":"itcCreditable","name":"ITC Creditable","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/"},{"id":"brType","name":"Business Relation Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-business-relation-type/"},{"id":"discType","name":"Discount Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-discount-type/"},{"id":"discRate","name":"Discount Rate","isMandatory":true,"inputType":"number"},{"id":"loyaltyDisc","name":"Loyalty Discount","isMandatory":true,"inputType":"number"},{"id":"paymentDisc","name":"Payment Discount","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-payment-term/", "default" : 0},{"id":"bpAdd","name":"BusinessPartnerAddress","isMandatory":true,"inputType":"text"},{"id":"bpAdd1","name":"BusinessPartnerAddress1","isMandatory":false,"inputType":"text"},{"id":"bpCity","name":"BusinessPartnerCity","isMandatory":true,"inputType":"text"},{"id":"bpState","name":"State","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-states/"},{"id":"bpZipCode","name":"ZipCode","isMandatory":true,"inputType":"text"},{"id":"bpDistance","name":"Distance","isMandatory":true,"inputType":"number"},{"id":"bpCountry","name":"Country","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-countries/"},{"id":"bpPhone","name":"BusinessPartnerPhone","isMandatory":true,"inputType":"text"},{"id":"bpWhatsApp","name":"BusinessPartnerWhatsApp","isMandatory":false,"inputType":"text"},{"id":"bpEmail","name":"Email","isMandatory":true,"inputType":"email"},{"id":"contactPerson","name":"Contact Person","isMandatory":true,"inputType":"text"},{"id":"designation","name":"Designation","isMandatory":true,"inputType":"text"},{"id":"bpConnected","name":"Business Partner Connected","isMandatory":false,"inputType":"text"}]';

  void reset() {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    notifyListeners();
  }

  void getBusinessPartnerCodes() async {
    bpCodes = await formService.getDropdownMenuItem("/get-business-partner/");
    notifyListeners();
  }

  void initWidget() async {
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
          defaultValue: element['default'],
          controller: controller));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void initEditWidget() async {
    Map<String, dynamic> editMapData = await getByIdBusinessPartner();
    GlobalVariables.requestBody[featureName] = editMapData;
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
          controller: controller,
          defaultValue: editMapData[element['id']]));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/add-business-partner/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-business-partner/",
        [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<Map<String, dynamic>> getByIdBusinessPartner() async {
    http.StreamedResponse response = await networkService
        .get("/get-business-partner/${editController.text}/");
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"bpName","name":"Business Partner Name","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"bpState","name":"State","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-states/"},{"id":"discType","name":"Discount Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-discount-type/"},{"id":"brType","name":"BR Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-business-relation-type/"}]';

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

  void getLedgerReport() async {
    bpSaleDiscount.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-bp-sale-discount/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      bpSaleDiscount = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void initPaymentInfoReport() async {
    GlobalVariables.requestBody[reportInfoFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"bpName","name":"Business Partner Name","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"bpState","name":"State","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-states/"}]';

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
    await formService.generateDynamicForm(formFieldDetails, reportInfoFeature);
    reportWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getPaymentInfoReport() async {
    bpPaymentInfo.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-bp-payment-info/", GlobalVariables.requestBody[reportInfoFeature]);
    if (response.statusCode == 200) {
      bpPaymentInfo = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }



}
