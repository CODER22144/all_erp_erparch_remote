// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:fintech_new_web/features/common/widgets/pop_ups.dart';
import 'package:fintech_new_web/features/paymentOutward/provider/payment_outward_provider.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' as exl;

import '../../common/widgets/comman_appbar.dart';

class AddPaymentOutward extends StatefulWidget {
  static String routeName = "/AddPaymentOutward";
  final String? editing;

  const AddPaymentOutward({super.key, this.editing});

  @override
  State<AddPaymentOutward> createState() => _AddPaymentOutwardState();
}

class _AddPaymentOutwardState extends State<AddPaymentOutward> {
  late PaymentOutwardProvider provider;
  bool pass = true;

  bool manualOrder = true;
  bool autoOrder = false;
  bool isFileUploaded = false;

  List<Map<String, dynamic>> jsonData = [];

  @override
  void initState() {
    super.initState();
    provider = Provider.of<PaymentOutwardProvider>(context, listen: false);
    if (widget.editing == "true") {
      provider.initEditWidget();
    } else {
      provider.initWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<PaymentOutwardProvider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: HexColor('#f9f9ff'),
        appBar: PreferredSize(
            preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: CommonAppbar(
                title: widget.editing == "true"
                    ? 'Update Payment Outward'
                    : "Add Payment Outward")),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  border: provider.widgetList.isNotEmpty
                      ? Border.all(width: 1, color: Colors.black)
                      : null),
              width: kIsWeb
                  ? GlobalVariables.deviceWidth / 2.0
                  : GlobalVariables.deviceWidth,
              padding: const EdgeInsets.all(10),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: manualOrder,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, right: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(1), // Square shape
                                ),
                                padding: EdgeInsets.zero,
                                // Remove internal padding to make it square
                                minimumSize: const Size(
                                    200, 50), // Width and height for the button
                              ),
                              child: const Text(
                                "Import",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                setState(() {
                                  manualOrder = false;
                                  autoOrder = true;
                                });
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: autoOrder,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, right: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(1), // Square shape
                                ),
                                padding: EdgeInsets.zero,
                                // Remove internal padding to make it square
                                minimumSize: const Size(
                                    250, 50), // Width and height for the button
                              ),
                              onPressed: () {
                                setState(() {
                                  manualOrder = true;
                                  autoOrder = false;
                                  isFileUploaded = false;
                                });
                              },
                              child: const Text(
                                "Manual",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Visibility(
                        visible: autoOrder,
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: InkWell(
                            child: const Text(
                              "Click to View file format for Import",
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500),
                            ),
                            onTap: () async {
                              final Uri uri = Uri.parse(
                                  "https://docs.google.com/spreadsheets/d/1VED8zniC_PAgmG7fpj0fRQKIvNFDH0x4JN0Bc3u0SRE/edit?usp=sharing");
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri,
                                    mode: LaunchMode.inAppBrowserView);
                              } else {
                                throw 'Could not launch';
                              }
                            },
                          ),
                        )),
                    Row(
                      children: [
                        Visibility(
                          visible: autoOrder,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, right: 10),
                            child: ElevatedButton(
                              onPressed: _importExcel,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(1), // Square shape
                                ),
                                padding: EdgeInsets.zero,
                                // Remove internal padding to make it square
                                minimumSize: const Size(
                                    150, 50), // Width and height for the button
                              ),
                              child: const Text(
                                'Choose File',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 30),
                        Visibility(
                          visible: isFileUploaded,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, right: 10),
                            child: Text(
                              "File Uploaded Successfully. ${jsonData.length} Items Will Import.",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#006400")),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: manualOrder,
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
                    Visibility(
                      visible: provider.widgetList.isNotEmpty,
                      child: Container(
                        margin:
                        const EdgeInsets.only(bottom: 10, top: 10),
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor("#0B6EFE"),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5)))),
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
                                widget.editing == "true"
                                    ? await provider
                                    .processUpdateFormInfo()
                                    : await provider
                                    .processAddFormInfo(manualOrder);
                                var message = jsonDecode(
                                    await result.stream.bytesToString());
                                if (result.statusCode == 200) {
                                  if (widget.editing == "true") {
                                    context.pop();
                                  } else {
                                    context.pushReplacementNamed(
                                        AddPaymentOutward.routeName);
                                  }
                                  provider.getPaymentOutwardReport();
                                } else if (result.statusCode == 400) {
                                  await showAlertDialog(
                                      context,
                                      message['message'].toString(),
                                      "Continue",
                                      false);
                                } else if (result.statusCode == 500) {
                                  await showAlertDialog(
                                      context,
                                      message['message'],
                                      "Continue",
                                      false);
                                } else {
                                  await showAlertDialog(
                                      context,
                                      message['message'],
                                      "Continue",
                                      false);
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
        var excel = exl.Excel.decodeBytes(bytes);

        var sheet = excel.tables.values.first;

        if (sheet != null) {
          // Get the first row as headers
          List<String> headers = sheet.rows[1]
              .map((cell) => cell?.value?.toString() ?? '')
              .toList();

          // Iterate over remaining rows and map them to headers
          jsonData.clear();
          for (int i = 2; i < sheet.rows.length; i++) {
            var row = sheet.rows[i];
            Map<String, dynamic> rowMap = {};

            for (int j = 0; j < headers.length; j++) {
              if (j < row.length) {
                rowMap[headers[j]] = row[j]?.value.toString();
              } else {
                rowMap[headers[j]] = null; // Handle missing columns
              }
            }
            setState(() {
              isFileUploaded = true;
              jsonData.add(rowMap);
            });
          }
          GlobalVariables.requestBody[PaymentOutwardProvider.featureName] = {};
          GlobalVariables.requestBody[PaymentOutwardProvider.featureName] =
              jsonData;
        }
      } else {
        showAlertDialog(context, "File selection canceled", "OKAY", false);
      }
    } catch (e) {
      showAlertDialog(context, "Unable to access file.", "OKAY", false);
    }
  }
}
