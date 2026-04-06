import 'dart:convert';

import 'package:fintech_new_web/features/bankUpload/screens/bank_update.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';
import '../../utility/services/generate_form_service.dart';

class BankProvider with ChangeNotifier {
  static const String reportFeature = "BankStatements";
  static const String featureName = "BankUpdate";

  static const String uploadFeature = "HdfcUpload";
  static const String uploadFeature1 = "KotakUpload";

  List<FormUI> formFieldDetails = [];
  List<Widget> reportWidgetList = [];
  List<Widget> widgetList = [];

  List<dynamic> bankStatement = [];

  List<DataRow> rows = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();

    String jsonData =
        '[{"id":"bpCode","name":"Business Partner Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-business-partner/"},{"id":"type","name":"Trans. Type (D/W)","isMandatory":false,"inputType":"text","maxCharacter":1, "default" : "D"},{"id":"fdate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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
        await formService.generateDynamicForm(formFieldDetails, reportFeature);
    reportWidgetList.addAll(widgets);
    notifyListeners();
  }

  void initReportS() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();

    String jsonData =
        '[{"id":"bpCode","name":"Business Partner Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-business-partner/"},{"id":"type","name":"Trans. Type (D/W)","isMandatory":false,"inputType":"text","maxCharacter":1, "default" : "D", "readOnly" : true},{"id":"fdate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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
          readOnly: element['readOnly'] ?? false,
          controller: controller));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, reportFeature);
    reportWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getBankStatements(BuildContext context) async {
    bankStatement.clear();
    http.StreamedResponse response = await networkService.post(
        "/bank-statements/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      bankStatement = jsonDecode(await response.stream.bytesToString());
    }
    getRows(context);
  }

  void getRows(BuildContext context) {
    List<double> totals = [0, 0];
    rows.clear();

    for (var data in bankStatement) {
      totals[0] = totals[0] + parseEmptyStringToDouble('${data['withdrawal']}');
      totals[1] = totals[1] + parseEmptyStringToDouble('${data['deposit']}');

      rows.add(DataRow(cells: [
        DataCell(Text('${data['transId'] ?? "-"}')),
        DataCell(Visibility(
          visible: parseEmptyStringToDouble(data['deposit'] ?? "") > 0.0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
            onPressed: () async {
              context.pushNamed(BankUpdate.routeName,
                  queryParameters: {"bankDetails": jsonEncode(data)});
            },
            child: const Text(
              'Claim Payment',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        )),
        DataCell(Text('${data['dtransDate'] ?? "-"}')),
        DataCell(Text('${data['transDescription'] ?? "-"}')),
        DataCell(Text('${data['refNumber'] ?? "-"}')),
        DataCell(Text('${data['valueDate'] ?? "-"}')),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['withdrawal']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['deposit']}')))),
        DataCell(Text('${data['bankCode'] ?? "-"}')),
        DataCell(Text('${data['lcode'] ?? "-"}')),
        DataCell(Text('${data['postMethod'] ?? "-"}')),
        DataCell(Text('${data['naration'] ?? "-"}')),
      ]));
    }

    rows.add(DataRow(cells: [
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
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
    ]));

    notifyListeners();
  }

  void initEditWidget(String transId, double amount) async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    String jsonData =
        '[{"id":"transId","name":"Transaction Id","isMandatory":true,"inputType":"text","default":"$transId","readOnly":true},{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"amount","name":"Amount","isMandatory":true,"inputType":"number","default":"$amount","readOnly":true}]';

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
          readOnly: element['readOnly'] ?? false,
          defaultValue: element['default']));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-bank-statement/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void initHdfcUpload() async {
    GlobalVariables.requestBody[uploadFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();

    String jsonData =
        '[{"id":"transDate","name":"Transaction Date","isMandatory":true,"inputType":"datetime"}, {"id" : "fileName", "name" : "File Name", "inputType" : "text", "isMandatory" : true}]';

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          controller: controller));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, uploadFeature);
    reportWidgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> uploadHdfc() async {
    http.StreamedResponse response = await networkService.post(
        "/upload-hdfc/", GlobalVariables.requestBody[uploadFeature]);
    return response;
  }

  void initKotakUpload() async {
    GlobalVariables.requestBody[uploadFeature1] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();

    String jsonData =
        '[{"id":"transDate","name":"Transaction Date","isMandatory":true,"inputType":"datetime"}, {"id" : "fileName", "name" : "File Name", "inputType" : "text", "isMandatory" : true}]';

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          controller: controller));
    }

    List<Widget> widgets =
    await formService.generateDynamicForm(formFieldDetails, uploadFeature1);
    reportWidgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> uploadKotak() async {
    http.StreamedResponse response = await networkService.post(
        "/upload-kotak/", GlobalVariables.requestBody[uploadFeature1]);
    return response;
  }
}
