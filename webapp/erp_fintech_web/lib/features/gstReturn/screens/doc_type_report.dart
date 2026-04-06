import 'package:fintech_new_web/features/gstReturn/provider/gst_return_provider.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class DocTypeReport extends StatefulWidget {
  static String routeName = "DocTypeReport";

  const DocTypeReport({super.key});

  @override
  State<DocTypeReport> createState() => _DocTypeReportState();
}

class _DocTypeReportState extends State<DocTypeReport> {
  @override
  void initState() {
    GstReturnProvider provider =
    Provider.of<GstReturnProvider>(context, listen: false);
    provider.getDocType();
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
                      child: const CommonAppbar(title: 'Doc. Type Report')),
                  body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Visibility(
                        visible: provider.docType.isNotEmpty,
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
                                  downloadJsonToExcel(provider.docType, "doc_type_export");
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
                                DataColumn(label: Text("Doc Description")),
                                DataColumn(label: Text("From Sno.")),
                                DataColumn(label: Text("To Sno.")),
                                DataColumn(label: Text("Total")),
                                DataColumn(label: Text("Cancelled")),
                              ],
                              rows: provider.docType.map((data) {
                                return DataRow(cells: [
                                  DataCell(Text('${data['DOC DESCRIPTION'] ?? "-"}')),
                                  DataCell(Text('${data['FROM SNO.'] ?? "-"}')),
                                  DataCell(Text('${data['TO SNO.'] ?? "-"}')),
                                  DataCell(Align(alignment: Alignment.centerRight, child: Text('${data['TOTAL'] ?? "-"}'))),
                                  DataCell(Text('${data['CANCELLED'] ?? "-"}')),
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
