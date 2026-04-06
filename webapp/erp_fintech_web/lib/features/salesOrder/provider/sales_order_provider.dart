import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class SalesOrderProvider with ChangeNotifier {
  static const String featureName = "salesOrder";
  static const String reportFeature = "salesOrderReport";
  static const String saleReportFeature = "salesReport";
  static const String orderBalanceReportFeature = "orderBalanceReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<SearchableDropdownMenuItem<String>> discountType = [];

  List<dynamic> orderList = [];
  List<dynamic> orderMaterial = [];
  List<dynamic> orderReport = [];
  List<dynamic> salesReport = [];
  List<dynamic> shortQty = [];
  List<dynamic> orderBalance = [];
  List<dynamic> invoicePending = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  TextEditingController tdsController = TextEditingController();
  TextEditingController tdsRateController = TextEditingController();

  List<DataRow> rows = [];

  List<List<TextEditingController>> rowControllers = [];
  List<SearchableDropdownMenuItem<String>> bpCodes = [];
  Map<String, List<SearchableDropdownMenuItem<String>>> shipCodes = {};

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    bpCodes.clear();
    String jsonData =
        '[{"id":"carId","name":"Carrier","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-carrier/"},{"id":"poNo","name":"PO No.","isMandatory":false,"inputType":"text","maxCharacter":30},{"id":"poDate","name":"PO Date","isMandatory":false,"inputType":"datetime"},{"id":"transmode","name":"Mode Of Transport","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-trans-mode/"},{"id":"privateMark","name":"Private Mark","isMandatory":false,"inputType":"text","maxCharacter":20},{"id":"mop","name":"Mode Of Payemnt","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-mop/"},{"id":"mof","name":"Freight Mode","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-mof/"}]';

    bpCodes = await formService.getDropdownMenuItem("/get-business-partner/");

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
    initDetailsTab();
    getShippingByBpCode();
  }

  Future<http.StreamedResponse> processFormInfo(
      List<List<String>> tableRows, bool isManual) async {
    List<Map<String, dynamic>> orderDetails = [];
    for (int i = 0; i < tableRows.length; i++) {
      orderDetails.add({
        "icode": tableRows[i][0],
        "qty": tableRows[i][1],
      });
    }
    if (isManual) {
      GlobalVariables.requestBody[featureName]['orderdetails'] = orderDetails;
    }
    http.StreamedResponse response = await networkService.post(
        "/add-sales-order/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> appendItemInOrder(
      List<List<String>> tableRows, String orderId, String custCode) async {
    List<Map<String, dynamic>> orderItems = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loginId = prefs.get("currentLoginId").toString();
    for (int i = 0; i < tableRows.length; i++) {
      orderItems.add({
        "icode": tableRows[i][0],
        "qty": tableRows[i][1],
        "loginId": loginId,
        "custCode": custCode,
        "orderId": orderId
      });
    }
    http.StreamedResponse response =
        await networkService.post("/append-sales-order/", orderItems);
    return response;
  }

  void getOrderMaterial(String orderId) async {
    orderMaterial.clear();
    http.StreamedResponse response =
        await networkService.get("/get-sales-order-material/$orderId/");
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      orderMaterial.addAll(data);
    }
    notifyListeners();
  }

  void getAllOrder() async {
    orderList.clear();
    http.StreamedResponse response = await networkService.get("/get-orders/");
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      orderList.addAll(data);
    }
    notifyListeners();
  }

  void deleteOrderMaterial(String odId, String orderId) async {
    http.StreamedResponse response =
        await networkService.post("/delete-order-material/$odId/", {});
    if (response.statusCode == 204) {
      getOrderMaterial(orderId);
    }
    notifyListeners();
  }

  void deleteWholeOrder(String orderId) async {
    http.StreamedResponse response =
        await networkService.post("/delete-order/$orderId/", {});
    if (response.statusCode == 204) {
      getAllOrder();
    }
    notifyListeners();
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"orderId","name":"Order Id","isMandatory":false,"inputType":"text"},{"id":"bpCode","name":"Business Partner Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-business-partner/"},{"id":"stateId","name":"State","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-states/"},{"id":"fromDate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"toDate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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

  void getSalesOrderReport() async {
    orderReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/sales-order-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      orderReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void initSaleReport() async {
    GlobalVariables.requestBody[saleReportFeature] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"invNo","name":"Invoice No","isMandatory":false,"inputType":"number"},{"id":"bpCode","name":"Business Partner Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-business-partner/"},{"id":"stateId","name":"State","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-states/"},{"id":"slId","name":"Supply Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-supply-type/"},{"id":"stId","name":"Supplier Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-supplier-type/"},{"id":"fromDate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"toDate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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
        formFieldDetails, saleReportFeature);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void getSalesReport() async {
    salesReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-sales-report/", GlobalVariables.requestBody[saleReportFeature]);
    if (response.statusCode == 200) {
      salesReport = jsonDecode(await response.stream.bytesToString());
    }
    getRows();
  }

  void getRows() {
    List<double> totals = [0, 0, 0];
    rows.clear();

    for (var data in salesReport) {
      totals[0] = totals[0] + parseEmptyStringToDouble('${data['sumamount']}');
      totals[1] =
          totals[1] + parseEmptyStringToDouble('${data['sumgstamount']}');
      totals[2] = totals[2] + parseEmptyStringToDouble('${data['sumtamount']}');
      rows.add(DataRow(cells: [
        DataCell(InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var cid = prefs.getString("currentLoginCid");
              final Uri uri = Uri.parse(
                  "${NetworkService.baseUrl}/get-sale-invc-pdf/${data['invNo']}/$cid/");
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
              } else {
                throw 'Could not launch';
              }
            },
            child: Text('${data['invNo'] ?? "-"}',
                style: const TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.w500)))),
        DataCell(Text('${data['dtDate'] ?? "-"}')),
        DataCell(Text('${data['custName'] ?? "-"}')),
        DataCell(Text('${data['custCity'] ?? "-"}')),
        DataCell(Text('${data['custStateName'] ?? "-"}')),
        DataCell(Text('${data['slId'] ?? "-"}')),
        DataCell(Text('${data['stId'] ?? "-"}')),
        DataCell(Text('${data['isIgst'] ?? "-"}')),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['sumamount']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['sumgstamount']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['sumtamount']}')))),
      ]));
    }

    rows.add(DataRow(cells: [
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(
          Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${totals[0]}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${totals[1]}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${totals[2]}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
    ]));

    notifyListeners();
  }

  void initDetailsTab() {
    List<List<String>> tableRows = [
      ['', '']
    ];
    rowControllers = tableRows
        .map((row) =>
            row.map((field) => TextEditingController(text: field)).toList())
        .toList();
  }

  void deleteRowController(int index) {
    rowControllers.removeAt(index);
    notifyListeners();
  }

  void addRowController() {
    rowControllers.add([
      TextEditingController(),
      TextEditingController(),
    ]);
    notifyListeners();
  }

  void getShippingByBpCode() async {
    shipCodes.clear();
    http.StreamedResponse response = await networkService.get("/get-shipping/");
    if (response.statusCode == 200) {
      var respData = jsonDecode(await response.stream.bytesToString());
      for (var data in respData) {
        if (shipCodes.containsKey(data['bpCode'])) {
          shipCodes[data['bpCode']]?.add(SearchableDropdownMenuItem(
              label: data['shipName'],
              child: Text(data['shipName']),
              value: data['shipCode'].toString()));
        } else {
          shipCodes[data['bpCode']] = [];
          shipCodes[data['bpCode']]?.add(SearchableDropdownMenuItem(
              label: data['shipName'],
              child: Text(data['shipName']),
              value: data['shipCode'].toString()));
        }
      }
    }
    notifyListeners();
  }

  void getShortQty() async {
    shortQty.clear();
    http.StreamedResponse response = await networkService.get("/short-qty/");
    if (response.statusCode == 200) {
      shortQty = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void initOrderBalanceReport() async {
    GlobalVariables.requestBody[orderBalanceReportFeature] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"orderId","name":"Order Id","isMandatory":false,"inputType":"number"},{"id":"bpCode","name":"Business Partner","isMandatory":false,"inputType":"dropdown", "dropdownMenuItem" : "/get-business-partner/"},{"id":"fromDate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"toDate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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
        formFieldDetails, orderBalanceReportFeature);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void getOrderBalance() async {
    orderBalance.clear();
    http.StreamedResponse response = await networkService.post(
        "/order-balance/",
        GlobalVariables.requestBody[orderBalanceReportFeature]);
    if (response.statusCode == 200) {
      orderBalance = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void getEInvoicePending() async {
    invoicePending.clear();
    http.StreamedResponse response =
        await networkService.get("/einvoice-pending/");
    if (response.statusCode == 200) {
      invoicePending = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

}
