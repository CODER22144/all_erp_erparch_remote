import 'package:fintech_new_web/features/gr/provider/gr_provider.dart';
import 'package:fintech_new_web/features/purchaseOrder/provider/purchase_order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';

class PurchaseOrderItemReport extends StatefulWidget {
  static String routeName = "PurchaseOrderItemReport";

  const PurchaseOrderItemReport({super.key});

  @override
  State<PurchaseOrderItemReport> createState() => _PurchaseOrderItemReportState();
}

class _PurchaseOrderItemReportState extends State<PurchaseOrderItemReport> {
  @override
  void initState() {
    PurchaseOrderProvider provider = Provider.of<PurchaseOrderProvider>(context, listen: false);
    provider.getPoItemReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PurchaseOrderProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Purchase Order Item Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.poItemReport.isNotEmpty
                      ? Column(
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
                            downloadJsonToExcel(provider.poItemReport, "po_item_export");
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
                        columnSpacing: 30,
                        columns: const [
                          DataColumn(label: Text("PO Id")),
                          DataColumn(label: Text("PO Date")),
                          DataColumn(label: Text("Partner Name")),
                          DataColumn(label: Text("Material No.")),
                          DataColumn(label: Text("Description")),
                          DataColumn(label: Text("HSN Code")),
                          DataColumn(label: Text("Qty")),
                          DataColumn(label: Text("Unit")),
                          DataColumn(label: Text("Rate Type")),
                          DataColumn(label: Text("Rate")),
                          DataColumn(label: Text("Tax")),
                          DataColumn(label: Text("Amount")),
                          DataColumn(label: Text("Re. Qty")),
                          DataColumn(label: Text("Apo Qty")),
                          DataColumn(label: Text("Bl Qty")),
                        ],
                        rows: provider.poItemReport.map((data) {
                          return DataRow(cells: [
                            DataCell(Text('${data['poId'] ?? "-"}')),
                            DataCell(Text('${data['poDate'] ?? "-"}')),
                            DataCell(Text('${data['bpCode'] ?? "-"}\n${data['bpName'] ?? "-"}')),
                            DataCell(Text('${data['matno'] ?? "-"}')),
                            DataCell(Text('${data['matDescription'] ?? "-"}')),
                            DataCell(Text('${data['hsnCode'] ?? "-"}')),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['poQty'] ?? "-"}')))),
                            DataCell(Text('${data['puUnit'] ?? "-"}')),
                            DataCell(Text('${data['rateType'] ?? "-"}')),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['poRate'] ?? "-"}')))),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['gstTaxRate'] ?? "-"}')))),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['poAmount'] ?? "-"}')))),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['reQty'] ?? "-"}')))),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['apoQty'] ?? "-"}')))),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['blQty'] ?? "-"}')))),
                          ]);
                        }).toList(),
                      ),
                    ],
                  )
                      : const SizedBox(),
                ),
              ),
            )),
      );
    });
  }
}
