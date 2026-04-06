import 'dart:convert';

import 'package:fintech_new_web/features/acGroups/provider/account_group_provider.dart';
import 'package:fintech_new_web/features/acGroups/screens/ac_group_info.dart';
import 'package:fintech_new_web/features/acGroups/screens/add_ac_group.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';

class AcGroupReport extends StatefulWidget {
  static String routeName = "AcGroupReport";

  const AcGroupReport({super.key});

  @override
  State<AcGroupReport> createState() => _AcGroupReportState();
}

class _AcGroupReportState extends State<AcGroupReport> {
  @override
  void initState() {
    super.initState();
    AccountGroupProvider provider =
        Provider.of<AccountGroupProvider>(context, listen: false);
    provider.getAccountGroupReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountGroupProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Account Groups Report')),
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
                                  context.pushNamed(AddAcGroup.routeName);
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
                                  downloadJsonToExcel(provider.acGroups,
                                      "account_groups_export");
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
                            label: Text("Ag Code",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Description",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Mg Code",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("isTr",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("isPl",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("isBl",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Actions",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: provider.acGroups.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['agCode'] ?? "-"}')),
                          DataCell(Text('${data['agDescription'] ?? "-"}')),
                          DataCell(Text('${data['mgcode'] ?? "-"}')),
                          DataCell(Text('${data['isTr'] ?? "-"}')),
                          DataCell(Text('${data['isPl'] ?? "-"}')),
                          DataCell(Text('${data['isBl'] ?? "-"}')),
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
                                          '${data['agCode']}';
                                      context.pushNamed(AcGroupInfo.routeName);
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
                                          '${data['agCode']}';
                                      context.pushNamed(AddAcGroup.routeName,
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
                                              "Are you sure you want to delete this Account Group?",
                                              "SUBMIT",
                                              "CANCEL");
                                      if (confirmation) {
                                        NetworkService networkService =
                                            NetworkService();
                                        http.StreamedResponse response =
                                            await networkService.post(
                                                "/delete-agGroup/", {
                                          "agCode": '${data['agCode']}'
                                        });
                                        if (response.statusCode == 204) {
                                          provider.getAccountGroupReport();
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
