import 'package:fintech_new_web/features/gstReturn/provider/gst_return_provider.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class B2bReport extends StatefulWidget {
  static String routeName = "B2bReport";

  const B2bReport({super.key});

  @override
  State<B2bReport> createState() => _B2bReportState();
}

class _B2bReportState extends State<B2bReport> {
  @override
  void initState() {
    GstReturnProvider provider =
    Provider.of<GstReturnProvider>(context, listen: false);
    provider.getB2bReport();
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
                      child: const CommonAppbar(title: 'B2B Report')),
                  body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Visibility(
                        visible: provider.b2bReport.isNotEmpty,
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
                                  downloadJsonToExcel(provider.b2bReport, "b2b_export");
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
                                DataColumn(label: Text("GST/UIN Of Recipient")),
                                DataColumn(label: Text("Receiver Name")),
                                DataColumn(label: Text("Invoice Number")),
                                DataColumn(label: Text("Invoice Date")),
                                DataColumn(label: Text("Invoice Value")),
                                DataColumn(label: Text("Place Of Supply")),
                                DataColumn(label: Text("Reverse Charge")),
                                DataColumn(label: Text("Applicable % Rate")),
                                DataColumn(label: Text("Invoice Type")),
                                DataColumn(label: Text("E-Commerce GSTIN")),
                                DataColumn(label: Text("Rate")),
                                DataColumn(label: Text("Taxable Value")),
                                DataColumn(label: Text("Cess Amount")),
                              ],
                              rows: provider.b2bReport.map((data) {
                                return DataRow(cells: [
                                  DataCell(Text('${data['GSTIN/UIN of Recipient'] ?? "-"}')),
                                  DataCell(Text('${data['Receiver Name'] ?? "-"}')),
                                  DataCell(Text('${data['Invoice Number'] ?? "-"}')),
                                  DataCell(Text('${data['Invoice date'] ?? "-"}')),
                                  DataCell(Text('${data['Invoice Value'] ?? "-"}')),
                                  DataCell(Text('${data['Place Of Supply'] ?? "-"}')),
                                  DataCell(Text('${data['Reverse Charge'] ?? "-"}')),
                                  DataCell(Text('${data['Applicable % Rate'] ?? "-"}')),
                                  DataCell(Text('${data['Invoice Type'] ?? "-"}')),
                                  DataCell(Text('${data['E-Commerce GSTIN'] ?? "-"}')),
                                  DataCell(Text('${data['Rate'] ?? "-"}')),
                                  DataCell(Text('${data['Taxable Value'] ?? "-"}')),
                                  DataCell(Text('${data['Cess Amount'] ?? "-"}')),
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
