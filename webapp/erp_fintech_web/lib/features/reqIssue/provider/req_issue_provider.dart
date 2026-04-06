import 'dart:convert';

import 'package:fintech_new_web/features/reqIssue/screens/req_issue_mat_edit.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/provider/auth_provider.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';
import '../../utility/services/generate_form_service.dart';
import '../screens/add_req_issue.dart';

class ReqIssueProvider with ChangeNotifier {
  static const String featureName = "ReqIssue";
  static const String pendingFeature = "ReqIssuePending";
  static const String editFeature = "EditReqIssuePending";

  List<FormUI> formFieldDetails = [];
  List<FormUI> editFormFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> editWidgetList = [];
  List<Widget> pendingWidgetList = [];
  List<dynamic> reqPending = [];
  List<dynamic> reqSummary = [];
  List<List<String>> rowFields = [];
  List<DataRow> summaryRows = [];

  List<List<TextEditingController>> rowControllers = [];

  List<DataRow> rows = [];
  List<dynamic> materialList = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  void initWidget(String reqId) async {
    rowFields.clear();
    materialList.clear();
    rowControllers.clear();
    http.StreamedResponse response =
        await networkService.post("/get-req-mat-by-reqId/", {"reqId": reqId});
    if (response.statusCode == 200) {
      var respData = jsonDecode(await response.stream.bytesToString());
      materialList = respData;
      for (var data in respData) {
        rowFields
            .add(['${data['reqId']}', '${data['matno']}', '${data['bqty']}']);
        rowControllers.add([
          TextEditingController(text: '${data['matno']}'),
          TextEditingController(text: '${data['bqty']}')
        ]);
      }
    }
    notifyListeners();
  }

  void initAfterDelete(String reqId, int index) async {
    rowFields.clear();
    materialList.removeAt(index);
    deleteRowController(index);
    for (int i = 0; i < materialList.length; i++) {
      rowFields.add([
        '${materialList[i]['reqId']}',
        '${materialList[i]['matno']}',
        '${materialList[i]['bqty']}'
      ]);
    }

    notifyListeners();
  }

  void deleteRowIndex(int index) {
    rowFields.removeAt(index);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo(
      List<List<String>> tableRows) async {
    List<Map<String, dynamic>> reqIssue = [];
    for (int i = 0; i < tableRows.length; i++) {
      reqIssue.add({
        "reqId": tableRows[i][0],
        "matno": tableRows[i][1],
        "qty": tableRows[i][2],
      });
    }
    http.StreamedResponse response =
        await networkService.post("/add-req-issue/", reqIssue);
    return response;
  }

  void initPendingWidget() async {
    GlobalVariables.requestBody[pendingFeature] = {};
    formFieldDetails.clear();
    pendingWidgetList.clear();
    String jsonData =
        '[{"id":"dcode","name":"Department Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-department/"},{"id":"rtId","name":"Requirement Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/req-type/"},{"id":"reqId","name":"Requirement ID","isMandatory":false,"inputType":"number"},{"id":"matno","name":"Material no.","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"fromDate","name":"From Date","isMandatory":false,"inputType":"datetime"},{"id":"toDate","name":"To Date","isMandatory":false,"inputType":"datetime"}]';

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
        formFieldDetails, pendingFeature,
        disableDefault: true);
    pendingWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getReqIssuePending(BuildContext context) async {
    reqPending.clear();
    Map<String, List<dynamic>> groupedData = {};
    http.StreamedResponse response = await networkService.post(
        "/get-req-issue-pending/", GlobalVariables.requestBody[pendingFeature]);
    if (response.statusCode == 200) {
      reqPending = jsonDecode(await response.stream.bytesToString());
      for (var data in reqPending) {
        if (groupedData['${data['reqId']}'] != null) {
          groupedData['${data['reqId']}']?.add(data);
        } else {
          groupedData['${data['reqId']}'] = [data];
        }
      }
    }
    groupedDataTable(groupedData, context);
  }

  void groupedDataTable(
      Map<String, List<dynamic>> groupedData, BuildContext context) {
    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    provider.initUserInfo();

    rows.clear();
    groupedData.forEach((key, value) {
      rows.add(DataRow(cells: [
        DataCell(RichText(
            text: TextSpan(
                text: "ReqId: ",
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [
              TextSpan(
                  text: '$key\n',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var cid = prefs.getString("currentLoginCid");
                      final Uri uri = Uri.parse(
                          "${NetworkService.baseUrl}/req-slip/$key/$cid/");
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                      } else {
                        throw 'Could not launch';
                      }
                    },
                  style: const TextStyle(
                      color: Colors.blueAccent, fontWeight: FontWeight.w600)),
              TextSpan(
                  text: 'Date: ${value[0]['dtDate']}',
                  style: const TextStyle(fontWeight: FontWeight.bold))
            ]))),
        DataCell(Text('Mode: ${value[0]['mode'] ?? ""}',
            style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text("Dept: ${value[0]['deptName'] ?? ""}",
            style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text('Prod Matno: ${value[0]['prodmatno'] ?? ""}',
            style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text('Prod Qty: ${value[0]['prodqty'] ?? ""}',
            style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Visibility(
          visible: provider.userInfo['roles'] == 'ST' ||
              provider.userInfo['roles'] == 'AD',
          child: ElevatedButton(
              onPressed: () {
                context.pushNamed(AddReqIssue.routeName,
                    queryParameters: {"reqId": key});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1), // Square shape
                ),
                padding: EdgeInsets.zero,
                // Remove internal padding to make it square
                minimumSize:
                    const Size(150, 50), // Width and height for the button
              ),
              child: const Text(
                "Issue Material",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
        ))
      ]));
      for (var data in value) {
        rows.add(DataRow(cells: [
          DataCell(Row(children: [InkWell(child: const Icon(Icons.edit_outlined, color: Colors.blueAccent), onTap: () {
            context.pushNamed(ReqIssueMatEdit.routeName, queryParameters: {
              "reqdId" : '${data['reqdId'] ?? "-"}'
            });
          }), Text('${data['matno'] ?? "-"}')],)),
          DataCell(Text('${data['qty'] ?? "-"}')),
          DataCell(Text('${data['iqty'] ?? "-"}')),
          DataCell(Text('${data['bqty'] ?? "-"}')),
          DataCell(Text('${data['qtyinstock'] ?? "-"}')),
          const DataCell(Text('')),
        ]));
      }
    });
    notifyListeners();
  }

  void updateRowField(List<List<String>> rows) {
    rowFields = rows;
    notifyListeners();
  }

  void getReqIssueSummary() async {
    reqSummary.clear();
    http.StreamedResponse response = await networkService.get("/req-summary/");
    if (response.statusCode == 200) {
      reqSummary = jsonDecode(await response.stream.bytesToString());
    }
    getRows();
  }

  void getRows() {
    summaryRows.clear();
    List<double> sums = [0, 0, 0, 0];
    for (var data in reqSummary) {
      sums[0] += parseEmptyStringToDouble(data['sumqty']);
      sums[1] += parseEmptyStringToDouble(data['sumiqty']);
      sums[2] += parseEmptyStringToDouble(data['sumbqty']);
      sums[3] += parseEmptyStringToDouble(data['qtyinstock']);

      summaryRows.add(DataRow(cells: [
        DataCell(Text('${data['matno'] ?? "-"}')),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text('${data['sumqty'] ?? "-"}'))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text('${data['sumiqty'] ?? "-"}'))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text('${data['sumbqty'] ?? "-"}'))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text('${data['qtyinstock'] ?? "-"}'))),
      ]));
    }

    summaryRows.add(DataRow(cells: [
      const DataCell(
          Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal(sums[0].toString()),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal(sums[1].toString()),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal(sums[2].toString()),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal(sums[3].toString()),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
    ]));

    notifyListeners();
  }

  void initDetailsTab(List<List<String>> tableRows) {

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
    ]);
    notifyListeners();
  }


  void editRest() {
    GlobalVariables.requestBody[editFeature] = {};
    editFormFieldDetails.clear();
    editWidgetList.clear();
    notifyListeners();
  }

  Future<Map<String, dynamic>> getByIdReqDetails(String reqdId) async {
    http.StreamedResponse response =
    await networkService.post("/req-detail-byId/", {"reqdId": reqdId});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEdit(String reqdId) async {
    Map<String, dynamic> editMapData = await getByIdReqDetails(reqdId);
    GlobalVariables.requestBody[editFeature] = editMapData;
    editFormFieldDetails.clear();
    editWidgetList.clear();

    String jsonData =
        '[{"id":"matno","name":"Material No.","isMandatory":true,"inputType":"text","maxCharacter":15, "default" : "${editMapData['matno']}"},{"id":"cqty","name":"Qty","isMandatory":true,"inputType":"number", "default" : "${editMapData['bqty']}"}]';

    for (var element in jsonDecode(jsonData)) {
      TextEditingController editController = TextEditingController();
      editFormFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255,
          controller: editController,
          defaultValue: element['default']));
    }

    List<Widget> widgets = await formService.generateDynamicForm(
        editFormFieldDetails, editFeature);
    editWidgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> updateReqDetails() async {
    http.StreamedResponse response = await networkService.post(
        "/update-req-details/", GlobalVariables.requestBody[editFeature]);
    return response;
  }



}
