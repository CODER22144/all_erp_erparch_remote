import 'dart:convert';

import 'package:fintech_new_web/features/purchaseTransfer/provider/purchase_transfer_provider.dart';
import 'package:fintech_new_web/features/purchaseTransfer/screens/add_purchase_transfer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/global_variables.dart';

class PurchaseBillPendingReport extends StatefulWidget {
  static String routeName = "purchaseBillPendingReport";

  const PurchaseBillPendingReport({super.key});

  @override
  State<PurchaseBillPendingReport> createState() => _PurchaseBillPendingReportState();
}

class _PurchaseBillPendingReportState extends State<PurchaseBillPendingReport> {
  @override
  void initState() {
    super.initState();
    PurchaseTransferProvider provider =
    Provider.of<PurchaseTransferProvider>(context, listen: false);
    provider.getBillPendingReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PurchaseTransferProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Bill Pending Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Tran Id")),
                        DataColumn(label: Text("Date")),
                        DataColumn(label: Text("Voucher\nType")),
                        DataColumn(label: Text("Party Code")),
                        DataColumn(label: Text("Party Name")),
                        DataColumn(label: Text("Bill No.")),
                        DataColumn(label: Text("Bill Date")),
                        DataColumn(label: Text("Amount")),
                        DataColumn(label: Text("Pay\nAmount")),
                        DataColumn(label: Text("Balance\nAmount")),
                        DataColumn(label: Text("")),
                      ],
                      rows: provider.billPending.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['transId'] ?? "-"}')),
                          DataCell(Text('${data['dDate'] ?? "-"}')),
                          DataCell(Text('${data['vtype'] ?? "-"}')),
                          DataCell(Text('${data['lcode'] ?? "-"}')),
                          DataCell(Text('${data['lName'] ?? "-"}')),
                          DataCell(Text('${data['billNo'] ?? ""}')),
                          DataCell(Text('${data['billDate'] ?? ""}')),
                          DataCell(Text('${data['amount'] ?? "-"}')),
                          DataCell(Text('${data['payamount'] ?? "-"}')),
                          DataCell(Text('${data['bamount'] ?? "-"}')),
                          DataCell(ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                            onPressed: () async {
                              context.pushNamed(AddPurchaseTransfer.routeName, queryParameters: {
                                "details" : jsonEncode(data)
                              });
                            },
                            child: const Text(
                              'Purchase Transfer',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            )),
      );
    });
  }

  void _showTablePopup(BuildContext context, List<dynamic> orderBalance) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bill Clearance Details',
              style: TextStyle(fontWeight: FontWeight.w500)),
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
                      DataColumn(label: Text('Trans Id')),
                      DataColumn(label: Text('Voucher Type')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('Naration'))
                    ],
                    rows: orderBalance.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['transId'] ?? "-"}')),
                        DataCell(Text('${data['vtype'] ?? "-"}')),
                        DataCell(Align(alignment: Alignment.centerRight,child: Text('${data['amount'] ?? "-"}'))),
                        DataCell(Text('${data['clnaration'] ?? "-"}')),
                      ]);
                    }).toList(),
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
              ],
            )
          ],
        );
      },
    );
  }
}
