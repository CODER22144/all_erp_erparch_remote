import 'package:fintech_new_web/features/attendence/provider/attendance_provider.dart';
import 'package:fintech_new_web/features/visitInfo/provider/visit_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../billReceipt/screen/hyperlink.dart';
import '../../common/widgets/comman_appbar.dart';

class VisitInfoReport extends StatefulWidget {
  static String routeName = "visitReport";

  const VisitInfoReport({super.key});

  @override
  State<VisitInfoReport> createState() => _VisitInfoReportState();
}

class _VisitInfoReportState extends State<VisitInfoReport> {
  @override
  Widget build(BuildContext context) {
    return Consumer<VisitInfoProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Visit Info Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Transaction Date")),
                    DataColumn(label: Text("User-Id")),
                    DataColumn(label: Text("Business Partner Name")),
                    DataColumn(label: Text("Contact Person")),
                    DataColumn(label: Text("Contact No.")),
                    DataColumn(label: Text("Pop Visit")),
                    DataColumn(label: Text("Business Relation Type")),
                    DataColumn(label: Text("Balance Secured")),
                    DataColumn(label: Text("Live Image")),
                  ],
                  rows: provider.visitReport.map((data) {
                    return DataRow(cells: [
                      DataCell(Text('${data['tranDate']}')),
                      DataCell(Text('${data['userId']}')),
                      DataCell(Text('${data['bpName']}')),
                      DataCell(Text("${data['cperson']}")),
                      DataCell(Text('${data['cno']}')),
                      DataCell(Text('${data['popVisit']}')),
                      DataCell(Text('${data['brtDescription']}')),
                      DataCell(Text('${data['bsecured']}')),
                      DataCell(Hyperlink(
                          text: data['liveImage'].toString(),
                          url:
                          data['liveImage'] != null || data['liveImage'] != ""
                              ? data['liveImage']
                              : "")),
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

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmation'),
              content: Text('Are you sure you want to proceed?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false
                  },
                ),
                TextButton(
                  child: Text('Confirm'),
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true
                  },
                ),
              ],
            );
          },
        ) ??
        false; // Return false if dialog is dismissed by other means
  }
}
