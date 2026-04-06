import 'package:fintech_new_web/features/gstReturn/provider/gst_return_provider.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class B2cReport extends StatefulWidget {
  static String routeName = "B2cReport";

  const B2cReport({super.key});

  @override
  State<B2cReport> createState() => _B2cReportState();
}

class _B2cReportState extends State<B2cReport> {
  @override
  void initState() {
    GstReturnProvider provider =
    Provider.of<GstReturnProvider>(context, listen: false);
    provider.getB2cReport();
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
                      child: const CommonAppbar(title: 'B2C Report')),
                  body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Visibility(
                        visible: provider.b2cReport.isNotEmpty,
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
                                  downloadJsonToExcel(provider.b2cReport, "b2c_export");
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
                                DataColumn(label: Text("Type")),
                                DataColumn(label: Text("Place Of Supply")),
                                DataColumn(label: Text("Rate")),
                                DataColumn(label: Text("Applicable % Rate")),
                                DataColumn(label: Text("Taxable Value")),
                                DataColumn(label: Text("Cess Amount")),
                                DataColumn(label: Text("E-Commerce GSTIN")),
                              ],
                              rows: provider.b2cReport.map((data) {
                                return DataRow(cells: [
                                  DataCell(Text('${data['Type'] ?? "-"}')),
                                  DataCell(Text('${data['Place Of Supply'] ?? "-"}')),
                                  DataCell(Text('${data['Rate'] ?? "-"}')),
                                  DataCell(Text('${data['Applicable % Rate'] ?? "-"}')),
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
