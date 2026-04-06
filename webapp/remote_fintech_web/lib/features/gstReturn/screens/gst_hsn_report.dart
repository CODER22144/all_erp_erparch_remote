import 'package:fintech_new_web/features/gstReturn/provider/gst_return_provider.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class GstHsnReport extends StatefulWidget {
  static String routeName = "GstHsnReport";

  const GstHsnReport({super.key});

  @override
  State<GstHsnReport> createState() => _GstHsnReportState();
}

class _GstHsnReportState extends State<GstHsnReport> {
  @override
  void initState() {
    GstReturnProvider provider =
    Provider.of<GstReturnProvider>(context, listen: false);
    provider.getGstHsnReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GstReturnProvider>(
        builder: (context, provider, child) {
          return Material(
            child: SafeArea(
                child: Scaffold(
                  appBar: PreferredSize(
                      preferredSize:
                      Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                      child: const CommonAppbar(title: 'GST Hsn Summary')),
                  body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Visibility(
                        visible: provider.gstHsnSummary.isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Container(
                              width: 180,
                              margin: const EdgeInsets.only(top: 10, left: 2),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                  ),
                                ),
                                onPressed: () async {
                                  downloadJsonToExcel(provider.gstHsnSummary, "gst_hsn_export");
                                },
                                child: const Text(
                                  'Export',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),

                            DataTable(
                              columnSpacing: 25,
                              columns: const [
                                DataColumn(label: Text("HSN")),
                                DataColumn(label: Text("Description")),
                                DataColumn(label: Text("UQC")),
                                DataColumn(label: Text("Total Quantity")),
                                DataColumn(label: Text("Total Value")),
                                DataColumn(label: Text("Taxable Value")),
                                DataColumn(label: Text("Integrated Tax Amount")),
                                DataColumn(label: Text("Central Tax Amount")),
                                DataColumn(label: Text("State/UT Tax Amount")),
                                DataColumn(label: Text("Cess Amount")),
                                DataColumn(label: Text("Rate")),
                              ],
                              rows: provider.gstHsnSummary.map((data) {
                                return DataRow(cells: [
                                  DataCell(Text('${data['HSN'] ?? "-"}')),
                                  DataCell(Text('${data['Description'] ?? "-"}')),
                                  DataCell(Text('${data['UQC'] ?? "-"}')),
                                  DataCell(Text('${data['Total Quantity'] ?? "-"}')),
                                  DataCell(Text('${data['Total Value'] ?? "-"}')),
                                  DataCell(Text('${data['Taxable Value'] ?? "-"}')),
                                  DataCell(Text('${data['Integrated Tax Amount'] ?? "-"}')),
                                  DataCell(Text('${data['Central Tax Amount'] ?? "-"}')),
                                  DataCell(Text('${data['State/UT Tax Amount'] ?? "-"}')),
                                  DataCell(Text('${data['Cess Amount'] ?? "-"}')),
                                  DataCell(Text('${data['Rate'] ?? "-"}')),
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
