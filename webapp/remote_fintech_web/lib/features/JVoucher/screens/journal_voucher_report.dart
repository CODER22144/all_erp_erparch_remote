import 'dart:convert';

import 'package:fintech_new_web/features/JVoucher/provider/journal_voucher_provider.dart';
import 'package:fintech_new_web/features/JVoucher/screens/add_journal_voucher.dart';
import 'package:fintech_new_web/features/JVoucher/screens/journal_voucher_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

import '../../utility/services/common_utility.dart';

class JournalVoucherReport extends StatefulWidget {
  static String routeName = "journalVoucherReport";

  const JournalVoucherReport({super.key});

  @override
  State<JournalVoucherReport> createState() => _JournalVoucherReportState();
}

class _JournalVoucherReportState extends State<JournalVoucherReport> {
  @override
  void initState() {
    super.initState();
    JournalVoucherProvider provider =
        Provider.of<JournalVoucherProvider>(context, listen: false);
    provider.getJVoucherReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JournalVoucherProvider>(
        builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Journal Voucher Report')),
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
                                      .pushNamed(AddJournalVoucher.routeName);
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
                                  downloadJsonToExcel(provider.jVoucherReport,
                                      "journal_voucher_export");
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
                        DataColumn(
                            label: Text("Trans. ID",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Date",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Debit Code",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Credit Code",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Naration",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Amount",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Doc Proof",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Actions",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: provider.jVoucherReport.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['transId'] ?? "-"}')),
                          DataCell(Text('${data['Dt'] ?? "-"}')),
                          DataCell(Text('${data['dbCode'] ?? "-"}\n${data['dbName'] ?? "-"}')),
                          DataCell(Text('${data['crCode'] ?? "-"}\n${data['crName'] ?? "-"}')),
                          DataCell(Text('${data['naration'] ?? "-"}')),
                          DataCell(Text('${data['amount'] ?? "-"}')),
                          DataCell(Visibility(
                            visible: data['DocProof'] != null &&
                                data['DocProof'] != "",
                            child: InkWell(
                              child: const Icon(
                                Icons.file_present_outlined,
                                color: Colors.green,
                              ),
                              onTap: () async {
                                final Uri uri = Uri.parse(
                                    "${NetworkService.baseUrl}${data['DocProof']}");
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri,
                                      mode: LaunchMode.inAppBrowserView);
                                } else {
                                  throw 'Could not launch';
                                }
                              },
                            ),
                          )),
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
                                      provider.editController.text =
                                          '${data['transId']}';
                                      context.pushNamed(
                                          JournalVoucherInfo.routeName);
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
                                          '${data['transId']}';
                                      context.pushNamed(
                                          AddJournalVoucher.routeName,
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
                                              "Are you sure you want to delete this ledger?",
                                              "SUBMIT",
                                              "CANCEL");
                                      if (confirmation) {
                                        NetworkService networkService =
                                            NetworkService();
                                        http.StreamedResponse response =
                                            await networkService.post(
                                                "/delete-jvoucher/", {
                                          "transId": '${data['transId']}'
                                        });
                                        if (response.statusCode == 204) {
                                          provider.getJVoucherReport();
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
