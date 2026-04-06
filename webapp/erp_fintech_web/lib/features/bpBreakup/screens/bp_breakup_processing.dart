// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:fintech_new_web/features/bpBreakup/provider/bp_breakup_provider.dart';
import 'package:fintech_new_web/features/materialAssembly/provider/material_assembly_provider.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import 'bp_breakup_processing_row_fields.dart';

class BpBreakupProcessing extends StatefulWidget {
  static String routeName = "BpBreakupProcessing";

  const BpBreakupProcessing({super.key});
  @override
  BpBreakupProcessingState createState() => BpBreakupProcessingState();
}

class BpBreakupProcessingState extends State<BpBreakupProcessing> {
  List<List<String>> tableRows = [];
  var formKey = GlobalKey<FormState>();

  bool manualOrder = true;
  bool autoOrder = false;
  bool isFileUploaded = false;

  List<Map<String, dynamic>> jsonData = [];
  late BpBreakupProvider provider;

  double qtySum = 0;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<BpBreakupProvider>(context, listen: false);
    provider.initProcessingWidget();
    // Add one empty row at the beginning
    tableRows.add(['', '', '', '']);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Function to add a new row
  void addRow() {
    setState(() {
      tableRows.add(['', '', '', '']);
    });
    provider.addRowController2();
  }

  // Function to delete a row
  void deleteRow(int index) {
    setState(() {
      tableRows.removeAt(index);
    });
    provider.deleteRowController2(index);
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
          List<String> headers = sheet.rows[1]
              .map((cell) => cell?.value?.toString() ?? '')
              .toList();
          jsonData.clear();
          // Iterate over remaining rows and map them to headers
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
          GlobalVariables.requestBody['BPBreakupProcessing'] = jsonData;
        }
      } else {
        showAlertDialog(context, "File selection canceled", "OKAY", false);
      }
    } catch (e) {
      showAlertDialog(context, "Unable to access file.", "OKAY", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BpBreakupProvider>(
        builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Bp Breakup Processing')),
        body: Column(
          children: [
            SingleChildScrollView(
              child: SizedBox(
                width: GlobalVariables.deviceWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8, right: 10, left: 60),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor("#4166f5"),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(1), // Square shape
                              ),
                              padding: EdgeInsets.zero,
                              // Remove internal padding to make it square
                              minimumSize: const Size(
                                  100, 50), // Width and height for the button
                            ),
                            onPressed: () async {
                              http.StreamedResponse result = await provider
                                  .addMaterialAssemblyProcessing(
                                      tableRows, manualOrder);
                              var message = jsonDecode(
                                  await result.stream.bytesToString());
                              if (result.statusCode == 200) {
                                context.pushReplacementNamed(
                                    BpBreakupProcessing.routeName);
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
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Visibility(
                          visible: manualOrder,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, right: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#4166f5"),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      1), // Square shape
                                ),
                                padding: EdgeInsets.zero,
                                // Remove internal padding to make it square
                                minimumSize: const Size(150,
                                    50), // Width and height for the button
                              ),
                              child: const Text(
                                "Import",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w200),
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
                        const SizedBox(width: 10),
                        Visibility(
                          visible: autoOrder,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8, right: 10, left: 5),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#4166f5"),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      1), // Square shape
                                ),
                                padding: EdgeInsets.zero,
                                // Remove internal padding to make it square
                                minimumSize: const Size(200,
                                    50), // Width and height for the button
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // HEADER ROW
                    Visibility(
                      visible: manualOrder,
                      child: Row(
                        children: [
                          Container(
                              width: GlobalVariables.deviceWidth * 0.03,
                              height: GlobalVariables.deviceWidth * 0.03,
                              margin: const EdgeInsets.only(left: 5),
                              color: Colors.transparent,
                              child: const SizedBox()),
                          SizedBox(
                            width: GlobalVariables.deviceWidth * 0.16,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text("Business Partner",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(
                            width: GlobalVariables.deviceWidth * 0.16,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text("Material No.",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(
                            width: GlobalVariables.deviceWidth * 0.14,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text("Partner Processing",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(
                            width: GlobalVariables.deviceWidth * 0.08,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text("Quantity",
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Container(
                              width: GlobalVariables.deviceWidth * 0.03,
                              height: GlobalVariables.deviceWidth * 0.03,
                              margin: const EdgeInsets.only(right: 5),
                              color: Colors.transparent,
                              child: const SizedBox()),
                        ],
                      ),
                    ),

                    for (int i = 0; i < tableRows.length; i++)
                      Visibility(
                        visible: manualOrder,
                        child: BpBreakupProcessingRowFields(
                            addRow: addRow,
                            controllers: provider.rowControllers2,
                            index: i,
                            tableRows: tableRows,
                            deleteRow: deleteRow,
                            bpCodes: provider.bpCodes),
                      ),

                    Visibility(
                        visible: autoOrder,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, right: 10, left: 60),
                          child: InkWell(
                            child: const Text(
                              "Click to View file format for Import",
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500),
                            ),
                            onTap: () async {
                              final Uri uri = Uri.parse("https://docs.google.com/spreadsheets/d/1OtwDU4WwWAwb0CCOF_82Lfk9tr-Nctxa0kp-1ktBmao/edit?usp=sharing");
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri,
                                    mode: LaunchMode.inAppBrowserView);
                              } else {
                                throw 'Could not launch';
                              }
                            },
                          ),
                        )),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Space buttons evenly

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: autoOrder,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8, right: 10, left: 60),
                            child: ElevatedButton(
                              onPressed: _importExcel,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#4166f5"),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      1), // Square shape
                                ),
                                padding: EdgeInsets.zero,
                                // Remove internal padding to make it square
                                minimumSize: const Size(110,
                                    50), // Width and height for the button
                              ),
                              child: const Text(
                                'Choose File',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isFileUploaded,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 8, right: 10),
                            child: Text(
                              "File Uploaded Successfully",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                  color: Colors.green),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isFileUploaded,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, right: 10),
                            child: Text(
                              "${jsonData.length} Items Will Import.",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                  color: HexColor("#31007B")),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
