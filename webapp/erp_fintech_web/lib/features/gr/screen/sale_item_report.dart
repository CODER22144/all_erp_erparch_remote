import 'package:fintech_new_web/features/gr/provider/gr_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';

class SaleItemReport extends StatefulWidget {
  static String routeName = "SaleItemReport";

  const SaleItemReport({super.key});

  @override
  State<SaleItemReport> createState() => _SaleItemReportState();
}

class _SaleItemReportState extends State<SaleItemReport> {
  @override
  void initState() {
    GrProvider provider = Provider.of<GrProvider>(context, listen: false);
    provider.getSaleItemReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GrProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Sale Item Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.saleItemReport.isNotEmpty
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
                            downloadJsonToExcel(provider.saleItemReport, "sale_item_export");
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
                          DataColumn(label: Text("Invoice No.")),
                          DataColumn(label: Text("Date")),
                          DataColumn(label: Text("Party Name")),
                          DataColumn(label: Text("Party Address")),
                          DataColumn(label: Text("Material No.")),
                          DataColumn(label: Text("Description")),
                          DataColumn(label: Text("HSN Code")),
                          DataColumn(label: Text("Qty")),
                          DataColumn(label: Text("Rate")),
                          DataColumn(label: Text("Amount")),
                        ],
                        rows: provider.saleItemReport.map((data) {
                          return DataRow(cells: [
                            DataCell(Text('${data['invNo'] ?? "-"}')),
                            DataCell(Text('${data['tDate'] ?? "-"}')),
                            DataCell(Text('${data['custCode'] ?? "-"} \n${data['custName'] ?? "-"}', maxLines: 2)),
                            DataCell(Text('${data['custCity'] ?? "-"} - ${data['custStateName'] ?? "-"}', maxLines: 2)),
                            DataCell(Text('${data['icode'] ?? "-"}')),
                            DataCell(Text('${data['saleDescription'] ?? "-"}', maxLines: 2)),
                            DataCell(Text('${data['hsnCode'] ?? "-"}')),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['Qty'] ?? "-"}')))),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['Rate'] ?? "-"}')))),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['Amount'] ?? "-"}')))),
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
