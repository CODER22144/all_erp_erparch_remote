import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class SalesOrderNewProvider with ChangeNotifier {
  static const String featureName = "SalesOrderNew";
  static const String masterDetailFeatureName = "SaleItemDetails";
  static const String reportFeature = "saleOrderNewReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  List<dynamic> report = [];
  List<DataRow> rows = [];

  List<dynamic> salesRep = [];

  DataTable table =
  DataTable(columns: const [DataColumn(label: Text(""))], rows: const []);

  List<List<TextEditingController>> rowControllers = [];

  List<SearchableDropdownMenuItem<String>> materialUnit = [];
  List<SearchableDropdownMenuItem<String>> hsnCodes = [];
  List<SearchableDropdownMenuItem<String>> shippingDropDown = [];

  SearchableDropdownController<String> shipController = SearchableDropdownController<String>();

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id" : "Dt", "name" : "Date", "inputType" : "datetime", "isMandatory" : true},{"id":"lcode","name":"Ledger Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"crCode","name":"Credit Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"poNo","name":"PO No.","isMandatory":false,"inputType":"text","maxCharacter":30},{"id":"poDate","name":"PO Date","isMandatory":false,"inputType":"datetime"},{"id":"privateMark","name":"Private Mark","isMandatory":false,"inputType":"text","maxCharacter":20}]';

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
          eventTrigger: element['id'] == 'lcode' ? getShippingDropdown : null,
          controller: controller));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);

    widgetList.addAll([
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
            text: "Shipping",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      Container(
          height: 41,
          key: const Key('outletMappingDropdownKey'),
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 2),
          child: SearchableDropdown<String>(
            trailingIcon: const SizedBox(),
            isEnabled: true,
            backgroundDecoration: (child) => Container(
              height: 48,
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.black45, width: 0.8),
              ),
              child: child,
            ),
            items: shippingDropDown,
            controller: shipController,
            onChanged: (String? value) {
              GlobalVariables.requestBody[featureName]["shipId"] = value;
            },
            hasTrailingClearIcon: false,
          ))
    ]);

    materialUnit.clear();
    hsnCodes.clear();
    materialUnit = await formService.getDropdownMenuItem("/get-material-unit/");
    hsnCodes = await formService.getDropdownMenuItem("/get-hsn/");
    List<List<String>> tableRows = [
      ['', '', '', '', '', '', '1', '0', '', '0', '0', '0', '0', '0', '0']
    ];
    rowControllers = tableRows
        .map((row) =>
            row.map((field) => TextEditingController(text: field)).toList())
        .toList();
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo(
      List<List<String>> tableRows, bool manual) async {
    List<Map<String, dynamic>> inwardDetails = [];
    var payload;
    if (manual) {
      for (int i = 0; i < tableRows.length; i++) {
        inwardDetails.add({
          // "vtype": tableRows[i][0] == "" ? null : tableRows[i][0],
          "matno": tableRows[i][1] == "" ? null : tableRows[i][1],
          // "OrgInvNo": tableRows[i][2] == "" ? null : tableRows[i][2],
          // "OrgInvDate": tableRows[i][3] == "" ? null : tableRows[i][3],
          "PrdDesc": tableRows[i][4],
          "HsnCd": tableRows[i][5] == "" ? null : tableRows[i][5],
          "Qty": tableRows[i][6],
          "UnitPrice": tableRows[i][7],
          "Unit": tableRows[i][8],
          "AssAmt": tableRows[i][9],
          "Discount": tableRows[i][10],
          "GstRt": tableRows[i][11],
          "GstAmt": tableRows[i][12],
          "TotAmt": tableRows[i][14]
        });
      }

      GlobalVariables.requestBody[featureName]['SaleItemDetails'] =
          inwardDetails;
      payload = [GlobalVariables.requestBody[featureName]];
    } else {
      payload = GlobalVariables.requestBody[featureName];
    }
    http.StreamedResponse response =
        await networkService.post("/add-sales-order/", payload);
    return response;
  }

  // void initReport() async {
  //   GlobalVariables.requestBody[reportFeature] = {};
  //   formFieldDetails.clear();
  //   reportWidgetList.clear();
  //   String jsonData =
  //       '[{"id" : "docId", "name" : "Document ID", "isMandatory" : false, "inputType" : "number"},{"id" : "No", "name" : "Document No.", "isMandatory" : false, "inputType" : "text", "maxCharacter" : 16},{"id" : "RegRev", "name" : "Reg Rev.", "isMandatory" : false, "inputType" : "text", "maxCharacter" : 1},{"id":"lcode","name":"Party Code","isMandatory":false,"inputType":"dropdown", "dropdownMenuItem" : "/get-ledger-codes/"},{"id":"FDt","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"TDt","name":"To Date","isMandatory":true,"inputType":"datetime"}]';
  //
  //   for (var element in jsonDecode(jsonData)) {
  //     formFieldDetails.add(FormUI(
  //         id: element['id'],
  //         name: element['name'],
  //         isMandatory: element['isMandatory'],
  //         inputType: element['inputType'],
  //         dropdownMenuItem: element['dropdownMenuItem'] ?? "",
  //         maxCharacter: element['maxCharacter'] ?? 255));
  //   }
  //
  //   List<Widget> widgets =
  //   await formService.generateDynamicForm(formFieldDetails, reportFeature);
  //   reportWidgetList.addAll(widgets);
  //   notifyListeners();
  // }
  //
  // void getDbNoteReport() async {
  //   report.clear();
  //   http.StreamedResponse response = await networkService.post(
  //       "/sale-db-note-report/", GlobalVariables.requestBody[reportFeature]);
  //   if (response.statusCode == 200) {
  //     report = jsonDecode(await response.stream.bytesToString());
  //   }
  //   getRows();
  // }
  //
  // void getRows() {
  //   List<double> totals = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  //   rows.clear();
  //
  //   for (var data in report) {
  //     totals[0] = totals[0] + parseEmptyStringToDouble('${data['SumQty']}');
  //     totals[1] = totals[1] + parseEmptyStringToDouble('${data['SumTotAmt']}');
  //     totals[2] = totals[2] + parseEmptyStringToDouble('${data['SumDiscount']}');
  //     totals[3] = totals[3] + parseEmptyStringToDouble('${data['SumAssAmt']}');
  //     totals[4] = totals[4] + parseEmptyStringToDouble('${data['SumGstAmt']}');
  //     totals[5] = totals[5] + parseEmptyStringToDouble('${data['IgstAmt']}');
  //     totals[6] = totals[6] + parseEmptyStringToDouble('${data['CgstAmt']}');
  //     totals[7] = totals[7] + parseEmptyStringToDouble('${data['SgstAmt']}');
  //     totals[8] = totals[8] + parseEmptyStringToDouble('${data['SumTotItemVal']}');
  //
  //     rows.add(DataRow(cells: [
  //       DataCell(Text('${data['No'] ?? "-"}')),
  //       DataCell(Text('${data['DDt'] ?? "-"}')),
  //       DataCell(Text('${data['lcode'] ?? "-"}\n${data['LglNm']}')),
  //       DataCell(Text(
  //           '${data['Addr1'] ?? "-"} ${data['Addr2'] ?? ""}\n${data['Loc'] ?? "-"} - ${data['Stcd'] ?? "-"}')),
  //       DataCell(Text('${data['Pin'] ?? "-"}')),
  //       DataCell(Text('${data['Gstin'] ?? "-"}')),
  //       DataCell(Text('${data['drId'] ?? "-"} | ${data['daId'] ?? "-"}')),
  //       DataCell(Text('${data['crCode'] ?? "-"}\n${data['crlname']}')),
  //       DataCell(Text('${data['SupTyp'] ?? "-"}')),
  //       DataCell(Align(
  //           alignment: Alignment.centerRight,
  //           child: Text(parseDoubleUpto2Decimal('${data['SumQty']}')))),
  //       DataCell(Align(
  //           alignment: Alignment.centerRight,
  //           child: Text(parseDoubleUpto2Decimal('${data['SumTotAmt']}')))),
  //       DataCell(Align(
  //           alignment: Alignment.centerRight,
  //           child: Text(parseDoubleUpto2Decimal('${data['SumDiscount']}')))),
  //       DataCell(Align(
  //           alignment: Alignment.centerRight,
  //           child: Text(parseDoubleUpto2Decimal('${data['SumAssAmt']}')))),
  //
  //       DataCell(Align(
  //           alignment: Alignment.centerRight,
  //           child: Text(parseDoubleUpto2Decimal('${data['IgstAmt']}')))),
  //       DataCell(Align(
  //           alignment: Alignment.centerRight,
  //           child: Text(parseDoubleUpto2Decimal('${data['CgstAmt']}')))),
  //       DataCell(Align(
  //           alignment: Alignment.centerRight,
  //           child: Text(parseDoubleUpto2Decimal('${data['SgstAmt']}')))),
  //       DataCell(Align(
  //           alignment: Alignment.centerRight,
  //           child: Text(parseDoubleUpto2Decimal('${data['SumGstAmt']}')))),
  //       DataCell(Align(
  //           alignment: Alignment.centerRight,
  //           child: Text(parseDoubleUpto2Decimal('${data['SumTotVal']}')))),
  //     ]));
  //   }
  //
  //   rows.add(DataRow(cells: [
  //     const DataCell(SizedBox()),
  //     const DataCell(SizedBox()),
  //     const DataCell(SizedBox()),
  //     const DataCell(
  //         Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold))),
  //     const DataCell(SizedBox()),
  //     const DataCell(SizedBox()),
  //     const DataCell(SizedBox()),
  //     const DataCell(SizedBox()),
  //     const DataCell(SizedBox()),
  //     DataCell(Align(
  //         alignment: Alignment.centerRight,
  //         child: Text(parseDoubleUpto2Decimal('${totals[0]}'),
  //             style: const TextStyle(fontWeight: FontWeight.bold)))),
  //     DataCell(Align(
  //         alignment: Alignment.centerRight,
  //         child: Text(parseDoubleUpto2Decimal('${totals[1]}'),
  //             style: const TextStyle(fontWeight: FontWeight.bold)))),
  //     DataCell(Align(
  //         alignment: Alignment.centerRight,
  //         child: Text(parseDoubleUpto2Decimal('${totals[2]}'),
  //             style: const TextStyle(fontWeight: FontWeight.bold)))),
  //     DataCell(Align(
  //         alignment: Alignment.centerRight,
  //         child: Text(parseDoubleUpto2Decimal('${totals[3]}'),
  //             style: const TextStyle(fontWeight: FontWeight.bold)))),
  //
  //     DataCell(Align(
  //         alignment: Alignment.centerRight,
  //         child: Text(parseDoubleUpto2Decimal('${totals[5]}'),
  //             style: const TextStyle(fontWeight: FontWeight.bold)))),
  //     DataCell(Align(
  //         alignment: Alignment.centerRight,
  //         child: Text(parseDoubleUpto2Decimal('${totals[6]}'),
  //             style: const TextStyle(fontWeight: FontWeight.bold)))),
  //     DataCell(Align(
  //         alignment: Alignment.centerRight,
  //         child: Text(parseDoubleUpto2Decimal('${totals[7]}'),
  //             style: const TextStyle(fontWeight: FontWeight.bold)))),
  //     DataCell(Align(
  //         alignment: Alignment.centerRight,
  //         child: Text(parseDoubleUpto2Decimal('${totals[4]}'),
  //             style: const TextStyle(fontWeight: FontWeight.bold)))),
  //     DataCell(Align(
  //         alignment: Alignment.centerRight,
  //         child: Text(parseDoubleUpto2Decimal('${totals[8]}'),
  //             style: const TextStyle(fontWeight: FontWeight.bold)))),
  //   ]));
  //
  //   notifyListeners();
  // }

  void deleteRowController(int index) {
    rowControllers.removeAt(index);
    notifyListeners();
  }

  void addRowController() {
    rowControllers.add([
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(text: "1"),
      TextEditingController(text: "0"),
      TextEditingController(),
      TextEditingController(text: "0"),
      TextEditingController(text: "0"),
      TextEditingController(text: "0"),
      TextEditingController(text: "0"),
      TextEditingController(text: "0"),
      TextEditingController(text: "0"),
    ]);
    notifyListeners();
  }

  void getShippingDropdown() async {
    shippingDropDown.clear();
    http.StreamedResponse response = await networkService.post(
        "/customer-shipping-rep/",
        {"lcode": GlobalVariables.requestBody[featureName]['lcode']});

    List<dynamic> shippings = [];
    if (response.statusCode == 200) {
      shippings = jsonDecode(await response.stream.bytesToString());
    }

    for (var ship in shippings) {
      shippingDropDown.add(SearchableDropdownMenuItem(
          label:
              '${ship['shipCode'] ?? ""} ${ship['stateName'] ?? ""} ${ship['LglNm'] ?? ""}',
          value: '${ship['shipCode']}',
          child: Text('${ship['LglNm']} | ${ship['stateName']}')));
    }
    reformat();
  }

  void reformat() async {
    shipController.clear();
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id" : "Dt", "name" : "Date", "inputType" : "datetime", "isMandatory" : true},{"id":"lcode","name":"Ledger Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"crCode","name":"Credit Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"poNo","name":"PO No.","isMandatory":false,"inputType":"text","maxCharacter":30},{"id":"poDate","name":"PO Date","isMandatory":false,"inputType":"datetime"},{"id":"privateMark","name":"Private Mark","isMandatory":false,"inputType":"text","maxCharacter":20}]';

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255,
          defaultValue: GlobalVariables.requestBody[featureName][element['id']],
          eventTrigger: element['id'] == 'lcode' ? getShippingDropdown : null,
          controller: controller));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);

    widgetList.addAll([
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
            text: "Shipping",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      Stack(
        children: [
          Container(
              height: 41,
              key: const Key('outletMappingDropdownKey'),
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 2),
              child: SearchableDropdown<String>(
                trailingIcon: const SizedBox(),
                isEnabled: true,
                backgroundDecoration: (child) => Container(
                  height: 48,
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.black45, width: 0.8),
                  ),
                  child: child,
                ),
                items: shippingDropDown,
                controller: shipController,
                onChanged: (String? value) {
                  GlobalVariables.requestBody[featureName]["shipId"] = value;
                },
                hasTrailingClearIcon: false,
              )),
          Positioned(
              left: GlobalVariables.deviceWidth / 2.19,
              top: 5,
              child: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  // Clear the text field and trigger onChanged
                  shipController.clear();
                },
              ))
        ],
      )
    ]);

    materialUnit.clear();
    hsnCodes.clear();
    materialUnit = await formService.getDropdownMenuItem("/get-material-unit/");
    hsnCodes = await formService.getDropdownMenuItem("/get-hsn/");
    List<List<String>> tableRows = [
      ['', '', '', '', '', '', '1', '0', '', '0', '0', '0', '0', '0', '0']
    ];
    rowControllers = tableRows
        .map((row) =>
            row.map((field) => TextEditingController(text: field)).toList())
        .toList();
    notifyListeners();
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"igstOnIntra","name":"Igst On Intra","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/"},{"id":"lcode","name":"Party Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"fdate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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

  void getSalesOrderNewReport(BuildContext context) async {
    salesRep.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-sales-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      salesRep = jsonDecode(await response.stream.bytesToString());
    }

    List<DataRow> dataRows = [];
    List<double> totalAmounts = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    for (var data in salesRep) {
      totalAmounts = [
        totalAmounts[0] + parseEmptyStringToDouble(data['qty']),
        totalAmounts[1] + parseEmptyStringToDouble(data['amount']),
        totalAmounts[2] + parseEmptyStringToDouble(data['discountAmount']),
        totalAmounts[3] + parseEmptyStringToDouble(data['AssAmt']),
        totalAmounts[4] + parseEmptyStringToDouble(data['GstAmount']),
        totalAmounts[5] + parseEmptyStringToDouble(data['igstAmount']),
        totalAmounts[6] + parseEmptyStringToDouble(data['cgstAmount']),
        totalAmounts[7] + parseEmptyStringToDouble(data['sgstAmount']),
        totalAmounts[8] + parseEmptyStringToDouble(data['tamount']),
        totalAmounts[9] + parseEmptyStringToDouble(data['payAmount']),
        totalAmounts[10] + parseEmptyStringToDouble(data['bamount']),
      ];
      dataRows.add(DataRow(cells: [
        DataCell(Text("${data['No']}")),
        DataCell(Text("${data['dDt']}")),
        DataCell(Text("${data['lcode']} - ${data['lname']}")),
        DataCell(Text("${data['city']} - ${data['stateName']}")),
        DataCell(Text("${data['crCode']} - ${data['crlname']}")),
        DataCell(Text("${data['igstOnIntra']}")),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal(data['qty'])))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal(data['amount'])))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal(data['discountAmount'])))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal(data['AssAmt'])))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal(data['GstAmount'])))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal(data['igstAmount'])))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal(data['cgstAmount'])))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal(data['sgstAmount'])))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal(data['tamount'])))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal(data['payAmount'])))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal(data['bamount'])))),


        // DataCell(Align(
        //   alignment: Alignment.centerRight,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       // Container(
        //       //   decoration: const BoxDecoration(
        //       //       borderRadius: BorderRadius.only(
        //       //           topLeft: Radius.circular(5),
        //       //           bottomLeft: Radius.circular(5)),
        //       //       color: Colors.green),
        //       //   child: IconButton(
        //       //     icon: const Icon(Icons.info_outline),
        //       //     color: Colors.white,
        //       //     tooltip: 'Info',
        //       //     onPressed: () {
        //       //       provider.setEditController(
        //       //           data['hsnCode']);
        //       //       context.pushNamed(HsnInfo.routeName);
        //       //     },
        //       //   ),
        //       // ),
        //       // Container(
        //       //   color: Colors.blue,
        //       //   child: IconButton(
        //       //     icon: const Icon(Icons.edit),
        //       //     color: Colors.white,
        //       //     tooltip: 'Update',
        //       //     onPressed: () {
        //       //       provider.setEditController(
        //       //           data['hsnCode']);
        //       //       context.pushNamed(AddHsn.routeName,
        //       //           queryParameters: {
        //       //             "editing": 'true'
        //       //           });
        //       //     },
        //       //   ),
        //       // ),
        //       Container(
        //         decoration: const BoxDecoration(
        //             borderRadius: BorderRadius.only(
        //                 topRight: Radius.circular(5),
        //                 bottomRight: Radius.circular(5)),
        //             color: Colors.red),
        //         child: IconButton(
        //           icon: const Icon(Icons.delete),
        //           color: Colors.white,
        //           tooltip: 'Delete',
        //           onPressed: () async {
        //             bool confirmation = await showConfirmationDialogue(
        //                 context,
        //                 "Are you sure you want to delete Inward : ${data['transId']}?",
        //                 "SUBMIT",
        //                 "CANCEL");
        //             if (confirmation) {
        //               NetworkService networkService = NetworkService();
        //               http.StreamedResponse response = await networkService
        //                   .post(
        //                   "/delete-inward/", {"transId": data['transId']});
        //               if (response.statusCode == 204) {
        //                 getInwardBillReportTable(context);
        //               } else if (response.statusCode == 400) {
        //                 var message =
        //                 jsonDecode(await response.stream.bytesToString());
        //                 await showAlertDialog(context,
        //                     message['message'].toString(), "Continue", false);
        //               } else if (response.statusCode == 500) {
        //                 var message =
        //                 jsonDecode(await response.stream.bytesToString());
        //                 await showAlertDialog(
        //                     context, message['message'], "Continue", false);
        //               } else {
        //                 var message =
        //                 jsonDecode(await response.stream.bytesToString());
        //                 await showAlertDialog(
        //                     context, message['message'], "Continue", false);
        //               }
        //             }
        //           },
        //         ),
        //       ),
        //     ],
        //   ),
        // )),
      ]));
    }

    dataRows.add(DataRow(cells: [
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(Text(
        "Total",
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
            totalAmounts[0].toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
            totalAmounts[1].toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
            totalAmounts[2].toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
            totalAmounts[3].toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
            totalAmounts[4].toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
            totalAmounts[5].toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
            totalAmounts[6].toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
            totalAmounts[7].toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
            totalAmounts[8].toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
            totalAmounts[9].toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
            totalAmounts[10].toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ))),
    ]));

    table = DataTable(
      columnSpacing: 25,
      columns: const [
        DataColumn(label: Text("No.")),
        DataColumn(label: Text("Date")),
        DataColumn(label: Text("Party Code")),
        DataColumn(label: Text("City - State")),
        DataColumn(label: Text("Credit Code")),
        DataColumn(label: Text("Igst On Intra")),
        DataColumn(label: Text("Qty")),
        DataColumn(label: Text("Amount")),
        DataColumn(label: Text("Discount")),
        DataColumn(label: Text("AssAmt")),
        DataColumn(label: Text("GstAmount")),
        DataColumn(label: Text("Igst Amount")),
        DataColumn(label: Text("Cgst Amount")),
        DataColumn(label: Text("Sgst Amount")),
        DataColumn(label: Text("Total Amount")),
        DataColumn(label: Text("Pay Amount")),
        DataColumn(label: Text("Balance Amount")),
      ],
      rows: dataRows,
    );

    notifyListeners();
  }
}
