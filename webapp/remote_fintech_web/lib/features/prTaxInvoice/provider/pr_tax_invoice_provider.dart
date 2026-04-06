import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widgets/custom_dropdown_field.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:url_launcher/url_launcher.dart';

class PrTaxInvoiceProvider with ChangeNotifier {
  static const String featureName = "prTaxInvoice";
  static const String reportFeature = "prTaxInvoiceReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  List<dynamic> report = [];
  List<DataRow> rows = [];

  List<SearchableDropdownMenuItem<String>> discountType = [];
  List<SearchableDropdownMenuItem<String>> supplyType = [];
  List<SearchableDropdownMenuItem<String>> supplierType = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  TextEditingController tdsController = TextEditingController();
  TextEditingController tdsRateController = TextEditingController();

  SearchableDropdownController<String> supplyController = SearchableDropdownController<String>();
  SearchableDropdownController<String> supplierController = SearchableDropdownController<String>();

  void initWidget() async {
    supplyController.clear();
    supplierController.clear();
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"docno","name":"Document No.","isMandatory":true,"inputType":"number"},{"id":"docDate","name":"Document Date","isMandatory":true,"inputType":"datetime"},{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"drId","name":"Documnet Reason","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-doc-reason/"},{"id":"daId","name":"Document Against","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-doc-against/"},{"id":"crCode","name":"Credit Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"}]';

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
          eventTrigger: element['id'] == 'lcode' ? autoFillDetailsByPartyCode : null));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    initCustomObject();
  }

  void initCustomObject() async {
    supplyType =
    await formService.getDropdownMenuItem("/get-supply-type/");
    supplierType =
    await formService.getDropdownMenuItem("/get-supplier-type/");
    widgetList.addAll([
      CustomDropdownField(
          field: FormUI(
              id: "slId",
              name: "Supply Type",
              isMandatory: true,
              inputType: "dropdown",
              controller: supplyController),
          dropdownMenuItems: supplyType,
          feature: featureName),
      CustomDropdownField(
          field: FormUI(
              id: "stId",
              name: "Supplier Type",
              isMandatory: true,
              inputType: "dropdown",
              controller: supplierController),
          dropdownMenuItems: supplierType,
          feature: featureName)
    ]);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo(
      List<List<String>> tableRows) async {
    List<Map<String, dynamic>> inwardDetails = [];
    for (int i = 0; i < tableRows.length; i++) {
      inwardDetails.add({
        "naration": tableRows[i][0] == "" ? null : tableRows[i][0],
        "matno" : tableRows[i][1] == "" ? null : tableRows[i][1],
        "hsnCode": tableRows[i][2],
        "billNo" : tableRows[i][3] == "" ? null : tableRows[i][3],
        "billDate" : tableRows[i][4] == "" ? null : tableRows[i][4],
        "qty": tableRows[i][5],
        "rate": tableRows[i][6],
        "amount": tableRows[i][7],
        "discType": tableRows[i][8],
        "rdisc": tableRows[i][9],
        "discountAmount": tableRows[i][10],
        // "bcd": tableRows[i][11],
        "roff": tableRows[i][12],
        "rcess": tableRows[i][13],
        "cessAmount": tableRows[i][14],
        "rgst": tableRows[i][15],
        "gstAmount": tableRows[i][16],
        // "tcsAmount": tableRows[i][17],
        "tamount" : tableRows[i][18],
        "docno" : GlobalVariables.requestBody[featureName]['docno']
      });
    }
    GlobalVariables.requestBody[featureName]['PRTaxInvoiceDetails'] = inwardDetails;
    http.StreamedResponse response = await networkService.post(
        "/add-pr-tax/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void getDiscountType() async {
    http.StreamedResponse response =
    await networkService.get("/get-discper-type/");
    if (response.statusCode == 200) {
      discountType.clear();
      var data = jsonDecode(await response.stream.bytesToString());
      for (var element in data) {
        discountType.add(SearchableDropdownMenuItem(
            value: "${element["discType"]}",
            child: Text("${element["discDescription"]}"),
            label: "${element["discDescription"]}"));
      }
    }
    notifyListeners();
  }

  void autoFillDetailsByPartyCode() async {
    var partyCode = GlobalVariables.requestBody[featureName]['lcode'];
    if(partyCode != null && partyCode != "") {
      http.StreamedResponse response = await networkService.get("/get-ledger-code-supply/$partyCode/");
      if(response.statusCode == 200) {
        var details = jsonDecode(await response.stream.bytesToString())[0];
        var supplyItem = findDropdownMenuItem(supplyType, details['slId']);
        supplyController.selectedItem.value = supplyItem;
        var supplierItem = findDropdownMenuItem(supplierType, details['stId']);
        supplierController.selectedItem.value = supplierItem;

        GlobalVariables.requestBody[featureName]['slId'] = details['slId'];
        GlobalVariables.requestBody[featureName]['stId'] = details['stId'];
      }
    }
    notifyListeners();
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"docno","name":"Document No.","isMandatory":false,"inputType":"number"},{"id":"drId","name":"Documnet Reason","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-doc-reason/"},{"id":"daId","name":"Document Against","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-doc-against/"},{"id":"slId","name":"Supply Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-supply-type/"},{"id":"stId","name":"Supplier Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-supplier-type/"},{"id":"bpCode","name":"Party Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-business-partner/"},{"id":"fdate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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

  void getDbNoteReport() async {
    report.clear();
    http.StreamedResponse response = await networkService.post(
        "/pr-tax-invoice-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      report = jsonDecode(await response.stream.bytesToString());
    }
    getRows();
  }

  void getRows() {
    List<double> totals = [0,0,0,0,0,0,0,0,0];
    rows.clear();

    for (var data in report) {
      totals[0] = totals[0] + parseEmptyStringToDouble('${data['amount']}');
      totals[1] = totals[1] + parseEmptyStringToDouble('${data['discountAmount']}');
      totals[2] = totals[2] + parseEmptyStringToDouble('${data['taxAmount']}');
      totals[3] = totals[3] + parseEmptyStringToDouble('${data['cessAmount']}');
      totals[4] = totals[4] + parseEmptyStringToDouble('${data['gstAmount']}');
      totals[5] = totals[5] + parseEmptyStringToDouble('${data['roff']}');
      totals[6] = totals[6] + parseEmptyStringToDouble('${data['tamount']}');
      totals[7] = totals[7] + parseEmptyStringToDouble('${data['adjusted']}');
      totals[8] = totals[8] + parseEmptyStringToDouble('${data['bamount']}');

      rows.add(DataRow(cells: [
        DataCell(InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var cid = prefs.getString("currentLoginCid");
              final Uri uri = Uri.parse(
                  "${NetworkService.baseUrl}/prtax-invoice/${data['docno']}/$cid/");
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
              } else {
                throw 'Could not launch';
              }
            },
            child: Text('${data['docno'] ?? "-"}',
                style: const TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.w500)))),
        DataCell(Text('${data['ddocDate'] ?? "-"}')),
        DataCell(Visibility(
          visible: data['DocProof'] != null && data['DocProof'] != "",
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)))),
            onPressed: () async {
              final Uri uri =
              Uri.parse("${NetworkService.baseUrl}${data['DocProof']}");
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
              } else {
                throw 'Could not launch';
              }
            },
            child: const Text(
              'Show Doc',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
            ),
          ),
        )),
        DataCell(Text('${data['lcode'] ?? "-"}')),
        DataCell(Text('${data['drId'] ?? "-"}')),
        DataCell(Text('${data['daId'] ?? "-"}')),
        DataCell(Text('${data['crCode'] ?? "-"}')),
        DataCell(Text('${data['slId'] ?? "-"}')),
        DataCell(Text('${data['stId'] ?? "-"}')),
        DataCell(Text('${data['bpName'] ?? "-"}')),
        DataCell(Text('${data['bpAdd'] ?? "-"} ${data['bpAdd1'] ?? ""}')),
        DataCell(Text('${data['bpCity'] ?? "-"}')),
        DataCell(Text('${data['bpState'] ?? "-"}')),
        DataCell(Text('${data['bpZipCode'] ?? "-"}')),
        DataCell(Text('${data['bpGSTIN'] ?? "-"}')),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['amount']}')))),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['discountAmount']}')))),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['taxAmount']}')))),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['cessAmount']}')))),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['gstAmount']}')))),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['roff']}')))),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['tamount']}')))),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['adjusted']}')))),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['bamount']}')))),
      ]));
    }

    rows.add(DataRow(cells: [
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${totals[0]}'), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${totals[1]}'), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${totals[2]}'), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${totals[3]}'), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${totals[4]}'), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${totals[5]}'), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${totals[6]}'), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${totals[7]}'), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${totals[8]}'), style: const TextStyle(fontWeight: FontWeight.bold)))),
    ]));

    notifyListeners();
  }
}
