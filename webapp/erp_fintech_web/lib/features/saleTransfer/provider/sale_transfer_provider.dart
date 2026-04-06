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

class SaleTransferProvider with ChangeNotifier {
  static const String featureName = "SaleTransfer";
  static const String reportFeature = "SaleTransferReport";
  static const String clearFeature = "SaleTransferClear";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  List<Widget> clearWidgetList = [];

  List<dynamic> paymentPending = [];
  List<dynamic> paymentPendingExport = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  List<SearchableDropdownMenuItem<String>> voucherType = [];
  SearchableDropdownController<String> voucherTypeController =
  SearchableDropdownController<String>();
  TextEditingController bamountController = TextEditingController();

  void initWidget(String details) async {
    var data = jsonDecode(details);
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    String jsonData =
        '[{"id":"transId","name":"Transaction ID","isMandatory":true,"inputType":"text", "default" : "${data['transId']}"},{"id":"vtype","name":"Voucher Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-pay-pending-type/", "default" : "${data['vtype']}"},{"id":"mop","name":"Mode of Payment","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-mop/", "default" : "S", "readOnly" : true},{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/", "default" : "${data['lcode']}"},{"id":"crdrCode","name":"CR/DR Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/", "default" : "${data['transCode']}"},{"id":"amount","name":"Amount","isMandatory":true,"inputType":"text", "default" : "${data['bamount']}"},{"id":"naration","name":"Naration","isMandatory":true,"inputType":"text", "default" : "${data['paynaration']}"}]';

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          controller: controller,
          defaultValue: element['default'],
          readOnly: element['readOnly'] ?? false,
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void initClearWidget(String details) async {
    var data = jsonDecode(details);
    GlobalVariables.requestBody[clearFeature] = {};
    formFieldDetails.clear();
    clearWidgetList.clear();
    voucherTypeController.clear();
    bamountController.clear();
    String jsonData =
        '[{"id":"stId","name":"Sale Transfer ID","isMandatory":true,"inputType":"number", "default" : "${data['docno']}" },{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/", "default" : "${data['lcode']}"},{"id":"crdrCode","name":"CR/DR Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/","default" : "${data['transCode']}"},{"id":"amount","name":"Amount","isMandatory":true,"inputType":"text", "default" : "${data['unadjusted']}"},{"id":"clnaration","name":"Naration","isMandatory":true,"inputType":"text"}]';

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          controller: controller,
          defaultValue: element['default'],
          readOnly: element['readOnly'] ?? false,
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, clearFeature);
    clearWidgetList.addAll(widgets);
    initCustomWidget(data['lcode']);
  }

  void initCustomWidget(String lcode) async {
    voucherType = await formService.getDropdownMenuItem("/get-voucher-type/");
    var transIdItems = await formService
        .getDropdownMenuItem("/get-bill-pending-by-lcode/$lcode/");
    clearWidgetList.addAll([
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
                text: "Transaction ID",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Expanded(
            child: CustomDropdownField(
                field: FormUI(
                    id: "transId",
                    name: "Transaction ID",
                    isMandatory: true,
                    inputType: "dropdown"),
                customFunction: getVoucherTypeBylcode,
                dropdownMenuItems: transIdItems,
                feature: clearFeature),
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
                text: "Voucher Type",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Expanded(
            child: CustomDropdownField(
                field: FormUI(
                    id: "vtype",
                    name: "Voucher Type",
                    isMandatory: true,
                    inputType: "dropdown",
                    controller: voucherTypeController,
                    readOnly: true),
                dropdownMenuItems: voucherType,
                feature: clearFeature),
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
                text: "Balance Amount",
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
                    id: "bamount",
                    name: "Balance Amount",
                    isMandatory: false,
                    inputType: "number",
                    controller: bamountController,
                    readOnly: true),
                feature: clearFeature,
                inputType: TextInputType.number),
          ),
        ],
      )
    ]);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/add-sale-transfer/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<http.StreamedResponse> addSaleTransferClear() async {
    http.StreamedResponse response = await networkService.post(
        "/add-sale-transfer-clear/", [GlobalVariables.requestBody[clearFeature]]);
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"lcode","name":"Party Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"fdate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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

  void initPaymentPendingReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"lcode","name":"Party Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"}, {"id" : "bpState","name" : "States", "isMandatory": false, "inputType" : "dropdown", "dropdownMenuItem" : "/get-states/"},{"id":"pdays","name":"Days","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-days/"}]';

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

  void getBillPendingReport() async {
    paymentPending.clear();
    http.StreamedResponse response = await networkService.post(
        "/payment-pending/",
        GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      paymentPending = jsonDecode(await response.stream.bytesToString());
      paymentPendingExport = paymentPending;
      paymentPending = flattenGroupedWithTotals(paymentPending);
    }
    notifyListeners();
  }

  void getVoucherTypeBylcode() async {
    var transId = GlobalVariables.requestBody[clearFeature]['transId'];
    if (transId != null && transId != "") {
      http.StreamedResponse response =
      await networkService.get("/get-bill-pending-by-transId/$transId/");
      if (response.statusCode == 200) {
        var details = jsonDecode(await response.stream.bytesToString())[0];
        var vType = findDropdownMenuItem(voucherType, details['vtype']);
        voucherTypeController.selectedItem.value = vType;
        bamountController.text = details['bamount'];
        GlobalVariables.requestBody[clearFeature]['vtype'] = details['vtype'];
      }
    }
    notifyListeners();
  }

  List<Map<String, dynamic>> flattenGroupedWithTotals(List<dynamic> data) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    // Group by lcode
    for (var item in data) {
      final lcode = item['lcode'];
      grouped.putIfAbsent(lcode, () => []).add(item);
    }

    final List<Map<String, dynamic>> finalList = [];

    List<double> sums = [0,0,0];

    grouped.forEach((lcode, entries) {
      double amountSum = 0;
      double payAmountSum = 0;
      double bAmountSum = 0;

      entries.insert(0, {"transId" : lcode, "dDate" : entries[0]['lName'], 'vtype' : entries[0]['bpCity'], 'billNo' : entries[0]['stateName']});
      for (var item in entries) {
        double amount = parseEmptyStringToDouble(item['amount'].toString());
        double payamount = parseEmptyStringToDouble(item['payamount'].toString());
        double bamount = parseEmptyStringToDouble(item['bamount'].toString());

        amountSum += amount;
        payAmountSum += payamount;
        bAmountSum += bamount;

        if(bAmountSum != 0) {
          item['run'] = bAmountSum;
        }
        finalList.add(item);
      }

      finalList.add({
        'vtype': 'Total',
        'amount': amountSum.toStringAsFixed(2),
        'payamount': payAmountSum.toStringAsFixed(2),
        'bamount': bAmountSum.toStringAsFixed(2),
      });
      sums[0] += amountSum;
      sums[1] += payAmountSum;
      sums[2] += bAmountSum;
      finalList.add({});
    });

    finalList.add({
      'vtype': 'Grand Total',
      'amount': sums[0].toStringAsFixed(2),
      'payamount': sums[1].toStringAsFixed(2),
      'bamount': sums[2].toStringAsFixed(2),
    });

    return finalList;
  }

}
