import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';
import '../../utility/models/forms_UI.dart';
import '../../utility/services/common_utility.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:go_router/go_router.dart';

import 'package:http/http.dart' as http;

import '../screens/add_reverse_charge.dart';
import '../screens/rcm_info.dart';

class ReverseChargeProvider with ChangeNotifier {
  static const String featureName = "reverseCharge";
  static const String reportFeature = "reverseChargeReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> widgetReportList = [];

  List<dynamic> rcmRep = [];

  List<DataRow> rcmRows = [];

  TextEditingController editController = TextEditingController();

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  TextEditingController materialController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController gstRateController = TextEditingController();
  TextEditingController gstAmountController = TextEditingController();
  TextEditingController narationController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  SearchableDropdownController<String> hsnController =
      SearchableDropdownController<String>();
  SearchableDropdownController<String> unitController =
      SearchableDropdownController<String>();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    hsnController.clear();

    Map<String, dynamic> controllerMap = {
      "matno": materialController,
      "hsnCode": hsnController,
      "rate": rateController,
      "AssAmt": amountController,
      "rgst": gstRateController,
      "naration": narationController,
      "unit": unitController,
      "gstAmount": gstAmountController,
      "totalAmount": totalAmountController
    };

    Map<String, dynamic> triggerMap = {
      "hsnCode": getGstTaxRate,
      "matno": materialFunction,
      "rate": calculateAmount,
      "qty": calculateAmount,
      "rgst": calculateAmount
    };

    String jsonData =
        '[{"id":"No","name":"NO.","isMandatory":false,"inputType":"text","maxCharacter":16},{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"billNo","name":"Bill No.","isMandatory":false,"inputType":"text","maxCharacter":30},{"id":"billDate","name":"Bill Date","isMandatory":false,"inputType":"datetime"},{"id" : "itcEligible", "name" : "Itc Eligibility", "isMandatory": true, "inputType" : "dropdown", "dropdownMenuItem" : "/get-yesno/", "default" : "N"},{"id" : "matno", "name" : "Material No.", "isMandatory" : false, "inputType" : "text", "maxCharacter" : 15},{"id":"naration","name":"Narration","isMandatory":true,"inputType":"text","maxCharacter":100},{"id":"hsnCode","name":"Hsn Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-hsn/"},{"id":"qty","name":"Quantity","isMandatory":true,"inputType":"number", "default" : 1},{"id":"unit","name":"Unit","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-material-unit/"},{"id":"rate","name":"Rate","isMandatory":true,"inputType":"number"},{"id":"AssAmt","name":"Amount","isMandatory":true,"inputType":"number"},{"id":"rgst","name":"GST Rate","isMandatory":true,"inputType":"number"},{"id":"gstAmount","name":"GST Amount","isMandatory":true,"inputType":"number"},{"id":"totalAmount","name":"Total Amount","isMandatory":false,"inputType":"number"}]';

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          controller: controllerMap[element['id']] ?? controller,
          defaultValue: element['default'],
          eventTrigger: triggerMap[element['id']],
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void materialFunction() async {
    List<SearchableDropdownMenuItem<String>> hsnCodes =
        await formService.getDropdownMenuItem("/get-hsn/");
    List<SearchableDropdownMenuItem<String>> units =
        await formService.getDropdownMenuItem("/get-material-unit/");

    http.StreamedResponse response = await networkService.get(
        "/get-material/${GlobalVariables.requestBody[featureName]['matno']}/");
    var matDetails = jsonDecode(await response.stream.bytesToString())[0];
    if (response.statusCode == 200) {
      unitController.selectedItem.value =
          findDropdownMenuItem(units, matDetails['unit']);
      GlobalVariables.requestBody[featureName]['unit'] = matDetails['unit'];

      narationController.text = matDetails['saleDescription'];
      GlobalVariables.requestBody[featureName]['naration'] =
          matDetails['saleDescription'];

      hsnController.selectedItem.value =
          findDropdownMenuItem(hsnCodes, matDetails['hsnCode']);
      GlobalVariables.requestBody[featureName]['hsnCode'] =
          matDetails['hsnCode'];

      rateController.text = matDetails['prate'] ?? "0";
      GlobalVariables.requestBody[featureName]['rate'] =
          matDetails['prate'] ?? "0";

      gstRateController.text = matDetails['gstTaxRate'] ?? "0";
      GlobalVariables.requestBody[featureName]['rgst'] =
          matDetails['gstTaxRate'] ?? "0";
    } else {
      unitController.clear();
      GlobalVariables.requestBody[featureName]['unit'] = null;

      narationController.text = "";
      GlobalVariables.requestBody[featureName]['naration'] = null;

      hsnController.selectedItem.value = null;
      GlobalVariables.requestBody[featureName]['hsnCode'] = null;

      rateController.text = "0";
      GlobalVariables.requestBody[featureName]['rate'] = "0";

      gstRateController.text = "0";
      GlobalVariables.requestBody[featureName]['rgst'] = "0";
    }

    calculateAmount();
  }

  void getGstTaxRate() async {
    http.StreamedResponse response = await networkService.get(
        "/get-hsn-code/${GlobalVariables.requestBody[featureName]['hsnCode']}/");
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString())[0];
      gstRateController.text = data['gstTaxRate'].toString();
    } else {
      gstRateController.text = "0.00";
    }
    GlobalVariables.requestBody[featureName]['rgst'] = gstRateController.text;
    GlobalVariables.requestBody[featureName]['rate'] = rateController.text;

    calculateAmount();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService
        .post("/add-rcm/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-rcm/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<Map<String, dynamic>> getByIdRcm() async {
    http.StreamedResponse response =
        await networkService.post("/get-rcm/", {"No": editController.text});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEditWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    hsnController.clear();

    Map<String, dynamic> editMapData = await getByIdRcm();
    GlobalVariables.requestBody[featureName] = editMapData;

    Map<String, dynamic> controllerMap = {
      "matno": materialController,
      "hsnCode": hsnController,
      "rate": rateController,
      "AssAmt": amountController,
      "rgst": gstRateController,
      "gstAmount": gstAmountController
    };

    Map<String, dynamic> triggerMap = {
      "hsnCode": getGstTaxRate,
      "matno": materialFunction,
      "rate": calculateAmount,
      "qty": calculateAmount,
      "rgst": calculateAmount
    };

    String jsonData =
        '[{"id":"No","name":"NO.","isMandatory":false,"inputType":"text","maxCharacter":16},{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"billNo","name":"Bill No.","isMandatory":false,"inputType":"text","maxCharacter":30},{"id":"billDate","name":"Bill Date","isMandatory":false,"inputType":"datetime"},{"id":"naration","name":"Narration","isMandatory":false,"inputType":"text","maxCharacter":100},{"id" : "matno", "name" : "Material No.", "isMandatory" : false, "inputType" : "text", "maxCharacter" : 15},{"id":"hsnCode","name":"Hsn Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-hsn/"},{"id":"qty","name":"Quantity","isMandatory":true,"inputType":"number", "default" : 1},{"id":"unit","name":"Unit","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-material-unit/"},{"id":"rate","name":"Rate","isMandatory":true,"inputType":"number"},{"id":"AssAmt","name":"Amount","isMandatory":true,"inputType":"number"},{"id":"rgst","name":"GST Rate","isMandatory":true,"inputType":"number"},{"id":"gstAmount","name":"GST Amount","isMandatory":true,"inputType":"number"}]';

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          controller: controllerMap[element['id']] ?? controller,
          defaultValue: editMapData[element["id"]],
          eventTrigger: triggerMap[element['id']],
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    widgetReportList.clear();

    String jsonData =
        '[{"id":"No","name":"No.","isMandatory":false,"inputType":"text","maxCharacter":16},{"id":"lcode","name":"Ledger Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id" : "IgstOnIntra", "name" : "Igst On Intra", "isMandatory" : false, "inputType" : "dropdown", "dropdownMenuItem" : "/get-yesno/"},{"id":"fdate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, reportFeature);
    widgetReportList.addAll(widgets);
    notifyListeners();
  }

  void getRcmReport(BuildContext context) async {
    rcmRep.clear();
    http.StreamedResponse response = await networkService.post(
        "/rcm-rep/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      rcmRep = jsonDecode(await response.stream.bytesToString());
    }
    getRows(context);
  }

  void getRows(BuildContext context) {
    rcmRows.clear();
    List<double> sum = [0, 0, 0, 0, 0, 0, 0];
    for (var data in rcmRep) {
      sum[0] = sum[0] + parseEmptyStringToDouble('${data['qty']}');
      sum[1] = sum[1] + parseEmptyStringToDouble('${data['AssAmt']}');
      sum[2] = sum[2] + parseEmptyStringToDouble('${data['gstAmount']}');
      sum[3] = sum[3] + parseEmptyStringToDouble('${data['IgstAmt']}');
      sum[4] = sum[4] + parseEmptyStringToDouble('${data['CgstAmt']}');
      sum[5] = sum[5] + parseEmptyStringToDouble('${data['SgstAmt']}');
      sum[6] = sum[6] + parseEmptyStringToDouble('${data['tamount']}');

      rcmRows.add(DataRow(cells: [
        DataCell(Text('${data['No'] ?? "-"}')),
        DataCell(Text('${data['billNo'] ?? "-"}\n${data['billDate'] ?? "-"}')),
        DataCell(Text('${data['lcode'] ?? "-"}\n${data['lName'] ?? ""}')),
        DataCell(Text('${data['itcEligible'] ?? "-"}')),
        DataCell(Text('${data['matno'] ?? "-"}')),
        DataCell(Text('${data['naration'] ?? "-"}')),
        DataCell(Text('${data['hsnCode'] ?? "-"}')),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['qty'] ?? "-"}')))),
        DataCell(Text('${data['unit'] ?? "-"}')),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['rate'] ?? "-"}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['AssAmt'] ?? "-"}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['rgst'] ?? "-"}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child:
                Text(parseDoubleUpto2Decimal('${data['gstAmount'] ?? "-"}')))),
        DataCell(Text('${data['IgstOnIntra'] ?? "-"}')),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['IgstAmt'] ?? "-"}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['CgstAmt'] ?? "-"}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['SgstAmt'] ?? "-"}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['tamount'] ?? "-"}')))),
        DataCell(Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5)),
                    color: Colors.green),
                child: IconButton(
                  icon: const Icon(Icons.info_outline),
                  color: Colors.white,
                  tooltip: 'Info',
                  onPressed: () {
                    editController.text = '${data['No']}';
                    context.pushNamed(RcmInfo.routeName);
                  },
                ),
              ),
              Container(
                color: Colors.blue,
                child: IconButton(
                  icon: const Icon(Icons.edit),
                  color: Colors.white,
                  tooltip: 'Update',
                  onPressed: () {
                    editController.text = '${data['No']}';

                    context.pushNamed(AddReverseCharge.routeName,
                        queryParameters: {"editing": 'true'});
                  },
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                    color: Colors.red),
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.white,
                  tooltip: 'Delete',
                  onPressed: () async {
                    bool confirmation = await showConfirmationDialogue(
                        context,
                        "Are you sure you want to delete this RCM?",
                        "SUBMIT",
                        "CANCEL");
                    if (confirmation) {
                      NetworkService networkService = NetworkService();
                      http.StreamedResponse response = await networkService
                          .post("/delete-rcm/", {"No": '${data['No']}'});
                      if (response.statusCode == 204) {
                        getRcmReport(context);
                      } else if (response.statusCode == 400) {
                        var message =
                            jsonDecode(await response.stream.bytesToString());
                        await showAlertDialog(context,
                            message['message'].toString(), "Continue", false);
                      } else if (response.statusCode == 500) {
                        var message =
                            jsonDecode(await response.stream.bytesToString());
                        await showAlertDialog(
                            context, message['message'], "Continue", false);
                      } else {
                        var message =
                            jsonDecode(await response.stream.bytesToString());
                        await showAlertDialog(
                            context, message['message'], "Continue", false);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        )),
      ]));
    }

    rcmRows.add(DataRow(cells: [
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(
          Text("GRAND TOTAL", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(sum[0].toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(sum[1].toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      const DataCell(SizedBox()),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(sum[2].toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      const DataCell(SizedBox()),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(sum[3].toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(sum[4].toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(sum[5].toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(sum[6].toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      const DataCell(SizedBox()),
    ]));

    notifyListeners();
  }

  void calculateAmount() {
    double amount = (parseEmptyStringToDouble(
            GlobalVariables.requestBody[featureName]['qty'].toString()) *
        parseEmptyStringToDouble(
            GlobalVariables.requestBody[featureName]['rate'].toString()));

    amountController.text = amount.toStringAsFixed(2);
    GlobalVariables.requestBody[featureName]['AssAmt'] = amountController.text;

    gstAmountController.text = (amount *
            parseEmptyStringToDouble(
                GlobalVariables.requestBody[featureName]['rgst'].toString()) *
            0.01)
        .toStringAsFixed(2);

    totalAmountController.text = (parseEmptyStringToDouble(
                GlobalVariables.requestBody[featureName]['roff'].toString()) +
            amount +
            parseEmptyStringToDouble(gstAmountController.text))
        .toStringAsFixed(2);

    GlobalVariables.requestBody[featureName]['gstAmount'] =
        gstAmountController.text;
  }
}
