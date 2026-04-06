import 'package:fintech_new_web/features/prTaxInvoice/provider/pr_tax_invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class PrTaxInvoiceReport extends StatefulWidget {
  static String routeName = "PrTaxInvoiceReport";

  const PrTaxInvoiceReport({super.key});

  @override
  State<PrTaxInvoiceReport> createState() => _PrTaxInvoiceReportState();
}

class _PrTaxInvoiceReportState extends State<PrTaxInvoiceReport> {

  @override
  void initState() {
    super.initState();
    PrTaxInvoiceProvider provider =
    Provider.of<PrTaxInvoiceProvider>(context, listen: false);
    provider.getDbNoteReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PrTaxInvoiceProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'PR Tax Invoice Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Doc. No")),
                        DataColumn(label: Text("Doc. Date")),
                        DataColumn(label: Text("Doc Proof")),
                        DataColumn(label: Text("Party Code")),
                        DataColumn(label: Text("Document Reason")),
                        DataColumn(label: Text("Document Against")),
                        DataColumn(label: Text("Credit Code")),
                        DataColumn(label: Text("Supply Type")),
                        DataColumn(label: Text("Supplier Type")),
                        DataColumn(label: Text("Party Name")),
                        DataColumn(label: Text("Party Address")),
                        DataColumn(label: Text("City")),
                        DataColumn(label: Text("State")),
                        DataColumn(label: Text("Zipcode")),
                        DataColumn(label: Text("GSTIN")),
                        DataColumn(label: Text("Amount")),
                        DataColumn(label: Text("Discount Amount")),
                        DataColumn(label: Text("Tax Amount")),
                        DataColumn(label: Text("Cess Amount")),
                        DataColumn(label: Text("Gst Amount")),
                        DataColumn(label: Text("Round Off.")),
                        DataColumn(label: Text("Total Amount")),
                        DataColumn(label: Text("Adjusted")),
                        DataColumn(label: Text("Balance Amount")),
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
