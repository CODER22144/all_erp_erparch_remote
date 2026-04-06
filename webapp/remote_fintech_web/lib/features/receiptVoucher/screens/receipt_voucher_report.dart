import 'dart:convert';

import 'package:fintech_new_web/features/ledgerCodes/provider/ledger_codes_provider.dart';
import 'package:fintech_new_web/features/ledgerCodes/screen/ledger_codes.dart';
import 'package:fintech_new_web/features/ledgerCodes/screen/ledger_details_page.dart';
import 'package:fintech_new_web/features/paymentVoucher/provider/payment_voucher_provider.dart';
import 'package:fintech_new_web/features/paymentVoucher/screens/create_payment_voucher.dart';
import 'package:fintech_new_web/features/paymentVoucher/screens/payment_voucher_info.dart';
import 'package:fintech_new_web/features/receiptVoucher/provider/receipt_voucher_provider.dart';
import 'package:fintech_new_web/features/receiptVoucher/screens/create_receipt_voucher.dart';
import 'package:fintech_new_web/features/receiptVoucher/screens/receipt_voucher_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';

class ReceiptVoucherReport extends StatefulWidget {
  static String routeName = "ReceiptVoucherReport";

  const ReceiptVoucherReport({super.key});

  @override
  State<ReceiptVoucherReport> createState() => _ReceiptVoucherReportState();
}

class _ReceiptVoucherReportState extends State<ReceiptVoucherReport> {
  @override
  void initState() {
    super.initState();
    ReceiptVoucherProvider provider =
    Provider.of<ReceiptVoucherProvider>(context, listen: false);
    provider.getPaymentVoucherReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReceiptVoucherProvider>(
        builder: (context, provider, child) {
          return Material(
            child: SafeArea(
                child: Scaffold(
                  appBar: PreferredSize(
                      preferredSize:
                      Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                      child: const CommonAppbar(title: 'Receipt Voucher Report')),
                  body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
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
                                              context.pushNamed(
                                                  CreateReceiptVoucher.routeName);
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
                                              downloadJsonToExcel(
                                                  provider.paymentVoucherRep,
                                                  "receipt_voucher_export");
                                            },
                                          ),
                                        )
                                      ],
                                    )),
                              ],
                              rows: const [],
                            ),
                            DataTable(
                              columnSpacing: 30,
                              columns: const [
                                DataColumn(label: Text("Voucher No. & Date", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("Party Name", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("Naration", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("HSN Code", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("Ass Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("GST Rate", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("GST Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("Mode Of Payment", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("Pay. Ref No.", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text("Actions",
                                        style: TextStyle(fontWeight: FontWeight.bold))),
                              ],
                              rows: provider.paymentVoucherRep.map((data) {
                                return DataRow(cells: [
                                  DataCell(Text('${data['No'] ?? "-"}\n${data['Dt'] ?? "-"}')),
                                  DataCell(Text('${data['lcode'] ?? "-"}')),
                                  DataCell(Text('${data['naration'] ?? "-"}')),
                                  DataCell(Text('${data['hsnCode'] ?? "-"}')),
                                  DataCell(Text('${data['AssAmt'] ?? "-"}')),
                                  DataCell(Text('${data['GstRt'] ?? "-"}')),
                                  DataCell(Text('${data['gstAmount'] ?? "-"}')),
                                  DataCell(Text('${data['mop'] ?? "-"}')),
                                  DataCell(Text('${data['payRefno'] ?? "-"}')),
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
                                              provider.editController.text = '${data['No']}';
                                              context.pushNamed(ReceiptVoucherInfo.routeName);
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
                                              provider.editController.text =
                                              '${data['No']}';
                                              context.pushNamed(
                                                  CreateReceiptVoucher.routeName,
                                                  queryParameters: {
                                                    "editing": 'true',
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
                                                  "Are you sure you want to delete this Receipt?",
                                                  "SUBMIT",
                                                  "CANCEL");
                                              if (confirmation) {
                                                NetworkService networkService =
                                                NetworkService();
                                                http.StreamedResponse response =
                                                await networkService.post(
                                                    "/delete-receipt-voucher/",
                                                    {"No": '${data['No']}'});
                                                if (response.statusCode == 204) {
                                                  provider.getPaymentVoucherReport();
                                                } else if (response.statusCode == 400) {
                                                  var message = jsonDecode(
                                                      await response.stream
                                                          .bytesToString());
                                                  await showAlertDialog(
                                                      context,
                                                      message['message'].toString(),
                                                      "Continue",
                                                      false);
                                                } else if (response.statusCode == 500) {
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
                )),
          );
        });
  }
}
