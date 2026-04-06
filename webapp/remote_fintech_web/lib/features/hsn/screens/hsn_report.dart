import 'dart:convert';

import 'package:fintech_new_web/features/hsn/provider/hsn_provider.dart';
import 'package:fintech_new_web/features/hsn/screens/add_hsn.dart';
import 'package:fintech_new_web/features/hsn/screens/hsn_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';

class HsnReport extends StatefulWidget {
  static String routeName = "hsnReport";

  const HsnReport({super.key});

  @override
  State<HsnReport> createState() => _HsnReportState();
}

class _HsnReportState extends State<HsnReport> {
  @override
  void initState() {
    HsnProvider provider = Provider.of<HsnProvider>(context, listen: false);
    provider.getHsnReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HsnProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'HSN Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: provider.hsnReport.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        DataTable(
                          columns: [
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
                                      context.pushNamed(AddHsn.routeName);
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
                                    icon:
                                        const Icon(Icons.exit_to_app_outlined),
                                    color: Colors.white,
                                    tooltip: 'Export',
                                    onPressed: () {
                                      downloadJsonToExcel(
                                          provider.hsnReport, "export_hsn");
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
                                label: Text("Hsn Code",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("Hsn Description",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("Is Service",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("Gst Tax Rate",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("Action",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)))
                          ],
                          rows: provider.hsnReport.map((data) {
                            return DataRow(cells: [
                              DataCell(Text('${data['hsnCode'] ?? "-"}')),
                              DataCell(Text(
                                  '${data['hsnShortDescription'] ?? "-"}')),
                              DataCell(Text('${data['isService'] ?? "-"}')),
                              DataCell(Text('${data['gstTaxRate'] ?? "-"}')),
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
                                          provider.setEditController(
                                              data['hsnCode']);
                                          context.pushNamed(HsnInfo.routeName);
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
                                          provider.setEditController(
                                              data['hsnCode']);
                                          context.pushNamed(AddHsn.routeName,
                                              queryParameters: {
                                                "editing": 'true'
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
                                                    "/delete-hsn/${data['hsnCode']}/",
                                                    {});
                                            if (response.statusCode == 204) {
                                              provider.getHsnReport();
                                            } else if (response.statusCode ==
                                                400) {
                                              var message = jsonDecode(
                                                  await response.stream
                                                      .bytesToString());
                                              await showAlertDialog(
                                                  context,
                                                  message['message'].toString(),
                                                  "Continue",
                                                  false);
                                            } else if (response.statusCode ==
                                                500) {
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
                    )
                  : const SizedBox(),
            ),
          ),
        )),
      );
    });
  }
}
