import 'dart:convert';

import 'package:fintech_new_web/features/financialCreditNote/provider/financial_crnote_provider.dart';
import 'package:fintech_new_web/features/financialCreditNote/screens/create_financial_crnote.dart';
import 'package:fintech_new_web/features/financialCreditNote/screens/financial_crnote_info.dart';
import 'package:fintech_new_web/features/ledgerCodes/provider/ledger_codes_provider.dart';
import 'package:fintech_new_web/features/ledgerCodes/screen/ledger_codes.dart';
import 'package:fintech_new_web/features/ledgerCodes/screen/ledger_details_page.dart';
import 'package:fintech_new_web/features/paymentVoucher/provider/payment_voucher_provider.dart';
import 'package:fintech_new_web/features/paymentVoucher/screens/create_payment_voucher.dart';
import 'package:fintech_new_web/features/paymentVoucher/screens/payment_voucher_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';

class FinancialCrnoteReport extends StatefulWidget {
  static String routeName = "FinancialCrnoteReport";

  const FinancialCrnoteReport({super.key});

  @override
  State<FinancialCrnoteReport> createState() => _FinancialCrnoteReportState();
}

class _FinancialCrnoteReportState extends State<FinancialCrnoteReport> {
  @override
  void initState() {
    super.initState();
    FinancialCrnoteProvider provider =
    Provider.of<FinancialCrnoteProvider>(context, listen: false);
    provider.getFcnRep();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FinancialCrnoteProvider>(
        builder: (context, provider, child) {
          return Material(
            child: SafeArea(
                child: Scaffold(
                  appBar: PreferredSize(
                      preferredSize:
                      Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                      child: const CommonAppbar(title: 'Financial Credit Note Report')),
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
                                                  CreateFinancialCrnote.routeName);
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
                                                  provider.fcnRep,
                                                  "financial_crnote_export");
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
                                DataColumn(label: Text("Serial No. & Date", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("Credit Type", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("Party Name", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("Debit Code", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("Naration", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("Tod Rate", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text("Total Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text("Actions",
                                        style: TextStyle(fontWeight: FontWeight.bold))),
                              ],
                              rows: provider.fcnRep.map((data) {
                                return DataRow(cells: [
                                  DataCell(Text('${data['No'] ?? "-"}\n${data['Dt'] ?? "-"}')),
                                  DataCell(Text('${data['fcnType'] ?? "-"}')),
                                  DataCell(Text('${data['lcode'] ?? "-"}\n${data['lName'] ?? ""}')),
                                  DataCell(Text('${data['dbCode'] ?? "-"}')),
                                  DataCell(Text('${data['naration'] ?? "-"}')),
                                  DataCell(Text('${data['amount'] ?? "-"}')),
                                  DataCell(Text('${data['rtod'] ?? "-"}')),
                                  DataCell(Text('${data['tamount'] ?? "-"}')),
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
                                              context.pushNamed(FinancialCrnoteInfo.routeName);
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
                                                  CreateFinancialCrnote.routeName,
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
                                                  "Are you sure you want to delete this Voucher?",
                                                  "SUBMIT",
                                                  "CANCEL");
                                              if (confirmation) {
                                                NetworkService networkService =
                                                NetworkService();
                                                http.StreamedResponse response =
                                                await networkService.post(
                                                    "/delete-fcn/",
                                                    {"No": '${data['No']}'});
                                                if (response.statusCode == 204) {
                                                  provider.getFcnRep();
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
