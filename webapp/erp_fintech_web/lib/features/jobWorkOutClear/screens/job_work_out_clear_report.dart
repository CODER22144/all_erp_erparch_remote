import 'package:fintech_new_web/features/jobWorkOutClear/provider/job_work_out_clear_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';

class JobWorkOutClearReport extends StatefulWidget {
  static String routeName = "JobWorkOutClearReport";

  const JobWorkOutClearReport({super.key});

  @override
  State<JobWorkOutClearReport> createState() => _JobWorkOutClearReportState();
}

class _JobWorkOutClearReportState extends State<JobWorkOutClearReport> {
  @override
  void initState() {
    super.initState();
    JobWorkOutClearProvider provider =
        Provider.of<JobWorkOutClearProvider>(context, listen: false);
    provider.getJobWorkOutClearReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobWorkOutClearProvider>(
        builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Job Workout Clear Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("Date")),
                    DataColumn(label: Text("Doc No.")),
                    DataColumn(label: Text("Gr No.")),
                    DataColumn(label: Text("Bill No.")),
                    DataColumn(label: Text("Bill Date")),
                    DataColumn(label: Text("Material No.")),
                    DataColumn(label: Text("Qty")),
                    DataColumn(label: Text("Rate")),
                  ],
                  rows: provider.jwocRep.map((data) {
                    return DataRow(cells: [
                      DataCell(Text('${data['clId'] ?? "-"}')),
                      DataCell(Text('${data['dt'] ?? "-"}')),
                      DataCell(Text('${data['docno'] ?? "-"}')),
                      DataCell(Text('${data['grno'] ?? "-"}')),
                      DataCell(Text('${data['billNo'] ?? "-"}')),
                      DataCell(Text('${data['billDate'] ?? "-"}')),
                      DataCell(Text('${data['matno'] ?? "-"}')),
                      DataCell(Align(
                          alignment: Alignment.centerRight,
                          child: Text(parseDoubleUpto2Decimal(
                              '${data['qty'] ?? "-"}')))),
                      DataCell(Align(
                          alignment: Alignment.centerRight,
                          child: Text(parseDoubleUpto2Decimal(
                              '${data['rate'] ?? "-"}')))),
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
