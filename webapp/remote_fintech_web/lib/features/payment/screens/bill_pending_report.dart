import 'dart:convert';

import 'package:fintech_new_web/features/payment/provider/payment_provider.dart';
import 'package:fintech_new_web/features/payment/screens/add_payment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/global_variables.dart';
import '../../utility/services/common_utility.dart';

class BillPendingReport extends StatefulWidget {
  static String routeName = "billPendingReport";

  const BillPendingReport({super.key});

  @override
  State<BillPendingReport> createState() => _BillPendingReportState();
}

class _BillPendingReportState extends State<BillPendingReport> {
  @override
  void initState() {
    super.initState();
    PaymentProvider provider =
        Provider.of<PaymentProvider>(context, listen: false);
    provider.getBillPendingReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Bill Pending')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        downloadJsonToExcel(
                            provider.billPending, "bill_pending_export");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1),
                        ),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(200, 50),
                      ),
                      child: const Text('Export',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                    const SizedBox(height: 10),
                    DataTable(
                      columnSpacing: 20,
                      columns: const [
                        DataColumn(
                            label: Text("ID",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Bill No.",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Bill Date",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("VT",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Days",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("TDS",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Amount",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Paid",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Balance",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Total Balance",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: provider.billRows,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )),
      );
    });
  }

  // void _showTablePopup(BuildContext context, List<dynamic> orderBalance) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Bill Clearance Details',
  //             style: TextStyle(fontWeight: FontWeight.w500)),
  //         content: SingleChildScrollView(
  //           scrollDirection: Axis.horizontal,
  //           child: SingleChildScrollView(
  //             scrollDirection: Axis.vertical,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 DataTable(
  //                   columns: const [
  //                     DataColumn(label: Text('Trans Id')),
  //                     DataColumn(label: Text('Voucher Type')),
  //                     DataColumn(label: Text('Amount')),
  //                     DataColumn(label: Text('Naration'))
  //                   ],
  //                   rows: orderBalance.map((data) {
  //                     return DataRow(cells: [
  //                       DataCell(Text('${data['transId'] ?? "-"}')),
  //                       DataCell(Text('${data['vtype'] ?? "-"}')),
  //                       DataCell(Align(
  //                           alignment: Alignment.centerRight,
  //                           child: Text('${data['amount'] ?? "-"}'))),
  //                       DataCell(Text('${data['clnaration'] ?? "-"}')),
  //                     ]);
  //                   }).toList(),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         actions: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               InkWell(
  //                 onTap: () {
  //                   // Navigator.pop(context, false);
  //                   Navigator.of(context, rootNavigator: true).pop(false);
  //                 },
  //                 child: Container(
  //                   margin: const EdgeInsets.only(right: 5),
  //                   width: GlobalVariables.deviceWidth * 0.15,
  //                   height: GlobalVariables.deviceHeight * 0.05,
  //                   alignment: Alignment.center,
  //                   decoration: BoxDecoration(
  //                     color: HexColor("#e0e0e0"),
  //                     borderRadius: BorderRadius.circular(20),
  //                     boxShadow: const [
  //                       BoxShadow(
  //                         color: Colors.grey,
  //                         blurRadius: 2,
  //                         offset: Offset(
  //                           2,
  //                           3,
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                   child: const Text("CLOSE",
  //                       style: TextStyle(fontSize: 11, color: Colors.black)),
  //                 ),
  //               ),
  //             ],
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }
}
