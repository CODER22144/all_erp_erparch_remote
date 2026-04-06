import 'package:fintech_new_web/features/gstReturn/provider/gst_return_provider.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class CrdrNote extends StatefulWidget {
  static String routeName = "CrdrNote";

  const CrdrNote({super.key});

  @override
  State<CrdrNote> createState() => _CrdrNoteState();
}

class _CrdrNoteState extends State<CrdrNote> {
  @override
  void initState() {
    GstReturnProvider provider =
    Provider.of<GstReturnProvider>(context, listen: false);
    provider.getCrDrNote();
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
                      child: const CommonAppbar(title: 'CR/DB Note')),
                  body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Visibility(
                        visible: provider.crdrNote.isNotEmpty,
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
                                  downloadJsonToExcel(provider.crdrNote, "crdr_export");
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
                                DataColumn(label: Text("Note/Refund Voucher Number")),
                                DataColumn(label: Text("Note/Refund Voucher date")),
                                DataColumn(label: Text("Document Type")),
                                DataColumn(label: Text("Place Of Supply")),
                                DataColumn(label: Text("Reverse Charge")),
                                DataColumn(label: Text("Note Supply Type")),
                                DataColumn(label: Text("Note/Refund Voucher Value")),
                                DataColumn(label: Text("Rate")),
                                DataColumn(label: Text("Taxable Value")),
                                DataColumn(label: Text("Cess Amount")),
                              ],
                              rows: provider.crdrNote.map((data) {
                                return DataRow(cells: [
                                  DataCell(Text('${data['GSTIN/UIN of Recipient'] ?? "-"}')),
                                  DataCell(Text('${data['Receiver Name'] ?? "-"}')),
                                  DataCell(Text('${data['Note/Refund Voucher Number'] ?? "-"}')),
                                  DataCell(Text('${data['Note/Refund Voucher date'] ?? "-"}')),
                                  DataCell(Text('${data['Document Type'] ?? "-"}')),
                                  DataCell(Text('${data['Place Of Supply'] ?? "-"}')),
                                  DataCell(Text('${data['Reverse Charge'] ?? "-"}')),
                                  DataCell(Text('${data['Note Supply Type'] ?? "-"}')),
                                  DataCell(Text('${data['Note/Refund Voucher Value'] ?? "-"}')),
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
