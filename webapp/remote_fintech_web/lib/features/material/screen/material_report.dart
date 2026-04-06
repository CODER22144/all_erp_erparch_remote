import 'dart:convert';

import 'package:fintech_new_web/features/material/screen/material_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';
import '../provider/material_provider.dart';
import 'material_info.dart';

class MaterialReport extends StatefulWidget {
  static const String routeName = "materialReport1";

  const MaterialReport({super.key});

  @override
  State<MaterialReport> createState() => _MaterialReportState();
}

class _MaterialReportState extends State<MaterialReport> {
  @override
  void initState() {
    super.initState();
    MaterialProvider provider =
        Provider.of<MaterialProvider>(context, listen: false);
    provider.getMaterialReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MaterialProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Material Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Visibility(
                  visible: provider.materialReportList.isNotEmpty,
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
                                    context.pushNamed(MaterialScreen.routeName);
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
                                        provider.materialReportList,
                                        "material_export");
                                  },
                                ),
                              )
                            ],
                          )),
                        ],
                        rows: const [],
                      ),
                      DataTable(
                        dataRowMaxHeight: 100,
                        headingRowHeight: 80,
                        columns: const [
                          DataColumn(
                              label: Text("Material No & Description\nSale Description",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("Status",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("Hsn Code",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("PRate",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("Unit",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),

                          DataColumn(
                              label: Text("MRP\nList\nDisc. %",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("Actions",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: provider.materialReportList.map((data) {
                          return DataRow(cells: [
                            DataCell(Text('${data['matno']} - ${data['matDescription']}\n${data['saleDescription']}')),

                            DataCell(Text('${data['mst']}')),
                            DataCell(Text('${data['hsnCode']}')),
                            DataCell(Text('${data['prate']}')),
                            DataCell(Text('${data['unit']}')),

                            DataCell(Text(
                                '${data['mrp']}\n${data['listPrice']}\n${data['discRate']}')),
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
                                            data['matno'];
                                        context
                                            .pushNamed(MaterialInfo.routeName);
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
                                            data['matno'];
                                        context.pushNamed(
                                            MaterialScreen.routeName,
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
                                                  "/delete-material/", {
                                            "matno": '${data['matno']}'
                                          });
                                          if (response.statusCode == 204) {
                                            provider.getMaterialReport();
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
                  ),
                ),
              ),
            ),
          ),
        )),
      );
    });
  }
}
