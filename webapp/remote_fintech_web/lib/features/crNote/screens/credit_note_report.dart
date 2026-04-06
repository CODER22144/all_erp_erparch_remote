import 'package:fintech_new_web/features/crNote/provider/cr_note_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';

class CreditNoteReport extends StatefulWidget {
  static String routeName = "CreditNoteReport";

  const CreditNoteReport({super.key});

  @override
  State<CreditNoteReport> createState() => _CreditNoteReportState();
}

class _CreditNoteReportState extends State<CreditNoteReport> {

  @override
  void initState() {
    super.initState();
    CrNoteProvider provider =
    Provider.of<CrNoteProvider>(context, listen: false);
    provider.getDbNoteReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CrNoteProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Sale Credit Note Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
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
                              downloadJsonToExcel(provider.report, "credit_note_export");
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
                            DataColumn(label: Text("Doc. No")),
                            DataColumn(label: Text("Doc. Date")),
                            DataColumn(label: Text("Party Code")),
                            DataColumn(label: Text("Party Address")),
                            DataColumn(label: Text("Zipcode")),
                            DataColumn(label: Text("GSTIN")),

                            DataColumn(label: Text("DR | DA")),
                            DataColumn(label: Text("Debit Code")),
                            DataColumn(label: Text("Supply Type")),


                            DataColumn(label: Text("Qty")),
                            DataColumn(label: Text("Amount")),
                            DataColumn(label: Text("Discount")),
                            DataColumn(label: Text("Ass. Amount")),
                            DataColumn(label: Text("Gst Amount")),
                            DataColumn(label: Text("Igst Amount")),
                            DataColumn(label: Text("Cgst Amount")),
                            DataColumn(label: Text("Sgst Amount")),
                            DataColumn(label: Text("Total Amount")),
                          ],
                          rows: provider.rows,
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
