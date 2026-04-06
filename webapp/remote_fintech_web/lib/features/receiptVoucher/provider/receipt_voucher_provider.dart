import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../common/widgets/custom_dropdown_field.dart';
import '../../common/widgets/custom_text_field.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';
import '../../utility/services/generate_form_service.dart';

class ReceiptVoucherProvider with ChangeNotifier {
  static const String featureName = "receiptVoucher";
  static const String reportFeature = "receiptVoucherReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  List<SearchableDropdownMenuItem<String>> supplyType = [];

  List<SearchableDropdownMenuItem<String>> hsnCodes = [];

  List<dynamic> paymentVoucherRep = [];

  TextEditingController hsnController = TextEditingController();
  TextEditingController editController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController gstRateController = TextEditingController();
  TextEditingController gstAmountController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();

  SearchableDropdownController<String> supplyController =
  SearchableDropdownController<String>();

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  String jsonData =
      '[{"id":"No","name":"Voucher Number","isMandatory":false,"inputType":"text","maxCharacter":16},{"id":"Dt","name":"Date","isMandatory":true,"inputType":"datetime"},{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"naration","name":"Narration","isMandatory":true,"inputType":"text","maxCharacter":100},{"id":"AssAmt","name":"Assessable Amount","isMandatory":true,"inputType":"number"},{"id":"mop","name":"Mode of Payment","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-mop/"},{"id":"payRefno","name":"Payment Reference Number","isMandatory":false,"inputType":"text","maxCharacter":20}]';

  void initWidget() async {
    supplyController.clear();
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
          eventTrigger: element['id'] == 'AssAmt' ? calculateGstAmount : null,
          controller: controller));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    // initCustomObject();
    customObjects({});
  }

  Future<Map<String, dynamic>> getByIdPaymentVoucher() async {
    http.StreamedResponse response =
    await networkService.post("/get-receipt-voucher/", {"No" : editController.text});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }


  void initEditWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    widgetList.clear();
    formFieldDetails.clear();
    Map<String, dynamic> editMapData =
    await getByIdPaymentVoucher();
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
          eventTrigger: element['id'] == 'AssAmt' ? calculateGstAmount : null,
          defaultValue: editMapData[element['id']]));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    customObjects(editMapData);
  }

  void customObjects(Map<String, dynamic> editMapData) async {
    hsnCodes = await formService.getDropdownMenuItem("/get-hsn/");

    widgetList.insertAll(8, [
      Container(
        padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "",
                style: TextStyle(color: Colors.red),
              )
            ],
            text: "HSN Code",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      CustomDropdownField(
          field: FormUI(
              id: "hsnCode",
              name: "Hsn Code",
              isMandatory: false,
              defaultValue: editMapData['hsnCode'],
              inputType: "dropdown"),
          dropdownMenuItems: hsnCodes,
          customFunction: () async {
            http.StreamedResponse response = await networkService
                .get("/get-hsn-code/${GlobalVariables.requestBody[featureName]['hsnCode']}/");
            if(response.statusCode == 200) {
              gstRateController.text = jsonDecode(await response.stream.bytesToString())[0]['gstTaxRate'].toString();
            } else {
              gstRateController.text = "0.00";
            }
            GlobalVariables.requestBody[featureName]['GstRt'] = gstRateController.text;
            calculateGstAmount();
          },
          feature: featureName),
    ]);

    widgetList.insertAll(12,[
      Container(
        padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "*",
                style: TextStyle(color: Colors.red),
              )
            ],
            text: "Gst Rate",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      CustomTextField(
        field: FormUI(
            id: "GstRt",
            name: "Gst Rate",
            isMandatory: false,
            inputType: "text",
            defaultValue: editMapData['GstRt'] ?? 0.00,
            controller: gstRateController),
        customMethod: calculateGstAmount,
        feature: featureName,
        inputType: TextInputType.number,
      ),
      Container(
        padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "*",
                style: TextStyle(color: Colors.red),
              )
            ],
            text: "Gst Amount",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      CustomTextField(
        field: FormUI(
            id: "gstAmount",
            name: "Gst Rate",
            isMandatory: false,
            inputType: "text",
            readOnly: true,
            defaultValue: editMapData['gstAmount'] ?? 0.00,
            controller: gstAmountController),
        feature: featureName,
        inputType: TextInputType.number,
      ),
    ]);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo(bool manual) async {
    var payload = manual ? [GlobalVariables.requestBody[featureName]] : GlobalVariables.requestBody[featureName];
    http.StreamedResponse response = await networkService.post(
        "/create-receipt-voucher/", payload);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-receipt-voucher/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"No","name":"Voucher Number","isMandatory":false,"inputType":"text","maxCharacter":16},{"id":"lcode","name":"Ledger Code","isMandatory":false,"inputType":"text","maxCharacter":10},{"id":"IgstOnIntra","name":"IGST On Intra","isMandatory":false,"inputType":"text","maxCharacter":1},{"id":"fdate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

    for (var element in jsonDecode(jsonData)) {
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          controller: TextEditingController(),
          defaultValue: element['default'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, reportFeature);
    reportWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getPaymentVoucherReport() async {
    paymentVoucherRep.clear();
    http.StreamedResponse response = await networkService.post(
        "/receipt-voucher-rep/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      paymentVoucherRep = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void calculateGstAmount() {
    gstAmountController.text = (parseEmptyStringToDouble(
        GlobalVariables.requestBody[featureName]['AssAmt'].toString()) *
        parseEmptyStringToDouble(
            GlobalVariables.requestBody[featureName]['GstRt'].toString()) *
        0.01)
        .toStringAsFixed(2);


    GlobalVariables.requestBody[featureName]['gstAmount'] =
        gstAmountController.text;
  }
}
