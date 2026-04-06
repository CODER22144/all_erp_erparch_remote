// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:intl/intl.dart';
import 'package:fintech_new_web/features/purchaseOrder/provider/purchase_order_provider.dart';
import 'package:fintech_new_web/features/purchaseOrder/screen/purchase_order_row_fields.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
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

class PurchaseOrderScreen extends StatefulWidget {
  static String routeName = "/purchaseOrder";

  const PurchaseOrderScreen({super.key});
  @override
  PurchaseOrderScreenState createState() => PurchaseOrderScreenState();
}

class PurchaseOrderScreenState extends State<PurchaseOrderScreen>
    with SingleTickerProviderStateMixin {
  List<List<String>> tableRows = [];
  var formKey = GlobalKey<FormState>();
  late TabController tabController;

  bool manualOrder = true;
  bool autoOrder = false;
  bool isFileUploaded = false;

  List<Map<String, dynamic>> jsonData = [];
  late PurchaseOrderProvider provider;

  double qtySum = 0;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<PurchaseOrderProvider>(context, listen: false);
    provider.initWidget();
    // Add one empty row at the beginning
    tableRows.add(['', '', '', '', '']);
    tabController = TabController(length: 2, vsync: this);
    provider.getAllPriority();
    provider.getAllPoType();
  }

  void totalQty(String qty) {
    setState(() {
      qtySum += parseEmptyStringToDouble(qty);
    });
  }

  void subTotalQty(String qty) {
    setState(() {
      qtySum -= parseEmptyStringToDouble(qty);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  // Function to add a new row
  void addRow() {
    setState(() {
      tableRows.add(['', '', '', '', '']);
    });
    provider.addRowController();
  }

  // Function to delete a row
  void deleteRow(int index) {
    setState(() {
      tableRows.removeAt(index);
    });
    provider.deleteRowController(index);
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
          GlobalVariables.requestBody[PurchaseOrderProvider.featureName]
              ['PurchaseOrderDetails'] = jsonData;
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
    return Consumer<PurchaseOrderProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Purchase Order')),
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
                                          backgroundColor: HexColor("#1abc9c"),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)))),
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          tabController.animateTo(1);
                                        }
                                      },
                                      child: const Text('Next ->',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
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
                                          borderRadius: BorderRadius.circular(
                                              1), // Square shape
                                        ),
                                        padding: EdgeInsets.zero,
                                        // Remove internal padding to make it square
                                        minimumSize: const Size(100,
                                            50), // Width and height for the button
                                      ),
                                      onPressed: () async {
                                        http.StreamedResponse result =
                                            await provider.processFormInfo(
                                                tableRows, manualOrder);
                                        var message = jsonDecode(await result
                                            .stream
                                            .bytesToString());
                                        if (result.statusCode == 200) {
                                          context.pushReplacementNamed(
                                              PurchaseOrderScreen.routeName);
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
                                        'Submit PO',
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
                                      padding: const EdgeInsets.only(
                                          top: 8, right: 10),
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
                                          "Import Materials",
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
                                          "Manually Add Materials",
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
                                        child: Text("Material No.", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 100,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(" Quantity", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 100,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text("Rate", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: GlobalVariables.deviceWidth * 0.09,
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text("HSN Code", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: GlobalVariables.deviceWidth * 0.08,
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text("Delivery Date", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: GlobalVariables.deviceWidth * 0.08,
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text("PO Type", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: GlobalVariables.deviceWidth * 0.08,
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text("Priority", style: TextStyle(fontWeight: FontWeight.bold)),
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
                                  child: PurchaseOrderRowFields(
                                      subTotalQty: subTotalQty,
                                      totalQty: totalQty,
                                      addRow: addRow,
                                      controllers: provider.rowControllers,
                                      poType: provider.poType,
                                      priority: provider.priorities,
                                      index: i,
                                      tableRows: tableRows,
                                      deleteRow: deleteRow),
                                ),

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
                                        child: Text("GRAND TOTAL", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(" $qtySum", style: const TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 100,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(""),
                                      ),
                                    ),
                                    SizedBox(
                                      width: GlobalVariables.deviceWidth * 0.09,
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(""),
                                      ),
                                    ),
                                    SizedBox(
                                      width: GlobalVariables.deviceWidth * 0.08,
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(""),
                                      ),
                                    ),
                                    SizedBox(
                                      width: GlobalVariables.deviceWidth * 0.08,
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(""),
                                      ),
                                    ),
                                    SizedBox(
                                      width: GlobalVariables.deviceWidth * 0.08,
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(""),
                                      ),
                                    ),
                                    Container(
                                        width: GlobalVariables.deviceWidth * 0.03,
                                        height: GlobalVariables.deviceWidth * 0.03,
                                        margin: const EdgeInsets.only(right: 5),
                                        color: Colors.transparent,
                                        child: const SizedBox())
                                  ],
                                ),
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
                                        final Uri uri = Uri.parse(
                                            "https://docs.google.com/spreadsheets/d/1tWzfqd1aglZQPMMIGHEqMbkZQVVOcn1d55Zj1g3HMK4/edit?usp=sharing");
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri,
                                              mode:
                                                  LaunchMode.inAppBrowserView);
                                        } else {
                                          throw 'Could not launch';
                                        }
                                      },
                                    ),
                                  )),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .start, // Space buttons evenly

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
                  ]))
            ],
          ),
        ),
      );
    });
  }
}
