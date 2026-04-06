import 'dart:convert';

import 'package:fintech_new_web/features/ledgerCodes/provider/ledger_codes_provider.dart';
import 'package:fintech_new_web/features/ledgerCodes/screen/ledger_codes.dart';
import 'package:fintech_new_web/features/ledgerCodes/screen/ledger_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';

class LedgerCodeReport extends StatefulWidget {
  static String routeName = "LedgerCodeReport";

  const LedgerCodeReport({super.key});

  @override
  State<LedgerCodeReport> createState() => _LedgerCodeReportState();
}

class _LedgerCodeReportState extends State<LedgerCodeReport> {
  @override
  void initState() {
    super.initState();
    LedgerCodesProvider provider =
        Provider.of<LedgerCodesProvider>(context, listen: false);
    provider.getLedgerReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LedgerCodesProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Ledger Report')),
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
                                  context.pushNamed(LedgerCodes.routeName);
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
                                  downloadJsonToExcel(provider.ledgerReport,
                                      "ledger_codes_export");
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
                            label: Text("Ledger Code & Name",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Type",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Acc. Group",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Status",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Gstin", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("City", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("State", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Country", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Actions",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: provider.ledgerReport.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['lcode'] ?? "-"} - ${data['lname'] ?? "-"}')),
                          DataCell(Text('${data['ltype'] ?? "-"}')),
                          DataCell(Text('${data['agCode'] ?? "-"} - ${data['agDescription'] ?? "-"}')),
                          DataCell(Text('${data['lstatus'] ?? "-"}')),
                          DataCell(Text('${data['Gstin'] ?? "-"}')),
                          DataCell(Text('${data['city'] ?? "-"}')),
                          DataCell(Text('${data['stateName'] ?? "-"}')),
                          DataCell(Text('${data['country'] ?? "-"}')),
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
                                      context.pushNamed(
                                          LedgerDetailsPage.routeName,
                                          queryParameters: {
                                            "partyCode":
                                                '${data['lcode'] ?? ""}'
                                          });
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
                                      context.pushNamed(LedgerCodes.routeName,
                                          queryParameters: {
                                            "editing": 'true',
                                            "partyCode":
                                                '${data['lcode'] ?? ""}'
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
                                              "Are you sure you want to delete this ledger?",
                                              "SUBMIT",
                                              "CANCEL");
                                      if (confirmation) {
                                        NetworkService networkService =
                                            NetworkService();
                                        http.StreamedResponse response =
                                            await networkService.post(
                                                "/delete-ledger-codes/",
                                                {"lcode": '${data['lcode']}'});
                                        if (response.statusCode == 204) {
                                          provider.getLedgerReport();
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
