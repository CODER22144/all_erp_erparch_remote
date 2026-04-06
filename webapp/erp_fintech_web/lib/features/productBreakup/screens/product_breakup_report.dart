import 'package:fintech_new_web/features/productBreakup/provider/product_breakup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class ProductBreakupReport extends StatefulWidget {
  static String routeName = "ProductBreakupReport";

  const ProductBreakupReport({super.key});

  @override
  State<ProductBreakupReport> createState() => _ProductBreakupReportState();
}

class _ProductBreakupReportState extends State<ProductBreakupReport> {
  @override
  void initState() {
    ProductBreakupProvider provider =
        Provider.of<ProductBreakupProvider>(context, listen: false);
    provider.getProductBreakupReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductBreakupProvider>(
        builder: (context, provider, child) {
          List<dynamic> detailsList = [];
          List<dynamic> processingList = [];
      if (provider.breakupReport.isNotEmpty) {
        detailsList =
            List<dynamic>.from(provider.breakupReport[0]['pbDetails'] ?? []);
        processingList =
            List<dynamic>.from(provider.breakupReport[0]['pbProcessing'] ?? []);
      }
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Product Breakup Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Visibility(
                visible: provider.breakupReport.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DataTable(
                      columns: const [
                        DataColumn(label: Text("Material No.")),
                        DataColumn(label: Text("Description")),
                        DataColumn(label: Text("List Rate")),
                        DataColumn(label: Text("Mrp")),
                        DataColumn(label: Text("OEM Rate")),
                        DataColumn(label: Text("Std. Pack")),
                        DataColumn(label: Text("Mst. Pack")),
                        DataColumn(label: Text("Jumbo Pack")),
                        DataColumn(label: Text("Revision No.")),
                        DataColumn(label: Text("Gross Weight")),
                        DataColumn(label: Text("Net Weight")),
                        DataColumn(label: Text("Status")),
                        DataColumn(label: Text("Remark")),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text(
                              '${provider.breakupReport[0]['matno'] ?? "-"}')),
                          DataCell(Text(
                              '${provider.breakupReport[0]['sDescription'] ?? "-"}')),
                          DataCell(Text(
                              '${provider.breakupReport[0]['ListRate'] ?? "-"}')),
                          DataCell(Text(
                              '${provider.breakupReport[0]['Mrp'] ?? "-"}')),
                          DataCell(Text(
                              '${provider.breakupReport[0]['OemRate'] ?? "-"}')),
                          DataCell(Text(
                              '${provider.breakupReport[0]['StdPack'] ?? "-"}')),
                          DataCell(Text(
                              '${provider.breakupReport[0]['MstPack'] ?? "-"}')),
                          DataCell(Text(
                              '${provider.breakupReport[0]['JamboPack'] ?? "-"}')),
                          DataCell(Text(
                              '${provider.breakupReport[0]['RevisionNo'] ?? "-"}')),
                          DataCell(Text(
                              '${provider.breakupReport[0]['GrossWeight'] ?? "-"}')),
                          DataCell(Text(
                              '${provider.breakupReport[0]['NetWeight'] ?? "-"}')),
                          DataCell(Text(
                              '${provider.breakupReport[0]['csId'] ?? "-"}')),
                          DataCell(Text(
                              '${provider.breakupReport[0]['REMARKS'] ?? "-"}')),
                        ])
                      ],
                    ),
                    const SizedBox(
                        height: 25,
                        child: Text("    Product Breakup Details",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    detailsList.isNotEmpty
                        ? DataTable(
                            columns: const [
                              DataColumn(label: Text("ID")),
                              DataColumn(label: Text("Part No.")),
                              DataColumn(label: Text("Qty")),
                              DataColumn(label: Text("Length")),
                              DataColumn(label: Text("Unit")),
                              DataColumn(label: Text("TNO")),
                              DataColumn(label: Text("RM Type")),
                            ],
                            rows: detailsList.map((data) {
                              return DataRow(cells: [
                                DataCell(Text('${data['pbdId'] ?? "-"}')),
                                DataCell(Text('${data['partNo'] ?? "-"}')),
                                DataCell(Text('${data['qty'] ?? "-"}')),
                                DataCell(Text('${data['pLength'] ?? "-"}')),
                                DataCell(Text('${data['unit'] ?? "-"}')),
                                DataCell(Text('${data['tno'] ?? "-"}')),
                                DataCell(Text('${data['rmType'] ?? "-"}')),
                              ]);
                            }).toList(),
                          )
                        : const SizedBox(),
                    const SizedBox(
                        height: 25,
                        child: Text("    Product Breakup Processing",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    processingList.isNotEmpty
                        ? DataTable(
                            columns: const [
                              DataColumn(label: Text("ID")),
                              DataColumn(label: Text("Work Process")),
                              DataColumn(label: Text("Order By")),
                              DataColumn(label: Text("Resource")),
                              DataColumn(label: Text("Qty")),
                              DataColumn(label: Text("Day Production")),
                            ],
                            rows: processingList.map((data) {
                              return DataRow(cells: [
                                DataCell(Text('${data['pbpId'] ?? "-"}')),
                                DataCell(Text('${data['wpId'] ?? "-"}')),
                                DataCell(Text('${data['orderBy'] ?? "-"}')),
                                DataCell(Text('${data['rId'] ?? "-"}')),
                                DataCell(Text('${data['rQty'] ?? "-"}')),
                                DataCell(
                                    Text('${data['dayProduction'] ?? "-"}')),
                              ]);
                            }).toList(),
                          )
                        : const SizedBox()
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
