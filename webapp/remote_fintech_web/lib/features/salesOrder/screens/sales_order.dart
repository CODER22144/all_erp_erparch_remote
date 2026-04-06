// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:fintech_new_web/features/network/service/network_service.dart';
import 'package:fintech_new_web/features/salesOrder/provider/sales_order_provider.dart';
import 'package:fintech_new_web/features/salesOrder/screens/sale_order_form_tab.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' as exl;
import 'package:url_launcher/url_launcher.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';

class SalesOrderDetails extends StatefulWidget {
  static String routeName = "/salesOrder";

  const SalesOrderDetails({super.key});
  @override
  SalesOrderDetailsState createState() => SalesOrderDetailsState();
}

class SalesOrderDetailsState extends State<SalesOrderDetails>
    with SingleTickerProviderStateMixin {
  List<List<String>> tableRows = [];
  late TabController tabController;

  TextEditingController icodeController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController rateController = TextEditingController();

  bool manualOrder = true;
  bool autoOrder = false;
  bool isFileUploaded = false;

  bool isLoading = false;

  List<Map<String, dynamic>> jsonData = [];
  List<Map<String, dynamic>> masterData = [];
  List<Map<String, dynamic>> masterDetailsData = [];
  late SalesOrderProvider provider;

  List<DataRow> materialList = [];
  NetworkService networkService = NetworkService();

  @override
  void initState() {
    super.initState();
    provider = Provider.of<SalesOrderProvider>(context, listen: false);
    provider.initWidget();
    // Add one empty row at the beginning
    tableRows.add(['', '']);
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  // Function to add a new row
  void addRow() async {
    http.StreamedResponse response =
        await networkService.post("/get-mat-amt/", {
      "lcode": GlobalVariables.requestBody[SalesOrderProvider.featureName]
          ['lcode'],
      "matno": icodeController.text,
      "qty": qtyController.text
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString())[0];
      setState(() {
        materialList.add(DataRow(
            color: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                // Alternate row color
                return HexColor("#f2f2f2");
              },
            ),
            cells: [
              DataCell(Text("${data['matno']}")),
              DataCell(Text("${data['saleDescription']}")),
              DataCell(Text("${data['qty']}")),
              DataCell(Text("${data['rate']}")),
              DataCell(Text("${data['unit']}")),
              DataCell(Text("${data['amount']}")),
              DataCell(Text("${data['gstTaxRate']}")),
              DataCell(Text("${data['gstAmount']}")),
              DataCell(Text("${data['tAmount']}")),
              DataCell(Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    color: Colors.red),
                child: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.white,
                    tooltip: 'Delete',
                    onPressed: () {
                      deleteRow(data['matno']);
                    }),
              )),
            ]));
        jsonData
            .add({"matno": icodeController.text, "Qty": qtyController.text});
      });
      qtyController.clear();
      icodeController.clear();
      rateController.clear();
    } else {
      await showAlertDialog(
          context,
          "Material No: ${icodeController.text} doesn't exists.",
          "Continue",
          false);
    }
  }

  // Function to delete a row
  void deleteRow(String mat) {
    setState(() {
      materialList.removeWhere((row) =>
          row.cells[0].child is Text &&
          (row.cells[0].child as Text).data == mat);

      jsonData.removeWhere((data) => data['matno'] == mat);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SalesOrderProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Sales Order Details')),
        body: Center(
          child: Column(
            children: [
              TabBar(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  isScrollable: false,
                  tabs: const [
                    Tab(text: "Order"),
                    Tab(text: "Details"),
                  ]),
              Expanded(
                  child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: tabController,
                      children: [
                    const SaleOrderFormTab(),
                    SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(
                              width: GlobalVariables.deviceWidth / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  // Row(
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: [
                                  //
                                  //     const SizedBox(height: 20),
                                  //   ],
                                  // ),
                                  const SizedBox(height: 20),
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
                                              "https://docs.google.com/spreadsheets/d/1g5wfprUEw2shCbdDNv5HPVVK88SZNoppUbJ3teJ22ws/edit?usp=sharing");
                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri,
                                                mode: LaunchMode
                                                    .inAppBrowserView);
                                          } else {
                                            throw 'Could not launch';
                                          }
                                        },
                                      )),
                                  Row(
                                    children: [
                                      Visibility(
                                        visible: autoOrder,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8, right: 10),
                                          child: ElevatedButton(
                                            onPressed: _importExcel,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  HexColor("#006B7B"),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        1), // Square shape
                                              ),
                                              padding: EdgeInsets.zero,
                                              // Remove internal padding to make it square
                                              minimumSize: const Size(200,
                                                  50), // Width and height for the button
                                            ),
                                            child: const Text(
                                              'Choose File',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                      Visibility(
                                        visible: isFileUploaded,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8, right: 10),
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
                                    child: Column(
                                      children: [
                                        Focus(
                                          onFocusChange: (hasFocus) async {
                                            if (!hasFocus) {
                                              http.StreamedResponse response =
                                                  await networkService.get(
                                                      "/get-material/${icodeController.text}/");

                                              if (response.statusCode == 200) {
                                                var data = jsonDecode(
                                                    await response.stream
                                                        .bytesToString())[0];
                                                setState(() {
                                                  rateController.text =
                                                      '${data['srate'] ?? ""}';
                                                });
                                              } else {
                                                await showAlertDialog(
                                                    context,
                                                    "Material No: ${icodeController.text} doesn't exists.",
                                                    "Continue",
                                                    false);
                                              }
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: TextFormField(
                                              controller: icodeController,
                                              decoration: InputDecoration(
                                                label: RichText(
                                                  text: const TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: "*",
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      )
                                                    ],
                                                    text: "Item Code",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                                border:
                                                    const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 0),
                                                ),
                                              ),
                                              validator: (String? val) {
                                                if (val == null ||
                                                    val.isEmpty) {
                                                  return 'This field is Mandatory';
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: TextFormField(
                                            validator: (String? val) {
                                              if (val == null || val.isEmpty) {
                                                return 'This field is Mandatory';
                                              }
                                            },
                                            controller: qtyController,
                                            decoration: InputDecoration(
                                              label: RichText(
                                                text: const TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "*",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    )
                                                  ],
                                                  text: "Quantity",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ),
                                              border: const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black,
                                                    width: 0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: TextFormField(
                                            readOnly: true,
                                            controller: rateController,
                                            decoration: InputDecoration(
                                              label: RichText(
                                                text: const TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    )
                                                  ],
                                                  text: "Rate",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ),
                                              border: const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black,
                                                    width: 0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      /// LEFT
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: manualOrder
                                              ? ElevatedButton(
                                                  onPressed: addRow,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.blueAccent,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              1),
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                    minimumSize:
                                                        const Size(200, 50),
                                                  ),
                                                  child: const Text(
                                                      'Add Material',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white)),
                                                )
                                              : ElevatedButton(
                                                  onPressed: () async {
                                                    http.StreamedResponse
                                                        result = await provider
                                                            .processFormInfo(
                                                                jsonData,
                                                                manualOrder);
                                                    var message = jsonDecode(
                                                        await result.stream
                                                            .bytesToString());
                                                    if (result.statusCode ==
                                                        200) {
                                                      context
                                                          .pushReplacementNamed(
                                                              SalesOrderDetails
                                                                  .routeName);
                                                    } else if (result
                                                            .statusCode ==
                                                        400) {
                                                      await showAlertDialog(
                                                          context,
                                                          message['message']
                                                              .toString(),
                                                          "Continue",
                                                          false);
                                                    } else if (result
                                                            .statusCode ==
                                                        500) {
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.blueAccent,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              1),
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                    minimumSize:
                                                        const Size(200, 50),
                                                  ),
                                                  child: const Text('Submit',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white)),
                                                ),
                                        ),
                                      ),

                                      /// CENTER
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: !manualOrder
                                              ? ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      manualOrder = true;
                                                      autoOrder = false;
                                                      isFileUploaded = false;
                                                    });
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        HexColor("#31007B"),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              1),
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                    minimumSize:
                                                        const Size(250, 50),
                                                  ),
                                                  child: const Text(
                                                    "Manually Add Order Materials",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                )
                                              : ElevatedButton(
                                                  onPressed: () async {
                                                    http.StreamedResponse
                                                        result = await provider
                                                            .processFormInfo(
                                                                jsonData,
                                                                manualOrder);
                                                    var message = jsonDecode(
                                                        await result.stream
                                                            .bytesToString());
                                                    if (result.statusCode ==
                                                        200) {
                                                      context
                                                          .pushReplacementNamed(
                                                              SalesOrderDetails
                                                                  .routeName);
                                                    } else if (result
                                                            .statusCode ==
                                                        400) {
                                                      await showAlertDialog(
                                                          context,
                                                          message['message']
                                                              .toString(),
                                                          "Continue",
                                                          false);
                                                    } else if (result
                                                            .statusCode ==
                                                        500) {
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.blueAccent,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              1),
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                    minimumSize:
                                                        const Size(200, 50),
                                                  ),
                                                  child: const Text('Submit',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white)),
                                                ),
                                        ),
                                      ),

                                      /// RIGHT
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: manualOrder
                                              ? ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      manualOrder = false;
                                                      autoOrder = true;
                                                    });
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        HexColor("#1B7B00"),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              1),
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                    minimumSize:
                                                        const Size(200, 50),
                                                  ),
                                                  child: const Text(
                                                    "Import Order Materials",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                )
                                              : SizedBox.shrink(),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Visibility(
                                  visible: manualOrder,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: DataTable(
                                        border: TableBorder.all(
                                            color: HexColor("#dee2e6")),
                                        columns: const [
                                          DataColumn(
                                              label: Text("Material No.",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text("Description",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text("Qty",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text("Rate",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text("Unit",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text("Amount",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text("Tax Rate",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text("GST Amount",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text("Total Amount",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text("Action",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        ],
                                        rows: materialList),
                                  ),
                                ),
                              ),
                            )
                          ],
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
                rowMap[headers[j]] = row[j]?.value.toString();
              } else {
                rowMap[headers[j]] = null; // Handle missing columns
              }
            }
            setState(() {
              // isFileUploaded = true;
              masterData.add(rowMap);
            });
          }
          GlobalVariables.requestBody[SalesOrderProvider.featureName] =
              masterData;
        }

        // CREATE MASTER DETAILS DATA

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
                rowMap[headers[j]] = row[j]?.value.toString();
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
      } else {
        showAlertDialog(context, "File selection canceled", "OKAY", false);
      }
    } catch (e) {
      showAlertDialog(context, "Unable to access file.", "OKAY", false);
    }
  }

  void groupMasterAndDetailsData() {
    Map<String, List<dynamic>> detailsMap = {};

    for (var item in masterDetailsData) {
      if (detailsMap.containsKey(item["No"])) {
        detailsMap[item["No"]]!.add(item);
      } else {
        detailsMap[item["No"]] = [item];
      }
    }

    List<Map<String, dynamic>> merged = [];
    for (var item in masterData) {
      item["SaleItemDetails"] = detailsMap[item["No"]];
      merged.add(item);
    }

    GlobalVariables.requestBody[SalesOrderProvider.featureName] = merged;
  }
}
