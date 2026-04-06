import 'dart:convert';

import 'package:fintech_new_web/features/common/widgets/custom_text_field.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../camera/service/camera_service.dart';
import '../../common/widgets/custom_dropdown_field.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';
import '../../utility/services/generate_form_service.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class InwardVoucherProvider with ChangeNotifier {
  static const String featureName = "inwardVoucher";
  static const String featureNameSingle = "inwardVoucherSingle";
  static const String reportFeature = "inwardVoucherReport";
  static const String masterDetailFeatureName = "InwardVoucherDetails";

  DataTable table =
  DataTable(columns: const [DataColumn(label: Text(""))], rows: const []);

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  TextEditingController editController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController roffController = TextEditingController(text: "0");

  SearchableDropdownController<String> hsnController =
      SearchableDropdownController<String>();
  TextEditingController rateController = TextEditingController();
  TextEditingController tdsController = TextEditingController();
  TextEditingController tdsRateController = TextEditingController();
  TextEditingController tdsAmountController = TextEditingController();
  TextEditingController gstRateController = TextEditingController();
  TextEditingController gstAmountController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController narationController = TextEditingController();

  List<SearchableDropdownMenuItem<String>> tdsCodes = [];
  List<SearchableDropdownMenuItem<String>> hsnCodes = [];
  List<SearchableDropdownMenuItem<String>> units = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  List<List<TextEditingController>> rowControllers = [];

  List<dynamic> exportInward = [];

  String jsonData =
      '[{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id": "brId","name": "BR Id","isMandatory": false,"inputType": "number"},{"id":"billNo","name":"Bill No.","isMandatory":false,"inputType":"number"},{"id":"billDate","name":"Bill Date","isMandatory":true,"inputType":"datetime"},{"id":"dbCode","name":"Debit Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"rc","name":"Reverse Charges","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/", "default" : "N"}]';

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    String jsonData =
        '[{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id": "brId","name": "BR Id","isMandatory": false,"inputType": "number"},{"id":"billNo","name":"Bill No.","isMandatory":false,"inputType":"number"},{"id":"billDate","name":"Bill Date","isMandatory":true,"inputType":"datetime"},{"id":"naration","name":"Narration","isMandatory":true,"inputType":"text","maxCharacter":255},{"id":"dbCode","name":"Debit Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"rc","name":"Reverse Charges","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-yesno/", "default" : "N"}]';

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
          controller:
              element['id'] == 'naration' ? narationController : controller,
          readOnly: element['readOnly'] ?? false));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);

    rowControllers = [
      [
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
      ]
    ]
        .map((row) =>
            row.map((field) => TextEditingController(text: field)).toList())
        .toList();

    units = await formService.getDropdownMenuItem("/get-material-unit/");
    hsnCodes = await formService.getDropdownMenuItem("/get-hsn/");

    customObjects();
  }

  void materialFunction() async {
    List<SearchableDropdownMenuItem<String>> hsnCodes =
        await formService.getDropdownMenuItem("/get-hsn/");
    http.StreamedResponse response = await networkService.get(
        "/get-material/${GlobalVariables.requestBody[featureName]['matno']}/");
    var matDetails = jsonDecode(await response.stream.bytesToString())[0];
    if (response.statusCode == 200) {
      narationController.text = matDetails['saleDescription'];

      GlobalVariables.requestBody[featureName]['naration'] =
          matDetails['saleDescription'];

      hsnController.selectedItem.value =
          findDropdownMenuItem(hsnCodes, matDetails['hsnCode']);
      GlobalVariables.requestBody[featureName]['hsnCode'] =
          matDetails['hsnCode'];

      rateController.text = matDetails['prate'] ?? "0";
      GlobalVariables.requestBody[featureName]['rate'] =
          matDetails['prate'] ?? "0";

      gstRateController.text = matDetails['gstTaxRate'] ?? "0";
      GlobalVariables.requestBody[featureName]['GstRt'] =
          matDetails['gstTaxRate'] ?? "0";
    } else {
      narationController.text = "";
      GlobalVariables.requestBody[featureName]['naration'] = null;

      hsnController.selectedItem.value = null;
      GlobalVariables.requestBody[featureName]['hsnCode'] = null;

      rateController.text = "0";
      GlobalVariables.requestBody[featureName]['rate'] = "0";

      gstRateController.text = "0";
      GlobalVariables.requestBody[featureName]['GstRt'] = "0";
    }

    calculateTdsAmount();
  }

  void customObjects() async {
    tdsCodes = await formService.getDropdownMenuItem("/get-tds/");
    hsnCodes = await formService.getDropdownMenuItem("/get-hsn/");
    widgetList.addAll([
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

  void initEditWidget() async {
    Map<String, dynamic> editMapData = await getByIdBusinessPartner();
    GlobalVariables.requestBody[featureName] = editMapData;
    formFieldDetails.clear();
    widgetList.clear();

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
          defaultValue: editMapData[element['id']]));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo(
      List<List<String>> tableRows, bool manual) async {
    List<Map<String, dynamic>> inwardDetails = [];
    var payload;
    if (manual) {
      for (int i = 0; i < tableRows.length; i++) {
        inwardDetails.add({
          "naration": tableRows[i][0] == "" ? null : tableRows[i][0],
          "matno": tableRows[i][1] == "" ? null : tableRows[i][1],
          "hsnCode": tableRows[i][2] == "" ? null : tableRows[i][2],
          "qty": tableRows[i][3],
          "unit": tableRows[i][6],
          "rate": tableRows[i][4],
          "amount": tableRows[i][5],
          "discountAmount": tableRows[i][8],
          "roff": tableRows[i][10],
          "GstRt": tableRows[i][13],
          "GstAmount": tableRows[i][14],
        });
      }
      GlobalVariables.requestBody[featureName]['InwardVoucherDetails'] =
          inwardDetails;
      payload = [GlobalVariables.requestBody[featureName]];
    } else {
      payload = GlobalVariables.requestBody[featureName];
    }

    http.StreamedResponse response =
        await networkService.post("/create-inward-voucher/", payload);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.put(
        "/update-inward-voucher/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  Future<http.StreamedResponse> processSingleImport() async {
    http.StreamedResponse response = await networkService.post(
        "/import-inward-voucher/", GlobalVariables.requestBody[featureNameSingle]);
    return response;
  }

  Future<Map<String, dynamic>> getByIdBusinessPartner() async {
    http.StreamedResponse response =
        await networkService.get("/get-inward-voucher/${editController.text}/");
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
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
    GlobalVariables.requestBody[featureName]['GstAmount'] =
        gstAmountController.text;
    GlobalVariables.requestBody[featureName]['tamount'] =
        totalAmountController.text;
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
        calculateTdsAmount();
        notifyListeners();
      }
    }
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

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"fdate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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
    List<double> totalAmounts = [0, 0, 0, 0, 0, 0, 0, 0, 0];

    for (var data in inwardBillPending) {
      totalAmounts = [
        totalAmounts[0] + parseEmptyStringToDouble(data['qty']),
        totalAmounts[1] + parseEmptyStringToDouble(data['amount']),
        totalAmounts[2] + parseEmptyStringToDouble(data['discountAmount']),
        totalAmounts[3] + parseEmptyStringToDouble(data['AssAmt']),
        totalAmounts[4] + parseEmptyStringToDouble(data['igstAmount']),
        totalAmounts[5] + parseEmptyStringToDouble(data['cgstAmount']),
        totalAmounts[6] + parseEmptyStringToDouble(data['sgstAmount']),
        totalAmounts[7] + parseEmptyStringToDouble(data['roff']),
        totalAmounts[8] + parseEmptyStringToDouble(data['tamount']),
      ];
      dataRows.add(DataRow(cells: [
        DataCell(Text('${data['transId'] ?? "-"}')),
        DataCell(Text("${data['lcode']} - ${data['lname']}")),
        DataCell(Text("${data['billNo'] ?? ''}\n${data['billDate'] ?? ''}")),
        DataCell(Text("${data['naration'] ?? ""}")),
        DataCell(Text("${data['hsnCode'] ?? ""}\n${data['GstRt'] ?? ""}")),
        DataCell(Text("${data['tdsCode'] ?? ""}\n${data['rtds'] ?? ""}")),
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
            child: Text(parseDoubleUpto2Decimal(data['tamount'])))),
        DataCell(Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                      http.StreamedResponse response = await networkService
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
      const DataCell(SizedBox()),
    ]));

    table = DataTable(
      columnSpacing: 25,
      columns: const [
        DataColumn(label: Text("Trans Id")),
        DataColumn(label: Text("Vendor Name")),
        DataColumn(label: Text("Bill No. & Date")),
        DataColumn(label: Text("Naration")),
        DataColumn(label: Text("HSN")),
        DataColumn(label: Text("TDS")),
        DataColumn(label: Text("DB Code")),
        DataColumn(label: Text("RC")),
        DataColumn(label: Text("Qty")),
        DataColumn(label: Text("Amount")),
        DataColumn(label: Text("Disc.")),
        DataColumn(label: Text("Ass. Amount")),
        DataColumn(label: Text("IGST")),
        DataColumn(label: Text("CGST")),
        DataColumn(label: Text("SGST")),
        DataColumn(label: Text("Roff")),
        DataColumn(label: Text("Total Amount")),
        DataColumn(label: Text("Actions")),
      ],
      rows: dataRows,
    );

    notifyListeners();
  }
}
