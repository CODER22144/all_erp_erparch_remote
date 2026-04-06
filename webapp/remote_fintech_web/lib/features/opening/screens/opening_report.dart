import 'dart:convert';

import 'package:fintech_new_web/features/ledgerCodes/provider/ledger_codes_provider.dart';
import 'package:fintech_new_web/features/ledgerCodes/screen/ledger_codes.dart';
import 'package:fintech_new_web/features/ledgerCodes/screen/ledger_details_page.dart';
import 'package:fintech_new_web/features/opening/provider/opening_provider.dart';
import 'package:fintech_new_web/features/opening/screens/add_opening.dart';
import 'package:fintech_new_web/features/opening/screens/opening_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';

class OpeningReport extends StatefulWidget {
  static String routeName = "OpeningReport";

  const OpeningReport({super.key});

  @override
  State<OpeningReport> createState() => _OpeningReportState();
}

class _OpeningReportState extends State<OpeningReport> {
  @override
  void initState() {
    super.initState();
    OpeningProvider provider =
    Provider.of<OpeningProvider>(context, listen: false);
    provider.getOpeningReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OpeningProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Opening Report')),
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
                                          context.pushNamed(AddOpening.routeName);
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
                                          downloadJsonToExcel(provider.openReport,
                                              "opening_export");
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
                            DataColumn(label: Text("Ledger Code & Name", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Period", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Debit Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Credit Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold))),

                          ],
                          rows: provider.openReport.map((data) {
                            return DataRow(cells: [
                              DataCell(Text('${data['lcode'] ?? "-"}')),
                              DataCell(Text('${data['Fy'] ?? "-"}')),
                              DataCell(Text('${data['DrAmt'] ?? "-"}')),
                              DataCell(Text('${data['CrAmt'] ?? "-"}')),
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
                                          provider.editController.text = '${data['obId']}';
                                          context.pushNamed(
                                              OpeningInfo.routeName);
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
                                          provider.editController.text = '${data['ObId']}';
                                          context.pushNamed(AddOpening.routeName,
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
                                              "Are you sure you want to delete this record?",
                                              "SUBMIT",
                                              "CANCEL");
                                          if (confirmation) {
                                            NetworkService networkService =
                                            NetworkService();
                                            http.StreamedResponse response =
                                            await networkService.post(
                                                "/delete-opening/",
                                                {"ObId": '${data['ObId']}'});
                                            if (response.statusCode == 204) {
                                              provider.getOpeningReport();
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
