import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hexcolor/hexcolor.dart';


import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';
import '../provider/part_sub_assembly_provider.dart';

class PartSubAssemblyReport extends StatefulWidget {
  static String routeName = "PartSubAssemblyReport";

  const PartSubAssemblyReport({super.key});

  @override
  State<PartSubAssemblyReport> createState() => _PartSubAssemblyReportState();
}

class _PartSubAssemblyReportState extends State<PartSubAssemblyReport> {
  @override
  void initState() {
    PartSubAssemblyProvider provider =
    Provider.of<PartSubAssemblyProvider>(context, listen: false);
    provider.getProductBreakupReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartSubAssemblyProvider>(
        builder: (context, provider, child) {
          List<dynamic> detailsList = [];
          List<dynamic> processingList = [];
          if (provider.partSubAssemblyReport.isNotEmpty) {
            detailsList =
            List<dynamic>.from(provider.partSubAssemblyReport[0]['pbDetails'] ?? []);
            processingList =
            List<dynamic>.from(provider.partSubAssemblyReport[0]['pbProcessing'] ?? []);
          }
          return Material(
            child: SafeArea(
                child: Scaffold(
                  appBar: PreferredSize(
                      preferredSize:
                      Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                      child: const CommonAppbar(title: 'Part Sub Assembly Report')),
                  body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Visibility(
                        visible: provider.partSubAssemblyReport.isNotEmpty,
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
                                  DataCell(Text('${provider.partSubAssemblyReport[0]['matno'] ?? "-"}')),
                                  DataCell(Visibility(
                                    visible: provider.partSubAssemblyReport[0]['pic'] != null,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          final Uri uri = Uri.parse("${NetworkService.baseUrl}${provider.partSubAssemblyReport[0]['pic'] ?? ""}");
                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                                          } else {
                                            throw 'Could not launch ${provider.partSubAssemblyReport[0]['pic']}';
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
                                    visible: provider.partSubAssemblyReport[0]['drawing'] != null,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          final Uri uri = Uri.parse("${NetworkService.baseUrl}${provider.partSubAssemblyReport[0]['drawing'] ?? ""}");
                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                                          } else {
                                            throw 'Could not launch ${provider.partSubAssemblyReport[0]['drawing']}';
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
                                    visible: provider.partSubAssemblyReport[0]['asdrawing'] != null,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          final Uri uri = Uri.parse("${NetworkService.baseUrl}${provider.partSubAssemblyReport[0]['asdrawing'] ?? ""}");
                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                                          } else {
                                            throw 'Could not launch ${provider.partSubAssemblyReport[0]['asdrawing']}';
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
                                      '${provider.partSubAssemblyReport[0]['RevisionNo'] ?? "-"}')),
                                  DataCell(Text(
                                      '${provider.partSubAssemblyReport[0]['csId'] ?? "-"}')),
                                ])
                              ],
                            ),
                            const SizedBox(
                                height: 25,
                                child: Text("    Part Sub Assembly Details",
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
                                  DataCell(Text('${data['psadId'] ?? "-"}')),
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
                                child: Text("    Part Sub Assembly Processing",
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
                                  DataCell(Text('${data['psapId'] ?? "-"}')),
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
