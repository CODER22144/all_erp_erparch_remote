import 'dart:convert';

import 'package:fintech_new_web/features/gstReturn/screens/update_b2b.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';

class GstReturnProvider with ChangeNotifier {
  static String featureName = "b2b";
  static String gstFeature = "GST";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  List<dynamic> b2bReport = [];
  List<dynamic> b2cReport = [];
  List<dynamic> b2ClReport = [];
  List<dynamic> gstHsnSummary = [];
  List<dynamic> crdrNote = [];
  List<dynamic> docType = [];
  Map<String, dynamic> b2bNoMatch = {};
  Map<String, dynamic> b2bMatch = {};
  Map<String, dynamic> b2bNotIn = {};

  List<DataRow> b2bRows = [];
  List<DataRow> b2bMatchRows = [];
  List<DataRow> b2bNotInRows = [];

  TextEditingController editController = TextEditingController();
  TextEditingController revController = TextEditingController();

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
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets = await formService.generateDynamicForm(
        formFieldDetails, featureName,
        disableDefault: true);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void initGstHsnReport() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"fromDate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"toDate","name":"To Date","isMandatory":true,"inputType":"datetime"}, {"id" : "repType", "name" : "Rep Type (B/S/L)", "isMandatory" : true, "inputType" : "text", "maxCharacter" : 1}]';

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
        formFieldDetails, featureName,
        disableDefault: true);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void getB2bReport() async {
    b2bReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-b2b/", GlobalVariables.requestBody[featureName]);
    if (response.statusCode == 200) {
      b2bReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void getB2cReport() async {
    b2cReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-b2c/", GlobalVariables.requestBody[featureName]);
    if (response.statusCode == 200) {
      b2cReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void getB2ClReport() async {
    b2ClReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-b2Cl/", GlobalVariables.requestBody[featureName]);
    if (response.statusCode == 200) {
      b2ClReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void getGstHsnReport() async {
    gstHsnSummary.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-gst-hsn/", GlobalVariables.requestBody[featureName]);
    if (response.statusCode == 200) {
      gstHsnSummary = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void getCrDrNote() async {
    crdrNote.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-crdr-note/", GlobalVariables.requestBody[featureName]);
    if (response.statusCode == 200) {
      crdrNote = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void getDocType() async {
    docType.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-doc-type/", GlobalVariables.requestBody[featureName]);
    if (response.statusCode == 200) {
      docType = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void getB2bNoMatchReport(BuildContext context) async {
    b2bNoMatch.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-2bb2b-no-match/",
        {"rtnprd": editController.text, "rev": revController.text});
    if (response.statusCode == 200) {
      b2bNoMatch = jsonDecode(await response.stream.bytesToString());
    }
    getB2bRows(context);
  }

  void getB2bRows(BuildContext context) {
    b2bRows.clear();

    for (var data in b2bNoMatch['b2bdet']) {
      b2bRows.add(DataRow(cells: [
        DataCell(Text("${data['transId'] ?? ''}")),
        DataCell(Text("${data['inwid'] ?? ''}")),
        DataCell(Text("${data['tradename'] ?? ''}")),
        DataCell(Text("${data['docno'] ?? ''}")),
        DataCell(Text("${data['docdate'] ?? ''}")),
        DataCell(Text("${data['rfiledate'] ?? ''}")),
        DataCell(Text("${data['rev'] ?? ''}")),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal("${data['val']}")))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal("${data['txval'] ?? ''}")))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal("${data['igst'] ?? ''}")))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal("${data['cgst'] ?? ''}")))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal("${data['sgst'] ?? ''}")))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal("${data['cess'] ?? ''}")))),
        DataCell(ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)))),
          onPressed: () async {
            context.pushNamed(UpdateB2b.routeName,
                queryParameters: {"transId": '${data['transId']}'});
          },
          child: const Text(
            'Update',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w300, color: Colors.white),
          ),
        ))
      ]));
    }

    b2bRows.add(DataRow(cells: [
      const DataCell(
          Text("TOTAL", style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal("${b2bNoMatch['val']}"),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal("${b2bNoMatch['txval']}"),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal("${b2bNoMatch['igst']}"),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal("${b2bNoMatch['cgst']}"),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal("${b2bNoMatch['sgst']}"),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal("${b2bNoMatch['cess']}"),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      const DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold)))
    ]));

    notifyListeners();
  }

  void getB2bMatchReport() async {
    b2bMatch.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-2bb2b-match/",
        {"rtnprd": editController.text, "rev": revController.text});
    if (response.statusCode == 200) {
      b2bMatch = jsonDecode(await response.stream.bytesToString());
    }
    getB2bMatchRows();
  }

  void getB2bMatchRows() {
    b2bMatchRows.clear();

    for (var data in b2bMatch['b2bdet']) {
      b2bMatchRows.add(DataRow(cells: [
        DataCell(Text("${data['transId'] ?? ''}")),
        DataCell(Text("${data['inwid'] ?? ''}")),
        DataCell(Text("${data['tradename'] ?? ''}")),
        DataCell(Text("${data['docno'] ?? ''}")),
        DataCell(Text("${data['docdate'] ?? ''}")),
        DataCell(Text("${data['rfiledate'] ?? ''}")),
        DataCell(Text("${data['rev'] ?? ''}")),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal("${data['val']}")))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal("${data['txval']}")))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal("${data['igst']}")))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal("${data['cgst']}")))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal("${data['sgst']}")))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal("${data['cess']}")))),
      ]));
    }

    b2bMatchRows.add(DataRow(cells: [
      const DataCell(
          Text("TOTAL", style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal("${b2bMatch['val']}"),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal("${b2bMatch['txval']}"),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal("${b2bMatch['igst']}"),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal("${b2bMatch['cgst']}"),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal("${b2bMatch['sgst']}"),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal("${b2bMatch['cess']}"),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
    ]));

    notifyListeners();
  }

  void getB2bNotInReport() async {
    b2bNotIn.clear();
    http.StreamedResponse response = await networkService
        .post("/get-2bb2b-not-in/", {"rtnPrd": editController.text});
    if (response.statusCode == 200) {
      b2bNotIn = jsonDecode(await response.stream.bytesToString());
    }
    getB2bNotInRows();
  }

  void getB2bNotInRows() {
    b2bNotInRows.clear();

    for (var data in b2bNotIn['b2bdet']) {
      b2bNotInRows.add(DataRow(cells: [
        DataCell(Text("${data['transId'] ?? ''}")),
        DataCell(Text("${data['transDate'] ?? ''}")),
        DataCell(Text("${data['bpName'] ?? ''}")),
        DataCell(Text("${data['bpGSTIN'] ?? ''}")),
        DataCell(Text("${data['billNo'] ?? ''}")),
        DataCell(Text("${data['billDate'] ?? ''}")),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal("${data['taxAmount']}")))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal("${data['gstAmount']}")))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal("${data['tamount']}")))),
      ]));
    }

    b2bNotInRows.add(DataRow(cells: [
      const DataCell(
          Text("TOTAL", style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
              parseDoubleUpto2Decimal("${b2bNotIn['taxAmount'] ?? '-'}"),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal("${b2bNotIn['gstAmount']}"),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal("${b2bNotIn['tamount']}"),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
    ]));
  }

  void initGst() async {
    GlobalVariables.requestBody[gstFeature] = {};
    formFieldDetails.clear();
    widgetList.clear();
    String jsonData =
        '[{"id":"username","name":"Username","isMandatory":true,"inputType":"text"},{"id":"password","name":"Password","isMandatory":true,"inputType":"text"},{"id":"email","name":"Email","isMandatory":true,"inputType":"text"},{"id":"clientId","name":"Client Id","isMandatory":true,"inputType":"text"},{"id":"clientSecret","name":"Client Secret","isMandatory":true,"inputType":"text"},{"id":"ipAddress","name":"IP Address","isMandatory":true,"inputType":"text"},{"id":"gstin","name":"GSTIN","isMandatory":true,"inputType":"text","maxCharacter":15}]';

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
        formFieldDetails, gstFeature,
        disableDefault: true);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  // void authorization() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   http.StreamedResponse response = await networkService.authorizeGst(
  //       GlobalVariables.requestBody[GstReturnProvider.gstFeature], "");
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(await response.stream.bytesToString());
  //     prefs.setString("gstToken", data['data']['AuthToken']);
  //   }
  // }

  // Future<http.StreamedResponse> generateIrn(dynamic requestBody) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var heads = GlobalVariables.requestBody[GstReturnProvider.gstFeature];
  //   var authToken = prefs.getString("gstToken");
  //   Map<String, String> headers = {
  //     'accept': '*/*',
  //     'ip_address': heads['ipAddress'],
  //     'client_id': heads['clientId'],
  //     'client_secret': heads['clientSecret'],
  //     'username': heads['username'],
  //     'auth-token': authToken!,
  //     'gstin': heads['gstin'],
  //     'Content-Type': 'application/json'
  //   };
  //   var request = http.Request(
  //       'POST',
  //       Uri.parse(
  //           '${NetworkService.productionGstBaseUrl}/einvoice/type/GENERATE/version/V1_03?email=${heads['email']}'));
  //   request.body = json.encode(requestBody);
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //   return response;
  // }
}
