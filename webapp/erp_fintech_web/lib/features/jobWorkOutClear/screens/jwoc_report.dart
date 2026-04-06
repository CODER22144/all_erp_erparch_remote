import 'package:fintech_new_web/features/jobWorkOutClear/provider/job_work_out_clear_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';

class JwocPendingReport extends StatefulWidget {
  static String routeName = "JwocPendingReport";

  const JwocPendingReport({super.key});

  @override
  State<JwocPendingReport> createState() => _JwocPendingReportState();
}

class _JwocPendingReportState extends State<JwocPendingReport> {
  @override
  void initState() {
    super.initState();
    JobWorkOutClearProvider provider =
        Provider.of<JobWorkOutClearProvider>(context, listen: false);
    provider.getJobWorkOutClearPendingReport();
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
              child: const CommonAppbar(title: 'Job Workout Clear Pending')),
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
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        onPressed: () async {
                          downloadJsonToExcel(flattenWithParentFields(provider.jwocPendingRep),
                              "job_work_clear_pending_export");
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
                        DataColumn(
                            label: Text("Doc No.",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Date",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Party Code",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("City - State",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Return Matno.",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Qty",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Clear Qty",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Balance Qty",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: provider.jwocRows,
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
