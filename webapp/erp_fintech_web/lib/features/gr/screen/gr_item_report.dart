import 'package:fintech_new_web/features/gr/provider/gr_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';

class GrItemReport extends StatefulWidget {
  static String routeName = "GrItemReport";

  const GrItemReport({super.key});

  @override
  State<GrItemReport> createState() => _GrItemReportState();
}

class _GrItemReportState extends State<GrItemReport> {
  @override
  void initState() {
    GrProvider provider = Provider.of<GrProvider>(context, listen: false);
    provider.getGrItemReport();
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
              child: const CommonAppbar(title: 'GR Item Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: provider.grItemReport.isNotEmpty
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
                            downloadJsonToExcel(provider.grItemReport, "gr_item_export");
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
                            DataColumn(label: Text("GR No.")),
                            DataColumn(label: Text("Partner Name")),
                            DataColumn(label: Text("Bill No.")),
                            DataColumn(label: Text("Bill Date")),
                            DataColumn(label: Text("Material No.")),
                            DataColumn(label: Text("Description")),
                            DataColumn(label: Text("HSN Code")),
                            DataColumn(label: Text("Qty")),
                            DataColumn(label: Text("PO Rate")),
                            DataColumn(label: Text("GR Rate")),
                            DataColumn(label: Text("Amount")),
                          ],
                          rows: provider.grItemReport.map((data) {
                            return DataRow(cells: [
                              DataCell(Text('${data['grno'] ?? "-"}')),
                              DataCell(Text(
                                  '${data['bpCode'] ?? "-"} \n${data['bpName'] ?? "-"}',
                                  maxLines: 2)),
                              DataCell(Text('${data['billNo'] ?? "-"}')),
                              DataCell(Text('${data['billDate'] ?? "-"}')),
                              DataCell(Text('${data['matno'] ?? "-"}')),
                              DataCell(Text('${data['matDescription'] ?? "-"}', maxLines: 2)),
                              DataCell(Text('${data['hsnCode'] ?? "-"}')),
                              DataCell(Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(parseDoubleUpto2Decimal('${data['grQty'] ?? "-"}')))),
                              DataCell(Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(parseDoubleUpto2Decimal('${data['poRate'] ?? "-"}')))),
                              DataCell(Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(parseDoubleUpto2Decimal('${data['grRate'] ?? "-"}')))),
                              DataCell(Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(parseDoubleUpto2Decimal('${data['grAmount'] ?? "-"}'))))
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
