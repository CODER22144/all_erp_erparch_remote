import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http_parser/http_parser.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:go_router/go_router.dart';

import '../screen/ledger_codes.dart';
import '../screen/ledger_details_page.dart';

class LedgerCodesProvider with ChangeNotifier {
  static const String featureName = "ledgerCodes";
  static const String reportFeature = "ledgerCodesReport";
  static const String report2Feature = "ledgerReport";

  List<FormUI> formFieldDetails = [];
  List<FormUI> optFormFieldDetails1 = [];
  List<FormUI> optFormFieldDetails2 = [];
  List<FormUI> optFormFieldDetails3 = [];
  List<Widget> widgetList = [];
  List<Widget> optWidgetList1 = [];
  List<Widget> optWidgetList2 = [];
  List<Widget> optWidgetList3 = [];
  List<Widget> reportWidgetList = [];
  List<SearchableDropdownMenuItem<String>> partyCodes = [];

  String authToken = "";
  String expiry = "";

  String visibility = "";

  var request;

  List<dynamic> ledgerReport = [];
  dynamic ledgerRep = {};
  dynamic gstDetails = {};

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  SearchableDropdownController<String> stcdController =
      SearchableDropdownController<String>();

  String jsonData =
      '[{"id":"ltype","name":"Ledger Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-type/", "default" : "O"},{"id":"lstatus","name":"Status","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-status/", "default" : "A"},{"id":"remark","name":"Remark","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"agCode","name":"Ledger Group","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-account-groups/"},{"id":"lcode","name":"Ledger Code","isMandatory":true,"inputType":"text", "maxCharacter" : 10},{"id":"lname","name":"Ledger Name","isMandatory":true,"inputType":"text", "maxCharacter" : 50}]';

  List<DataRow> rows = [];

  Map<String, TextEditingController> controllerMap = {};

  void reset() {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    visibility = "";
  }

  void getPartyCodes() async {
    partyCodes.clear();
    partyCodes = await formService.getDropdownMenuItem("/get-ledger-codes/");
    notifyListeners();
  }

  void initWidget(BuildContext context) async {
    visibility = "";
    GlobalVariables.requestBody[featureName] = {};

    formFieldDetails.clear();
    optFormFieldDetails1.clear();
    optFormFieldDetails2.clear();
    optFormFieldDetails3.clear();

    widgetList.clear();
    optWidgetList1.clear();
    optWidgetList2.clear();
    optWidgetList3.clear();
    widgetList.clear();

    String jsonOpt1 =
        '[{"id":"Gstin","name":"GSTIN","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"SupTyp","name":"Supply Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-supply-type/", "default" : "B2B"},{"id":"tdsCode","name":"TDS Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-tds/"},{"id":"rc","name":"Reverse Charge","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/", "default" : "N"},{"id":"regId","name":"Ledger Gst Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-gst-regen-type/", "default" : "REG"},{"id":"isEcom","name":"Is Ecom?","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/", "default" : "N"},{"id":"crDays","name":"Credit Days","isMandatory":false,"inputType":"number"},{"id":"paymentTerm","name":"Payment Term","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"add","name":"Address","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"add1","name":"Address 1","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"city","name":"City","isMandatory":false,"inputType":"text","maxCharacter":50},{"id":"Stcd","name":"State","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-states/"},{"id":"zipCode","name":"ZipCode","isMandatory":false,"inputType":"text","maxCharacter":6},{"id":"distance","name":"Distance","isMandatory":false,"inputType":"number"},{"id":"country","name":"Country","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-countries/", "default" : "IN"},{"id":"phone","name":"Phone","isMandatory":false,"inputType":"text","maxCharacter":10},{"id":"altPhone","name":"WhatsApp","isMandatory":false,"inputType":"text","maxCharacter":10},{"id":"email","name":"Email","isMandatory":false,"inputType":"text","maxCharacter":50}]';
    String jsonOpt2 =
        '[{"id":"bankAcNo","name":"BankAcNo","isMandatory":true,"inputType":"text","maxCharacter":20},{"id":"bankAcName","name":"BankAcName","isMandatory":true,"inputType":"text","maxCharacter":50},{"id":"bankName","name":"BankName","isMandatory":true,"inputType":"text","maxCharacter":50},{"id":"ifscCode","name":"IfscCode","isMandatory":true,"inputType":"text","maxCharacter":11},{"id":"swiftCode","name":"SwiftCode","isMandatory":true,"inputType":"text","maxCharacter":20}]';
    String jsonOpt3 =
        '[{"id":"discType","name":"DiscType","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-discount-type/"},{"id":"discRate","name":"DiscRate","isMandatory":false,"inputType":"number", "default" : 0},{"id":"loyaltyDisc","name":"LoyaltyDisc","isMandatory":false,"inputType":"number", "default" : 0},{"id":"paymentDisc","name":"Payment Discount","isMandatory":false,"inputType":"number", "default" : 0},{"id":"igstOnIntra","name":"IgstOnIntra","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/", "default" : "N"}]';

    for (var element in jsonDecode(jsonData)) {
      controllerMap[element['id']] = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255,
          defaultValue: element['default'],
          controller: controllerMap[element['id']],
          eventTrigger: element['id'] == 'ltype' ? setVisibility : null,
          children: element['children'] ?? []));
    }
    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);

    // OPT1
    for (var element in jsonDecode(jsonOpt1)) {
      controllerMap[element['id']] = TextEditingController();
      optFormFieldDetails1.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          defaultValue: element['default'],
          controller: element['id'] == 'Stcd'
              ? stcdController
              : controllerMap[element['id']],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255,
          suffix: element['id'] == 'Gstin'
              ? ElevatedButton(
                  onPressed: () async {
                    var gstin =
                        GlobalVariables.requestBody[featureName]['Gstin'];
                    getGstnDetails(context, gstin);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3), // Square shape
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  ),
                  child: const Text(
                    "Gstin Details",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ))
              : null,
          children: element['children'] ?? []));
    }
    List<Widget> optWidgets1 = await formService.generateDynamicForm(
        optFormFieldDetails1, featureName);
    optWidgetList1.addAll(optWidgets1);

    // OPT2
    for (var element in jsonDecode(jsonOpt2)) {
      controllerMap[element['id']] = TextEditingController();
      optFormFieldDetails2.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          defaultValue: element['default'],
          controller: controllerMap[element['id']],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255,
          children: element['children'] ?? []));
    }
    List<Widget> optWidgets2 = await formService.generateDynamicForm(
        optFormFieldDetails2, featureName);
    optWidgetList2.addAll(optWidgets2);

    // OPT3
    for (var element in jsonDecode(jsonOpt3)) {
      controllerMap[element['id']] = TextEditingController();
      optFormFieldDetails3.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          defaultValue: element['default'],
          controller: controllerMap[element['id']],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255,
          children: element['children'] ?? []));
    }
    List<Widget> optWidgets3 = await formService.generateDynamicForm(
        optFormFieldDetails3, featureName);
    optWidgetList3.addAll(optWidgets3);

    notifyListeners();
  }

  Future<Map<String, dynamic>> getByIdPartyCode(String partyCode) async {
    http.StreamedResponse response =
        await networkService.get("/get-ledger-code/$partyCode/");
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEditWidget(String partyCode) async {
    GlobalVariables.requestBody[featureName] = {};
    Map<String, dynamic> editMapData = await getByIdPartyCode(partyCode);
    GlobalVariables.requestBody[featureName] = editMapData;
    formFieldDetails.clear();
    widgetList.clear();

    optFormFieldDetails1.clear();
    optFormFieldDetails2.clear();
    optFormFieldDetails3.clear();

    optWidgetList1.clear();
    optWidgetList2.clear();
    optWidgetList3.clear();
    widgetList.clear();

    String jsonOpt1 =
        '[{"id":"SupTyp","name":"Supply Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-supply-type/", "default" : "B2B"},{"id":"tdsCode","name":"TDS Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-tds/"},{"id":"rc","name":"Reverse Charge","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/", "default" : "N"},{"id":"regId","name":"Ledger Gst Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-gst-regen-type/", "default" : "REG"},{"id":"Gstin","name":"GSTIN","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"isEcom","name":"Is Ecom?","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/", "default" : "N"},{"id":"crDays","name":"Credit Days","isMandatory":false,"inputType":"number"},{"id":"paymentTerm","name":"Payment Term","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"add","name":"Address","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"add1","name":"Address 1","isMandatory":false,"inputType":"text","maxCharacter":100},{"id":"city","name":"City","isMandatory":false,"inputType":"text","maxCharacter":50},{"id":"Stcd","name":"State","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-states/"},{"id":"zipCode","name":"ZipCode","isMandatory":false,"inputType":"text","maxCharacter":6},{"id":"distance","name":"Distance","isMandatory":false,"inputType":"number"},{"id":"country","name":"Country","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-countries/", "default" : "IN"},{"id":"phone","name":"Phone","isMandatory":false,"inputType":"text","maxCharacter":10},{"id":"altPhone","name":"WhatsApp","isMandatory":false,"inputType":"text","maxCharacter":10},{"id":"email","name":"Email","isMandatory":false,"inputType":"text","maxCharacter":50}]';
    String jsonOpt2 =
        '[{"id":"bankAcNo","name":"BankAcNo","isMandatory":true,"inputType":"text","maxCharacter":20},{"id":"bankAcName","name":"BankAcName","isMandatory":true,"inputType":"text","maxCharacter":50},{"id":"bankName","name":"BankName","isMandatory":true,"inputType":"text","maxCharacter":50},{"id":"ifscCode","name":"IfscCode","isMandatory":true,"inputType":"text","maxCharacter":11},{"id":"swiftCode","name":"SwiftCode","isMandatory":true,"inputType":"text","maxCharacter":20}]';
    String jsonOpt3 =
        '[{"id":"discType","name":"DiscType","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-discount-type/"},{"id":"discRate","name":"DiscRate","isMandatory":false,"inputType":"number", "default" : 0},{"id":"loyaltyDisc","name":"LoyaltyDisc","isMandatory":false,"inputType":"number", "default" : 0},{"id":"paymentDisc","name":"Payment Discount","isMandatory":false,"inputType":"number", "default" : 0},{"id":"igstOnIntra","name":"IgstOnIntra","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/", "default" : "N"}]';

    visibility = editMapData['ltype'] ?? "";

    for (var element in jsonDecode(jsonData)) {
      TextEditingController editController = TextEditingController();
      formFieldDetails.add(FormUI(
        id: element['id'],
        name: element['name'],
        isMandatory: false,
        inputType: element['inputType'],
        dropdownMenuItem: element['dropdownMenuItem'] ?? "",
        maxCharacter: element['maxCharacter'] ?? 255,
        controller: editController,
        children: element['children'] ?? [],
        eventTrigger: element['id'] == 'ltype' ? setVisibility : null,
        defaultValue: editMapData[element['id']],
      ));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);

    // JSON 1

    for (var element in jsonDecode(jsonOpt1)) {
      TextEditingController editController = TextEditingController();
      optFormFieldDetails1.add(FormUI(
        id: element['id'],
        name: element['name'],
        isMandatory: false,
        inputType: element['inputType'],
        dropdownMenuItem: element['dropdownMenuItem'] ?? "",
        maxCharacter: element['maxCharacter'] ?? 255,
        controller: editController,
        children: element['children'] ?? [],
        defaultValue: editMapData[element['id']],
      ));
    }

    List<Widget> widgetsOpt1 = await formService.generateDynamicForm(
        optFormFieldDetails1, featureName);
    optWidgetList1.addAll(widgetsOpt1);

    // JSON 2
    for (var element in jsonDecode(jsonOpt2)) {
      TextEditingController editController = TextEditingController();
      optFormFieldDetails2.add(FormUI(
        id: element['id'],
        name: element['name'],
        isMandatory: false,
        inputType: element['inputType'],
        dropdownMenuItem: element['dropdownMenuItem'] ?? "",
        maxCharacter: element['maxCharacter'] ?? 255,
        controller: editController,
        children: element['children'] ?? [],
        defaultValue: editMapData[element['id']],
      ));
    }

    List<Widget> widgetsOpt2 = await formService.generateDynamicForm(
        optFormFieldDetails2, featureName);
    optWidgetList2.addAll(widgetsOpt2);

    // JSON 3
    for (var element in jsonDecode(jsonOpt3)) {
      TextEditingController editController = TextEditingController();
      optFormFieldDetails3.add(FormUI(
        id: element['id'],
        name: element['name'],
        isMandatory: false,
        inputType: element['inputType'],
        dropdownMenuItem: element['dropdownMenuItem'] ?? "",
        maxCharacter: element['maxCharacter'] ?? 255,
        controller: editController,
        children: element['children'] ?? [],
        defaultValue: editMapData[element['id']],
      ));
    }

    List<Widget> widgetsOpt3 = await formService.generateDynamicForm(
        optFormFieldDetails3, featureName);
    optWidgetList3.addAll(widgetsOpt3);

    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo(bool manual) async {
    if (!manual) {
      http.StreamedResponse respFile = await request.send();
      return respFile;
    }

    String? ipAddress = await networkService.getPublicIpAddress();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> payload = [];
    // if (manual) {
    GlobalVariables.requestBody[featureName]["workstation"] = ipAddress;
    GlobalVariables.requestBody[featureName]["userid"] =
        prefs.getString("currentLoginId");
    payload = [GlobalVariables.requestBody[featureName]];
    // }
    // else {
    //   payload = GlobalVariables.requestBody[featureName];
    // }

    http.StreamedResponse response =
        await networkService.post("/add-ledger-codes/", payload);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    String? ipAddress = await networkService.getPublicIpAddress();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    GlobalVariables.requestBody[featureName]["workstation"] = ipAddress;
    GlobalVariables.requestBody[featureName]["userid"] =
        prefs.getString("currentLoginId");

    http.StreamedResponse response = await networkService.post(
        "/update-ledger-codes/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"lstatus","name":"Ledger Status","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-status/","default":"A"},{"id":"lname","name":"Ledger Name","isMandatory":false,"inputType":"text","maxCharacter":50},{"id":"lcode","name":"Ledger Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"stateCode","name":"State","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-states/"},{"id":"supplyType","name":"Supply Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-supply-type/"}]';

    for (var element in jsonDecode(jsonData)) {
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          controller: TextEditingController(),
          defaultValue: element['default'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, reportFeature);
    reportWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getLedgerReport() async {
    ledgerReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-ledger-codes-report/",
        GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      ledgerReport = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void setVisibility() {
    visibility = GlobalVariables.requestBody[LedgerCodesProvider.featureName]
            ['ltype'] ??
        "";
    notifyListeners();
  }

  void initLedgerReport() async {
    GlobalVariables.requestBody[report2Feature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"lcode","name":"Ledger Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem" : "/get-ledger-codes/"},{"id":"fromDate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"toDate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

    for (var element in jsonDecode(jsonData)) {
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          controller: TextEditingController(),
          defaultValue: element['default'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, report2Feature);
    reportWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getLedgersReport() async {
    ledgerRep.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-ledger-report/", GlobalVariables.requestBody[report2Feature]);
    if (response.statusCode == 200) {
      ledgerRep = jsonDecode(await response.stream.bytesToString());
    }
    getRows();
  }

  void getRows() {
    rows.clear();

    // rows.add(DataRow(cells: [
    //   DataCell(Text('${ledgerRep['lcode'] ?? "-"}', style: const TextStyle(fontWeight: FontWeight.bold),)),
    //   DataCell(Text('${ledgerRep['lname'] ?? "-"}', style: const TextStyle(fontWeight: FontWeight.bold))),
    //   // DataCell(Text('${ledgerRep['legalName'] ?? "-"}')),
    //   // DataCell(Text(
    //   //     '${ledgerRep['compAdd'] ?? "-"} ${ledgerRep['compAdd1'] ?? "-"}')),
    //   // DataCell(Text('${ledgerRep['compCity'] ?? "-"}')),
    //   const DataCell(SizedBox()),
    //   const DataCell(SizedBox()),
    //   const DataCell(SizedBox()),
    //   const DataCell(SizedBox()),
    //   const DataCell(SizedBox()),
    // ]));

    rows.add(const DataRow(cells: [
      DataCell(
          Text('Ledger Name', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(
          Text('Bill Date', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(
          Text('Narration', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(
          Text('DB Amount', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(
          Text('CR Amount', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text('Balance', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
    ]));

    for (var data in ledgerRep['ledgerdet']) {
      rows.add(DataRow(cells: [
        DataCell(Text('${data['lname'] ?? "-"}')),
        DataCell(Text('${data['billDate'] ?? "-"}')),
        DataCell(Text('${data['naration'] ?? "-"}')),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child:
                Text(parseDoubleUpto2Decimal('${data['dbamount'] ?? "-"}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child:
                Text(parseDoubleUpto2Decimal('${data['cramount'] ?? "-"}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child:
                Text(parseDoubleUpto2Decimal('${data['rowtotal'] ?? "-"}')))),
        DataCell(Text('${data['ty'] ?? "-"}')),
      ]));
    }

    var sumData = ledgerRep['ledgersum'][0];

    rows.add(DataRow(cells: [
      const DataCell(SizedBox()),
      const DataCell(
          Text('GRAND TOTAL', style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(SizedBox()),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
              parseDoubleUpto2Decimal('${sumData['totdbAmount'] ?? "-"}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
              parseDoubleUpto2Decimal('${sumData['totcrAmount'] ?? "-"}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${sumData['balAmount'] ?? "-"}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Text('${sumData['ty'] ?? "-"}',
          style: const TextStyle(fontWeight: FontWeight.bold))),
    ]));

    notifyListeners();
  }

  void uploadExcel(String blobPath, String name) async {
    request = http.MultipartRequest(
        'POST', Uri.parse('${NetworkService.baseUrl}/import-ledger-codes/'));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("auth_token");
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      "Authorization": "Bearer $token"
    };

    if (kIsWeb) {
      // Fetch the blob
      final response = await http.get(Uri.parse(blobPath));

      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;

        // Create a multipart file
        final http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: name,
          contentType: MediaType('image', 'png'),
        );

        // Add the multipart file to the request
        request.files.add(multipartFile);
      }
    } else {
      request.files.add(await http.MultipartFile.fromPath('file', blobPath));
    }
    request.headers.addAll(headers);

    notifyListeners();
  }

  Future<String> authorizeGstToken(BuildContext context) async {
    String? ipAddress = await networkService.getPublicIpAddress();

    Map<String, String> headers = {
      'accept': '*/*',
      'username': "API_swisssolapi",
      'password': r'TsldoqdhAW"$2937',
      'ip_address': ipAddress ?? "115.241.56.122",
      'client_id': "EINP97df8e27-a1c8-4632-a21a-69151899b960",
      'client_secret': "EINPca7a8069-0226-42aa-963c-60f6382e1a7d",
      'gstin': "07AADCG7261M1Z9"
    };

    var request = http.Request(
        'GET',
        Uri.parse(
            '${NetworkService.productionGstBaseUrl}/einvoice/authenticate?email=ajay%40sapswiss.com'));
    request.bodyFields = {};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var gstCreds = jsonDecode(await response.stream.bytesToString());

      return gstCreds['data']['AuthToken'];
    } else {
      var responseBody = jsonDecode(await response.stream.bytesToString());
      var error = responseBody['error'];
      if (error != null) {
        await showAlertDialog(
            context, responseBody['error']['message'], "Continue", false);
      } else {
        await showAlertDialog(
            context, responseBody['status_desc'], "Continue", false);
      }
    }
    return "";
  }

  void getGstnDetails(BuildContext context, String gstin) async {
    String authToken = "";

    authToken = await authorizeGstToken(context);

    var headers = {
      'accept': '*/*',
      'ip_address': '115.241.56.122',
      'client_id': "EINP97df8e27-a1c8-4632-a21a-69151899b960",
      'client_secret': "EINPca7a8069-0226-42aa-963c-60f6382e1a7d",
      'username': 'API_swisssolapi',
      'auth-token': authToken,
      'gstin': "07AADCG7261M1Z9"
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${NetworkService.productionGstBaseUrl}/einvoice/type/GSTNDETAILS/version/V1_03?param1=$gstin&email=ajay%40sapswiss.com'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responseBody = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      http.StreamedResponse result =
          await networkService.post("/get-gstn-details/", responseBody);
      var message = jsonDecode(await result.stream.bytesToString());
      if (result.statusCode == 200) {
        var data = jsonDecode(message[0]['']);
        controllerMap['lname']?.text = data['lname'];
        controllerMap['add']?.text = data['add'];
        controllerMap['add1']?.text = data['add1'];
        controllerMap['zipCode']?.text = '${data['zipCode']}';
        var states = await formService.getDropdownMenuItem("/get-states/");
        stcdController.selectedItem.value = findDropdownMenuItem(
            states, data['Stcd'].toString().padLeft(2, '0'));

        GlobalVariables.requestBody[featureName]['lname'] = data['lname'];
        GlobalVariables.requestBody[featureName]['add'] = data['add'];
        GlobalVariables.requestBody[featureName]['add1'] = data['add1'];
        GlobalVariables.requestBody[featureName]['zipCode'] = data['zipCode'];
        GlobalVariables.requestBody[featureName]['Stcd'] = data['Stcd'];

        notifyListeners();
      } else if (result.statusCode == 400) {
        await showAlertDialog(
            context, message['message'].toString(), "Continue", false);
      } else if (result.statusCode == 500) {
        await showAlertDialog(context, message['message'], "Continue", false);
      } else {
        await showAlertDialog(context, message['message'], "Continue", false);
      }
    } else {
      var error = responseBody['error'];
      if (error != null) {
        await showAlertDialog(
            context, responseBody['error']['message'], "Continue", false);
      } else {
        await showAlertDialog(
            context, responseBody['status_desc'], "Continue", false);
      }
    }
  }
}
