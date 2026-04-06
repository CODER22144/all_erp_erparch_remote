import 'dart:convert';

import 'package:fintech_new_web/features/common/widgets/custom_dropdown_field.dart';
import 'package:fintech_new_web/features/common/widgets/custom_text_field.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';
import '../../utility/services/generate_form_service.dart';

class PaymentClearProvider with ChangeNotifier {
  static const String featureName = "paymentClear";
  static const String clearFeature = "UnadjustedPaymentClear";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<dynamic> paymentAdvancePending = [];
  List<dynamic> paymentUnadjustedPending = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  List<SearchableDropdownMenuItem<String>> voucherType = [];
  SearchableDropdownController<String> voucherTypeController =
      SearchableDropdownController<String>();


  TextEditingController bamountController = TextEditingController();

  TextEditingController vtypeController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  void initWidget(String details) async {
    voucherTypeController.clear();
    bamountController.clear();
    var data = jsonDecode(details);
    String jsonData =
        '[{"id":"payId","name":"Pay ID","isMandatory":true,"inputType":"number", "default" : "${data['payId']}"},{"id":"payType","name":"Pay Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-pay-type/", "default" : "O"},{"id":"amount","name":"Amount","isMandatory":true,"inputType":"number", "default" : "${data['unadjusted']}"},{"id":"clnaration","name":"Naration","isMandatory":false,"inputType":"text","maxCharacter":100}]';

    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      if((data['vtype'] == 'D' || data['vtype'] == 'T') && element['id'] == 'payType') {
        continue;
      }
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255,
          defaultValue: element['default'],
          controller: controller,
          readOnly: element['readOnly'] ?? false));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    initCustomWidget(data['lcode']);
  }

  void initCustomWidget(String lcode) async {
    voucherType = await formService.getDropdownMenuItem("/get-voucher-type/");
    var transIdItems = await formService
        .getDropdownMenuItem("/get-bill-pending-by-lcode/$lcode/");
    widgetList.addAll([
      CustomDropdownField(
          field: FormUI(
              id: "transId",
              name: "Transaction ID",
              isMandatory: true,
              inputType: "dropdown"),
          customFunction: getVoucherTypeBylcode,
          dropdownMenuItems: transIdItems,
          feature: featureName),
      CustomDropdownField(
          field: FormUI(
              id: "vtype",
              name: "Voucher Type",
              isMandatory: true,
              inputType: "dropdown",
              controller: voucherTypeController,
              readOnly: true),
          dropdownMenuItems: voucherType,
          feature: featureName),
      CustomTextField(
          field: FormUI(
              id: "bamount",
              name: "Balance Amount",
              isMandatory: false,
              inputType: "number",
              controller: bamountController,
              readOnly: true),
          feature: featureName,
          inputType: TextInputType.number)
    ]);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/add-payment-clear/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<http.StreamedResponse> submitFormInfoTypeD() async {
    http.StreamedResponse response = await networkService.post(
        "/add-dbnote-clear/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<http.StreamedResponse> submitFormInfoTypeT() async {
    http.StreamedResponse response = await networkService.post(
        "/add-prtax-invoice-clear/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  void getPaymentAdvancePendingReport() async {
    http.StreamedResponse response =
        await networkService.get("/get-payment-advance-pending/");
    if (response.statusCode == 200) {
      paymentAdvancePending = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void getVoucherTypeBylcode() async {
    var transId = GlobalVariables.requestBody[featureName]['transId'];
    if (transId != null && transId != "") {
      http.StreamedResponse response =
          await networkService.get("/get-bill-pending-by-transId/$transId/");
      if (response.statusCode == 200) {
        var details = jsonDecode(await response.stream.bytesToString())[0];
        var vType = findDropdownMenuItem(voucherType, details['vtype']);
        voucherTypeController.selectedItem.value = vType;
        bamountController.text = details['bamount'];
        GlobalVariables.requestBody[featureName]['vtype'] = details['vtype'];
      }
    }
    notifyListeners();
  }

  void getUnadjustedPaymentPending() async {
    paymentUnadjustedPending.clear();
    http.StreamedResponse response =
    await networkService.get("/get-unadjusted-payment-pending/");
    if (response.statusCode == 200) {
      paymentUnadjustedPending = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  // UNADJUSTED PAYMENT PENDING CLEAR

  void initClearWidget(String details) async {
    var data = jsonDecode(details);
    String jsonData =
        '[{"id":"payTransId","name":"Payment Transaction ID","isMandatory":true,"inputType":"number", "default" : "${data['docno']}"},{"id":"payVtype","name":"Payment Voucher Type","isMandatory":true,"inputType":"text", "default" : "${data['ptype']}"},{"id":"amount","name":"Amount","isMandatory":true,"inputType":"number", "default" : "${data['bamount']}"},{"id":"clnaration","name":"Naration","isMandatory":false,"inputType":"text","maxCharacter":100}]';

    GlobalVariables.requestBody[clearFeature] = {};
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
          controller: controller,
          readOnly: element['readOnly'] ?? false));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, clearFeature);
    widgetList.addAll(widgets);
    customWidget(data['lcode']);

  }

  void customWidget(String lcode) async {

    var transIdDropdown = await formService.getDropdownMenuItem("/get-bill-pending-by-lcode/$lcode/");

    widgetList.addAll([
      CustomDropdownField(
          field: FormUI(
              id: "transId",
              name: "Transaction ID",
              isMandatory: true,
              inputType: "dropdown"),
          customFunction: getVoucherType,
          dropdownMenuItems: transIdDropdown,
          feature: clearFeature),
      CustomTextField(
          field: FormUI(
              id: "vtype",
              name: "Voucher Type",
              isMandatory: true,
              inputType: "text",
              controller: vtypeController,
              readOnly: true),
          feature: clearFeature, inputType: TextInputType.text),
      CustomTextField(
          field: FormUI(
              id: "disp",
              name: "Balance Amount",
              isMandatory: false,
              inputType: "number",
              controller: amountController,
              readOnly: true),
          feature: clearFeature, inputType: TextInputType.number),
    ]);

    notifyListeners();
  }

  void getVoucherType() async {
    String transId = GlobalVariables.requestBody[clearFeature]['transId'];
    if(transId!= "" && transId != null) {
      http.StreamedResponse response =
      await networkService.get("/get-bill-pending-by-transId/$transId/");
      var details = jsonDecode(await response.stream.bytesToString())[0];
      amountController.text = details['bamount'];
      vtypeController.text = details['vtype'];

      GlobalVariables.requestBody[clearFeature]['transId'] = details['transId'];
      GlobalVariables.requestBody[clearFeature]['vtype'] = details['vtype'];
    }
    notifyListeners();
  }

  Future<http.StreamedResponse> addUnadjustedPaymentClear() async {
    http.StreamedResponse response = await networkService
        .post("/add-unadj-payment-clear/", GlobalVariables.requestBody[clearFeature]);
    return response;
  }



}
