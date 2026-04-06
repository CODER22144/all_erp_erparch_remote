import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' as exl;

import '../../common/widgets/pop_ups.dart';
import '../global_variables.dart';
import 'common_utility.dart';

class ImportWidget extends StatefulWidget {
  final String feature;
  final String sampleFileUrl;
  final bool isMaster;
  final String masterDetailFeatureName;
  final bool manualOrder;
  final bool autoOrder;
  final bool isFileUploaded;
  final VoidCallback toggleManual;
  final VoidCallback toggleAuto;
  final String groupBy;
  final String text;
  const ImportWidget(
      {super.key,
      required this.feature,
      required this.sampleFileUrl,
      required this.isMaster,
      this.masterDetailFeatureName = "",
      this.groupBy = "",
      this.text = "",
      required this.manualOrder,
      required this.autoOrder,
      required this.isFileUploaded,
      required this.toggleManual,
      required this.toggleAuto});

  @override
  State<ImportWidget> createState() => _ImportWidgetState();
}

class _ImportWidgetState extends State<ImportWidget> {
  List<Map<String, dynamic>> masterData = [];
  List<Map<String, dynamic>> masterDetailsData = [];
  bool isFileUploaded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: widget.manualOrder,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1), // Square shape
                    ),
                    padding: EdgeInsets.zero,
                    // Remove internal padding to make it square
                    minimumSize:
                        const Size(200, 50), // Width and height for the button
                  ),
                  onPressed: () {
                    widget.toggleManual();

                    setState(() {
                      masterData = [];
                      masterDetailsData = [];
                      isFileUploaded = false;
                    });
                    GlobalVariables.requestBody[widget.feature] = null;
                  },
                  child: Text(
                    checkForEmptyOrNullString(widget.text) ? widget.text : "Import",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: widget.autoOrder,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1), // Square shape
                    ),
                    padding: EdgeInsets.zero,
                    // Remove internal padding to make it square
                    minimumSize:
                        const Size(200, 50), // Width and height for the button
                  ),
                  onPressed: () {
                    widget.toggleAuto();

                    setState(() {
                      masterData = [];
                      masterDetailsData = [];
                      isFileUploaded = false;
                    });

                    GlobalVariables.requestBody[widget.feature] = null;
                  },
                  child: const Text(
                    "Manual",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
        const SizedBox(height: 20),
        Visibility(
            visible: widget.autoOrder,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: InkWell(
                child: const Text(
                  "Click to View file format for Import",
                  style: TextStyle(
                      color: Colors.blueAccent, fontWeight: FontWeight.w500),
                ),
                onTap: () async {
                  final Uri uri = Uri.parse(widget.sampleFileUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                  } else {
                    throw 'Could not launch';
                  }
                },
              ),
            )),
        Row(
          children: [
            Visibility(
              visible: widget.autoOrder,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 10),
                child: ElevatedButton(
                  onPressed: _importExcel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1), // Square shape
                    ),
                    padding: EdgeInsets.zero,
                    // Remove internal padding to make it square
                    minimumSize:
                        const Size(200, 50), // Width and height for the button
                  ),
                  child: const Text(
                    'Choose File',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 30),
            Visibility(
              visible: isFileUploaded && widget.autoOrder,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 10),
                child: Text(
                  "File Uploaded Successfully. ${masterData.length} Items Will Import.",
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
      ],
    );
  }

  Future<void> _importExcel() async {
    setState(() {
      isFileUploaded = false;
    });
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

        var masterSheet = excel.tables['master'];
        var masterDetailSheet = excel.tables['masterDetail'];

        // CREATE MASTER DATA
        if (masterSheet != null) {
          // Get the first row as headers
          List<String> headers = masterSheet.rows[1]
              .map((cell) => cell?.value?.toString() ?? '')
              .toList();

          // Iterate over remaining rows and map them to headers
          masterData.clear();
          for (int i = 2; i < masterSheet.rows.length; i++) {
            var row = masterSheet.rows[i];
            Map<String, dynamic> rowMap = {};

            for (int j = 0; j < headers.length; j++) {
              if (j < row.length) {
                if (checkForEmptyOrNullString(row[j]?.value.toString())) {
                  rowMap[headers[j]] = validateAndConvertDateToDbFormat(
                      row[j]!.value.toString(), i, headers[j]);
                }
              } else {
                rowMap[headers[j]] = null; // Handle missing columns
              }
            }
            setState(() {
              isFileUploaded = true;
              masterData.add(rowMap);
            });
          }
          GlobalVariables.requestBody[widget.feature] = masterData;
        }

        // CREATE MASTER DETAILS DATA
        if (!widget.isMaster) {
          if (masterDetailSheet != null) {
            // Get the first row as headers
            List<String> headers = masterDetailSheet.rows[1]
                .map((cell) => cell?.value?.toString() ?? '')
                .toList();

            // Iterate over remaining rows and map them to headers
            masterDetailsData.clear();
            for (int i = 2; i < masterDetailSheet.rows.length; i++) {
              var row = masterDetailSheet.rows[i];
              Map<String, dynamic> rowMap = {};

              for (int j = 0; j < headers.length; j++) {
                if (j < row.length) {
                  if (checkForEmptyOrNullString(row[j]?.value.toString())) {
                    rowMap[headers[j]] = validateAndConvertDateToDbFormat(
                        row[j]!.value.toString(), i, headers[j]);
                  }
                } else {
                  rowMap[headers[j]] = null; // Handle missing columns
                }
              }
              setState(() {
                // isFileUploaded = true;
                masterDetailsData.add(rowMap);
              });
            }
          }
          groupMasterAndDetailsData();
        }
      } else {
        showAlertDialog(context, "File selection canceled.", "OKAY", false);
      }
    } catch (e) {
      showAlertDialog(
          context, "Unable to access file.\n${e.toString()}", "OKAY", false);
    }
  }

  void groupMasterAndDetailsData() {
    Map<String, List<dynamic>> detailsMap = {};

    for (var item in masterDetailsData) {
      if (detailsMap.containsKey(item[widget.groupBy])) {
        detailsMap[item[widget.groupBy]]!.add(item);
      } else {
        detailsMap[item[widget.groupBy]] = [item];
      }
    }

    List<Map<String, dynamic>> merged = [];
    for (var item in masterData) {
      item[widget.masterDetailFeatureName] = detailsMap[item[widget.groupBy]];
      merged.add(item);
    }

    GlobalVariables.requestBody[widget.feature] = merged;
  }
}
