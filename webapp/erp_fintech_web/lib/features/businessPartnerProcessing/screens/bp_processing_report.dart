import 'package:fintech_new_web/features/businessPartnerProcessing/provider/bp_processing_provider.dart';
import 'package:fintech_new_web/features/jobWorkOutClear/provider/job_work_out_clear_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';

class BpProcessingReport extends StatefulWidget {
  static String routeName = "BpProcessingReport";

  const BpProcessingReport({super.key});

  @override
  State<BpProcessingReport> createState() => _BpProcessingReportState();
}

class _BpProcessingReportState extends State<BpProcessingReport> {
  @override
  void initState() {
    super.initState();
    BpProcessingProvider provider =
    Provider.of<BpProcessingProvider>(context, listen: false);
    provider.getReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BpProcessingProvider>(
        builder: (context, provider, child) {
          return Material(
            child: SafeArea(
                child: Scaffold(
                  appBar: PreferredSize(
                      preferredSize:
                      Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                      child: const CommonAppbar(title: 'Business Partner Processing Report')),
                  body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text("Business Partner", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("PID", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Description", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Rate", style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: provider.bppReport.map((data) {
                            return DataRow(cells: [
                              DataCell(Text('${data['bpCode'] ?? "-"}')),
                              DataCell(Text('${data['pId'] ?? "-"}')),
                              DataCell(Text('${data['proDescription'] ?? "-"}')),
                              DataCell(Text(parseDoubleUpto2Decimal('${data['proRate'] ?? "-"}'))),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                )),
          );
        });
  }
}
