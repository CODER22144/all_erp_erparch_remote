import 'dart:convert';

import 'package:fintech_new_web/features/costResource/provider/cost_resource_provider.dart';
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

class CostResourceReport extends StatefulWidget {
  static String routeName = "CostResourceReport";

  const CostResourceReport({super.key});

  @override
  State<CostResourceReport> createState() => _CostResourceReportState();
}

class _CostResourceReportState extends State<CostResourceReport> {
  @override
  void initState() {
    super.initState();
    CostResourceProvider provider =
    Provider.of<CostResourceProvider>(context, listen: false);
    provider.getResource();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CostResourceProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Resource Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Resource ID")),
                        DataColumn(label: Text("Resource Name")),
                        DataColumn(label: Text("Wages")),
                        DataColumn(label: Text("")),
                      ],
                      rows: provider.resources.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['rId'] ?? "-"}')),
                          DataCell(Text('${data['rName'] ?? "-"}')),
                          DataCell(Text('${data['wages'] ?? "-"}')),
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
                                  "Do you want to Delete Resource : ${data['rId'] ?? "-"}?",
                                  "SUBMIT",
                                  "CANCEL");
                              if(confirmation) {
                                NetworkService networkService = NetworkService();
                                http.StreamedResponse response = await networkService.post("/delete-cost-resource/", {"rId" : '${data['rId'] ?? "-"}'});
                                if(response.statusCode == 204) {
                                  provider.getResource();
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
