import 'package:fintech_new_web/features/gstReturn/provider/gst_return_provider.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class B2ClReport extends StatefulWidget {
  static String routeName = "B2ClReport";

  const B2ClReport({super.key});

  @override
  State<B2ClReport> createState() => _B2ClReportState();
}

class _B2ClReportState extends State<B2ClReport> {
  @override
  void initState() {
    GstReturnProvider provider =
    Provider.of<GstReturnProvider>(context, listen: false);
    provider.getB2ClReport();
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
                      child: const CommonAppbar(title: 'B2CL Report')),
                  body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Visibility(
                        visible: provider.b2ClReport.isNotEmpty,
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
                                  downloadJsonToExcel(provider.b2ClReport, "b2cl_export");
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
                                DataColumn(label: Text("Invoice Number")),
                                DataColumn(label: Text("Invoice Date")),
                                DataColumn(label: Text("Invoice Value")),
                                DataColumn(label: Text("Place Of Supply")),
                                DataColumn(label: Text("Applicable % Rate")),
                                DataColumn(label: Text("Rate")),
                                DataColumn(label: Text("Taxable Value")),
                                DataColumn(label: Text("Cess Amount")),
                                DataColumn(label: Text("E-Commerce GSTIN")),
                              ],
                              rows: provider.b2ClReport.map((data) {
                                return DataRow(cells: [
                                  DataCell(Text('${data['Invoice Number'] ?? "-"}')),
                                  DataCell(Text('${data['Invoice date'] ?? "-"}')),
                                  DataCell(Text('${data['Invoice Value'] ?? "-"}')),
                                  DataCell(Text('${data['Place Of Supply'] ?? "-"}')),
                                  DataCell(Text('${data['Applicable % Rate'] ?? "-"}')),
                                  DataCell(Text('${data['Rate'] ?? "-"}')),
                                  DataCell(Text('${data['Taxable Value'] ?? "-"}')),
                                  DataCell(Text('${data['Cess Amount'] ?? "-"}')),
                                  DataCell(Text('${data['E-Commerce GSTIN'] ?? "-"}')),
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
