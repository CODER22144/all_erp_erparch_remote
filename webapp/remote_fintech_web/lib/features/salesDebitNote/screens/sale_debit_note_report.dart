import 'package:fintech_new_web/features/dbNote/provider/dbnote_provider.dart';
import 'package:fintech_new_web/features/salesDebitNote/provider/sales_debit_note_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class SaleDebitNoteReport extends StatefulWidget {
  static String routeName = "SaleDebitNoteReport";

  const SaleDebitNoteReport({super.key});

  @override
  State<SaleDebitNoteReport> createState() => _SaleDebitNoteReportState();
}

class _SaleDebitNoteReportState extends State<SaleDebitNoteReport> {

  @override
  void initState() {
    super.initState();
    SalesDebitNoteProvider provider =
    Provider.of<SalesDebitNoteProvider>(context, listen: false);
    provider.getDbNoteReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SalesDebitNoteProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Sale Debit Note Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 25,
                      columns: const [
                        DataColumn(label: Text("Doc. No")),
                        DataColumn(label: Text("Doc. Date")),
                        DataColumn(label: Text("Party Code")),
                        DataColumn(label: Text("Party Address")),
                        DataColumn(label: Text("Zipcode")),
                        DataColumn(label: Text("GSTIN")),

                        DataColumn(label: Text("DR | DA")),
                        DataColumn(label: Text("Credit Code")),
                        DataColumn(label: Text("Supply Type")),


                        DataColumn(label: Text("Qty")),
                        DataColumn(label: Text("Amount")),
                        DataColumn(label: Text("Discount")),
                        DataColumn(label: Text("Ass. Amount")),
                        DataColumn(label: Text("Igst Amount")),
                        DataColumn(label: Text("Cgst Amount")),
                        DataColumn(label: Text("Sgst Amount")),
                        DataColumn(label: Text("Gst Amount")),
                        DataColumn(label: Text("Total Amount")),
                      ],
                      rows: provider.rows,
                    ),
                  ),
                ),
              ),
            )),
      );
    });
  }
}
