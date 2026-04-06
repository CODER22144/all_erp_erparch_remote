import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class PurchaseOrderProvider with ChangeNotifier {
  static const String featureName = "purchaseOrder";
  static const String reportFeature = "purchaseOrderReport";
  static const String itemReportFeature = "purchaseOrderItemReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  List<SearchableDropdownMenuItem<String>> priorities = [];
  List<SearchableDropdownMenuItem<String>> poType = [];

  List<List<TextEditingController>> rowControllers = [];

  List<dynamic> poItemReport = [];

  DataTable table =
      DataTable(columns: const [DataColumn(label: Text(""))], rows: const []);

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id": "poDate","name": "Order Date","isMandatory": true,"inputType": "datetime"},{"id": "bpCode","name": "Business Partner","isMandatory": true,"inputType": "dropdown","dropdownMenuItem" : "/get-business-partner/"},{"id": "mof","name": "Mode Of Freight","isMandatory": true,"inputType": "dropdown","dropdownMenuItem" : "/get-mof/"},{"id": "freightAmount","name": "Freight Amount","isMandatory": true,"inputType": "number"},{"id" : "insurance","name" : "Insurance","isMandatory" : true,"inputType" : "dropdown","dropdownMenuItem" : "/get-yesno/"},{"id": "insuranceAmount","name": "Insurance Amount","isMandatory": true,"inputType": "number"},{"id" : "otherCharges","name" : "Other Charges","isMandatory" : false,"inputType" : "text","maxCharacter" : 100},{"id" : "ocAmount","name" : "OC Amount","isMandatory" : true,"inputType" : "number"},{"id": "validFrom","name": "Valid From","isMandatory": true,"inputType": "datetime"},{"id": "validTo","name": "Valid To","isMandatory": true,"inputType": "datetime"},{"id": "whCode","name": "Warehouse","isMandatory": true,"inputType": "dropdown", "dropdownMenuItem":"/get-warehouse/"},{"id": "carrierName","name": "Carrier Name","isMandatory": true,"inputType": "text","maxCharacter" : 50},{"id": "transmode","name": "Mode Of Transport","isMandatory": true,"inputType": "dropdown","dropdownMenuItem" : "/get-trans-mode/"},{"id": "paymentTerm","name": "Payment Term","isMandatory": true,"inputType": "text","maxCharacter" : 100},{"id": "pdi","name": "PDI","isMandatory": true,"inputType": "dropdown","dropdownMenuItem" : "/get-tf/"},{"id": "mtc","name": "MTC","isMandatory": true,"inputType": "dropdown","dropdownMenuItem" : "/get-tf/"},{"id": "packingList","name": "Packing List","isMandatory": true,"inputType": "dropdown","dropdownMenuItem" : "/get-tf/"}]';

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
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);

    List<List<String>> tableRows = [
      ['', '', '', '', '']
    ];
    rowControllers = tableRows
        .map((row) =>
            row.map((field) => TextEditingController(text: field)).toList())
        .toList();
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo(
      List<List<String>> tableRows, bool isManual) async {
    List<Map<String, dynamic>> orderDetails = [];
    for (int i = 0; i < tableRows.length; i++) {
      orderDetails.add({
        "matno": tableRows[i][0],
        "poQty": tableRows[i][1],
        "deliveryDate": tableRows[i][2],
        "priority": tableRows[i][3],
        "potype": tableRows[i][4]
      });
    }
    if (isManual) {
      GlobalVariables.requestBody[featureName]['PurchaseOrderDetails'] =
          orderDetails;
    }
    http.StreamedResponse response = await networkService.post(
        "/create-purchase-order/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"poId","name":"Purchase Order Id","isMandatory":false,"inputType":"text"},{"id":"fmatno","name":"From Material No.","isMandatory":false,"inputType":"text", "maxCharacter" : 15},{"id":"tmatno","name":"To Material No.","isMandatory":false,"inputType":"text", "maxCharacter" : 15},{"id":"bpCode","name":"Business Partner","isMandatory":false,"inputType":"dropdown", "dropdownMenuItem" : "/get-business-partner/"},{"id":"fromDate","name":"From Date","isMandatory":false,"inputType":"datetime"},{"id":"toDate","name":"To Date","isMandatory":false,"inputType":"datetime"}]';

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
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<dynamic> getPurchaseOrderReport() async {
    http.StreamedResponse response = await networkService.post(
        "/purchase-order-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void nestedTable() async {
    table =
        DataTable(columns: const [DataColumn(label: Text(""))], rows: const []);
    var purchaseOrderReport = await getPurchaseOrderReport();
    List<DataRow> rows = [];
    int counter = 0;

    DataRow emptyRowNamed = const DataRow(cells: [
      DataCell(Text("")),
      DataCell(Text("")),
      DataCell(Text("")),
      DataCell(Text("")),
      DataCell(Text("")),
      DataCell(Text("")),
      DataCell(Text("")),
    ]);

    DataRow headerRow = const DataRow(cells: [
      DataCell(
          Text("Material No.", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(
          Text("Description", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child:
              Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Text("Rate", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text("Amount", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text("HSN Code", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
    ]);

    DataRow columnHeader = const DataRow(cells: [
      DataCell(Text("Order Id", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(
          Text("Order Date", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text("Business Partner",
          style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text("City", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text("State", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(
          Text("Carrier Name", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
    ]);

    for (var data in purchaseOrderReport) {
      rows.add(DataRow(cells: [
        DataCell(InkWell(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var cid = prefs.getString("currentLoginCid");
            final Uri uri = Uri.parse(
                "${NetworkService.baseUrl}/purchase-order-invoice-pdf/${data['poId']}/$cid/");
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
            } else {
              throw 'Could not launch';
            }
          },
          child: Text(
            '${data['poId'] ?? "-"}',
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.blueAccent),
          ),
        )),
        DataCell(Text('${data['poDate'] ?? "-"}')),
        DataCell(Text('${data['bpName'] ?? "-"}')),
        DataCell(Text('${data['bpCity'] ?? "-"}')),
        DataCell(Text('${data['stateName'] ?? "-"}')),
        DataCell(Text('${data['carrierName'] ?? "-"}')),
        const DataCell(Text("")),
      ]));
      rows.add(headerRow);
      for (var poData in data['pod']) {
        rows.add(DataRow(cells: [
          DataCell(Text('${poData['matno'] ?? "-"}')),
          DataCell(Text('${poData['matDescription'] ?? "-"}')),
          DataCell(Align(
              alignment: Alignment.centerRight,
              child:
                  Text(parseDoubleUpto2Decimal('${poData['poQty'] ?? "-"}')))),
          DataCell(Align(
              alignment: Alignment.centerRight,
              child:
                  Text(parseDoubleUpto2Decimal('${poData['poRate'] ?? "-"}')))),
          DataCell(Align(
              child: Text(
            parseDoubleUpto2Decimal('${poData['poAmount'] ?? "-"}'),
            textAlign: TextAlign.right,
          ))),
          DataCell(Text('${poData['hsnCode'] ?? "-"}')),
          const DataCell(Text('')),
        ]));
      }
      rows.add(DataRow(cells: [
        const DataCell(Text('')),
        const DataCell(
            Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['poQty'] ?? "-"}'),
                style: const TextStyle(fontWeight: FontWeight.bold)))),
        const DataCell(Text('')),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['poAmount'] ?? "-"}'),
                style: const TextStyle(fontWeight: FontWeight.bold)))),
        const DataCell(Text('')),
        const DataCell(Text('')),
      ]));
      counter = counter + 1;
      if (counter != purchaseOrderReport.length) {
        rows.add(emptyRowNamed);
        rows.add(columnHeader);
      }
    }

    table = DataTable(columns: const [
      DataColumn(
          label:
              Text("Order Id", style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("Order Date",
              style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("Business Partner",
              style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("City", style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("State", style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("Carrier Name",
              style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("", style: TextStyle(fontWeight: FontWeight.bold))),
    ], rows: rows);

    notifyListeners();
  }

  void getAllPriority() async {
    http.StreamedResponse response = await networkService.get("/get-priority/");
    if (response.statusCode == 200) {
      priorities.clear();
      var data = jsonDecode(await response.stream.bytesToString());
      for (var element in data) {
        priorities.add(SearchableDropdownMenuItem(
            value: "${element["priority"]}",
            child: Text("${element["Description"]}"),
            label: "${element["Description"]}"));
      }
    }
    notifyListeners();
  }

  void getAllPoType() async {
    poType = await formService.getDropdownMenuItem("/get-po-type/");
    notifyListeners();
  }

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
    ]);
    notifyListeners();
  }

  void initPoItemReport() async {
    GlobalVariables.requestBody[itemReportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"bpCode","name":"Business Partner","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-business-partner/"},{"id":"poId","name":"Purchase Order ID","isMandatory":false,"inputType":"text","maxCharacter":16},{"id":"frommatno","name":"From Material No.","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"tomatno","name":"To Material No.","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"fromDate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"toDate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

    for (var element in jsonDecode(jsonData)) {
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets = await formService.generateDynamicForm(
        formFieldDetails, itemReportFeature);
    reportWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getPoItemReport() async {
    poItemReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/po-item-report/", GlobalVariables.requestBody[itemReportFeature]);
    if (response.statusCode == 200) {
      poItemReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }
}
