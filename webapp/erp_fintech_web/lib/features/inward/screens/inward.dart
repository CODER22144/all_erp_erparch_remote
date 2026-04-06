// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/billReceipt/screen/hyperlink.dart';
import 'package:fintech_new_web/features/gr/provider/gr_provider.dart';
import 'package:fintech_new_web/features/inward/provider/inward_provider.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../camera/widgets/camera_widget.dart';
import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../home.dart';
import '../../network/service/network_service.dart';
import 'inward_row_fields.dart';

class InwardDetails extends StatefulWidget {
  static String routeName = "/inward";

  final dynamic grDetails;
  String? disable;
  InwardDetails(
      {super.key, this.grDetails, this.disable});

  @override
  InwardDetailsState createState() => InwardDetailsState();
}

class InwardDetailsState extends State<InwardDetails>
    with SingleTickerProviderStateMixin {
  List<List<String>> tableRows = [];
  var formKey = GlobalKey<FormState>();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    InwardProvider provider =
        Provider.of<InwardProvider>(context, listen: false);
    provider.initWidget(widget.grDetails, widget.disable!);
    // Add one empty row at the beginning
    tableRows = provider.rowField;
    tabController = TabController(length: 2, vsync: this);
    provider.getDiscountType();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  // Function to add a new row
  void addRow() {
    setState(() {
      tableRows.add(['', '', '', '', '', '0', 'N', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0']);
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
    return Consumer<InwardProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Inward Details')),
        body: Center(
          child: Column(
            children: [
              TabBar(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  isScrollable: false,
                  tabs: const [
                    Tab(text: "Inward"),
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
                                    visible: false,
                                    child: CameraWidget(
                                        setImagePath: provider.setImagePath,
                                        showCamera: !kIsWeb)),
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
                            children: [
                              const SizedBox(height: 10),
                              for (int i = 0; i < tableRows.length; i++)
                                InwardRowFields(
                                    index: i,
                                    tableRows: tableRows,
                                    discountType: provider.discountType,
                                    deleteRow: deleteRow),
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
                                  ElevatedButton(
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

  void _showTablePopup(BuildContext context, InwardProvider provider) {

    GrProvider grProvider =
    Provider.of<GrProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Inward Summary', style: TextStyle(fontWeight: FontWeight.w500)),
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
                      DataColumn(label: Text('GR No.')),
                      DataColumn(label: Text('Party Code')),
                      DataColumn(label: Text('Bill No.')),
                      DataColumn(label: Text('Bill Date')),
                      DataColumn(label: Text('TCS')),
                      DataColumn(label: Text('Debit Code')),
                      DataColumn(label: Text('Supply Type')),
                      DataColumn(label: Text('Supplier Type')),
                      DataColumn(label: Text('Reverse Charge')),
                      DataColumn(label: Text('TDS Code')),
                      DataColumn(label: Text('TDS Rate')),
                      DataColumn(label: Text('Document')),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text(
                            "${GlobalVariables.requestBody[InwardProvider.featureName]['transDate'] ?? '-'}")),
                        DataCell(Text(
                            "${GlobalVariables.requestBody[InwardProvider.featureName]['brId'] ?? '-'}")),
                        DataCell(Text(
                            "${GlobalVariables.requestBody[InwardProvider.featureName]['grno'] ?? '-'}")),
                        DataCell(Text(
                            "${GlobalVariables.requestBody[InwardProvider.featureName]['lcode'] ?? '-'}")),
                        DataCell(Text(
                            "${GlobalVariables.requestBody[InwardProvider.featureName]['billNo'] ?? '-'}")),
                        DataCell(Text(
                            "${GlobalVariables.requestBody[InwardProvider.featureName]['billDate'] ?? '-'}")),
                        DataCell(Text(
                            "${GlobalVariables.requestBody[InwardProvider.featureName]['tcs'] ?? '-'}")),
                        DataCell(Text(
                            "${GlobalVariables.requestBody[InwardProvider.featureName]['dbCode'] ?? '-'}")),
                        DataCell(Text(
                            "${GlobalVariables.requestBody[InwardProvider.featureName]['slId'] ?? '-'}")),
                        DataCell(Text(
                            "${GlobalVariables.requestBody[InwardProvider.featureName]['stId'] ?? '-'}")),
                        DataCell(Text(
                            "${GlobalVariables.requestBody[InwardProvider.featureName]['rc'] ?? '-'}")),
                        DataCell(Text(
                            "${GlobalVariables.requestBody[InwardProvider.featureName]['tdsCode'] ?? '-'}")),
                        DataCell(Text(
                            "${GlobalVariables.requestBody[InwardProvider.featureName]['rtds'] ?? '-'}")),
                        DataCell(GlobalVariables
                                        .requestBody[InwardProvider.featureName]
                                    ['DocProof'] !=
                                null
                            ? Hyperlink(
                                text: "File",
                                url:
                                    "${GlobalVariables.requestBody[InwardProvider.featureName]['DocProof'] ?? ''}")
                            : const Text("-")),
                      ])
                    ],
                  ),
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('Material No.')),
                      DataColumn(label: Text('Material Description')),
                      DataColumn(label: Text('Hsn Code')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Rate')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('Discount Type')),
                      DataColumn(label: Text('Discount (%)')),
                      DataColumn(label: Text('Discount Amount')),
                      DataColumn(label: Text('BCD')),
                      DataColumn(label: Text('Round Off.')),
                      DataColumn(label: Text('Cess Rate')),
                      DataColumn(label: Text('Cess Amount')),
                      DataColumn(label: Text('GST Tax Rate')),
                      DataColumn(label: Text('GST Amount')),
                      DataColumn(label: Text('TCS Amount')),
                      DataColumn(label: Text('Total Amount')),
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
                SizedBox(
                  width: GlobalVariables.deviceWidth * 0.01,
                ),
                InkWell(
                  onTap: () async {
                    {
                      http.StreamedResponse result =
                          await provider.processFormInfo(tableRows);
                      var message =
                          jsonDecode(await result.stream.bytesToString());
                      if (result.statusCode == 200) {
                        grProvider.getPendingGr();
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
              ],
            )
          ],
        );
      },
    );
  }

  List<DataRow> _getRows() {
    List<DataRow> rows = [];
    List<String> summedUpRow = [
      '',
      '',
      '',
      '0',
      '0',
      '0',
      'N',
      '0',
      '0',
      '0',
      '0',
      '0',
      '0',
      '0',
      '0',
      '0',
      '0'
    ];

    for (var data in tableRows) {
      rows.add(DataRow(cells: [
        DataCell(Text(data[1])),
        DataCell(Text(data[0])),
        DataCell(Text(data[2])),
        DataCell(Text(data[3])),
        DataCell(Text(data[4])),
        DataCell(Text(data[5])),
        DataCell(Text(data[6])),
        DataCell(Text(data[7])),
        DataCell(Text(data[8])),
        DataCell(Text(data[9])),
        DataCell(Text(data[10])),
        DataCell(Text(data[11])),
        DataCell(Text(data[12])),
        DataCell(Text(data[13])),
        DataCell(Text(data[14])),
        DataCell(Text(data[15])),
        DataCell(Text(data[16])),
      ]));

      summedUpRow = [
        'Total',
        '',
        '',
        '${parseEmptyStringToDouble(summedUpRow[3]) + parseEmptyStringToDouble(data[3])}',
        '',
        '${parseEmptyStringToDouble(summedUpRow[5]) + parseEmptyStringToDouble(data[5])}',
        '',
        '',
        '${parseEmptyStringToDouble(summedUpRow[8]) + parseEmptyStringToDouble(data[8])}',
        '${parseEmptyStringToDouble(summedUpRow[9]) + parseEmptyStringToDouble(data[9])}',
        '${parseEmptyStringToDouble(summedUpRow[10]) + parseEmptyStringToDouble(data[10])}',
        '',
        '${parseEmptyStringToDouble(summedUpRow[12]) + parseEmptyStringToDouble(data[12])}',
        '',
        '${parseEmptyStringToDouble(summedUpRow[14]) + parseEmptyStringToDouble(data[14])}',
        '${parseEmptyStringToDouble(summedUpRow[15]) + parseEmptyStringToDouble(data[15])}',
        '${parseEmptyStringToDouble(summedUpRow[16]) + parseEmptyStringToDouble(data[16])}',
      ];
    }

      rows.add(DataRow(cells: [
        DataCell(Text(summedUpRow[1])),
        DataCell(Text(summedUpRow[0])),
        DataCell(Text(summedUpRow[2])),
        DataCell(Text(summedUpRow[3])),
        DataCell(Text(summedUpRow[4])),
        DataCell(Text(summedUpRow[5])),
        DataCell(Text(summedUpRow[6])),
        DataCell(Text(summedUpRow[7])),
        DataCell(Text(summedUpRow[8])),
        DataCell(Text(summedUpRow[9])),
        DataCell(Text(summedUpRow[10])),
        DataCell(Text(summedUpRow[11])),
        DataCell(Text(summedUpRow[12])),
        DataCell(Text(summedUpRow[13])),
        DataCell(Text(summedUpRow[14])),
        DataCell(Text(summedUpRow[15])),
        DataCell(Text(summedUpRow[16])),
      ]));


    return rows;
  }
}
