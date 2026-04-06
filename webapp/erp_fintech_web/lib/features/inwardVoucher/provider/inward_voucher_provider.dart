import 'dart:convert';

import 'package:fintech_new_web/features/common/widgets/custom_text_field.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../camera/service/camera_service.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class InwardVoucherProvider with ChangeNotifier {
  static const String featureName = "inwardVoucher";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  TextEditingController editController = TextEditingController();
  // TextEditingController hsnController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  // TextEditingController discTypeController = TextEditingController();
  // TextEditingController discRateController = TextEditingController();
  // TextEditingController discAmountController = TextEditingController();
  // TextEditingController cessRateController = TextEditingController();
  // TextEditingController cessAmountController = TextEditingController();
  // TextEditingController gstRateController = TextEditingController();
  // TextEditingController gstAmountController = TextEditingController();
  // TextEditingController tcsAmountController = TextEditingController();
  // TextEditingController roffController = TextEditingController();
  // TextEditingController totalAmountController = TextEditingController();

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  String jsonData =
      '[{"id": "tDate","name": "Transaction Date","isMandatory": true,"inputType": "datetime"},{"id": "lcode","name": "Party Code","isMandatory": true,"inputType": "dropdown","dropdownMenuItem": "/get-ledger-codes/"},{"id": "billNo","name": "Bill No.","isMandatory": false,"inputType": "text","maxCharacter": 30},{"id": "billDate","name": "Bill Date","isMandatory": false,"inputType": "datetime"},{"id": "naration","name": "Naration","isMandatory": true,"inputType": "text","maxCharacter": 100},{"id": "dbCode","name": "Debit Code","isMandatory": true,"inputType": "dropdown","dropdownMenuItem": "/get-ledger-codes/"}]';

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
    initCustomObject();
  }

  void initCustomObject() async {
    List<SearchableDropdownMenuItem<String>> discTypeItems = await getDiscountType();
    widgetList.addAll([
      // Focus(
      //   onFocusChange: (hasFocus) {
      //     if(!hasFocus) {
      //       getGstTaxRate();
      //     }
      //   },
      //   child: CustomTextField(
      //       field: FormUI(
      //           id: "hsnCode",
      //           name: "HSN Code",
      //           isMandatory: true,
      //           inputType: "text",
      //           maxCharacter: 10,
      //           controller: hsnController),
      //       feature: featureName,
      //       inputType: TextInputType.number),
      // ),
      Row(
        children: [
          SizedBox(
            width: GlobalVariables.deviceWidth * 0.13,
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "*",
                    style: TextStyle(color: Colors.red),
                  )
                ],
                text: "Quantity",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Expanded(
            child: CustomTextField(
                field: FormUI(
                    id: "qty",
                    name: "Quantity",
                    isMandatory: true,
                    inputType: "number",
                    controller: qtyController),
                feature: featureName,
                inputType: TextInputType.number,
                customMethod: setCalculatedAmounts),
          ),
        ],
      ),
      Row(
        children: [
          SizedBox(
            width: GlobalVariables.deviceWidth * 0.13,
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "*",
                    style: TextStyle(color: Colors.red),
                  )
                ],
                text: "Rate",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Expanded(
            child: CustomTextField(
                field: FormUI(
                    id: "rate",
                    name: "Rate",
                    isMandatory: true,
                    inputType: "number",
                    controller: rateController),
                feature: featureName,
                inputType: TextInputType.number,
                customMethod: setCalculatedAmounts),
          ),
        ],
      ),
      Row(
        children: [
          SizedBox(
            width: GlobalVariables.deviceWidth * 0.13,
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "*",
                    style: TextStyle(color: Colors.red),
                  )
                ],
                text: "Amount",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Expanded(
            child: CustomTextField(
                field: FormUI(
                    id: "amount",
                    name: "Amount",
                    isMandatory: true,
                    inputType: "number",
                    controller: amountController,
                    defaultValue: 0,
                    readOnly: true),
                feature: featureName,
                inputType: TextInputType.number),
          ),
        ],
      ),
      // CustomDropdownField(
      //     field: FormUI(
      //         id: "discType",
      //         name: "Discount Type",
      //         isMandatory: true,
      //         inputType: "number",
      //         controller: discTypeController),
      //     feature: featureName,
      //     dropdownMenuItems: discTypeItems),
      // CustomTextField(
      //     field: FormUI(
      //         id: "rdisc",
      //         name: "Discount Rate",
      //         isMandatory: true,
      //         inputType: "number",
      //         controller: discRateController,
      //         defaultValue: 0),
      //     feature: featureName,
      //     inputType: TextInputType.number,
      //     customMethod: setCalculatedAmounts),
      // CustomTextField(
      //     field: FormUI(
      //         id: "discountAmount",
      //         name: "Discount Amount",
      //         isMandatory: true,
      //         inputType: "number",
      //         controller: discAmountController,
      //         defaultValue: 0),
      //     feature: featureName,
      //     inputType: TextInputType.number,
      //     customMethod: setCalculatedAmounts),
      // CustomTextField(
      //     field: FormUI(
      //         id: "rcess",
      //         name: "Cess Rate",
      //         isMandatory: true,
      //         inputType: "number",
      //         controller: cessRateController,
      //         defaultValue: 0),
      //     feature: featureName,
      //     inputType: TextInputType.number,
      //     customMethod: setCalculatedAmounts),
      // CustomTextField(
      //     field: FormUI(
      //         id: "cessamount",
      //         name: "Cess Amount",
      //         isMandatory: true,
      //         inputType: "number",
      //         controller: cessAmountController,
      //         defaultValue: 0,
      //         readOnly: true),
      //     feature: featureName,
      //     inputType: TextInputType.number),
      // CustomTextField(
      //     field: FormUI(
      //         id: "rgst",
      //         name: "Gst Tax Rate",
      //         isMandatory: true,
      //         inputType: "number",
      //         controller: gstRateController,
      //         defaultValue: 0,
      //         readOnly: true),
      //     feature: featureName,
      //     inputType: TextInputType.number),
      // CustomTextField(
      //     field: FormUI(
      //         id: "gstAmount",
      //         name: "Gst Amount",
      //         isMandatory: true,
      //         inputType: "number",
      //         controller: gstAmountController,
      //         defaultValue: 0,
      //         readOnly: true),
      //     feature: featureName,
      //     inputType: TextInputType.number),
      // CustomTextField(
      //     field: FormUI(
      //         id: "tcsAmount",
      //         name: "Tcs Amount",
      //         isMandatory: true,
      //         inputType: "number",
      //         controller: tcsAmountController,
      //         defaultValue: 0),
      //     feature: featureName,
      //     inputType: TextInputType.number,
      //     customMethod: setCalculatedAmounts),
      // CustomTextField(
      //     field: FormUI(
      //         id: "roff",
      //         name: "Round Off.",
      //         isMandatory: true,
      //         inputType: "number",
      //         controller: roffController,
      //         defaultValue: 0),
      //     feature: featureName,
      //     inputType: TextInputType.number,
      //     customMethod: setCalculatedAmounts),
      // CustomTextField(
      //     field: FormUI(
      //         id: "tAmount",
      //         name: "Total Amount",
      //         isMandatory: true,
      //         inputType: "number",
      //         controller: totalAmountController,
      //         defaultValue: 0,
      //         readOnly: true),
      //     feature: featureName,
      //     inputType: TextInputType.number)
    ]);
    notifyListeners();

  }

  void initEditWidget() async {
    Map<String, dynamic> editMapData = await getByIdBusinessPartner();
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

  Future<http.StreamedResponse> processFormInfo(bool manual) async {
    if(manual) {
      http.StreamedResponse response = await networkService.post(
          "/create-inward-voucher/", [GlobalVariables.requestBody[featureName]]);
      return response;
    }
    http.StreamedResponse response = await networkService.post(
        "/create-inward-voucher/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.put(
        "/update-inward-voucher/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<Map<String, dynamic>> getByIdBusinessPartner() async {
    http.StreamedResponse response =
        await networkService.get("/get-inward-voucher/${editController.text}/");
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
      GlobalVariables.requestBody[featureName]["DocProof"] = blobUrl;
    }
    notifyListeners();
  }

  void setCalculatedAmounts() {
    amountController.text = calculateAmount().toString();
    GlobalVariables.requestBody[featureName]['amount'] = amountController.text;
    // discAmountController.text = calculateDiscountAmount().toString();
    // cessAmountController.text = calculateCessAmount().toString();
    // gstAmountController.text = calculateGstAmount().toString();
    // totalAmountController.text = calculateTotalAmount().toString();
    notifyListeners();
  }

  double calculateAmount() {
    return double.parse((int.parse(
                "${GlobalVariables.requestBody[featureName]["qty"] ?? "0"}") *
            double.parse(
                "${GlobalVariables.requestBody[featureName]["rate"] ?? "0"}"))
        .toStringAsFixed(2));
  }

  double calculateTotalAmount() {
    double amount = calculateAmount();
    double discAmount = calculateDiscountAmount();
    double gstAmount = calculateGstAmount();
    double totalAmount = (amount - discAmount) +
        double.parse(
            "${GlobalVariables.requestBody[featureName]['cessamount'] ?? "0"}") +
        double.parse(
            "${GlobalVariables.requestBody[featureName]['roff'] ?? "0"}") +
        double.parse(
            "${GlobalVariables.requestBody[featureName]['tcsAmount'] ?? "0"}") +
        gstAmount;
    return double.parse(totalAmount.toStringAsFixed(2));
  }

  double calculateGstAmount() {
    double amount = calculateAmount();
    double discAmount = calculateDiscountAmount();
    double gstAmount = (amount - discAmount) *
        double.parse(
            "${GlobalVariables.requestBody[featureName]['rgst'] ?? "0"}") *
        0.01;
    return double.parse(gstAmount.toStringAsFixed(2));
  }

  double calculateDiscountAmount() {
    String discType =
        GlobalVariables.requestBody[featureName]['discType'] ?? "";
    double discAmount = 0;
    double amount = calculateAmount();
    if (discType == "P") {
      discAmount = (amount *
          double.parse(
              "${GlobalVariables.requestBody[featureName]["rdisc"] ?? "0"}") *
          0.01);
    }
    if (discType == "F") {
      discAmount = double.tryParse(
              "${GlobalVariables.requestBody[featureName]['discountAmount']}") ??
          0;
    }
    return double.parse(discAmount.toStringAsFixed(2));
  }

  double calculateCessAmount() {
    double amount = calculateAmount();
    double discAmount = calculateDiscountAmount();
    double cessAmount = (amount - discAmount) *
        double.parse(
            "${GlobalVariables.requestBody[featureName]["rcess"] ?? "0"}") *
        0.01;
    return double.parse(cessAmount.toStringAsFixed(2));
  }

  // void getGstTaxRate() async {
  //   NetworkService networkService = NetworkService();
  //   if (hsnController.text != null && hsnController.text != "") {
  //     http.StreamedResponse response =
  //         await networkService.get("/get-hsn/${hsnController.text}/");
  //     if (response.statusCode == 200) {
  //       var hsnDetails = jsonDecode(await response.stream.bytesToString());
  //       gstRateController.text = hsnDetails[0]['gstTaxRate'] ?? "0";
  //       GlobalVariables.requestBody[featureName]['rgst'] = gstRateController.text;
  //       notifyListeners();
  //     } else {
  //       gstRateController.text = "0";
  //       GlobalVariables.requestBody[featureName]['rgst'] = gstRateController.text;
  //     }
  //   }
  //   setCalculatedAmounts();
  // }

  Future<List<SearchableDropdownMenuItem<String>>> getDiscountType() async {
    List<SearchableDropdownMenuItem<String>> discountType = [];
    http.StreamedResponse response =
    await networkService.get("/get-discper-type/");
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      for (var element in data) {
        discountType.add(SearchableDropdownMenuItem(
            value: "${element["discType"]}",
            child: Text("${element["discDescription"]}"),
            label: "${element["discDescription"]}"));
      }
    }
    return discountType;
  }

}
