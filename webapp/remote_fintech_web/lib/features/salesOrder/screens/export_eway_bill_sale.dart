import 'dart:convert';

import 'package:fintech_new_web/features/common/widgets/pop_ups.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';
import '../../utility/services/common_utility.dart';

class ExportEwayBillSale extends StatefulWidget {
  static String routeName = '/ExportEwayBillSale';
  const ExportEwayBillSale({super.key});

  @override
  State<ExportEwayBillSale> createState() => _ExportEwayBillSaleState();
}

class _ExportEwayBillSaleState extends State<ExportEwayBillSale> {
  TextEditingController docnoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
          child: const CommonAppbar(title: 'Export Eway Bill Sale')),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: kIsWeb
                ? GlobalVariables.deviceWidth / 2.0
                : GlobalVariables.deviceWidth,
            padding: const EdgeInsets.all(10),
            child: Form(
              // key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      readOnly: false,
                      controller: docnoController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        label: RichText(
                          text: const TextSpan(
                            text: "Invoice No.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                            ),
                            children: [
                              TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ],
                          ),
                        ),
                      ),
                      validator: (String? val) {
                        if ((val == null || val.isEmpty)) {
                          return 'This field is Mandatory';
                        }
                      },
                      maxLines: 1,
                    ),
                  ),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly, // Adjust alignment
                    children: [
                      Expanded(
                        // Ensures even spacing and prevents overflow
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10, right: 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor("#0B6EFE"),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                            onPressed: () async {
                              NetworkService networkService = NetworkService();
                              http.StreamedResponse response =
                                  await networkService.post(
                                      "/export-eway-bill-sale/",
                                      {"docno": docnoController.text});
                              if (response.statusCode == 200) {
                                var data = jsonDecode(
                                    await response.stream.bytesToString());
                                String fileName =
                                    'eway_bill_${docnoController.text}.json';
                                String jsonString =
                                    const JsonEncoder.withIndent("  ")
                                        .convert(data);

                                if (data['billLists'] != null) {
                                  if (kIsWeb) {
                                    downloadJsonWeb(jsonString, fileName);
                                  } else {
                                    downloadForAndroid(
                                        jsonString, fileName, context);
                                  }
                                } else {
                                  showAlertDialog(
                                    context,
                                    "Invalid Invoice No. or no data is fetched for Invoice No : ${docnoController.text}",
                                    "CONTINUE",
                                    false,
                                  );
                                }
                              }
                            },
                            child: const Text(
                              'Eway Bill',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        // Ensures even spacing and prevents overflow
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10, left: 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor("#0B6EFE"),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                            onPressed: () async {
                              NetworkService networkService = NetworkService();
                              http.StreamedResponse response =
                                  await networkService.post("/export-einvoice/",
                                      {"docno": docnoController.text});
                              if (response.statusCode == 200) {
                                var data = jsonDecode(
                                    await response.stream.bytesToString());
                                String fileName =
                                    'EInvoice_${docnoController.text}.json';
                                String jsonString =
                                    const JsonEncoder.withIndent("  ")
                                        .convert(data);

                                if (data[0] != null) {
                                  if (kIsWeb) {
                                    downloadJsonWeb(jsonString, fileName);
                                  } else {
                                    downloadForAndroid(
                                        jsonString, fileName, context);
                                  }
                                } else {
                                  showAlertDialog(
                                    context,
                                    "Invalid Invoice No. or no data is fetched for Invoice No : ${docnoController.text}",
                                    "CONTINUE",
                                    false,
                                  );
                                }
                              }
                            },
                            child: const Text(
                              'E-Invoice',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
