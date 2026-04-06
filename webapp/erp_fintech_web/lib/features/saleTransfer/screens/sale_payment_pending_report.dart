import 'dart:convert';

import 'package:fintech_new_web/features/payment/provider/payment_provider.dart';
import 'package:fintech_new_web/features/payment/screens/add_payment.dart';
import 'package:fintech_new_web/features/saleTransfer/provider/sale_transfer_provider.dart';
import 'package:fintech_new_web/features/saleTransfer/screens/add_sale_transfer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/global_variables.dart';

class SalePaymentPendingReport extends StatefulWidget {
  static String routeName = "salePaymentPendingReport";

  const SalePaymentPendingReport({super.key});

  @override
  State<SalePaymentPendingReport> createState() => _SalePaymentPendingReportState();
}

class _SalePaymentPendingReportState extends State<SalePaymentPendingReport> {
  @override
  void initState() {
    super.initState();
    SaleTransferProvider provider =
    Provider.of<SaleTransferProvider>(context, listen: false);
    provider.getBillPendingReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SaleTransferProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Payment Pending')),
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
                      rows: provider.paymentPending.map((data) {
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
                              context.pushNamed(AddSaleTransfer.routeName, queryParameters: {
                                "details" : jsonEncode(data)
                              });
                            },
                            child: const Text(
                              'Sale Transfer',
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
