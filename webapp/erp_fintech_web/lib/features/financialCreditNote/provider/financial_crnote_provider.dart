import 'dart:convert';

import 'package:fintech_new_web/features/common/widgets/custom_dropdown_field.dart';
import 'package:fintech_new_web/features/common/widgets/custom_text_field.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class FinancialCrnoteProvider with ChangeNotifier {
  static const String featureName = "financialCrnoteProvider";
  static const String reportFeature = "financialCrnoteProvider";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController rtod = TextEditingController();
  TextEditingController rtodController = TextEditingController();

  List<dynamic> fiacRep = [];
  List<DataRow> rows = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  String jsonData =
      '[{"id":"tDate","name":"Transaction Date","isMandatory":true,"inputType":"datetime"},{"id":"fcnType","name":"Credit Note Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-crn-type/"},{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"dbCode","name":"Debit Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"naration","name":"Naration","isMandatory":true,"inputType":"text","maxCharacter":100}]';

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
    List<SearchableDropdownMenuItem<String>> rateTod = await getTodRate();
    widgetList.addAll([
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
                    defaultValue: 0),
                feature: featureName,
                inputType: TextInputType.number),
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
                text: "TOD Rate",
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
                  id: "rtod",
                  name: "Tod Rate",
                  isMandatory: true,
                  inputType: "number",
                  controller: rtodController,
                  defaultValue: 0.00),
              feature: featureName,
              dropdownMenuItems: rateTod,
            ),
          ),
        ],
      )
    ]);
    notifyListeners();
  }

  Future<List<SearchableDropdownMenuItem<String>>> getTodRate() async {
    List<SearchableDropdownMenuItem<String>> discountType = [];
    http.StreamedResponse response = await networkService.get("/get-tod-rate/");
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      for (var element in data) {
        discountType.add(SearchableDropdownMenuItem(
            value: "${element["rtod"]}",
            child: Text("${element["rtod"]}"),
            label: "${element["rtod"]}"));
      }
    }
    return discountType;
  }

  Future<http.StreamedResponse> processFormInfo(bool manual) async {
    var payload = manual
        ? [GlobalVariables.requestBody[featureName]]
        : GlobalVariables.requestBody[featureName];
    http.StreamedResponse response =
        await networkService.post("/create-financial-crnote/", payload);
    return response;
  }

  void initReport() async {
    String jsonData =
        '[{"id":"lcode","name":"Party Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"fdate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();

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

  void getFiacCrNoteReport() async {
    fiacRep.clear();
    http.StreamedResponse response = await networkService.post(
        "/fiac-crnote-rep/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      fiacRep = jsonDecode(await response.stream.bytesToString());
    }
    getRows();
  }

  void getRows() {
    rows.clear();

    double sum = 0.0;

    for(var data in fiacRep) {
      sum += parseEmptyStringToDouble(data['TAMOUNT']);
      rows.add(
          DataRow(cells: [
            DataCell(InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  var cid = prefs.getString("currentLoginCid");
                  final Uri uri = Uri.parse(
                      "${NetworkService.baseUrl}/get-fcsno-pdf/${data['fcnsno']}/$cid/");
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri,
                        mode: LaunchMode.inAppBrowserView);
                  } else {
                    throw 'Could not launch';
                  }
                },
                child: Text('${data['fcnsno'] ?? "-"}',
                    style: const TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w500)))),
            DataCell(Text('${data['dtDate'] ?? "-"}')),
            DataCell(Text('${data['lcode'] ?? "-"}')),
            DataCell(Text('${data['bpName'] ?? "-"}')),
            DataCell(Text('${data['bpGSTIN'] ?? "-"}')),
            DataCell(Text('${data['DBCODE'] ?? "-"}')),
            DataCell(Align(alignment: Alignment.centerRight,child: Text('${data['AMOUNT'] ?? "-"}'))),
            DataCell(Align(alignment: Alignment.centerRight,child: Text('${data['RTOD'] ?? "-"}'))),
            DataCell(Align(alignment: Alignment.centerRight,child: Text('${data['TAMOUNT'] ?? "-"}'))),
          ])
      );
    }

    rows.add(
      DataRow(cells: [
        const DataCell(SizedBox()),
        const DataCell(SizedBox()),
        const DataCell(SizedBox()),
        const DataCell(Text("GRAND TOTAL", style: TextStyle(fontWeight: FontWeight.bold))),
        const DataCell(SizedBox()),
        const DataCell(SizedBox()),
        const DataCell(SizedBox()),
        const DataCell(SizedBox()),
        DataCell(Align(alignment: Alignment.centerRight,child: Text(sum.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)))),
      ])
    );

    notifyListeners();
  }


}
