import 'dart:convert';

import 'package:fintech_new_web/features/ledgerCodes/provider/ledger_codes_provider.dart';
import 'package:fintech_new_web/features/ledgerCodes/screen/ledger_codes.dart';
import 'package:fintech_new_web/features/ledgerCodes/screen/ledger_details_page.dart';
import 'package:fintech_new_web/features/payment/screens/add_payment.dart';
import 'package:fintech_new_web/features/paymentIn/provider/payment_in_provider.dart';
import 'package:fintech_new_web/features/paymentIn/screens/payment_in_info.dart';
import 'package:fintech_new_web/features/paymentOutward/provider/payment_outward_provider.dart';
import 'package:fintech_new_web/features/paymentOutward/screens/add_payment_outward.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';
import 'add_payment_id.dart';

class PaymentInReport extends StatefulWidget {
  static String routeName = "PaymentInReport";

  const PaymentInReport({super.key});

  @override
  State<PaymentInReport> createState() => _PaymentInReportState();
}

class _PaymentInReportState extends State<PaymentInReport> {
  @override
  void initState() {
    super.initState();
    PaymentInProvider provider =
    Provider.of<PaymentInProvider>(context, listen: false);
    provider.getPaymentInReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentInProvider>(
        builder: (context, provider, child) {
          return Material(
            child: SafeArea(
                child: Scaffold(
                  appBar: PreferredSize(
                      preferredSize:
                      Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                      child: const CommonAppbar(title: 'Payment In Report')),
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
                                              context
                                                  .pushNamed(AddPaymentId.routeName);
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
                                              downloadJsonToExcel(provider.payInRep,
                                                  "payment_outward_export");
                                            },
                                          ),
                                        )
                                      ],
                                    )),
                              ],
                              rows: const [],
                            ),
                            DataTable(
                              columns: const [
                                DataColumn(label: Text("PayID", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("Date", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("Party Code", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("Debit Code", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("MOP", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("Ref No.", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("Ref Date", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("Narration", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("Adjusted Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("Unadjusted Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text("Actions",
                                        style: TextStyle(fontWeight: FontWeight.bold))),
                              ],
                              rows: provider.payInRep.map((data) {
                                return DataRow(cells: [
                                  DataCell(Text('${data['payId'] ?? "-"}')),
                                  DataCell(Text('${data['dDt'] ?? "-"}')),
                                  DataCell(Text('${data['lcode'] ?? "-"}')),
                                  DataCell(Text('${data['dbCode'] ?? "-"}')),
                                  DataCell(Text('${data['mop'] ?? "-"}')),
                                  DataCell(Text('${data['refNo'] ?? "-"}')),
                                  DataCell(Text('${data['refDate'] ?? "-"}')),
                                  DataCell(Text('${data['narration'] ?? "-"}')),
                                  DataCell(Text('${data['amount'] ?? "-"}')),
                                  DataCell(Text('${data['adjAmount'] ?? "-"}')),
                                  DataCell(Text('${data['unadjusted'] ?? "-"}')),
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
                                              provider.editController.text = '${data['payId']}';
                                              context.pushNamed(PaymentInInfo.routeName);
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
                                              '${data['payId']}';
                                              context.pushNamed(
                                                  AddPaymentId.routeName,
                                                  queryParameters: {"editing": 'true'});
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
                                                  "Are you sure you want to delete this record?",
                                                  "SUBMIT",
                                                  "CANCEL");
                                              if (confirmation) {
                                                NetworkService networkService =
                                                NetworkService();
                                                http.StreamedResponse response =
                                                await networkService.post(
                                                    "/delete-payment-in/",
                                                    {"payId": '${data['payId']}'});
                                                if (response.statusCode == 204) {
                                                  provider.getPaymentInReport();
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
