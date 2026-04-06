import 'dart:convert';

import 'package:fintech_new_web/features/common/widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';

import '../../common/widgets/custom_dropdown_field.dart';
import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';
import '../../utility/models/forms_UI.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:http/http.dart';

class UnadjustedPaymentInwardProvider with ChangeNotifier {
  static const String featureName = "UnadjustedPaymentInwardClear";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  TextEditingController voucherTypeController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initClearWidget(String details) async {
    var data = jsonDecode(details);
    String jsonData =
        '[{"id":"payTransId","name":"Payment Transaction ID","isMandatory":true,"inputType":"number", "default" : "${data['docno']}"},{"id":"payVtype","name":"Payment Voucher Type","isMandatory":true,"inputType":"text", "default" : "${data['ptype']}"},{"id":"amount","name":"Amount","isMandatory":true,"inputType":"number", "default" : "${data['bamount']}"},{"id":"clnaration","name":"Naration","isMandatory":false,"inputType":"text","maxCharacter":100}]';

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
          controller: controller,
          readOnly: element['readOnly'] ?? false));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    customWidget(data['lcode']);

  }

  void customWidget(String lcode) async {

    var transIdDropdown = await formService.getDropdownMenuItem("/get-payment-pending-lcode/$lcode/");


    widgetList.addAll([
      CustomDropdownField(
          field: FormUI(
              id: "transId",
              name: "Transaction ID",
              isMandatory: true,
              inputType: "dropdown"),
          customFunction: getVoucherType,
          dropdownMenuItems: transIdDropdown,
          feature: featureName),
      CustomTextField(
          field: FormUI(
              id: "vtype",
              name: "Voucher Type",
              isMandatory: true,
              inputType: "text",
              controller: voucherTypeController,
              readOnly: true),
          feature: featureName, inputType: TextInputType.text),
      CustomTextField(
          field: FormUI(
              id: "display",
              name: "Balance Amount",
              isMandatory: false,
              inputType: "number",
              controller: amountController,
              readOnly: true),
          feature: featureName, inputType: TextInputType.number),
    ]);

    notifyListeners();
  }

  void getVoucherType() async {
    String transId = GlobalVariables.requestBody[featureName]['transId'];
    GlobalVariables.requestBody[featureName]['transId'] = transId.split("|")[1];
    GlobalVariables.requestBody[featureName]['vtype'] = transId.split("|")[0];
    voucherTypeController.text = transId.split("|")[0];
    if(transId!= "" && transId != null) {
      StreamedResponse response =
          await networkService.post("/get-payment-pending-transId/", {"transId" : transId.split("|")[1], "vType" : transId.split("|")[0]});
      var details = jsonDecode(await response.stream.bytesToString())[0];
      amountController.text = details['bamount'];
    }
    notifyListeners();
  }

  Future<StreamedResponse> addUnadjustedPaymentInwardClear() async {
    StreamedResponse response = await networkService
        .post("/add-unadj-payment-inward-clear/", GlobalVariables.requestBody[featureName]);
    return response;
  }
}