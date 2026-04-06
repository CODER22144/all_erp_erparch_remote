import 'dart:convert';
import 'dart:io';

import 'package:fintech_new_web/features/network/service/network_service.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../utility/global_variables.dart';

class EditMaterialSourceBulk extends StatefulWidget {
  static String routeName = "editMaterialSourceBulk";
  const EditMaterialSourceBulk({super.key});

  @override
  State<EditMaterialSourceBulk> createState() => _EditMaterialSourceBulkState();
}

class _EditMaterialSourceBulkState extends State<EditMaterialSourceBulk> {
  List<Map<String, dynamic>> jsonData = [];
  bool isFileUploaded = false;

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
          jsonData.clear();

          // Iterate over remaining rows and map them to headers
          for (int i = 1; i < sheet.rows.length; i++) {
            var row = sheet.rows[i];
            Map<String, dynamic> rowMap = {};

            for (int j = 0; j < headers.length; j++) {
              if (j < row.length) {

                if(headers[j] == 'rateEf') {
                  rowMap[headers[j]] = DateFormat("MM-dd-yyyy").format(
                      DateFormat("dd-MM-yyyy").parse(row[j]!.value.toString()));
                } else {
                  rowMap[headers[j]] = row[j]?.value.toString();
                }
              } else {
                rowMap[headers[j]] = null; // Handle missing columns
              }
            }
            setState(() {
              isFileUploaded = true;
              jsonData.add(rowMap);
            });
          }
        }
      } else {
        showAlertDialog(context, "File selection canceled", "OKAY", false);
      }
    } catch (e) {
      showAlertDialog(context, "There is some issue in the file.\n${e.toString()}", "OKAY", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Edit Material Source')),
          body: InkWell(
              onTap: _importExcel,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: GlobalVariables.deviceWidth / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        child: const Text(
                          "Click to View file format for Import",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w500),
                        ),
                        onTap: () async {
                          final Uri uri = Uri.parse(
                              "https://docs.google.com/spreadsheets/d/1FMVQPNmUv-uBSpGDrOUjgUib8z41y-9oFy_tRW6Cgaw/edit?usp=sharing");
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.inAppBrowserView);
                          } else {
                            throw 'Could not launch';
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
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
                          isFileUploaded
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
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor("#0B6EFE"),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                          onPressed: () async {
                            bool confirmation =
                            await showConfirmationDialogue(
                                context,
                                "Do you want to upload the selected file?",
                                "SUBMIT",
                                "CANCEL");
                            if (confirmation) {
                              NetworkService networkService = NetworkService();
                              http.StreamedResponse response =
                              await networkService.post("/edit-material-source-bulk/", jsonData);
                              if (response.statusCode == 200) {
                                showAlertDialog(
                                    context, "File Uploaded Successfully", "OKAY", false);
                                context.pushReplacementNamed(EditMaterialSourceBulk.routeName);

                                setState(() {
                                  jsonData.clear();
                                });

                              } else {
                                var errorMsg = jsonDecode(await response.stream.bytesToString());
                                await showAlertDialog(
                                    context, errorMsg['message'].toString(), "Continue", false);
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
                      )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
