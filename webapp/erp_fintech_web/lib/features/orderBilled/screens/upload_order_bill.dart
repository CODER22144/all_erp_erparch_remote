// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:fintech_new_web/features/orderBilled/provider/order_billed_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../utility/global_variables.dart';

class UploadOrderBill extends StatefulWidget {
  static String routeName = "/uploadOrderBill";
  final String orderId;
  const UploadOrderBill({super.key, required this.orderId});

  @override
  State<UploadOrderBill> createState() => _UploadOrderBillState();
}

class _UploadOrderBillState extends State<UploadOrderBill> {
  List<Map<String, dynamic>> jsonData = [];
  late OrderBilledProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<OrderBilledProvider>(context, listen: false);
    provider.initWidget(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<OrderBilledProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: CommonAppbar(
                title: 'Upload Order Bill For: ${widget.orderId}')),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: kIsWeb
                  ? GlobalVariables.deviceWidth / 2.0
                  : GlobalVariables.deviceWidth,
              padding: const EdgeInsets.all(10),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: ListView.builder(
                        itemCount: provider.widgetList.length,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return provider.widgetList[index];
                        },
                      ),
                    ),
                    InkWell(
                        onTap: _importExcel,
                        child: Visibility(
                          visible: provider.widgetList.isNotEmpty,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                const ElevatedButton(
                                    onPressed: null,
                                    child: Text(
                                      "Choose File",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                    )),
                                jsonData.isNotEmpty
                                    ? const Text(
                                        "File Uploaded Successfully",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 12,
                                            color: Colors.green),
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          ),
                        )),
                    Visibility(
                      visible: provider.widgetList.isNotEmpty,
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor("#0B6EFE"),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              bool confirmation =
                                  await showConfirmationDialogue(
                                      context,
                                      "Do you want to submit the records?",
                                      "SUBMIT",
                                      "CANCEL");
                              if (confirmation) {
                                http.StreamedResponse result =
                                    await provider.processFormInfo();
                                var message = jsonDecode(
                                    await result.stream.bytesToString());
                                if (result.statusCode == 200) {
                                  provider.getOrderPending();
                                  context.pop();
                                } else if (result.statusCode == 400) {
                                  await showAlertDialog(
                                      context,
                                      message['message'].toString(),
                                      "Continue",
                                      false);
                                } else if (result.statusCode == 500) {
                                  await showAlertDialog(context,
                                      message['message'], "Continue", false);
                                } else {
                                  await showAlertDialog(context,
                                      message['message'], "Continue", false);
                                }
                              }
                            }
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> _importExcel() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        // Use the bytes directly if the path is null
        final bytes = result.files.single.bytes ??
            File(result.files.single.path!).readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        var sheet = excel.tables.values.first;

        if (sheet != null) {
          // Get the first row as headers
          List<String> headers = sheet.rows.first
              .map((cell) => cell?.value?.toString() ?? '')
              .toList();

          // Iterate over remaining rows and map them to headers
          for (int i = 1; i < sheet.rows.length; i++) {
            var row = sheet.rows[i];
            Map<String, dynamic> rowMap = {};

            for (int j = 0; j < headers.length; j++) {
              if (j < row.length) {
                rowMap[headerMap(headers[j])] = row[j]?.value.toString();
              } else {
                rowMap[headerMap(headers[j])] = null; // Handle missing columns
              }
            }
            setState(() {
              jsonData.add(rowMap);
            });
          }
          GlobalVariables.requestBody[OrderBilledProvider.featureName]
              .addAll(jsonData[0]);
        }
      } else {
        showAlertDialog(context, "File selection canceled", "OKAY", false);
      }
    } catch (e) {
      showAlertDialog(context, "Unable to access file.", "OKAY", false);
    }
  }

  String headerMap(String excelHeader) {
    switch (excelHeader) {
      case 'IRN':
        return 'irn';
      case 'Ack No':
        return 'ackno';
      case 'Ack Date':
        return 'ackdate';
      case 'Doc No':
        return 'docno';
      case 'Doc Typ':
        return 'doctype';
      case 'Doc Date':
        return 'docdate';
      case 'Inv Value.':
        return 'billValue';
      case 'Recipient GSTIN':
        return 'rgstin';
      case 'Status':
        return 'status';
      case 'Signed QR Code':
        return 'sqrcode';
      default:
        return '';
    }
  }
}
