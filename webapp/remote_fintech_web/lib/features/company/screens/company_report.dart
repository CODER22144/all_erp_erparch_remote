import 'dart:convert';

import 'package:fintech_new_web/features/company/provider/add_company_provider.dart';
import 'package:fintech_new_web/features/company/screens/add_company_form.dart';
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
import 'company_info.dart';

class CompanyReport extends StatefulWidget {
  static String routeName = "CompanyReport";

  const CompanyReport({super.key});

  @override
  State<CompanyReport> createState() => _CompanyReportState();
}

class _CompanyReportState extends State<CompanyReport> {
  @override
  void initState() {
    super.initState();
    CompanyProvider provider =
    Provider.of<CompanyProvider>(context, listen: false);
    provider.getCompanyReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CompanyProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Company Report')),
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
                                          context.pushNamed(AddCompanyForm.routeName);
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
                                          downloadJsonToExcel(provider.compRep,
                                              "company_export");
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
                            DataColumn(label: Text("CID", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("GSTIN", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Legal Name", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Trade Name", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Address", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("City", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("State", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Phone", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("Actions",
                                    style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: provider.compRep.map((data) {
                            return DataRow(cells: [
                              DataCell(Text('${data['cid'] ?? "-"}')),
                              DataCell(Text('${data['compGstin'] ?? "-"}')),
                              DataCell(Text('${data['legalName'] ?? "-"}')),
                              DataCell(Text('${data['tradeName'] ?? "-"}')),
                              DataCell(Text('${data['compAdd'] ?? "-"}, ${data['compAdd1'] ?? ""}')),
                              DataCell(Text('${data['compCity'] ?? "-"}')),
                              DataCell(Text('${data['compStateCode'] ?? "-"}, ${data['compZipCode'] ?? "-"}')),
                              DataCell(Text('${data['compPhone'] ?? "-"}')),
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
                                          provider.editController.text = '${data['cid']}';
                                          context.pushNamed(CompanyInfo.routeName);
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
                                          provider.editController.text = '${data['cid']}';
                                          context.pushNamed(AddCompanyForm.routeName,
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
                                              "Are you sure you want to delete this company?",
                                              "SUBMIT",
                                              "CANCEL");
                                          if (confirmation) {
                                            NetworkService networkService =
                                            NetworkService();
                                            http.StreamedResponse response =
                                            await networkService.post(
                                                "/delete-company/",
                                                {"cid": '${data['cid']}'});
                                            if (response.statusCode == 204) {
                                              provider.getCompanyReport();
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
