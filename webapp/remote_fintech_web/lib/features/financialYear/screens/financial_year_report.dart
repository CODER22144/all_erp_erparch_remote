import 'dart:convert';

import 'package:fintech_new_web/features/financialYear/provider/financial_year_provider.dart';
import 'package:fintech_new_web/features/financialYear/screens/add_financial_year.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';

class FinancialYearReport extends StatefulWidget {
  static String routeName = "FinancialYearReport";

  const FinancialYearReport({super.key});

  @override
  State<FinancialYearReport> createState() => _FinancialYearReportState();
}

class _FinancialYearReportState extends State<FinancialYearReport> {
  @override
  void initState() {
    super.initState();
    FinancialYearProvider provider =
        Provider.of<FinancialYearProvider>(context, listen: false);
    provider.getFyReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FinancialYearProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Financial Year Report')),
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
                                  context.pushNamed(AddFinancialYear.routeName);
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
                                      provider.FyRep, "financialYear_export");
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
                            label: Text("Fy",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Start Date",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("End Date",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("isActive",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Actions",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: provider.FyRep.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['Fy'] ?? "-"}')),
                          DataCell(Text('${data['SDate'] ?? "-"}')),
                          DataCell(Text('${data['EDate'] ?? "-"}')),
                          DataCell(data['IsActive'] ? const Icon(Icons.check_circle_outline_outlined, color: Colors.green) : const Icon(Icons.cancel_outlined, color: Colors.red)),
                          DataCell(Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Container(
                                //   decoration: const BoxDecoration(
                                //       borderRadius: BorderRadius.only(
                                //           topLeft: Radius.circular(5),
                                //           bottomLeft: Radius.circular(5)),
                                //       color: Colors.green),
                                //   child: IconButton(
                                //     icon: const Icon(Icons.info_outline),
                                //     color: Colors.white,
                                //     tooltip: 'Info',
                                //     onPressed: () {
                                //       provider.editController.text = '${data['cid']}';
                                //       context.pushNamed(CompanyInfo.routeName);
                                //     },
                                //   ),
                                // ),
                                Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5)), color: Colors.blue),
                                  child: IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: Colors.white,
                                    tooltip: 'Update',
                                    onPressed: () {
                                      provider.editController.text =
                                          '${data['Fy']}';
                                      context.pushNamed(
                                          AddFinancialYear.routeName,
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
                                              "Are you sure you want to delete this Financial Year?",
                                              "SUBMIT",
                                              "CANCEL");
                                      if (confirmation) {
                                        NetworkService networkService =
                                            NetworkService();
                                        http.StreamedResponse response =
                                            await networkService.post(
                                                "/delete-fy/",
                                                {"Fy": '${data['Fy']}'});
                                        if (response.statusCode == 204) {
                                          provider.getFyReport();
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
