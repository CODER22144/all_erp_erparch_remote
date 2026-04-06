// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/acGroups/provider/account_group_provider.dart';
import 'package:fintech_new_web/features/common/widgets/pop_ups.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:excel/excel.dart' as exl;
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../common/widgets/comman_appbar.dart';

class AddAcGroup extends StatefulWidget {
  static String routeName = "/addAcGroup";
  final String? editing;
  const AddAcGroup({super.key, this.editing});

  @override
  State<AddAcGroup> createState() => _AddAcGroupState();
}

class _AddAcGroupState extends State<AddAcGroup> {
  late AccountGroupProvider provider;
  bool manualOrder = true;
  bool autoOrder = false;
  bool isFileUploaded = false;

  bool isLoading = false;
  double progress = 0;
  int records = 0;

  List<Map<String, dynamic>> jsonData = [];

  // Pick file
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ["xlsx", "xls"],
    );

    if (result == null) return;

    Uint8List fileBytes = result.files.first.bytes!;
    final excel = exl.Excel.decodeBytes(fileBytes);
    var sheet = excel.tables.values.first;

    setState(() {
      records = sheet.rows.length - 2;
      isLoading = true;
      isFileUploaded = false;
      progress = 0.0;
    });

    await convertExcel(fileBytes);
  }

  // Convert Excel using compute()
  Future<void> convertExcel(Uint8List bytes) async {
    // HEAVY TASK (runs in background isolate OR web worker)
    List<Map<String, dynamic>> result =
        await compute(parseExcelInBackground, bytes);

    setState(() {
      jsonData = result;
      progress = 1.0;
      isLoading = false;
      isFileUploaded = true;
    });

    GlobalVariables.requestBody[AccountGroupProvider.featureName] = {};
    GlobalVariables.requestBody[AccountGroupProvider.featureName] = jsonData;
  }

  @override
  void initState() {
    super.initState();
    provider = Provider.of<AccountGroupProvider>(context, listen: false);
    if (widget.editing == "true") {
      provider.initEditWidget();
    } else {
      provider.initWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<AccountGroupProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Add Account Groups')),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white54)),
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, right: 20, left: 20),
              width: kIsWeb
                  ? GlobalVariables.deviceWidth / 2.0
                  : GlobalVariables.deviceWidth,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  "https://docs.google.com/spreadsheets/d/1Y3klFAWuBfh1AOIH7bVNeR6HqsFVjSGGWj5zpj6lSVw/edit?usp=sharing");
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
                              onPressed: () {
                                pickFile();
                              },
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
                        // Progress Bar
                        isLoading
                            ? CircularPercentIndicator(
                                radius: 20,
                                percent: (progress / 100).toDouble(),
                                progressColor: Colors.green,
                                center: Text("${progress.toInt()}%",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)))
                            : Visibility(
                                visible: isFileUploaded,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, right: 10),
                                  child: Text(
                                    "Processing Completed.",
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
                      child: Padding(
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
                    ),
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
                                    widget.editing == "true"
                                        ? await provider.processUpdateFormInfo()
                                        : await provider
                                            .processFormInfo(manualOrder);
                                var message = jsonDecode(
                                    await result.stream.bytesToString());
                                if (result.statusCode == 200) {
                                  if (widget.editing == "true") {
                                    context.pop();
                                  } else {
                                    context.pushReplacementNamed(
                                        AddAcGroup.routeName);
                                  }
                                  provider.getAccountGroupReport();
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

  Future<List<Map<String, dynamic>>> parseExcelInBackground(
      Uint8List bytes) async {
    List<Map<String, dynamic>> output = [];
    final excel = exl.Excel.decodeBytes(bytes);
    var sheet = excel.tables.values.first;

    List<String> headers =
        sheet.rows[1].map((cell) => cell?.value?.toString() ?? '').toList();

    for (int i = 2; i < sheet.rows.length; i++) {
      Map<String, dynamic> rowData = {};
      var row = sheet.rows[i];

      for (int j = 0; j < headers.length; j++) {
        if (j < row.length) {
          rowData[headers[j]] = row[j]?.value.toString();
        } else {
          rowData[headers[j]] = null; // Handle missing columns
        }
      }
      output.add(rowData);

      setState(() {
        progress = (i - 1) / records * 100;
      });
    }

    return output;
  }
}
