// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io' as io;

import 'package:fintech_new_web/features/gr/screen/gr_details_row_field.dart';
import 'package:fintech_new_web/features/network/service/network_service.dart';
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

import '../../billReceipt/provider/bill_receipt_provider.dart';
import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../utility/services/common_utility.dart';
import '../provider/gr_provider.dart';
import 'dart:ui_web' as ui;
import 'dart:html';


class GrDetails extends StatefulWidget {
  static String routeName = "/grDetails";
  final dynamic brDetails;

  const GrDetails({super.key, required this.brDetails});

  @override
  GrDetailsState createState() => GrDetailsState();
}

class GrDetailsState extends State<GrDetails>
    with SingleTickerProviderStateMixin {
  bool manualOrder = true;
  bool autoOrder = false;
  bool isFileUploaded = false;

  List<Map<String, dynamic>> jsonData = [];

  List<List<String>> tableRows = [];
  var formKey = GlobalKey<FormState>();
  late TabController tabController;

  late GrProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<GrProvider>(context, listen: false);
    provider.initWidget(widget.brDetails);
    // Add one empty row at the beginning
    tableRows.add(['', '', '', '', '', '']);
    tabController = TabController(length: 2, vsync: this);
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
    provider.addRowController();
  }

  // Function to delete a row
  void deleteRow(int index) {
    setState(() {
      tableRows.removeAt(index);
    });
    provider.deleteRowController(index);
  }

  Widget pdfIframeView(String pdfUrl) {
    final viewType = 'pdf-iframe-${pdfUrl.hashCode}';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      viewType,
          (int viewId) => IFrameElement()
        ..src = pdfUrl
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%',
    );

    return HtmlElementView(viewType: viewType);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GrProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Goods Receipt')),
        body: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Column(
                  children: [
                    TabBar(controller: tabController, tabs: const [
                      Tab(text: "GR"),
                      Tab(text: "Details"),
                    ]),
                    Expanded(
                        child: TabBarView(controller: tabController, children: [
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
                                width: kIsWeb
                                    ? GlobalVariables.deviceWidth / 2
                                    : GlobalVariables.deviceWidth,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    const SizedBox(height: 10),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Visibility(
                                          visible: manualOrder,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8, right: 10),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blueAccent,
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
                                                backgroundColor: Colors.blueAccent,
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
                                                  tableRows.clear();
                                                  tableRows.add(['', '', '', '', '', '']);
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
                                        child: InkWell(
                                          child: const Text(
                                            "Click to View file format for Import",
                                            style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          onTap: () async {
                                            final Uri uri = Uri.parse(
                                                "https://docs.google.com/spreadsheets/d/1jsILum2njP8jzVwdwtSXIRMO01bVlLBPXBVqCwB_u4c/edit?usp=sharing");
                                            if (await canLaunchUrl(uri)) {
                                              await launchUrl(uri,
                                                  mode: LaunchMode.inAppBrowserView);
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
                                    for (int i = 0; i < tableRows.length; i++)
                                      Visibility(
                                        visible: manualOrder,
                                        child: GrDetailsRowField(
                                            controllers: provider.rowControllers,
                                            index: i,
                                            tableRows: tableRows,
                                            validOrder: provider.dropdownItem,
                                            deleteRow: deleteRow),
                                      ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly, // Space buttons evenly
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: HexColor("#0B6EFE"),
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(5)))),
                                          onPressed: () {
                                            _showTablePopup(context, provider);
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
            ),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: pdfIframeView('${NetworkService.baseUrl}${jsonDecode(widget.brDetails)['docImage']}'),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showTablePopup(BuildContext context, GrProvider provider) {
    BillReceiptProvider brProvider =
    Provider.of<BillReceiptProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('GR Summary', style: TextStyle(fontWeight: FontWeight.w500)),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('BR No.')),
                      DataColumn(label: Text('Inventory Type')),
                      DataColumn(label: Text('Business Partner Code'))
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text(
                            "${GlobalVariables.requestBody[GrProvider.featureName]['grDate'] ?? '-'}")),
                        DataCell(Text(
                            "${GlobalVariables.requestBody[GrProvider.featureName]['brid'] ?? '-'}")),
                        DataCell(Text(
                            "${GlobalVariables.requestBody[GrProvider.featureName]['it'] ?? 'Inventory Item'}")),
                        DataCell(Text(
                            "${GlobalVariables.requestBody[GrProvider.featureName]['bpCode'] ?? '-'}")),
                      ]),
                    ],
                  ),
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('Material No.')),
                      DataColumn(label: Text('Order ID')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Rate')),
                      DataColumn(label: Text('HSN Code'))
                    ],
                    rows: _getRows(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    {
                      http.StreamedResponse result =
                      await provider.processFormInfo(tableRows, manualOrder);
                      var message =
                      jsonDecode(await result.stream.bytesToString());
                      if (result.statusCode == 200) {
                        brProvider.getPostedBillReceipt();
                        context.pop();
                        context.pop();
                      } else if (result.statusCode == 400) {
                        await showAlertDialog(context,
                            message['message'].toString(), "Continue", false);
                      } else if (result.statusCode == 500) {
                        await showAlertDialog(
                            context, message['message'], "Continue", false);
                      } else {
                        await showAlertDialog(
                            context, message['message'], "Continue", false);
                      }
                    }
                  },
                  child: Container(
                    key: const Key('TestConfirmBtnPopup'),
                    margin: const EdgeInsets.only(left: 5),
                    width: GlobalVariables.deviceWidth * 0.25,
                    height: GlobalVariables.deviceHeight * 0.05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: GlobalVariables.themeColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          offset: Offset(
                            2,
                            3,
                          ),
                        )
                      ],
                    ),
                    child: const Text(
                      key: Key('TestConfirmOrderFeedbackBtn'),
                      "SUBMIT",
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ),
                SizedBox(
                  width: GlobalVariables.deviceWidth * 0.01,
                ),
                InkWell(
                  onTap: () {
                    // Navigator.pop(context, false);
                    Navigator.of(context, rootNavigator: true).pop(false);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 5),
                    width: GlobalVariables.deviceWidth * 0.15,
                    height: GlobalVariables.deviceHeight * 0.05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: HexColor("#e0e0e0"),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          offset: Offset(
                            2,
                            3,
                          ),
                        )
                      ],
                    ),
                    child: const Text("CLOSE",
                        style: TextStyle(fontSize: 11, color: Colors.black)),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  List<DataRow> _getRows() {
    List<DataRow> rows = [];
    List<String> summedUpRow = ['', '', '', '0', '0', ''];

    for (var data in tableRows) {
      rows.add(DataRow(cells: [
        DataCell(Text(data[0])),
        DataCell(Text(data[1])),
        DataCell(Text(data[2])),
        DataCell(Text(data[3])),
        DataCell(Text(data[4])),
      ]));

      summedUpRow = [
        'Total',
        '',
        '${parseEmptyStringToDouble(summedUpRow[2]) + parseEmptyStringToDouble(data[2])}',
        '',
        '',
      ];
    }

    rows.add(DataRow(cells: [
      DataCell(Text(summedUpRow[0])),
      DataCell(Text(summedUpRow[1])),
      DataCell(Text(summedUpRow[2])),
      DataCell(Text(summedUpRow[3])),
      DataCell(Text(summedUpRow[4]))
    ]));


    return rows;
  }

  void _importExcel() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        // Use the bytes directly if the path is null
        final bytes = result.files.single.bytes ??
            io.File(result.files.single.path!).readAsBytesSync();
        var excel = exl.Excel.decodeBytes(bytes);

        var sheet = excel.tables.values.first;

        if (sheet != null) {
          // Get the first row as headers
          List<String> headers = sheet.rows.first
              .map((cell) => cell?.value?.toString() ?? '')
              .toList();

          // Iterate over remaining rows and map them to headers
          jsonData.clear();
          tableRows.clear();
          for (int i = 1; i < sheet.rows.length; i++) {
            var row = sheet.rows[i];
            Map<String, dynamic> rowMap = {};
            List<String> stringRow = [];

            for (int j = 0; j < headers.length; j++) {
              if (j < row.length) {
                rowMap[headers[j]] = row[j]?.value.toString();
                stringRow.add(row[j]!.value.toString());
              } else {
                rowMap[headers[j]] = null; // Handle missing columns
                stringRow.add("");
              }
            }
            setState(() {
              isFileUploaded = true;
              jsonData.add(rowMap);
            });

            tableRows.add(stringRow);
          }
          GlobalVariables.requestBody[GrProvider.featureName]
          ['GrDetails'] = jsonData;
        }
      } else {
        showAlertDialog(context, "File selection canceled", "OKAY", false);
      }
    } catch (e) {
      showAlertDialog(context, "Unable to access file.", "OKAY", false);
    }
  }
}
