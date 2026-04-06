import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/custom_dropdown_field.dart';
import '../../common/widgets/custom_text_field.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';
import '../../utility/services/generate_form_service.dart';
import '../screens/create_payment_voucher.dart';
import '../screens/payment_voucher_info.dart';

class PaymentVoucherProvider with ChangeNotifier {
  static const String featureName = "paymentVoucher";
  static const String reportFeature = "paymentVoucherReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  List<SearchableDropdownMenuItem<String>> supplyType = [];

  List<SearchableDropdownMenuItem<String>> hsnCodes = [];

  List<dynamic> paymentVoucherRep = [];

  List<DataRow> rows = [];
  TextEditingController hsnController = TextEditingController();
  TextEditingController editController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController gstRateController = TextEditingController();
  TextEditingController gstAmountController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();

  SearchableDropdownController<String> supplyController =
      SearchableDropdownController<String>();

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();
  String jsonData =
      '[{"id":"No","name":"Voucher Number","isMandatory":false,"inputType":"text","maxCharacter":16},{"id":"Dt","name":"Date","isMandatory":true,"inputType":"datetime"},{"id":"lcode","name":"Party Code","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"naration","name":"Narration","isMandatory":true,"inputType":"text","maxCharacter":100},{"id":"AssAmt","name":"Assessable Amount","isMandatory":true,"inputType":"number"},{"id":"mop","name":"Mode of Payment","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-mop/"},{"id":"payRefno","name":"Payment Reference Number","isMandatory":false,"inputType":"text","maxCharacter":20}]';

  void initWidget() async {
    supplyController.clear();
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
          eventTrigger: element['id'] == 'AssAmt' ? calculateGstAmount : null,
          controller: controller));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    // initCustomObject();
    customObjects({});
  }

  Future<Map<String, dynamic>> getByIdPaymentVoucher() async {
    http.StreamedResponse response = await networkService
        .post("/get-payment-voucher/", {"No": editController.text});
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEditWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    widgetList.clear();
    formFieldDetails.clear();
    Map<String, dynamic> editMapData = await getByIdPaymentVoucher();
    GlobalVariables.requestBody[featureName] = editMapData;

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
          eventTrigger: element['id'] == 'AssAmt' ? calculateGstAmount : null,
          defaultValue: editMapData[element['id']]));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    customObjects(editMapData);
  }

  void customObjects(Map<String, dynamic> editMapData) async {
    hsnCodes = await formService.getDropdownMenuItem("/get-hsn/");

    widgetList.insertAll(8, [
      Container(
        padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "",
                style: TextStyle(color: Colors.red),
              )
            ],
            text: "HSN Code",
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
              id: "hsnCode",
              name: "Hsn Code",
              isMandatory: false,
              defaultValue: editMapData['hsnCode'],
              inputType: "dropdown"),
          dropdownMenuItems: hsnCodes,
          customFunction: () async {
            http.StreamedResponse response = await networkService.get(
                "/get-hsn-code/${GlobalVariables.requestBody[featureName]['hsnCode']}/");
            if (response.statusCode == 200) {
              gstRateController.text =
                  jsonDecode(await response.stream.bytesToString())[0]
                          ['gstTaxRate']
                      .toString();
            } else {
              gstRateController.text = "0.00";
            }
            GlobalVariables.requestBody[featureName]['GstRt'] =
                gstRateController.text;
            calculateGstAmount();
          },
          feature: featureName),
    ]);

    widgetList.insertAll(12, [
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
            text: "Gst Rate",
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
            id: "GstRt",
            name: "Gst Rate",
            isMandatory: false,
            inputType: "text",
            defaultValue: editMapData['GstRt'] ?? 0.00,
            controller: gstRateController),
        customMethod: calculateGstAmount,
        feature: featureName,
        inputType: TextInputType.number,
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
            text: "Gst Amount",
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
            id: "gstAmount",
            name: "Gst Rate",
            isMandatory: false,
            inputType: "text",
            readOnly: true,
            defaultValue: editMapData['gstAmount'] ?? 0.00,
            controller: gstAmountController),
        feature: featureName,
        inputType: TextInputType.number,
      ),
    ]);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo(bool manual) async {
    var payload = manual
        ? [GlobalVariables.requestBody[featureName]]
        : GlobalVariables.requestBody[featureName];
    http.StreamedResponse response =
        await networkService.post("/create-payment-voucher/", payload);
    return response;
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-payment-voucher/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  void autoFillDetailsByPartyCode() async {
    var partyCode = GlobalVariables.requestBody[featureName]['lcode'];
    if (partyCode != null && partyCode != "") {
      http.StreamedResponse response =
          await networkService.get("/get-ledger-code-supply/$partyCode/");
      if (response.statusCode == 200) {
        var details = jsonDecode(await response.stream.bytesToString())[0];
        var supplyItem = findDropdownMenuItem(supplyType, details['slId']);
        supplyController.selectedItem.value = supplyItem;
        GlobalVariables.requestBody[featureName]['slId'] = details['slId'];
      }
    }
    notifyListeners();
  }

  void initReport() async {
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();
    String jsonData =
        '[{"id":"No","name":"Voucher Number","isMandatory":false,"inputType":"text","maxCharacter":16},{"id":"lcode","name":"Ledger Code","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-ledger-codes/"},{"id":"IgstOnIntra","name":"IGST On Intra","isMandatory":false,"inputType":"text","maxCharacter":1},{"id":"fdate","name":"From Date","isMandatory":true,"inputType":"datetime"},{"id":"tdate","name":"To Date","isMandatory":true,"inputType":"datetime"}]';

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

  void getPaymentVoucherReport(BuildContext context) async {
    paymentVoucherRep.clear();
    http.StreamedResponse response = await networkService.post(
        "/payment-voucher-rep/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      paymentVoucherRep = jsonDecode(await response.stream.bytesToString());
    }
    getRows(context);
  }

  void getRows(BuildContext context) {
    rows.clear();
    List<double> sums = [0, 0];
    for (var data in paymentVoucherRep) {
      sums[0] += parseEmptyStringToDouble(data['AssAmt']);
      sums[1] += parseEmptyStringToDouble(data['gstAmount']);

      rows.add(DataRow(cells: [
        DataCell(Text('${data['No'] ?? "-"}\n${data['Dt'] ?? "-"}')),
        DataCell(Text('${data['lcode'] ?? "-"}')),
        DataCell(Text('${data['naration'] ?? "-"}')),
        DataCell(Text('${data['hsnCode'] ?? "-"}')),
        DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['AssAmt'] ?? "-"}')))),
        DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['GstRt'] ?? "-"}')))),
        DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['gstAmount'] ?? "-"}')))),
        DataCell(Text('${data['mop'] ?? "-"}')),
        DataCell(Text('${data['payRefno'] ?? "-"}')),
        DataCell(Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5)),
                    color: Colors.green),
                child: IconButton(
                  icon: const Icon(Icons.info_outline),
                  color: Colors.white,
                  tooltip: 'Info',
                  onPressed: () {
                    editController.text = '${data['No']}';
                    context.pushNamed(PaymentVoucherInfo.routeName);
                  },
                ),
              ),
              Container(
                color: Colors.blue,
                child: IconButton(
                  icon: const Icon(Icons.edit),
                  color: Colors.white,
                  tooltip: 'Update',
                  onPressed: () {
                    editController.text = '${data['No']}';
                    context.pushNamed(CreatePaymentVoucher.routeName,
                        queryParameters: {
                          "editing": 'true',
                        });
                  },
                ),
              ),
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
                        "Are you sure you want to delete this Voucher?",
                        "SUBMIT",
                        "CANCEL");
                    if (confirmation) {
                      NetworkService networkService = NetworkService();
                      http.StreamedResponse response = await networkService
                          .post("/delete-payment-voucher/",
                              {"No": '${data['No']}'});
                      if (response.statusCode == 204) {
                        getPaymentVoucherReport(context);
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

    rows.add(DataRow(cells: [
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(
          Text("GRAND TOTAL", style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Align(
        alignment: Alignment.centerRight,
        child: Text(sums[0].toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold)),
      )),
      const DataCell(SizedBox()),
      DataCell(Align(
        alignment: Alignment.centerRight,
        child: Text(sums[1].toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold)),
      )),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
    ]));

    notifyListeners();
  }

  void calculateGstAmount() {
    gstAmountController.text = (parseEmptyStringToDouble(
                GlobalVariables.requestBody[featureName]['AssAmt'].toString()) *
            parseEmptyStringToDouble(
                GlobalVariables.requestBody[featureName]['GstRt'].toString()) *
            0.01)
        .toStringAsFixed(2);

    GlobalVariables.requestBody[featureName]['gstAmount'] =
        gstAmountController.text;
  }
}
