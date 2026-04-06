import 'package:fintech_new_web/features/partAssembly/provider/part_assembly_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hexcolor/hexcolor.dart';


import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';

class PartAssemblyReport extends StatefulWidget {
  static String routeName = "PartAssemblyReport";

  const PartAssemblyReport({super.key});

  @override
  State<PartAssemblyReport> createState() => _PartAssemblyReportState();
}

class _PartAssemblyReportState extends State<PartAssemblyReport> {
  @override
  void initState() {
    PartAssemblyProvider provider =
    Provider.of<PartAssemblyProvider>(context, listen: false);
    provider.getProductBreakupReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartAssemblyProvider>(
        builder: (context, provider, child) {
          List<dynamic> detailsList = [];
          List<dynamic> processingList = [];
          if (provider.partAssemblyReport.isNotEmpty) {
            detailsList =
            List<dynamic>.from(provider.partAssemblyReport[0]['pbDetails'] ?? []);
            processingList =
            List<dynamic>.from(provider.partAssemblyReport[0]['pbProcessing'] ?? []);
          }
          return Material(
            child: SafeArea(
                child: Scaffold(
                  appBar: PreferredSize(
                      preferredSize:
                      Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                      child: const CommonAppbar(title: 'Part Assembly Report')),
                  body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Visibility(
                        visible: provider.partAssemblyReport.isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DataTable(
                              columns: const [
                                DataColumn(label: Text("Material No.")),
                                DataColumn(label: Text("Pic")),
                                DataColumn(label: Text("Drawing")),
                                DataColumn(label: Text("As Drawing")),
                                DataColumn(label: Text("Revision No")),
                                DataColumn(label: Text("Status")),
                              ],
                              rows: [
                                DataRow(cells: [
                                  DataCell(Text('${provider.partAssemblyReport[0]['matno'] ?? "-"}')),
                                  DataCell(Visibility(
                                    visible: provider.partAssemblyReport[0]['pic'] != null,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          final Uri uri = Uri.parse("${NetworkService.baseUrl}${provider.partAssemblyReport[0]['pic'] ?? ""}");
                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                                          } else {
                                            throw 'Could not launch ${provider.partAssemblyReport[0]['pic']}';
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: HexColor("#0038a8"),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(3), // Square shape
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                                        ),
                                        child: const Text(
                                          "Pic",
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        )),
                                  )),
                                  DataCell(Visibility(
                                    visible: provider.partAssemblyReport[0]['drawing'] != null,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          final Uri uri = Uri.parse("${NetworkService.baseUrl}${provider.partAssemblyReport[0]['drawing'] ?? ""}");
                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                                          } else {
                                            throw 'Could not launch ${provider.partAssemblyReport[0]['drawing']}';
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: HexColor("#0038a8"),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(3), // Square shape
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                                        ),
                                        child: const Text(
                                          "Drawing",
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        )),
                                  )),
                                  DataCell(Visibility(
                                    visible: provider.partAssemblyReport[0]['asdrawing'] != null,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          final Uri uri = Uri.parse("${NetworkService.baseUrl}${provider.partAssemblyReport[0]['asdrawing'] ?? ""}");
                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                                          } else {
                                            throw 'Could not launch ${provider.partAssemblyReport[0]['asdrawing']}';
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: HexColor("#0038a8"),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(3), // Square shape
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                                        ),
                                        child: const Text(
                                          "As Drawing",
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        )),
                                  )),
                                  DataCell(Text(
                                      '${provider.partAssemblyReport[0]['RevisionNo'] ?? "-"}')),
                                  DataCell(Text(
                                      '${provider.partAssemblyReport[0]['csId'] ?? "-"}')),
                                ])
                              ],
                            ),
                            const SizedBox(
                                height: 25,
                                child: Text("    Part Assembly Details",
                                    style: TextStyle(fontWeight: FontWeight.bold))),
                            detailsList.isNotEmpty
                                ? DataTable(
                              columns: const [
                                DataColumn(label: Text("ID")),
                                DataColumn(label: Text("Part No.")),
                                DataColumn(label: Text("Qty")),
                                DataColumn(label: Text("Length")),
                                DataColumn(label: Text("Unit")),
                                DataColumn(label: Text("TNO")),
                                DataColumn(label: Text("RM Type")),
                              ],
                              rows: detailsList.map((data) {
                                return DataRow(cells: [
                                  DataCell(Text('${data['padId'] ?? "-"}')),
                                  DataCell(Text('${data['partNo'] ?? "-"}')),
                                  DataCell(Text('${data['qty'] ?? "-"}')),
                                  DataCell(Text('${data['pLength'] ?? "-"}')),
                                  DataCell(Text('${data['unit'] ?? "-"}')),
                                  DataCell(Text('${data['tno'] ?? "-"}')),
                                  DataCell(Text('${data['rmType'] ?? "-"}')),
                                ]);
                              }).toList(),
                            )
                                : const SizedBox(),
                            const SizedBox(
                                height: 25,
                                child: Text("    Part Assembly Processing",
                                    style: TextStyle(fontWeight: FontWeight.bold))),
                            processingList.isNotEmpty
                                ? DataTable(
                              columns: const [
                                DataColumn(label: Text("ID")),
                                DataColumn(label: Text("Work Process")),
                                DataColumn(label: Text("Order By")),
                                DataColumn(label: Text("Resource")),
                                DataColumn(label: Text("Qty")),
                                DataColumn(label: Text("Day Production")),
                              ],
                              rows: processingList.map((data) {
                                return DataRow(cells: [
                                  DataCell(Text('${data['papId'] ?? "-"}')),
                                  DataCell(Text('${data['wpId'] ?? "-"}')),
                                  DataCell(Text('${data['orderBy'] ?? "-"}')),
                                  DataCell(Text('${data['rId'] ?? "-"}')),
                                  DataCell(Text('${data['rQty'] ?? "-"}')),
                                  DataCell(
                                      Text('${data['dayProduction'] ?? "-"}')),
                                ]);
                              }).toList(),
                            )
                                : const SizedBox()
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
