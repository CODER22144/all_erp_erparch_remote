import 'package:fintech_new_web/features/reqIssue/provider/req_issue_provider.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class ReqIssueSummary extends StatefulWidget {
  static String routeName = "ReqIssueSummary";

  const ReqIssueSummary({super.key});

  @override
  State<ReqIssueSummary> createState() => _ReqIssueSummaryState();
}

class _ReqIssueSummaryState extends State<ReqIssueSummary> {
  @override
  void initState() {
    ReqIssueProvider provider =
    Provider.of<ReqIssueProvider>(context, listen: false);
    provider.getReqIssueSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReqIssueProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Req. Issue Summary')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.reqSummary.isNotEmpty
                      ? DataTable(
                      columns: const [
                        DataColumn(label: Text("Material No.")),
                        DataColumn(label: Text("Req. Qty")),
                        DataColumn(label: Text("Issue Qty")),
                        DataColumn(label: Text("Balance Qty")),
                        DataColumn(label: Text("Stock Qty")),
                      ],
                      rows: provider.summaryRows,
                  )
                      : const SizedBox(),
                ),
              ),
            )),
      );
    });
  }
}
