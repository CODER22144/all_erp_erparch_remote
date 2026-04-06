import 'package:fintech_new_web/features/jobWorkOut/provider/job_work_out_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';

class JobWorkoutReport extends StatefulWidget {
  static String routeName = "JobWorkoutReport";

  const JobWorkoutReport({super.key});

  @override
  State<JobWorkoutReport> createState() => _JobWorkoutReportState();
}

class _JobWorkoutReportState extends State<JobWorkoutReport> {
  @override
  void initState() {
    super.initState();
    JobWorkOutProvider provider =
    Provider.of<JobWorkOutProvider>(context, listen: false);
    provider.getJobWorkoutReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobWorkOutProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Job WorkOut Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Doc No.")),
                        DataColumn(label: Text("Date")),
                        DataColumn(label: Text("Party Code")),
                        DataColumn(label: Text("Party Name")),
                        DataColumn(label: Text("Address")),
                        DataColumn(label: Text("Returned Material")),
                        DataColumn(label: Text("Quantity")),
                        DataColumn(label: Text("Sum Quantity")),
                        DataColumn(label: Text("Amount")),
                        DataColumn(label: Text("GST Amount")),
                        DataColumn(label: Text("Total Amount")),
                      ],
                      rows: provider.jobWorkoutReport.map((data) {
                        return DataRow(cells: [
                          DataCell(InkWell(onTap: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            var cid = prefs.getString("currentLoginCid");
                            final Uri uri = Uri.parse("${NetworkService.baseUrl}/get-jwo-pdf/${data['docno']}/$cid/");
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                            } else {
                              throw 'Could not launch';
                            }
                          },child: Text('${data['docno'] ?? "-"}', style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w500)))),
                          DataCell(Text('${data['dtDate'] ?? "-"}')),
                          DataCell(Text('${data['bpCode'] ?? "-"}')),
                          DataCell(Text('${data['bpName'] ?? "-"}')),
                          DataCell(Text('${data['bpCity'] ?? "-"}, ${data['stateName'] ?? "-"}')),
                          DataCell(Text('${data['matnoReturn'] ?? "-"}')),
                          DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['qty']}')))),
                          DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['sumQty']}')))),
                          DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['sumAmount']}')))),
                          DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['sumGstAmount']}')))),
                          DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['sumTamount']}')))),
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
