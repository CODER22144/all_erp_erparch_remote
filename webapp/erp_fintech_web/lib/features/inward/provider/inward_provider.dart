import 'dart:convert';

import 'package:fintech_new_web/features/common/widgets/custom_dropdown_field.dart';
import 'package:fintech_new_web/features/common/widgets/custom_text_field.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../../billReceipt/screen/hyperlink.dart';
import '../../camera/service/camera_service.dart';
import '../../network/service/network_service.dart';
import '../../payment/provider/payment_provider.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class InwardProvider with ChangeNotifier {
  static const String featureName = "inward";
  static const String reportFeature = "inwardReport";
  static const String tdsReportFeature = "tdsReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];

  List<dynamic> exportInward = [];

  DataTable table =
      DataTable(columns: const [DataColumn(label: Text(""))], rows: const []);

  List<DataRow> rows = [];

  List<SearchableDropdownMenuItem<String>> discountType = [];
  List<SearchableDropdownMenuItem<String>> tcsItems = [];
  List<SearchableDropdownMenuItem<String>> supplyType = [];
  List<SearchableDropdownMenuItem<String>> supplierType = [];
  List<SearchableDropdownMenuItem<String>> reverseCharge = [];
  List<SearchableDropdownMenuItem<String>> tdsCodes = [];

  List<List<String>> rowField = [];
  String storedGrDetails = "";

  List<dynamic> tdsReport = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  TextEditingController tdsController = TextEditingController();
  TextEditingController tdsRateController = TextEditingController();

  SearchableDropdownController<String> supplyController =
      SearchableDropdownController<String>();
  SearchableDropdownController<String> supplierController =
      SearchableDropdownController<String>();
  SearchableDropdownController<String> tdsCodeController =
      SearchableDropdownController<String>();
  SearchableDropdownController<String> rcController =
      SearchableDropdownController<String>();
  SearchableDropdownController<String> tcsController =
      SearchableDropdownController<String>();

  setStoredGrDetails(String data) {
    storedGrDetails = data;
    notifyListeners();
  }

  void initWidget(dynamic grDetails, String disable) async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    setStoredGrDetails(grDetails);
    var data = jsonDecode(grDetails);
    String jsonData =
        '[{"id":"transDate","name":"Transaction Date","isMandatory":true,"inputType":"datetime"},{"id":"brId","name":"Bill Receipt No.","isMandatory":true,"inputType":"number", "default" : "${data['brid'] ?? data['brId'] ?? ''}"},{"id":"grno","name":"Goods Receipt No.","isMandatory":false,"inputType":"number", "default" : "${data['grno'] ?? ''}"},{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/", "default" : "${data['bpCode']}", "readOnly" : ${disable == "true"}},{"id":"billNo","name":"Bill No.","isMandatory":false,"inputType":"number", "default" : "${data['billNo'] ?? ''}"},{"id":"billDate","name":"Bill Date","isMandatory":false,"inputType":"datetime", "default" : "${data['dbillDate'] ?? ''}"},{"id":"tcs","name":"TCS","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/", "default" : "${data['tcs'] ?? ''}"},{"id":"dbCode","name":"Debit Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/", "default" : "${data['crdrCode'] ?? ''}"},{"id":"slId","name":"Supply Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-supply-type/", "default" : "${data['slId'] ?? ''}"},{"id":"stId","name":"Supplier Type","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-supplier-type/", "default" : "${data['stId'] ?? ""}"},{"id":"rc","name":"Reverse Charges","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/", "default" : "${data['rc'] ?? ""}"}]';

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
          readOnly: element['readOnly'] ?? false,
          eventTrigger:
              element['id'] == 'lcode' ? autoFillDetailsByPartyCode : null,
          suffix: (element['id'] == 'brId' || element['id'] == "grno")
              ? element['id'] == 'grno'
                  ? data['grno'] != null
                      ? viewGr(data['grno'].toString())
                      : null
                  : viewBr(data['docImage'])
              : null));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    initCustomObjects(data['grno'] ?? "", data['tdsCode'] ?? "",
        parseEmptyStringToDouble(data['rtds'].toString()) ?? 0);
  }

  void initCustomObjects(dynamic grNo, String tdsCode, double rtds) async {
    tdsCodes = await formService.getDropdownMenuItem("/get-tds/");
    tcsItems = await formService.getDropdownMenuItem("/get-yesno/");
    reverseCharge = await formService.getDropdownMenuItem("/get-yesno/");
    supplyType = await formService.getDropdownMenuItem("/get-supply-type/");
    supplierType = await formService.getDropdownMenuItem("/get-supplier-type/");

    widgetList.addAll([
      Row(
        children: [
          SizedBox(
            width: GlobalVariables.deviceWidth * 0.13,
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "",
                    style: TextStyle(color: Colors.red),
                  )
                ],
                text: "TDS Code",
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
                  id: "tdsCode",
                  name: "TDS Code",
                  isMandatory: false,
                  inputType: "dropdown",
                  controller: tdsController,
                  defaultValue: tdsCode),
              feature: featureName,
              dropdownMenuItems: tdsCodes,
              customFunction: getTdsRate,
            ),
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
                    text: "",
                    style: TextStyle(color: Colors.red),
                  )
                ],
                text: "Tds Rate",
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
                  id: "rtds",
                  name: "Tds Rate",
                  isMandatory: false,
                  inputType: "text",
                  controller: tdsRateController,
                  defaultValue: rtds),
              feature: featureName,
              inputType: TextInputType.text,
            ),
          ),
        ],
      )
    ]);

    rowField.clear();
    http.StreamedResponse response = await networkService.get("/get-gr/$grNo/");

    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      for (var element in data[0]['grd']) {
        rowField.add([
          '${element['matDescription'] ?? ""}',
          '${element['matno'] ?? ""}',
          '${element['hsnCode'] ?? ""}',
          '${element['grQty'] ?? ""}',
          '${element['grRate'] ?? "0"}',
          '${element['grAmount'] ?? "0"}',
          'N',
          '0',
          '0',
          '0',
          '0',
          '0',
          '0',
          '${element['gstTaxRate'] ?? "0"}',
          '${element['gstAmount'] ?? "0"}',
          '0',
          '${element['tAmount'] ?? "0"}'
        ]);
      }
    } else {
      rowField.add([
        '',
        '',
        '',
        '',
        '',
        '0',
        'N',
        '0',
        '0',
        '0',
        '0',
        '0',
        '0',
        '0',
        '0',
        '0',
        '0'
      ]);
    }

    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo(
      List<List<String>> tableRows) async {
    List<Map<String, dynamic>> inwardDetails = [];
    for (int i = 0; i < tableRows.length; i++) {
      inwardDetails.add({
        "naration": tableRows[i][0],
        "matno": tableRows[i][1] == "" ? null : tableRows[i][1],
        "hsnCode": tableRows[i][2],
        "qty": tableRows[i][3],
        "rate": tableRows[i][4],
        "amount": tableRows[i][5],
        "discType": tableRows[i][6],
        "rdisc": tableRows[i][7],
        "discountAmount": tableRows[i][8],
        "bcd": tableRows[i][9],
        "roff": tableRows[i][10],
        "rcess": tableRows[i][11],
        "cessAmount": tableRows[i][12],
        "rgst": tableRows[i][13],
        "gstAmount": tableRows[i][14],
        "tcsAmount": tableRows[i][15],
        "tamount": tableRows[i][16]
      });
    }
    GlobalVariables.requestBody[featureName]['InwardDetails'] = inwardDetails;
    http.StreamedResponse response = await networkService.post(
        "/add-inward-details/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void setImagePath(String blob, String name) async {
    String blobUrl = "";
    Camera camera = Camera();
    blobUrl = await camera.getBlobUrl(blob, name);
    if (blobUrl.isNotEmpty) {
      GlobalVariables.requestBody[featureName]["DocProof"] = blobUrl;
    }
    notifyListeners();
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

  void getTdsRate() async {
    String tdsCode = GlobalVariables.requestBody[featureName]['tdsCode'];
    if (tdsCode != null && tdsCode != "") {
      http.StreamedResponse response =
          await networkService.get("/get-tds-rate/$tdsCode/");
      if (response.statusCode == 200) {
        var tds = jsonDecode(await response.stream.bytesToString());
        tdsRateController.text = tds[0]['rtds'];
        GlobalVariables.requestBody[featureName]['rtds'] =
            tdsRateController.text;
        notifyListeners();
      }
    }
  }

  Widget viewGr(String grno) {
    return ElevatedButton(
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var cid = prefs.getString("currentLoginCid");
          final Uri uri =
              Uri.parse("${NetworkService.baseUrl}/srv/$grno/$cid/");
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
          } else {
            throw 'Could not launch';
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: HexColor("#0038a8"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3), // Square shape
          ),
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        ),
        child: const Text(
          "View Gr",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ));
  }

  Widget viewBr(String url) {
    return ElevatedButton(
        onPressed: () async {
          final Uri uri = Uri.parse("${NetworkService.baseUrl}${url ?? ""}");
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
          } else {
            throw 'Could not launch $url';
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: HexColor("#0038a8"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3), // Square shape
          ),
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        ),
        child: const Text(
          "View Br",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ));
  }

  void autoFillDetailsByPartyCode() async {
    var partyCode = GlobalVariables.requestBody[featureName]['lcode'];
    if (partyCode != null && partyCode != "") {
      http.StreamedResponse response =
          await networkService.get("/get-ledger-code-supply/$partyCode/");
      if (response.statusCode == 200) {
        var data = jsonDecode(storedGrDetails);
        var details = jsonDecode(await response.stream.bytesToString())[0];
        data['bpCode'] = partyCode;
        data['tcs'] = details['tcs'];
        data['slId'] = details['slId'];
        data['stId'] = details['stId'];
        data['rc'] = details['rc'];
        data['tdsCode'] = details['tdsCode'];
        data['rtds'] = details['rtds'];
        initWidget(jsonEncode(data), "false");
      }
    }
    notifyListeners();
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"lcode","name":"Party Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"vtype","name":"Voucher Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-voucher-type/"},{ "id": "slId", "name": "Supply Type", "isMandatory": false, "inputType": "dropdown", "dropdownMenuItem": "/get-supply-type/" }, { "id": "stId", "name": "Supplier Type", "isMandatory": false, "inputType": "dropdown", "dropdownMenuItem": "/get-supplier-type/" },{"id": "rc","name": "Reverse Charge","isMandatory": false,"inputType": "dropdown","dropdownMenuItem": "/get-yesno/"},{"id":"fdate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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

  void getInwardBillReportTable(BuildContext context) async {
    List<dynamic> inwardBillPending = [];
    http.StreamedResponse response = await networkService.post(
        "/get-inward-bill-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      inwardBillPending = jsonDecode(await response.stream.bytesToString());
      exportInward = inwardBillPending;
    }
    PaymentProvider paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);

    List<DataRow> dataRows = [];
    List<double> totalAmounts = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0];

    for (var data in inwardBillPending) {
      totalAmounts = [
        totalAmounts[0] + parseEmptyStringToDouble(data['amount']),
        totalAmounts[1] + parseEmptyStringToDouble(data['discountAmount']),
        totalAmounts[2] + parseEmptyStringToDouble(data['taxAmount']),
        totalAmounts[3] + parseEmptyStringToDouble(data['cessAmount']),
        totalAmounts[4] + parseEmptyStringToDouble(data['igstAmount']),
        totalAmounts[5] + parseEmptyStringToDouble(data['sgstAmount']),
        totalAmounts[6] + parseEmptyStringToDouble(data['cgstAmount']),
        totalAmounts[7] + parseEmptyStringToDouble(data['tcsAmount']),
        totalAmounts[8] + parseEmptyStringToDouble(data['bcd']),
        totalAmounts[9] + parseEmptyStringToDouble(data['roff']),
        totalAmounts[10] + parseEmptyStringToDouble(data['tamount']),
        totalAmounts[11] + parseEmptyStringToDouble(data['payamount']),
        totalAmounts[12] + parseEmptyStringToDouble(data['tdsAmount']),
        totalAmounts[13] + parseEmptyStringToDouble(data['bamount'])
      ];
      dataRows.add(DataRow(cells: [
        DataCell(InkWell(
            child: Text('${data['transId'] ?? "-"}',
                style: const TextStyle(color: Colors.blue)),
            onTap: () async {
              var resp = await paymentProvider.getInwardClear(
                  '${data['transId'] ?? "-"}', '${data['vtype'] ?? "-"}');
              billClearencePopup(context, resp);
            })),
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
            child: const Icon(Icons.file_present_outlined, color: Colors.white),
          ),
        )),
        DataCell(Text('${data['brId'] ?? "-"}')),
        DataCell(Text('${data['grno'] ?? "-"}')),
        DataCell(Text('${data['vtype'] ?? "-"}')),
        DataCell(Text('${data['lcode'] ?? "-"}')),
        DataCell(Text('${data['lName'] ?? "-"}')),
        DataCell(Text('${data['billNo'] ?? "-"}')),
        DataCell(Text('${data['DbillDate'] ?? "-"}')),
        DataCell(Text('${data['tdsCode'] ?? "-"}')),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['rtds'] ?? "-"}')))),
        DataCell(Text('${data['dbCode'] ?? "-"}')),
        DataCell(Text('${data['slId'] ?? "-"}')),
        DataCell(Text('${data['stId'] ?? "-"}')),
        DataCell(Text('${data['rc'] ?? "-"}')),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['amount'] ?? ""}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(
                parseDoubleUpto2Decimal('${data['discountAmount'] ?? ""}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child:
                Text(parseDoubleUpto2Decimal('${data['taxAmount'] ?? ""}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child:
                Text(parseDoubleUpto2Decimal('${data['cessAmount'] ?? ""}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child:
                Text(parseDoubleUpto2Decimal('${data['igstAmount'] ?? ""}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child:
                Text(parseDoubleUpto2Decimal('${data['cgstAmount'] ?? ""}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child:
                Text(parseDoubleUpto2Decimal('${data['sgstAmount'] ?? ""}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child:
                Text(parseDoubleUpto2Decimal('${data['tcsAmount'] ?? ""}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['bcd'] ?? ""}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['roff'] ?? ""}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['tamount'] ?? ""}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child:
                Text(parseDoubleUpto2Decimal('${data['payamount'] ?? ""}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child:
            Text(parseDoubleUpto2Decimal('${data['tdsAmount'] ?? ""}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['bamount'] ?? ""}')))),
      ]));
    }

    dataRows.add(DataRow(cells: [
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),

      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(Text(
        "Total",
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
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
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
            totalAmounts[11].toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
            totalAmounts[12].toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
            totalAmounts[13].toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ))),
    ]));

    table = DataTable(
      columnSpacing: 25,
      columns: const [
        DataColumn(label: Text("Tran Id")),
        DataColumn(label: Text("Bill")),
        DataColumn(label: Text("BR Id")),
        DataColumn(label: Text("GR No.")),
        DataColumn(label: Text("VType")),
        DataColumn(label: Text("Party Code")),
        DataColumn(label: Text("Party Name")),
        DataColumn(label: Text("Bill No")),
        DataColumn(label: Text("Bill Date")),
        DataColumn(label: Text("TDS Code")),
        DataColumn(label: Text("TDS Rate")),
        DataColumn(label: Text("Debit Code")),
        DataColumn(label: Text("Supply\nType")),
        DataColumn(label: Text("Supplier\nType")),
        DataColumn(label: Text("Reverse\nCharges")),
        DataColumn(label: Text("Amount")),
        DataColumn(label: Text("Discount\nAmount")),
        DataColumn(label: Text("Tax\nAmount")),
        DataColumn(label: Text("Cess\nAmount")),
        DataColumn(label: Text("IGST\nAmount")),
        DataColumn(label: Text("CGST\nAmount")),
        DataColumn(label: Text("SGST\nAmount")),
        DataColumn(label: Text("Tcs\nAmount")),
        DataColumn(label: Text("BCD")),
        DataColumn(label: Text("Roff.")),
        DataColumn(label: Text("Total\nAmount")),
        DataColumn(label: Text("Pay\nAmount")),
        DataColumn(label: Text("Tds\nAmount")),
        DataColumn(label: Text("Balance\nAmount")),
      ],
      rows: dataRows,
    );

    notifyListeners();
  }

  void billClearencePopup(BuildContext context, List<dynamic> orderBalance) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bill Clearance Details',
              style: TextStyle(fontWeight: FontWeight.w500)),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('Trans Id')),
                      DataColumn(label: Text('Voucher Type')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('Naration'))
                    ],
                    rows: orderBalance.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['transId'] ?? "-"}')),
                        DataCell(Text('${data['vtype'] ?? "-"}')),
                        DataCell(Align(
                            alignment: Alignment.centerRight,
                            child: Text(parseDoubleUpto2Decimal(
                                '${data['amount'] ?? "-"}')))),
                        DataCell(Text('${data['clnaration'] ?? "-"}')),
                      ]);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // Navigator.pop(context, false);
                    Navigator.of(context, rootNavigator: true).pop(false);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 5),
                    width: GlobalVariables.deviceWidth * 0.15,
                    height: GlobalVariables.deviceHeight * 0.05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: HexColor("#e0e0e0"),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          offset: Offset(
                            2,
                            3,
                          ),
                        )
                      ],
                    ),
                    child: const Text("CLOSE",
                        style: TextStyle(fontSize: 11, color: Colors.black)),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void initTdsReport() async {
    GlobalVariables.requestBody[tdsReportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"lcode","name":"Party Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id": "tdsCode","name": "TDS Code","isMandatory": false,"inputType": "dropdown","dropdownMenuItem": "/get-tds/"},{"id":"fdate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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
        formFieldDetails, tdsReportFeature);
    reportWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getTdsReport() async {
    tdsReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-tds-report/", GlobalVariables.requestBody[tdsReportFeature]);
    if (response.statusCode == 200) {
      tdsReport = jsonDecode(await response.stream.bytesToString());
      getRowsForTds();
    }
  }

  void getRowsForTds() {
    rows.clear();

    List<double> sums = [0,0,0,0,0,0,0,0,0,0];

    for(var data in tdsReport) {

      sums[0] += parseEmptyStringToDouble('${data['amount']}');
      sums[1] += parseEmptyStringToDouble('${data['discountAmount']}');
      sums[2] += parseEmptyStringToDouble('${data['taxAmount']}');
      sums[3] += parseEmptyStringToDouble('${data['cessAmount']}');
      sums[4] += parseEmptyStringToDouble('${data['igstAmount']}');
      sums[5] += parseEmptyStringToDouble('${data['cgstAmount']}');
      sums[6] += parseEmptyStringToDouble('${data['sgstAmount']}');
      sums[7] += parseEmptyStringToDouble('${data['roff']}');
      sums[8] += parseEmptyStringToDouble('${data['tamount']}');
      sums[9] += parseEmptyStringToDouble('${data['tdsAmount']}');


      rows.add(DataRow(cells: [
        DataCell(Hyperlink(text: '${data['transId']}', url: "${NetworkService.baseUrl}${data['DocProof']}")),
        DataCell(Text('${data['lcode'] ?? "-"} - ${data['lName'] ?? "-"}')),
        DataCell(Text('${data['billNo'] ?? "-"}')),
        DataCell(Text('${data['dbillDate'] ?? "-"}')),
        DataCell(Text('${data['section'] ?? "-"}')),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['amount']}')))),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['discountAmount']}')))),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['taxAmount']}')))),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['cessAmount']}')))),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['igstAmount']}')))),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['cgstAmount']}')))),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['sgstAmount']}')))),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['roff']}')))),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['tamount']}')))),
        DataCell(Text('${data['tdsCode'] ?? "-"}')),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['rtds']}')))),
        DataCell(Align(alignment: Alignment.centerRight, child: Text(parseDoubleUpto2Decimal('${data['tdsAmount']}')))),
      ]));
    }

    rows.add(DataRow(cells: [
      const DataCell(SizedBox()),
      const DataCell(Text("GRAND TOTAL", style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(sums[0].toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(sums[1].toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(sums[2].toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(sums[3].toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(sums[4].toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(sums[5].toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(sums[6].toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(sums[7].toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(sums[8].toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)))),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(sums[9].toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)))),
    ]));

    notifyListeners();
  }



}
