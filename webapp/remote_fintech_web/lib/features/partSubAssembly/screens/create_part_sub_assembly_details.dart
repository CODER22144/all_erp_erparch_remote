// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:fintech_new_web/features/partAssembly/provider/part_assembly_provider.dart';
import 'package:fintech_new_web/features/partSubAssembly/screens/part_sub_assembly_details_master_table.dart';
import 'package:fintech_new_web/features/partSubAssembly/screens/part_sub_assembly_row_field.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../provider/part_sub_assembly_provider.dart';

class CreatePartSubAssemblyDetails extends StatefulWidget {
  static String routeName = "CreatePartSubAssemblyDetails";

  const CreatePartSubAssemblyDetails({super.key});

  @override
  CreatePartSubAssemblyDetailsState createState() => CreatePartSubAssemblyDetailsState();
}

class CreatePartSubAssemblyDetailsState extends State<CreatePartSubAssemblyDetails> {
  List<List<String>> tableRows = [];
  var formKey = GlobalKey<FormState>();

  bool manualOrder = true;
  bool autoOrder = false;
  bool isFileUploaded = false;

  List<Map<String, dynamic>> jsonData = [];

  @override
  void initState() {
    super.initState();
    tableRows.add(
        ['', '', '', '', '', '']);
  }

  void addRow() {
    setState(() {
      tableRows.add(
          ['', '', '', '', '', '']);
    });
  }

  void deleteRow(int index) {
    setState(() {
      tableRows.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartSubAssemblyProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Append Part Sub Assembly Details')),
        body: Center(
          child: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: kIsWeb
                    ? GlobalVariables.deviceWidth / 2
                    : GlobalVariables.deviceWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor("#0B6EFE"),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
                          onPressed: () async {
                            http.StreamedResponse result = await provider
                                .addPartSubAssemblyDetails(tableRows, manualOrder);
                            var message =
                                jsonDecode(await result.stream.bytesToString());
                            if (result.statusCode == 200) {
                              context.pop();
                              provider.getPartSubAssemblyByMatno();
                            } else if (result.statusCode == 400) {
                              await showAlertDialog(
                                  context,
                                  message['message'].toString(),
                                  "Continue",
                                  false);
                            } else if (result.statusCode == 500) {
                              await showAlertDialog(context, message['message'],
                                  "Continue", false);
                            } else {
                              await showAlertDialog(context, message['message'],
                                  "Continue", false);
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
                        Visibility(
                          visible: manualOrder,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, right: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#1B7B00"),
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
                                "Import Part Assembly",
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
                        Padding(
                          padding: const EdgeInsets.only(top: 8, right: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
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
                              "Delete",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              context.pushNamed(PartSubAssemblyDetailsMasterTable.routeName);
                            },
                          ),
                        ),
                        Visibility(
                          visible: autoOrder,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, right: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#31007B"),
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
                                "Manually Create",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    for (int i = 0; i < tableRows.length; i++)
                      Visibility(
                        visible: manualOrder,
                        child: PartSubAssemblyRowField(
                            index: i,
                            tableRows: tableRows,
                            deleteRow: deleteRow,
                            rmType: provider.rmType,
                         units: provider.units),
                      ),
                    Visibility(
                        visible: autoOrder,
                        child: InkWell(
                          child: const Text(
                            "Click to View file format for Import",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w500),
                          ),
                          onTap: () async {
                            final Uri uri = Uri.parse(
                                "https://docs.google.com/spreadsheets/d/1_Tz4ATfq7JU0HNKk47Q7z9QtQqcgBjKaWMABhZinVu0/edit?usp=sharing");
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.inAppBrowserView);
                            } else {
                              throw 'Could not launch';
                            }
                          },
                        )),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Space buttons evenly

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: manualOrder,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#0B6EFE"),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)))),
                            onPressed: addRow,
                            child: const Text('Add Row',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                        Visibility(
                          visible: autoOrder,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, right: 10),
                            child: ElevatedButton(
                              onPressed: _importExcel,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#006B7B"),
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
          GlobalVariables.requestBody['PartSubAssemblyDetails'] = [];
          GlobalVariables.requestBody['PartSubAssemblyDetails'] = jsonData;
        }
      } else {
        showAlertDialog(context, "File selection canceled", "OKAY", false);
      }
    } catch (e) {
      showAlertDialog(context, "Unable to access file.", "OKAY", false);
    }
  }
}
