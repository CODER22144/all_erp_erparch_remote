import 'dart:convert';

import 'package:fintech_new_web/features/billReceipt/provider/bill_receipt_provider.dart';
import 'package:fintech_new_web/features/billReceipt/screen/create_bill_receipt.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:hexcolor/hexcolor.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../inward/screens/inward.dart';
import '../../network/service/network_service.dart';
import 'br_info.dart';
import 'hyperlink.dart';

class BrReport extends StatefulWidget {
  static String routeName = "BrReport";

  const BrReport({super.key});

  @override
  State<BrReport> createState() => _BrReportState();
}

class _BrReportState extends State<BrReport> {
  @override
  void initState() {
    super.initState();
    BillReceiptProvider provider =
        Provider.of<BillReceiptProvider>(context, listen: false);
    provider.getBrReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BillReceiptProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'BR Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Visibility(
                  visible: provider.brReport.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      DataTable(
                        columns: [
                          const DataColumn(label: Text("")),
                          const DataColumn(label: Text("")),
                          const DataColumn(label: Text("")),
                          const DataColumn(label: Text("")),
                          const DataColumn(label: Text("")),
                          const DataColumn(label: Text("")),
                          const DataColumn(label: Text("")),
                          const DataColumn(label: Text("")),
                          DataColumn(
                              label: Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5)),
                                    color: Colors.green),
                                child: IconButton(
                                  icon: const Icon(Icons.add),
                                  color: Colors.white,
                                  tooltip: 'Add',
                                  onPressed: () {
                                    context
                                        .pushNamed(CreateBillReceipt.routeName);
                                  },
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5)),
                                    color: Colors.blue),
                                child: IconButton(
                                  icon: const Icon(Icons.exit_to_app_outlined),
                                  color: Colors.white,
                                  tooltip: 'Export',
                                  onPressed: () {
                                    downloadJsonToExcel(provider.brReport,
                                        "bill_receipt_export");
                                  },
                                ),
                              )
                            ],
                          )),
                        ],
                        rows: const [],
                      ),
                      DataTable(
                        columnSpacing: 23,
                        columns: const [
                          DataColumn(label: Text("Br Id")),
                          DataColumn(label: Text("Date")),
                          DataColumn(label: Text("Bill Type")),
                          DataColumn(label: Text("Party Name")),
                          DataColumn(label: Text("Bill No.")),
                          DataColumn(label: Text("Bill Date")),
                          DataColumn(label: Text("Bill Amount")),
                          DataColumn(label: Text("Transport Mode")),
                          DataColumn(label: Text("Eway Bill No.")),
                          DataColumn(label: Text("Carrier Name")),
                          DataColumn(label: Text("Vehicle No.")),
                          DataColumn(label: Text("DCGR No.")),
                          DataColumn(label: Text("DCGR Date")),
                          DataColumn(label: Text("No of Packet")),
                          DataColumn(label: Text("Pending")),
                          DataColumn(label: Text("Actions")),
                        ],
                        rows: provider.brReport.map((data) {
                          return DataRow(cells: [
                            DataCell(Hyperlink(
                                text: data['brId'].toString(),
                                url: data['docImage'] != null ||
                                        data['docImage'] != ""
                                    ? data['docImage']
                                    : "")),
                            DataCell(Text('${data['tranDate'] ?? "-"}')),
                            DataCell(Text('${data['btDescription'] ?? "-"}')),
                            DataCell(Text('${data['bpName'] ?? "-"}')),
                            DataCell(Text('${data['billNo'] ?? "-"}')),
                            DataCell(Text('${data['billDate'] ?? "-"}')),
                            DataCell(Align(
                                alignment: Alignment.centerRight,
                                child: Text(parseDoubleUpto2Decimal(
                                    data['billAmount'])))),
                            DataCell(
                                Text('${data['transDescription'] ?? "-"}')),
                            DataCell(Text('${data['ewaybillno'] ?? "-"}')),
                            DataCell(Text('${data['carrierName'] ?? "-"}')),
                            DataCell(Text('${data['vehicleNo'] ?? "-"}')),
                            DataCell(Text('${data['dcgrNo'] ?? "-"}')),
                            DataCell(Text('${data['dcgrDate'] ?? "-"}')),
                            DataCell(Text('${data['nopkt'] ?? "-"}')),
                            DataCell(ElevatedButton(
                                onPressed: () {
                                  context.pushNamed(InwardDetails.routeName,
                                      queryParameters: {
                                        "brDetails": jsonEncode(data)
                                      });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor("#0038a8"),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        5), // Square shape
                                  ),
                                  padding: EdgeInsets
                                      .zero, // Remove internal padding to make it square
                                  minimumSize: const Size(80,
                                      50), // Width and height for the button
                                ),
                                child: const Text(
                                  "Post Bill",
                                  style: TextStyle(color: Colors.white),
                                ))),
                            DataCell(Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5)),
                                        color: Colors.green),
                                    child: IconButton(
                                      icon: const Icon(Icons.info_outline),
                                      color: Colors.white,
                                      tooltip: 'Info',
                                      onPressed: () {
                                        provider.editBrController.text =
                                            '${data['brId']}';
                                        context.pushNamed(BrInfo.routeName);
                                      },
                                    ),
                                  ),
                                  Container(
                                    color: Colors.blue,
                                    child: IconButton(
                                      icon: const Icon(Icons.edit),
                                      color: Colors.white,
                                      tooltip: 'Update',
                                      onPressed: () {
                                        provider.editBrController.text =
                                            '${data['brId']}';
                                        context.pushNamed(
                                            CreateBillReceipt.routeName,
                                            queryParameters: {
                                              "editing": 'true'
                                            });
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(5),
                                            bottomRight: Radius.circular(5)),
                                        color: Colors.red),
                                    child: IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: Colors.white,
                                      tooltip: 'Delete',
                                      onPressed: () async {
                                        bool confirmation =
                                            await showConfirmationDialogue(
                                                context,
                                                "Are you sure you want to delete this Bill Receipt?",
                                                "SUBMIT",
                                                "CANCEL");
                                        if (confirmation) {
                                          NetworkService networkService =
                                              NetworkService();
                                          http.StreamedResponse response =
                                              await networkService.post(
                                                  "/delete-br/${data['brId']}/",
                                                  {});
                                          if (response.statusCode == 204) {
                                            provider.getBrReport();
                                          } else if (response.statusCode ==
                                              400) {
                                            var message = jsonDecode(
                                                await response.stream
                                                    .bytesToString());
                                            await showAlertDialog(
                                                context,
                                                message['message'].toString(),
                                                "Continue",
                                                false);
                                          } else if (response.statusCode ==
                                              500) {
                                            var message = jsonDecode(
                                                await response.stream
                                                    .bytesToString());
                                            await showAlertDialog(
                                                context,
                                                message['message'],
                                                "Continue",
                                                false);
                                          } else {
                                            var message = jsonDecode(
                                                await response.stream
                                                    .bytesToString());
                                            await showAlertDialog(
                                                context,
                                                message['message'],
                                                "Continue",
                                                false);
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ]);
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )),
      );
    });
  }
}
