import 'dart:convert';

import 'package:fintech_new_web/features/payment/provider/payment_provider.dart';
import 'package:fintech_new_web/features/workProcess/provider/work_process_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';

class WorkProcessReport extends StatefulWidget {
  static String routeName = "WorkProcessReport";

  const WorkProcessReport({super.key});

  @override
  State<WorkProcessReport> createState() => _WorkProcessReportState();
}

class _WorkProcessReportState extends State<WorkProcessReport> {
  @override
  void initState() {
    super.initState();
    WorkProcessProvider provider =
    Provider.of<WorkProcessProvider>(context, listen: false);
    provider.getWorkProcessReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkProcessProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Work Process Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Work Process ID")),
                        DataColumn(label: Text("Work Process Name")),
                        DataColumn(label: Text("")),
                      ],
                      rows: provider.workProcess.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['wpId'] ?? "-"}')),
                          DataCell(Text('${data['wpName'] ?? "-"}')),
                          DataCell(ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                            onPressed: () async {
                              bool confirmation =
                              await showConfirmationDialogue(
                                  context,
                                  "Do you want to Delete Work Process : ${data['wpId'] ?? "-"}?",
                                  "SUBMIT",
                                  "CANCEL");
                              if(confirmation) {
                                NetworkService networkService = NetworkService();
                                http.StreamedResponse response = await networkService.post("/delete-work-process/", {"wpId" : '${data['wpId'] ?? "-"}'});
                                if(response.statusCode == 204) {
                                  provider.getWorkProcessReport();
                                }
                              }
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            )),
      );
    });
  }
}
