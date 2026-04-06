import 'package:fintech_new_web/features/materialIncomingStandard/provider/material_incoming_standard_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';

class MaterialIncomingStandardReport extends StatefulWidget {
  static String routeName = "MaterialIncomingStandardReport";

  const MaterialIncomingStandardReport({super.key});

  @override
  State<MaterialIncomingStandardReport> createState() => _MaterialIncomingStandardReportState();
}

class _MaterialIncomingStandardReportState extends State<MaterialIncomingStandardReport> {
  @override
  void initState() {
    super.initState();
    MaterialIncomingStandardProvider provider =
    Provider.of<MaterialIncomingStandardProvider>(context, listen: false);
    provider.getMaterialIncomingStandardReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MaterialIncomingStandardProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Material Incoming Standard Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Material No.")),
                        DataColumn(label: Text("Serial No.")),
                        DataColumn(label: Text("Test Type")),
                        DataColumn(label: Text("Inspect Item")),
                        DataColumn(label: Text("Instance Name")),
                        DataColumn(label: Text("Lower Limit")),
                        DataColumn(label: Text("Higher Limit")),
                        DataColumn(label: Text("")),
                      ],
                      rows: provider.materialIncStand.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['matno'] ?? "-"}')),
                          DataCell(Text('${data['misSno'] ?? "-"}')),
                          DataCell(Text('${data['testType'] ?? "-"}')),
                          DataCell(Text('${data['isnpItem'] ?? "-"}')),
                          DataCell(Text('${data['instName'] ?? "-"}')),
                          DataCell(Text('${data['lLimit'] ?? "-"}')),
                          DataCell(Text('${data['hLimit'] ?? "-"}')),
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
                                  "Do you want to Material Incoming Standard?",
                                  "SUBMIT",
                                  "CANCEL");
                              if(confirmation) {
                                NetworkService networkService = NetworkService();
                                http.StreamedResponse response = await networkService.post("/delete-mat-inc-std/", {"misId" : '${data['misId'] ?? "-"}'});
                                if(response.statusCode == 204) {
                                  provider.getMaterialIncomingStandardReport();
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
