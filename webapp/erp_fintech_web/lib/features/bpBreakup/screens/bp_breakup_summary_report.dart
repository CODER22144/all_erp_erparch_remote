import 'package:fintech_new_web/features/bpBreakup/provider/bp_breakup_provider.dart';
import 'package:fintech_new_web/features/hsn/provider/hsn_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';

class BpBreakupSummaryReport extends StatefulWidget {
  static String routeName = "BpBreakupSummaryReport";

  const BpBreakupSummaryReport({super.key});

  @override
  State<BpBreakupSummaryReport> createState() => _BpBreakupSummaryReportState();
}

class _BpBreakupSummaryReportState extends State<BpBreakupSummaryReport> {
  @override
  void initState() {
    BpBreakupProvider provider = Provider.of<BpBreakupProvider>(context, listen: false);
    provider.getBreakupSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BpBreakupProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Business Partner Breakup Summary')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.bpBreakupSummary.isNotEmpty
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
                            downloadJsonToExcel(provider.bpBreakupSummary, "bp_breakup_summary_export");
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
                        columns: const [
                          DataColumn(label: Text("BP Code", style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text("BP Name", style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text("Material No.", style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text("Rate", style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text("Net Amount.", style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text("Rate EF", style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: provider.bpBreakupSummary.map((data) {
                          return DataRow(cells: [
                            DataCell(Text('${data['bpCode'] ?? "-"}')),
                            DataCell(Text('${data['bpName'] ?? "-"}')),
                            DataCell(Text('${data['matno'] ?? "-"}')),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['brate'] ?? "-"}')))),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['netamount'] ?? "-"}')))),
                            DataCell(Text('${data['rateEF'] ?? "-"}')),
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
