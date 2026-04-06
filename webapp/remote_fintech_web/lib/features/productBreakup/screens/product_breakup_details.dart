// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:fintech_new_web/features/productBreakup/screens/product_breakup_processing_row_field.dart';
import 'package:fintech_new_web/features/productBreakup/screens/product_breakup_row_field.dart';
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

import '../../camera/widgets/camera_widget.dart';
import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../provider/product_breakup_provider.dart';

class ProductBreakupDetails extends StatefulWidget {
  static String routeName = "ProductBreakupDetails";

  const ProductBreakupDetails({super.key});

  @override
  ProductBreakupDetailsState createState() => ProductBreakupDetailsState();
}

class ProductBreakupDetailsState extends State<ProductBreakupDetails>
    with SingleTickerProviderStateMixin {
  List<List<String>> tableRows = [];
  List<List<String>> processingTableRows = [];
  var formKey = GlobalKey<FormState>();
  late TabController tabController;

  bool manualOrder = true;
  bool autoOrder = false;
  bool isFileUploaded = false;

  List<Map<String, dynamic>> jsonData = [];

  bool manualOrder1 = true;
  bool autoOrder1 = false;
  bool isFileUploaded1 = false;

  List<Map<String, dynamic>> partProcessingData = [];

  @override
  void initState() {
    super.initState();
    ProductBreakupProvider provider =
        Provider.of<ProductBreakupProvider>(context, listen: false);
    provider.initWidget();

    // Add one empty row at the beginning
    tableRows.add(['', '', '', '', '', '']);
    processingTableRows.add(['', '', '', '', '']);
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  // Function to add a new row
  void addRow() {
    setState(() {
      tableRows.add(['', '', '', '', '', '']);
    });
  }

  void addProcessingRow() {
    setState(() {
      processingTableRows.add(['', '', '', '', '']);
    });
  }

  void deleteProcessingRow(int index) {
    setState(() {
      processingTableRows.removeAt(index);
    });
  }

  // Function to delete a row
  void deleteRow(int index) {
    setState(() {
      tableRows.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductBreakupProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Product Breakup')),
        body: Center(
          child: Column(
            children: [
              TabBar(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  isScrollable: false,
                  tabs: const [
                    Tab(text: "Product Breakup"),
                    Tab(text: "Details"),
                    Tab(text: "Processing"),
                  ]),
              Expanded(
                  child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: tabController,
                      children: [
                    SingleChildScrollView(
                      child: Center(
                        child: Container(
                          width: kIsWeb
                              ? GlobalVariables.deviceWidth / 2
                              : GlobalVariables.deviceWidth,
                          padding: const EdgeInsets.all(10),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
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
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: HexColor("#0B6EFE"),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)))),
                                      onPressed: () async {
                                        http.StreamedResponse result =
                                        await provider.processFormInfo();
                                        var message = jsonDecode(
                                            await result.stream.bytesToString());
                                        if (result.statusCode == 200) {
                                          context.pushReplacementNamed(ProductBreakupDetails.routeName);
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: HexColor("#0B6EFE"),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)))),
                                    onPressed: () async {
                                      http.StreamedResponse result =
                                          await provider.addProductBreakupDetails(
                                              tableRows,manualOrder);
                                      var message = jsonDecode(
                                          await result.stream.bytesToString());
                                      if (result.statusCode == 200) {
                                        context.pushReplacementNamed(ProductBreakupDetails.routeName);
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
                                      padding: const EdgeInsets.only(
                                          top: 8, right: 10),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: HexColor("#1B7B00"),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                1), // Square shape
                                          ),
                                          padding: EdgeInsets.zero,
                                          // Remove internal padding to make it square
                                          minimumSize: const Size(200,
                                              50), // Width and height for the button
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
                                      padding: const EdgeInsets.only(
                                          top: 8, right: 10),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: HexColor("#31007B"),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                1), // Square shape
                                          ),
                                          padding: EdgeInsets.zero,
                                          // Remove internal padding to make it square
                                          minimumSize: const Size(250,
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
                                          "Manually",
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
                                  child: ProductBreakupRowField(
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
                                      final Uri uri = Uri.parse("https://docs.google.com/spreadsheets/d/19cU6K6__onhu5HxLyO0cHIQBzBM-ZMJ4OcGOaqMrS2c/edit?usp=sharing");
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
                                mainAxisAlignment: MainAxisAlignment
                                    .start, // Space buttons evenly

                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Visibility(
                                    visible: manualOrder,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: HexColor("#0B6EFE"),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)))),
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
                                      padding: const EdgeInsets.only(
                                          top: 8, right: 10),
                                      child: ElevatedButton(
                                        onPressed: _importExcel,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: HexColor("#006B7B"),
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
                                      padding:
                                          EdgeInsets.only(top: 8, right: 10),
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
                                      padding: const EdgeInsets.only(
                                          top: 8, right: 10),
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
                    SingleChildScrollView(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: HexColor("#0B6EFE"),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)))),
                                    onPressed: () async {
                                      http.StreamedResponse result =
                                          await provider.addProductBreakupProcessing(processingTableRows, manualOrder1);
                                      var message = jsonDecode(
                                          await result.stream.bytesToString());
                                      if (result.statusCode == 200) {
                                        context.pushReplacementNamed(ProductBreakupDetails.routeName);
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
                                    visible: manualOrder1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, right: 10),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: HexColor("#1B7B00"),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                1), // Square shape
                                          ),
                                          padding: EdgeInsets.zero,
                                          // Remove internal padding to make it square
                                          minimumSize: const Size(200,
                                              50), // Width and height for the button
                                        ),
                                        child: const Text(
                                          "Import",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            manualOrder1 = false;
                                            autoOrder1 = true;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: autoOrder1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, right: 10),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: HexColor("#31007B"),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                1), // Square shape
                                          ),
                                          padding: EdgeInsets.zero,
                                          // Remove internal padding to make it square
                                          minimumSize: const Size(250,
                                              50), // Width and height for the button
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            manualOrder1 = true;
                                            autoOrder1 = false;
                                            isFileUploaded1 = false;
                                          });
                                        },
                                        child: const Text(
                                          "Manually",
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
                              for (int i = 0; i < processingTableRows.length; i++)
                                Visibility(
                                  visible: manualOrder1,
                                  child: ProductBreakupProcessingRowField(
                                      index: i,
                                      tableRows: processingTableRows,
                                      deleteRow: deleteProcessingRow,
                                      workProcess: provider.workProcess,
                                      resources: provider.resources),
                                ),
                              Visibility(
                                  visible: autoOrder1,
                                  child: InkWell(
                                    child: const Text(
                                      "Click to View file format for Import",
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onTap: () async {
                                      final Uri uri = Uri.parse("https://docs.google.com/spreadsheets/d/1p3rlxLsvsxrSyDIAQ4vDGs_1UmLXX1NMC6t-NPAWUVs/edit?usp=sharing");
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
                                mainAxisAlignment: MainAxisAlignment
                                    .start, // Space buttons evenly

                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Visibility(
                                    visible: manualOrder1,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: HexColor("#0B6EFE"),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)))),
                                      onPressed: addProcessingRow,
                                      child: const Text('Add Row',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                    ),
                                  ),
                                  Visibility(
                                    visible: autoOrder1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, right: 10),
                                      child: ElevatedButton(
                                        onPressed: _importProcessingDataExcel,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: HexColor("#006B7B"),
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
                                          'Choose File',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: isFileUploaded1,
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.only(top: 8, right: 10),
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
                                    visible: isFileUploaded1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, right: 10),
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
                  ]))
            ],
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
          GlobalVariables.requestBody['ProductBreakupDetails'] = [];
          GlobalVariables.requestBody['ProductBreakupDetails'] =
              jsonData;
        }
      } else {
        showAlertDialog(context, "File selection canceled", "OKAY", false);
      }
    } catch (e) {
      showAlertDialog(context, "Unable to access file.", "OKAY", false);
    }
  }

  Future<void> _importProcessingDataExcel() async {
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
          partProcessingData.clear();
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
              isFileUploaded1 = true;
              partProcessingData.add(rowMap);
            });
          }
          GlobalVariables.requestBody['ProductBreakupProcessing'] = [];
          GlobalVariables.requestBody['ProductBreakupProcessing'] =
              partProcessingData;
        }
      } else {
        showAlertDialog(context, "File selection canceled", "OKAY", false);
      }
    } catch (e) {
      showAlertDialog(context, "Unable to access file.", "OKAY", false);
    }
  }
}
