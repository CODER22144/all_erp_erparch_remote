import 'package:fintech_new_web/features/reqIssue/provider/req_issue_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class ReqIssuePending extends StatefulWidget {
  static String routeName = "reqIssuePending";

  const ReqIssuePending({super.key});

  @override
  State<ReqIssuePending> createState() => _ReqIssuePendingState();
}

class _ReqIssuePendingState extends State<ReqIssuePending> {
  @override
  void initState() {
    ReqIssueProvider provider =
        Provider.of<ReqIssueProvider>(context, listen: false);
    provider.getReqIssuePending(context);
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
              child: const CommonAppbar(title: 'Pending Req. Issue')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: provider.reqPending.isNotEmpty
                  ? DataTable(
                      columns: const [
                        DataColumn(label: Text("Material No.")),
                        DataColumn(label: Text("Req. Qty")),
                        DataColumn(label: Text("I Qty")),
                        DataColumn(label: Text("B Qty")),
                        DataColumn(label: Text("Stock")),
                        DataColumn(label: Text(""))
                      ],
                      rows: provider.rows
                    )
                  : const SizedBox(),
            ),
          ),
        )),
      );
    });
  }
}
