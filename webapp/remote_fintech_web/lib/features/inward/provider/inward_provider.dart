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
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../payment/provider/payment_provider.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class InwardProvider with ChangeNotifier {
  static const String featureName = "inward";
  static const String masterDetailFeatureName = "InwardDetails";
  static const String reportFeature = "inwardReport";
  static const String tdsReportFeature = "tdsReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];

  List<dynamic> exportInward = [];

  DataTable table =
      DataTable(columns: const [DataColumn(label: Text(""))], rows: const []);

  List<DataRow> rows = [];
  List<SearchableDropdownMenuItem<String>> tdsCodes = [];
  List<SearchableDropdownMenuItem<String>> hsnCodes = [];
  TextEditingController tdsAmountController = TextEditingController();
  TextEditingController gstRateController = TextEditingController();
  TextEditingController gstAmountController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController roffController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  List<dynamic> tdsReport = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  TextEditingController tdsController = TextEditingController();
  TextEditingController tdsRateController = TextEditingController(text: '0.00');

  List<List<TextEditingController>> rowControllers = [];

  List<SearchableDropdownMenuItem<String>> units = [];

  void initWidget(String brDetails) async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    var brData = {};
    String jsonData =
        '[{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"brId","name":"BR ID","isMandatory":false,"inputType":"number"},{"id":"naration","name":"Narration","isMandatory":true,"inputType":"text","maxCharacter":255},{"id":"billNo","name":"Bill No.","isMandatory":true,"inputType":"number"},{"id":"billDate","name":"Bill Date","isMandatory":true,"inputType":"datetime"},{"id":"dbCode","name":"Debit Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"rc","name":"Reverse Charges","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/", "default" : "N"}]';
    if (checkForEmptyOrNullString(brDetails)) {
      brData = jsonDecode(brDetails);
      jsonData =
          '[{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"brId","name":"BR ID","isMandatory":false,"inputType":"number", "default" : "${brData['brId']}"},{"id":"naration","name":"Narration","isMandatory":true,"inputType":"text","maxCharacter":255},{"id":"billNo","name":"Bill No.","isMandatory":true,"inputType":"number", "default" : "${brData['billNo']}"},{"id":"billDate","name":"Bill Date","isMandatory":true,"inputType":"datetime", "default" : "${brData['billDate']}"},{"id":"dbCode","name":"Debit Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"rc","name":"Reverse Charges","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/", "default" : "N"}]';
    }

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
          suffix: element['id'] == 'brId'
              ? viewBr(brData['docImage'] ?? "")
              : null));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    List<List<String>> tableRows = [
      ['', '', '', '', '', '', '', '', '', '', '', '0','0','0']
    ];
    rowControllers = tableRows
        .map((row) =>
            row.map((field) => TextEditingController(text: field)).toList())
        .toList();

    units = await formService.getDropdownMenuItem("/get-material-unit/");
    hsnCodes = await formService.getDropdownMenuItem("/get-hsn/");
    initTdsWidget();
  }

  void initTdsWidget() async {
    tdsCodes = await formService.getDropdownMenuItem("/get-tds/");

    widgetList.insertAll(10, [
      Container(
        padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "*",
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
      CustomDropdownField(
        field: FormUI(
            id: "tdsCode",
            name: "TDS Code",
            isMandatory: false,
            inputType: "dropdown",
            defaultValue: "NA",
            controller: tdsController),
        feature: featureName,
        dropdownMenuItems: tdsCodes,
        customFunction: getTdsRate,
      ),
      Container(
        padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "*",
                style: TextStyle(color: Colors.red),
              )
            ],
            text: "TDS Rate",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      CustomTextField(
        field: FormUI(
            id: "rtds",
            name: "Tds Rate",
            isMandatory: false,
            inputType: "text",
            defaultValue: 0.00,
            controller: tdsRateController),
        feature: featureName,
        customMethod: calculateTdsAmount,
        inputType: TextInputType.text,
      ),
    ]);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo(
      List<List<String>> tableRows, bool manual) async {
    // GlobalVariables.requestBody[featureName]['ty'] = 'M';
    var payload;
    if (manual) {
      List<Map<String, dynamic>> inwardDetails = [];
      for (int i = 0; i < tableRows.length; i++) {
        inwardDetails.add({
          "naration": tableRows[i][0],
          "matno": tableRows[i][1],
          "hsnCode": tableRows[i][2],
          "qty": tableRows[i][3],
          "unit": tableRows[i][6],
          "rate": tableRows[i][4],
          "amount": tableRows[i][5],
          "discountAmount": tableRows[i][8],
          "roff": tableRows[i][10],
          "GstRt": tableRows[i][13],
          "GstAmount": tableRows[i][14],
          "CesRt" : tableRows[i][17] == "" ? null : tableRows[i][17],
          "CesAmt" : tableRows[i][18] == "" ? null : tableRows[i][18],
          "Bcd" : tableRows[i][19] == "" ? null : tableRows[i][19],
        });
      }
      GlobalVariables.requestBody[featureName]['InwardDetails'] = inwardDetails;
      payload = [GlobalVariables.requestBody[featureName]];
    } else {
      payload = GlobalVariables.requestBody[featureName];
    }
    http.StreamedResponse response =
        await networkService.post("/add-inward-details/", payload);
    return response;
  }

  Future<http.StreamedResponse> processMasterFormInfo() async {
    GlobalVariables.requestBody[featureName]['ty'] = 'S';
    http.StreamedResponse response = await networkService.post(
        "/add-inward/", GlobalVariables.requestBody[featureName]);
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
      }
    }
  }

  void calculateTdsAmount() {
    double amount = (parseEmptyStringToDouble(
            GlobalVariables.requestBody[featureName]['qty'].toString()) *
        parseEmptyStringToDouble(
            GlobalVariables.requestBody[featureName]['rate'].toString()));

    amountController.text = amount.toStringAsFixed(2);
    GlobalVariables.requestBody[featureName]['amount'] = amountController.text;

    amount = amount -
        parseEmptyStringToDouble(GlobalVariables.requestBody[featureName]
                ['discountAmount']
            .toString());

    tdsAmountController.text = (amount *
            parseEmptyStringToDouble(
                GlobalVariables.requestBody[featureName]['rtds'].toString()) *
            0.01)
        .toStringAsFixed(2);

    gstAmountController.text = (amount *
            parseEmptyStringToDouble(
                GlobalVariables.requestBody[featureName]['GstRt'].toString()) *
            0.01)
        .toStringAsFixed(2);

    totalAmountController.text = (parseEmptyStringToDouble(
                GlobalVariables.requestBody[featureName]['roff'].toString()) +
            amount +
            parseEmptyStringToDouble(gstAmountController.text))
        .toStringAsFixed(2);

    GlobalVariables.requestBody[featureName]['tdsAmount'] =
        tdsAmountController.text;
    GlobalVariables.requestBody[featureName]['gstAmount'] =
        gstAmountController.text;
    GlobalVariables.requestBody[featureName]['tamount'] =
        totalAmountController.text;
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
    return Visibility(
      visible: checkForEmptyOrNullString(url),
      child: ElevatedButton(
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
          )),
    );
  }

  // void autoFillDetailsByPartyCode() async {
  //   var partyCode = GlobalVariables.requestBody[featureName]['lcode'];
  //   if (partyCode != null && partyCode != "") {
  //     http.StreamedResponse response =
  //         await networkService.get("/get-ledger-code-supply/$partyCode/");
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(storedGrDetails);
  //       var details = jsonDecode(await response.stream.bytesToString())[0];
  //       data['bpCode'] = partyCode;
  //       data['tcs'] = details['tcs'];
  //       data['slId'] = details['slId'];
  //       data['stId'] = details['stId'];
  //       data['rc'] = details['rc'];
  //       data['tdsCode'] = details['tdsCode'];
  //       data['rtds'] = details['rtds'];
  //       // initWidget(jsonEncode(data), "false");
  //     }
  //   }
  //   notifyListeners();
  // }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"vtype","name":"Voucher Type(B/V)","isMandatory":false,"inputType":"text", "maxCharacter" : 1},{"id":"rc","name":"Reverse Charges","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/"},{"id":"igstOnIntra","name":"Igst On Intra","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/"},{"id":"lcode","name":"Party Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"fdate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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

    List<DataRow> dataRows = [];
    List<double> totalAmounts = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    for (var data in inwardBillPending) {
      totalAmounts = [
        totalAmounts[0] + parseEmptyStringToDouble(data['qty']),
        totalAmounts[1] + parseEmptyStringToDouble(data['amount']),
        totalAmounts[2] + parseEmptyStringToDouble(data['discountAmount']),
        totalAmounts[3] + parseEmptyStringToDouble(data['AssAmt']),
        totalAmounts[4] + parseEmptyStringToDouble(data['tdsAmount']),
        totalAmounts[5] + parseEmptyStringToDouble(data['CesAmt']),
        totalAmounts[6] + parseEmptyStringToDouble(data['GstAmount']),
        totalAmounts[7] + parseEmptyStringToDouble(data['igstAmount']),
        totalAmounts[8] + parseEmptyStringToDouble(data['cgstAmount']),
        totalAmounts[9] + parseEmptyStringToDouble(data['sgstAmount']),
        totalAmounts[10] + parseEmptyStringToDouble(data['tamount']),
      ];
      dataRows.add(DataRow(cells: [
        DataCell(InkWell(
          child: Text('${data['transId'] ?? "-"}',
              style: const TextStyle(color: Colors.black)),
        )),
        DataCell(Text("${data['lcode']} - ${data['lname']}")),
        DataCell(Text("${data['billNo'] ?? ''}\n${data['dbillDate'] ?? ''}")),
        DataCell(Text("${data['Gstin'] ?? ""}")),
        DataCell(Text("${data['SupTyp'] ?? ""}")),
        //DataCell(Text("${data['hsnCode'] ?? ""}\n${data['GstRt'] ?? ""}")),
        DataCell(Text("${data['tdsCode'] ?? ""}\n${data['rtds'] ?? ""}%")),
        DataCell(Text("${data['dbCode'] ?? ""} - ${data['dblname'] ?? ""}")),
        DataCell(Text("${data['rc']}")),
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
            child: Text(parseDoubleUpto2Decimal(data['tdsAmount'])))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal(data['CesAmt'])))),
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
            child: Text(parseDoubleUpto2Decimal(data['roff'])))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal(data['Bcd'])))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal(data['tamount'])))),
        DataCell(Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Container(
              //   decoration: const BoxDecoration(
              //       borderRadius: BorderRadius.only(
              //           topLeft: Radius.circular(5),
              //           bottomLeft: Radius.circular(5)),
              //       color: Colors.green),
              //   child: IconButton(
              //     icon: const Icon(Icons.info_outline),
              //     color: Colors.white,
              //     tooltip: 'Info',
              //     onPressed: () {
              //       provider.setEditController(
              //           data['hsnCode']);
              //       context.pushNamed(HsnInfo.routeName);
              //     },
              //   ),
              // ),
              // Container(
              //   color: Colors.blue,
              //   child: IconButton(
              //     icon: const Icon(Icons.edit),
              //     color: Colors.white,
              //     tooltip: 'Update',
              //     onPressed: () {
              //       provider.setEditController(
              //           data['hsnCode']);
              //       context.pushNamed(AddHsn.routeName,
              //           queryParameters: {
              //             "editing": 'true'
              //           });
              //     },
              //   ),
              // ),
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                    color: Colors.red),
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.white,
                  tooltip: 'Delete',
                  onPressed: () async {
                    bool confirmation = await showConfirmationDialogue(
                        context,
                        "Are you sure you want to delete Inward : ${data['transId']}?",
                        "SUBMIT",
                        "CANCEL");
                    if (confirmation) {
                      NetworkService networkService = NetworkService();
                      http.StreamedResponse response = data['vtype'] == 'V' ? await networkService
                          .post(
                          "/delete-inward-voucher/", {"transId": data['transId']}) :await networkService
                          .post(
                              "/delete-inward/", {"transId": data['transId']});
                      if (response.statusCode == 204) {
                        getInwardBillReportTable(context);
                      } else if (response.statusCode == 400) {
                        var message =
                            jsonDecode(await response.stream.bytesToString());
                        await showAlertDialog(context,
                            message['message'].toString(), "Continue", false);
                      } else if (response.statusCode == 500) {
                        var message =
                            jsonDecode(await response.stream.bytesToString());
                        await showAlertDialog(
                            context, message['message'], "Continue", false);
                      } else {
                        var message =
                            jsonDecode(await response.stream.bytesToString());
                        await showAlertDialog(
                            context, message['message'], "Continue", false);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        )),
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
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(
            totalAmounts[10].toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ))),
      const DataCell(SizedBox()),
    ]));

    table = DataTable(
      columnSpacing: 25,
      columns: const [
        DataColumn(label: Text("Trans Id", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("Vendor Name", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("Bill No. & Date", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("Gstin", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("SupType", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("TDS", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("DB Code", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("RC", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("Qty", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("Amount", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("Disc.", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("Ass. Amount", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("TDS Amount", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("Cess Amount", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("Gst Amount", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("IGST", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("CGST", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("SGST", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("Roff", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("BCD", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("Total Amount", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold))),
      ],
      rows: dataRows,
    );

    notifyListeners();
  }

  // void billClearencePopup(BuildContext context, List<dynamic> orderBalance) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Bill Clearance Details',
  //             style: TextStyle(fontWeight: FontWeight.w500)),
  //         content: SingleChildScrollView(
  //           scrollDirection: Axis.horizontal,
  //           child: SingleChildScrollView(
  //             scrollDirection: Axis.vertical,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 DataTable(
  //                   columns: const [
  //                     DataColumn(label: Text('Trans Id')),
  //                     DataColumn(label: Text('Voucher Type')),
  //                     DataColumn(label: Text('Amount')),
  //                     DataColumn(label: Text('Naration'))
  //                   ],
  //                   rows: orderBalance.map((data) {
  //                     return DataRow(cells: [
  //                       DataCell(Text('${data['transId'] ?? "-"}')),
  //                       DataCell(Text('${data['vtype'] ?? "-"}')),
  //                       DataCell(Align(
  //                           alignment: Alignment.centerRight,
  //                           child: Text(parseDoubleUpto2Decimal(
  //                               '${data['amount'] ?? "-"}')))),
  //                       DataCell(Text('${data['clnaration'] ?? "-"}')),
  //                     ]);
  //                   }).toList(),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         actions: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               InkWell(
  //                 onTap: () {
  //                   // Navigator.pop(context, false);
  //                   Navigator.of(context, rootNavigator: true).pop(false);
  //                 },
  //                 child: Container(
  //                   margin: const EdgeInsets.only(right: 5),
  //                   width: GlobalVariables.deviceWidth * 0.15,
  //                   height: GlobalVariables.deviceHeight * 0.05,
  //                   alignment: Alignment.center,
  //                   decoration: BoxDecoration(
  //                     color: HexColor("#e0e0e0"),
  //                     borderRadius: BorderRadius.circular(20),
  //                     boxShadow: const [
  //                       BoxShadow(
  //                         color: Colors.grey,
  //                         blurRadius: 2,
  //                         offset: Offset(
  //                           2,
  //                           3,
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                   child: const Text("CLOSE",
  //                       style: TextStyle(fontSize: 11, color: Colors.black)),
  //                 ),
  //               ),
  //             ],
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

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

    List<double> sums = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    for (var data in tdsReport) {
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
        DataCell(Hyperlink(
            text: '${data['transId']}',
            url: "${NetworkService.baseUrl}${data['DocProof']}")),
        DataCell(Text('${data['lcode'] ?? "-"} - ${data['lName'] ?? "-"}')),
        DataCell(Text('${data['billNo'] ?? "-"}')),
        DataCell(Text('${data['dbillDate'] ?? "-"}')),
        DataCell(Text('${data['section'] ?? "-"}')),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['amount']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['discountAmount']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['taxAmount']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['cessAmount']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['igstAmount']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['cgstAmount']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['sgstAmount']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['roff']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['tamount']}')))),
        DataCell(Text('${data['tdsCode'] ?? "-"}')),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['rtds']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['tdsAmount']}')))),
      ]));
    }

    rows.add(DataRow(cells: [
      const DataCell(SizedBox()),
      const DataCell(
          Text("GRAND TOTAL", style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(sums[0].toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(sums[1].toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(sums[2].toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(sums[3].toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(sums[4].toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(sums[5].toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(sums[6].toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(sums[7].toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(sums[8].toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(sums[9].toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
    ]));

    notifyListeners();
  }

  // void initMaster() async {
  //   GlobalVariables.requestBody[featureName] = {};
  //   formFieldDetails.clear();
  //   widgetList.clear();
  //
  //   String jsonData =
  //       '[{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"billNo","name":"Bill No.","isMandatory":false,"inputType":"number"},{"id":"billDate","name":"Bill Date","isMandatory":true,"inputType":"datetime"},{"id":"naration","name":"Naration","isMandatory":true,"inputType":"text","maxCharacter" : 100},{"id":"dbCode","name":"Debit Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"rc","name":"Reverse Charges","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/", "default" : "N"}]';
  //
  //   for (var element in jsonDecode(jsonData)) {
  //     TextEditingController controller = TextEditingController();
  //     formFieldDetails.add(FormUI(
  //         id: element['id'],
  //         name: element['name'],
  //         isMandatory: element['isMandatory'],
  //         inputType: element['inputType'],
  //         dropdownMenuItem: element['dropdownMenuItem'] ?? "",
  //         maxCharacter: element['maxCharacter'] ?? 255,
  //         defaultValue: element['default'],
  //         controller: controller,
  //         readOnly: element['readOnly'] ?? false));
  //   }
  //
  //   List<Widget> widgets =
  //       await formService.generateDynamicForm(formFieldDetails, featureName);
  //   widgetList.addAll(widgets);
  //   customObjects();
  // }
  //
  // void customObjects() async {
  //   tdsCodes = await formService.getDropdownMenuItem("/get-tds/");
  //   hsnCodes = await formService.getDropdownMenuItem("/get-hsn/");
  //
  //   widgetList.addAll([
  //     Container(
  //       padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
  //       child: RichText(
  //         text: const TextSpan(
  //           children: [
  //             TextSpan(
  //               text: "",
  //               style: TextStyle(color: Colors.red),
  //             )
  //           ],
  //           text: "HSN Code",
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.black,
  //             fontWeight: FontWeight.w400,
  //           ),
  //         ),
  //       ),
  //     ),
  //     CustomDropdownField(
  //         field: FormUI(
  //             id: "hsnCode",
  //             name: "Hsn Code",
  //             isMandatory: false,
  //             inputType: "dropdown"),
  //         dropdownMenuItems: hsnCodes,
  //         customFunction: () async {
  //           http.StreamedResponse response = await networkService.get(
  //               "/get-hsn-code/${GlobalVariables.requestBody[featureName]['hsnCode']}/");
  //           if (response.statusCode == 200) {
  //             gstRateController.text =
  //                 jsonDecode(await response.stream.bytesToString())[0]
  //                         ['gstTaxRate']
  //                     .toString();
  //           } else {
  //             gstRateController.text = "0.00";
  //           }
  //           GlobalVariables.requestBody[featureName]['GstRt'] =
  //               gstRateController.text;
  //           calculateTdsAmount();
  //         },
  //         feature: featureName),
  //     Container(
  //       padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
  //       child: RichText(
  //         text: const TextSpan(
  //           children: [
  //             TextSpan(
  //               text: "*",
  //               style: TextStyle(color: Colors.red),
  //             )
  //           ],
  //           text: "Quantity",
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.black,
  //             fontWeight: FontWeight.w400,
  //           ),
  //         ),
  //       ),
  //     ),
  //     CustomTextField(
  //       field: FormUI(
  //           id: "qty",
  //           name: "Quantity",
  //           defaultValue: 1.00,
  //           controller: TextEditingController(),
  //           isMandatory: false,
  //           inputType: "text"),
  //       feature: featureName,
  //       inputType: TextInputType.number,
  //       customMethod: calculateTdsAmount,
  //     ),
  //     Container(
  //       padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
  //       child: RichText(
  //         text: const TextSpan(
  //           children: [
  //             TextSpan(
  //               text: "*",
  //               style: TextStyle(color: Colors.red),
  //             )
  //           ],
  //           text: "Rate",
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.black,
  //             fontWeight: FontWeight.w400,
  //           ),
  //         ),
  //       ),
  //     ),
  //     CustomTextField(
  //       field: FormUI(
  //           id: "rate",
  //           name: "Rate",
  //           isMandatory: false,
  //           defaultValue: 0.00,
  //           controller: TextEditingController(),
  //           inputType: "text"),
  //       feature: featureName,
  //       inputType: TextInputType.number,
  //       customMethod: calculateTdsAmount,
  //     ),
  //     Container(
  //       padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
  //       child: RichText(
  //         text: const TextSpan(
  //           children: [
  //             TextSpan(
  //               text: "*",
  //               style: TextStyle(color: Colors.red),
  //             )
  //           ],
  //           text: "Amount",
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.black,
  //             fontWeight: FontWeight.w400,
  //           ),
  //         ),
  //       ),
  //     ),
  //     CustomTextField(
  //       field: FormUI(
  //           id: "amount",
  //           name: "Amount",
  //           isMandatory: false,
  //           defaultValue: 0.00,
  //           readOnly: true,
  //           inputType: "text",
  //           controller: amountController),
  //       feature: featureName,
  //       inputType: TextInputType.number,
  //       customMethod: calculateTdsAmount,
  //     ),
  //     Container(
  //       padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
  //       child: RichText(
  //         text: const TextSpan(
  //           children: [
  //             TextSpan(
  //               text: "*",
  //               style: TextStyle(color: Colors.red),
  //             )
  //           ],
  //           text: "Discount Amount",
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.black,
  //             fontWeight: FontWeight.w400,
  //           ),
  //         ),
  //       ),
  //     ),
  //     CustomTextField(
  //       field: FormUI(
  //           id: "discountAmount",
  //           name: "Discount Amount",
  //           isMandatory: false,
  //           defaultValue: 0.00,
  //           controller: TextEditingController(),
  //           inputType: "text"),
  //       feature: featureName,
  //       inputType: TextInputType.number,
  //       customMethod: calculateTdsAmount,
  //     ),
  //   ]);
  //   widgetList.addAll([
  //     Container(
  //       padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
  //       child: RichText(
  //         text: const TextSpan(
  //           children: [
  //             TextSpan(
  //               text: "*",
  //               style: TextStyle(color: Colors.red),
  //             )
  //           ],
  //           text: "TDS Code",
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.black,
  //             fontWeight: FontWeight.w400,
  //           ),
  //         ),
  //       ),
  //     ),
  //     CustomDropdownField(
  //       field: FormUI(
  //           id: "tdsCode",
  //           name: "TDS Code",
  //           isMandatory: false,
  //           inputType: "dropdown",
  //           controller: tdsController),
  //       feature: featureName,
  //       dropdownMenuItems: tdsCodes,
  //       customFunction: getTdsRate,
  //     ),
  //     Container(
  //       padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
  //       child: RichText(
  //         text: const TextSpan(
  //           children: [
  //             TextSpan(
  //               text: "*",
  //               style: TextStyle(color: Colors.red),
  //             )
  //           ],
  //           text: "TDS Rate",
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.black,
  //             fontWeight: FontWeight.w400,
  //           ),
  //         ),
  //       ),
  //     ),
  //     CustomTextField(
  //       field: FormUI(
  //           id: "rtds",
  //           name: "Tds Rate",
  //           isMandatory: false,
  //           inputType: "text",
  //           defaultValue: 0.00,
  //           controller: tdsRateController),
  //       feature: featureName,
  //       customMethod: calculateTdsAmount,
  //       inputType: TextInputType.text,
  //     ),
  //   ]);
  //   widgetList.addAll([
  //     Container(
  //       padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
  //       child: RichText(
  //         text: const TextSpan(
  //           children: [
  //             TextSpan(
  //               text: "*",
  //               style: TextStyle(color: Colors.red),
  //             )
  //           ],
  //           text: "TDS Amount",
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.black,
  //             fontWeight: FontWeight.w400,
  //           ),
  //         ),
  //       ),
  //     ),
  //     CustomTextField(
  //       field: FormUI(
  //           id: "tdsAmount",
  //           name: "Tds Amount",
  //           isMandatory: false,
  //           inputType: "text",
  //           readOnly: true,
  //           defaultValue: 0.00,
  //           controller: tdsAmountController),
  //       feature: featureName,
  //       inputType: TextInputType.text,
  //     ),
  //   ]);
  //   widgetList.addAll([
  //     Container(
  //       padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
  //       child: RichText(
  //         text: const TextSpan(
  //           children: [
  //             TextSpan(
  //               text: "*",
  //               style: TextStyle(color: Colors.red),
  //             )
  //           ],
  //           text: "Gst Rate",
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.black,
  //             fontWeight: FontWeight.w400,
  //           ),
  //         ),
  //       ),
  //     ),
  //     CustomTextField(
  //       field: FormUI(
  //           id: "GstRt",
  //           name: "Gst Rate",
  //           isMandatory: false,
  //           inputType: "text",
  //           defaultValue: 0.00,
  //           controller: gstRateController),
  //       customMethod: calculateTdsAmount,
  //       feature: featureName,
  //       inputType: TextInputType.number,
  //     ),
  //     Container(
  //       padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
  //       child: RichText(
  //         text: const TextSpan(
  //           children: [
  //             TextSpan(
  //               text: "*",
  //               style: TextStyle(color: Colors.red),
  //             )
  //           ],
  //           text: "Gst Amount",
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.black,
  //             fontWeight: FontWeight.w400,
  //           ),
  //         ),
  //       ),
  //     ),
  //     CustomTextField(
  //       field: FormUI(
  //           id: "GstAmount",
  //           name: "Gst Rate",
  //           isMandatory: false,
  //           inputType: "text",
  //           readOnly: true,
  //           defaultValue: 0.00,
  //           controller: gstAmountController),
  //       feature: featureName,
  //       inputType: TextInputType.number,
  //     ),
  //     Container(
  //       padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
  //       child: RichText(
  //         text: const TextSpan(
  //           children: [
  //             TextSpan(
  //               text: "*",
  //               style: TextStyle(color: Colors.red),
  //             )
  //           ],
  //           text: "Round Off.",
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.black,
  //             fontWeight: FontWeight.w400,
  //           ),
  //         ),
  //       ),
  //     ),
  //     CustomTextField(
  //       field: FormUI(
  //           id: "roff",
  //           name: "Round Off",
  //           isMandatory: false,
  //           inputType: "text",
  //           defaultValue: 0.00),
  //       customMethod: calculateTdsAmount,
  //       feature: featureName,
  //       inputType: TextInputType.number,
  //     ),
  //     Container(
  //       padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
  //       child: RichText(
  //         text: const TextSpan(
  //           children: [
  //             TextSpan(
  //               text: "*",
  //               style: TextStyle(color: Colors.red),
  //             )
  //           ],
  //           text: "Total Amount",
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.black,
  //             fontWeight: FontWeight.w400,
  //           ),
  //         ),
  //       ),
  //     ),
  //     CustomTextField(
  //       field: FormUI(
  //           id: "tamount",
  //           name: "Total Amount",
  //           isMandatory: false,
  //           inputType: "text",
  //           readOnly: true,
  //           defaultValue: 0.00,
  //           controller: totalAmountController),
  //       feature: featureName,
  //       inputType: TextInputType.number,
  //     ),
  //   ]);
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
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ]);
    notifyListeners();
  }
}
