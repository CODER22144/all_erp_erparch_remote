import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/custom_text_field.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class GrOtherChargesProvider with ChangeNotifier {
  static const String featureName = "grOtherCharges";
  static const String pendingFeature = "grOtherChargesPending";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  List<dynamic> grOtherChargesPending = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  TextEditingController hsnController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController gstTaxRateController = TextEditingController();
  TextEditingController gstAmountController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"grno","name":"GR No.","isMandatory":true,"inputType":"text","maxCharacter":20},{"id":"chargeName","name":"Charge Name","isMandatory":true,"inputType":"text","maxCharacter":30}]';

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
    initCustomObjects();
  }

  void initCustomObjects() {
    widgetList.addAll([
      Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            getGstTaxRate();
          }
        },
        child: CustomTextField(
            field: FormUI(
                id: "hsnCode",
                name: "HSN Code",
                isMandatory: true,
                inputType: "text",
                maxCharacter: 10,
                controller: hsnController),
            feature: featureName,
            inputType: TextInputType.number),
      ),
      CustomTextField(
          field: FormUI(
              id: "amount",
              name: "Amount",
              isMandatory: true,
              inputType: "number",
              controller: amountController),
          feature: featureName,
          inputType: TextInputType.number,
          customMethod: setCalculatedAmounts),
      CustomTextField(
          field: FormUI(
              id: "gstTaxRate",
              name: "GST Tax Rate",
              isMandatory: true,
              inputType: "number",
              controller: gstTaxRateController,
              readOnly: true),
          feature: featureName,
          inputType: TextInputType.number),
      CustomTextField(
          field: FormUI(
              id: "gstAmount",
              name: "GST Amount",
              isMandatory: true,
              inputType: "number",
              controller: gstAmountController,
              readOnly: true),
          feature: featureName,
          inputType: TextInputType.number),
      CustomTextField(
          field: FormUI(
              id: "tAmount",
              name: "Total Amount",
              isMandatory: true,
              inputType: "number",
              controller: totalAmountController,
              readOnly: true),
          feature: featureName,
          inputType: TextInputType.number),
    ]);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/add-gr-other-charges/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  void getGstTaxRate() async {
    NetworkService networkService = NetworkService();
    if (hsnController.text != null && hsnController.text != "") {
      http.StreamedResponse response =
          await networkService.get("/get-hsn/${hsnController.text}/");
      if (response.statusCode == 200) {
        var hsnDetails = jsonDecode(await response.stream.bytesToString());
        gstTaxRateController.text = hsnDetails[0]['gstTaxRate'] ?? "0";
        GlobalVariables.requestBody[featureName]['rgst'] =
            gstTaxRateController.text;
        notifyListeners();
      } else {
        gstTaxRateController.text = "0";
      }
    }
    setCalculatedAmounts();
  }

  void setCalculatedAmounts() {
    gstAmountController.text =
        (parseEmptyStringToDouble(amountController.text) *
                parseEmptyStringToDouble(gstTaxRateController.text) *
                0.01)
            .toStringAsFixed(2);
    totalAmountController.text =
        (parseEmptyStringToDouble(gstAmountController.text) +
                parseEmptyStringToDouble(amountController.text))
            .toStringAsFixed(2);

    GlobalVariables.requestBody[featureName]['amount'] = amountController.text;
    GlobalVariables.requestBody[featureName]['gstTaxRate'] =
        gstTaxRateController.text;
    GlobalVariables.requestBody[featureName]['gstAmount'] =
        gstAmountController.text;
    GlobalVariables.requestBody[featureName]['tAmount'] =
        totalAmountController.text;

    notifyListeners();
  }

  void initPendingWidget() async {
    GlobalVariables.requestBody[pendingFeature] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"repType","name":"Rep Type","isMandatory":false,"inputType":"text","maxCharacter":1, "default" : "P"},{"id":"fromDate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"toDate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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
    await formService.generateDynamicForm(formFieldDetails, pendingFeature);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void getGrOtherChargesPending() async {
    grOtherChargesPending.clear();
    http.StreamedResponse response = await networkService.post(
        "/gr-other-charges-pending/", GlobalVariables.requestBody[pendingFeature]);
    if(response.statusCode == 200) {
      grOtherChargesPending = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }
}
