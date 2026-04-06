import 'dart:convert';

import 'package:fintech_new_web/features/additionalOrder/screen/additional_order.dart';
import 'package:fintech_new_web/features/common/widgets/custom_dropdown_field.dart';
import 'package:fintech_new_web/features/common/widgets/pop_ups.dart';
import 'package:fintech_new_web/features/gr/screen/gr_mat_edit.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class SalesReportProvider with ChangeNotifier {
  static const String featureName = "yearlySalesReport";
  static const String reportFeature = "yearlyCategorySalesReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  List<dynamic> ysReport = [];
  dynamic ysCatReport = [];
  List<DataRow> rows = [];
  List<DataRow> catRows = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initReport() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"fromDate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"toDate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

    for (var element in jsonDecode(jsonData)) {
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          controller: TextEditingController(),
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void getYearlySalesReport() async {
    ysReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/yearly-sales-report/", GlobalVariables.requestBody[featureName]);
    if (response.statusCode == 200) {
      ysReport = jsonDecode(await response.stream.bytesToString());
    }
    getRows();
  }

  void getRows() {
    rows.clear();
    for (var item in ysReport[0]['MonthTotal']) {
      rows.add(DataRow(cells: [
        DataCell(Text("${item['custStateName'] ?? ""}")),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(formatNumber(
                parseDoubleUpto2Decimal("${item['APRIL'] ?? ""}"))))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(formatNumber(
                parseDoubleUpto2Decimal("${item['MAY'] ?? ""}"))))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(formatNumber(
                parseDoubleUpto2Decimal("${item['JUNE'] ?? ""}"))))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(formatNumber(
                parseDoubleUpto2Decimal("${item['JULY'] ?? ""}"))))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(formatNumber(
                parseDoubleUpto2Decimal("${item['AUGUST'] ?? ""}"))))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(formatNumber(
                parseDoubleUpto2Decimal("${item['SEPTEMBER'] ?? ""}"))))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(formatNumber(
                parseDoubleUpto2Decimal("${item['OCTOBER'] ?? ""}"))))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(formatNumber(
                parseDoubleUpto2Decimal("${item['NOVEMBER'] ?? ""}"))))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(formatNumber(
                parseDoubleUpto2Decimal("${item['DECEMBER'] ?? ""}"))))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(formatNumber(
                parseDoubleUpto2Decimal("${item['JANUARY'] ?? ""}"))))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(formatNumber(
                parseDoubleUpto2Decimal("${item['FEBRUARY'] ?? ""}"))))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(formatNumber(
                parseDoubleUpto2Decimal("${item['MARCH'] ?? ""}"))))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(formatNumber(
                parseDoubleUpto2Decimal("${item['total'] ?? ""}"))))),
      ]));
    }

    var item = ysReport[0];

    rows.add(DataRow(cells: [
      const DataCell(
          Text("GRAND TOTAL", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
              formatNumber(parseDoubleUpto2Decimal("${item['APRIL'] ?? ""}")),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
              formatNumber(parseDoubleUpto2Decimal("${item['MAY'] ?? ""}")),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
              formatNumber(parseDoubleUpto2Decimal("${item['JUNE'] ?? ""}")),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
              formatNumber(parseDoubleUpto2Decimal("${item['JULY'] ?? ""}")),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
              formatNumber(parseDoubleUpto2Decimal("${item['AUGUST'] ?? ""}")),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
              formatNumber(
                  parseDoubleUpto2Decimal("${item['SEPTEMBER'] ?? ""}")),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
              formatNumber(parseDoubleUpto2Decimal("${item['OCTOBER'] ?? ""}")),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
              formatNumber(
                  parseDoubleUpto2Decimal("${item['NOVEMBER'] ?? ""}")),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
              formatNumber(
                  parseDoubleUpto2Decimal("${item['DECEMBER'] ?? ""}")),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
              formatNumber(parseDoubleUpto2Decimal("${item['JANUARY'] ?? ""}")),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
              formatNumber(
                  parseDoubleUpto2Decimal("${item['FEBRUARY'] ?? ""}")),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
              formatNumber(parseDoubleUpto2Decimal("${item['MARCH'] ?? ""}")),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
              formatNumber(parseDoubleUpto2Decimal("${item['total'] ?? ""}")),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
    ]));

    notifyListeners();
  }

  // YEARLY CATEGORY SALES
  void initCatReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"compType","name":"Business Partner Type","isMandatory":false,"inputType":"dropdown", "dropdownMenuItem" : "/get-business-partner-type/"}]';

    for (var element in jsonDecode(jsonData)) {
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          controller: TextEditingController(),
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, reportFeature);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void getYearlyCatSalesReport() async {
    ysCatReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/yearly-category-sales-report/",
        GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      ysCatReport = jsonDecode(await response.stream.bytesToString());
    }
    getCatRows();
  }

  void getCatRows() {
    catRows.clear();
    Map<String, List> catGroup = groupJson(ysCatReport['data'], "CID");

    DataRow grandTotal = const DataRow(cells: []);
    DataRow categoryTotal = const DataRow(cells: []);

    for (var entry in catGroup.entries) {
      Map<String, List> subCatGroup = groupJson(catGroup[entry.key]!, "CTID");
      int count = 0;
      for (var subEntry in subCatGroup.entries) {
        for (var item in subEntry.value) {
          if (item['ctName'] == 'GRAND TOTAL') {
            grandTotal = DataRow(cells: [
              const DataCell(Text("GRAND TOTAL",
                  style: TextStyle(fontWeight: FontWeight.bold))),
              const DataCell(SizedBox()),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['APRIL'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['MAY'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['JUNE'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['JULY'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['AUGUST'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['SEPTEMBER'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['OCTOBER'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['NOVEMBER'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['DECEMBER'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['JANUARY'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['FEBRUARY'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['MARCH'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
            ]);
          } else if (item['sctName'] == 'CATEGORY TOTAL') {
            categoryTotal = DataRow(cells: [
              const DataCell(Text("CATEGORY TOTAL",
                  style: TextStyle(fontWeight: FontWeight.bold))),
              const DataCell(SizedBox()),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['APRIL'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['MAY'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['JUNE'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['JULY'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['AUGUST'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['SEPTEMBER'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['OCTOBER'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['NOVEMBER'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['DECEMBER'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['JANUARY'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['FEBRUARY'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['MARCH'] ?? ""}")), style: const TextStyle(fontWeight: FontWeight.bold)))),
            ]);
          } else {
            catRows.add(DataRow(cells: [
              DataCell(Text(count == 0 ? '${entry.value[0]['ctName']}' : "",
                  style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text("${subEntry.value[0]['sctName']}",
                  style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['APRIL'] ?? ""}"))))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['MAY'] ?? ""}"))))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['JUNE'] ?? ""}"))))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['JULY'] ?? ""}"))))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['AUGUST'] ?? ""}"))))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['SEPTEMBER'] ?? ""}"))))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['OCTOBER'] ?? ""}"))))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['NOVEMBER'] ?? ""}"))))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['DECEMBER'] ?? ""}"))))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['JANUARY'] ?? ""}"))))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['FEBRUARY'] ?? ""}"))))),
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(formatNumber(
                      parseDoubleUpto2Decimal("${item['MARCH'] ?? ""}"))))),
            ]));
          }
          count = count + 1;
        }
      }
      catRows.add(categoryTotal);
      catRows.add(const DataRow(cells: [
        DataCell(SizedBox()),
        DataCell(SizedBox()),
        DataCell(SizedBox()),
        DataCell(SizedBox()),
        DataCell(SizedBox()),
        DataCell(SizedBox()),
        DataCell(SizedBox()),
        DataCell(SizedBox()),
        DataCell(SizedBox()),
        DataCell(SizedBox()),
        DataCell(SizedBox()),
        DataCell(SizedBox()),
        DataCell(SizedBox()),
        DataCell(SizedBox()),
      ]));
    }

    catRows.add(grandTotal);

    // for (var item in ysCatReport['data']) {
    //   catRows.add(DataRow(cells: [
    //     DataCell(Text("${item['CTID'] ?? ""}")),
    //     DataCell(Text("${item['sctName'] ?? ""}")),
    //     DataCell(Align(
    //         alignment: Alignment.centerRight,
    //         child: Text(formatNumber(
    //             parseDoubleUpto2Decimal("${item['APRIL'] ?? ""}"))))),
    //     DataCell(Align(
    //         alignment: Alignment.centerRight,
    //         child: Text(formatNumber(
    //             parseDoubleUpto2Decimal("${item['MAY'] ?? ""}"))))),
    //     DataCell(Align(
    //         alignment: Alignment.centerRight,
    //         child: Text(formatNumber(
    //             parseDoubleUpto2Decimal("${item['JUNE'] ?? ""}"))))),
    //     DataCell(Align(
    //         alignment: Alignment.centerRight,
    //         child: Text(formatNumber(
    //             parseDoubleUpto2Decimal("${item['JULY'] ?? ""}"))))),
    //     DataCell(Align(
    //         alignment: Alignment.centerRight,
    //         child: Text(formatNumber(
    //             parseDoubleUpto2Decimal("${item['AUGUST'] ?? ""}"))))),
    //     DataCell(Align(
    //         alignment: Alignment.centerRight,
    //         child: Text(formatNumber(
    //             parseDoubleUpto2Decimal("${item['SEPTEMBER'] ?? ""}"))))),
    //     DataCell(Align(
    //         alignment: Alignment.centerRight,
    //         child: Text(formatNumber(
    //             parseDoubleUpto2Decimal("${item['OCTOBER'] ?? ""}"))))),
    //     DataCell(Align(
    //         alignment: Alignment.centerRight,
    //         child: Text(formatNumber(
    //             parseDoubleUpto2Decimal("${item['NOVEMBER'] ?? ""}"))))),
    //     DataCell(Align(
    //         alignment: Alignment.centerRight,
    //         child: Text(formatNumber(
    //             parseDoubleUpto2Decimal("${item['DECEMBER'] ?? ""}"))))),
    //     DataCell(Align(
    //         alignment: Alignment.centerRight,
    //         child: Text(formatNumber(
    //             parseDoubleUpto2Decimal("${item['JANUARY'] ?? ""}"))))),
    //     DataCell(Align(
    //         alignment: Alignment.centerRight,
    //         child: Text(formatNumber(
    //             parseDoubleUpto2Decimal("${item['FEBRUARY'] ?? ""}"))))),
    //     DataCell(Align(
    //         alignment: Alignment.centerRight,
    //         child: Text(formatNumber(
    //             parseDoubleUpto2Decimal("${item['MARCH'] ?? ""}"))))),
    //     DataCell(Align(
    //         alignment: Alignment.centerRight,
    //         child: Text(formatNumber(
    //             parseDoubleUpto2Decimal("${item['TOTSALE'] ?? ""}"))))),
    //   ]));
    // }

    // var item = jsonDecode(ysCatReport['totals']);
    //
    // catRows.add(DataRow(cells: [
    //   const DataCell(
    //       Text("GRAND TOTAL", style: TextStyle(fontWeight: FontWeight.bold))),
    //   const DataCell(SizedBox()),
    //   DataCell(Align(
    //       alignment: Alignment.centerRight,
    //       child: Text(formatNumber(parseDoubleUpto2Decimal("${item['APRIL'] ?? ""}")),
    //           style: const TextStyle(fontWeight: FontWeight.bold)))),
    //   DataCell(Align(
    //       alignment: Alignment.centerRight,
    //       child: Text(formatNumber(parseDoubleUpto2Decimal("${item['MAY'] ?? ""}")),
    //           style: const TextStyle(fontWeight: FontWeight.bold)))),
    //   DataCell(Align(
    //       alignment: Alignment.centerRight,
    //       child: Text(formatNumber(parseDoubleUpto2Decimal("${item['JUNE'] ?? ""}")),
    //           style: const TextStyle(fontWeight: FontWeight.bold)))),
    //   DataCell(Align(
    //       alignment: Alignment.centerRight,
    //       child: Text(formatNumber(parseDoubleUpto2Decimal("${item['JULY'] ?? ""}")),
    //           style: const TextStyle(fontWeight: FontWeight.bold)))),
    //   DataCell(Align(
    //       alignment: Alignment.centerRight,
    //       child: Text(formatNumber(parseDoubleUpto2Decimal("${item['AUGUST'] ?? ""}")),
    //           style: const TextStyle(fontWeight: FontWeight.bold)))),
    //   DataCell(Align(
    //       alignment: Alignment.centerRight,
    //       child: Text(formatNumber(parseDoubleUpto2Decimal("${item['SEPTEMBER'] ?? ""}")),
    //           style: const TextStyle(fontWeight: FontWeight.bold)))),
    //   DataCell(Align(
    //       alignment: Alignment.centerRight,
    //       child: Text(formatNumber(parseDoubleUpto2Decimal("${item['OCTOBER'] ?? ""}")),
    //           style: const TextStyle(fontWeight: FontWeight.bold)))),
    //   DataCell(Align(
    //       alignment: Alignment.centerRight,
    //       child: Text(formatNumber(parseDoubleUpto2Decimal("${item['NOVEMBER'] ?? ""}")),
    //           style: const TextStyle(fontWeight: FontWeight.bold)))),
    //   DataCell(Align(
    //       alignment: Alignment.centerRight,
    //       child: Text(formatNumber(parseDoubleUpto2Decimal("${item['DECEMBER'] ?? ""}")),
    //           style: const TextStyle(fontWeight: FontWeight.bold)))),
    //   DataCell(Align(
    //       alignment: Alignment.centerRight,
    //       child: Text(formatNumber(parseDoubleUpto2Decimal("${item['JANUARY'] ?? ""}")),
    //           style: const TextStyle(fontWeight: FontWeight.bold)))),
    //   DataCell(Align(
    //       alignment: Alignment.centerRight,
    //       child: Text(formatNumber(parseDoubleUpto2Decimal("${item['FEBRUARY'] ?? ""}")),
    //           style: const TextStyle(fontWeight: FontWeight.bold)))),
    //   DataCell(Align(
    //       alignment: Alignment.centerRight,
    //       child: Text(formatNumber(parseDoubleUpto2Decimal("${item['MARCH'] ?? ""}")),
    //           style: const TextStyle(fontWeight: FontWeight.bold)))),
    //   DataCell(Align(
    //       alignment: Alignment.centerRight,
    //       child: Text(formatNumber(parseDoubleUpto2Decimal("${item['GRANDTOTAL'] ?? ""}")),
    //           style: const TextStyle(fontWeight: FontWeight.bold)))),
    // ]));

    notifyListeners();
  }

  void groupData() {
    List<dynamic> groups = [];

    for (var data in ysCatReport['data']) {}
  }
}
