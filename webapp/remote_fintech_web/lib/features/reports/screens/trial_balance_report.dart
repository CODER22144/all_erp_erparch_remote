import 'package:fintech_new_web/features/ledger/provider/ledger_provider.dart';
import 'package:fintech_new_web/features/obalance/provider/oblance_provider.dart';
import 'package:fintech_new_web/features/reports/provider/report_provider.dart';
import 'package:fintech_new_web/features/salesOrder/provider/sales_order_provider.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class TrialBalanceReport extends StatefulWidget {
  static String routeName = "trialBalanceReport";

  const TrialBalanceReport({super.key});

  @override
  State<TrialBalanceReport> createState() => _TrialBalanceReportState();
}

class _TrialBalanceReportState extends State<TrialBalanceReport> {
  @override
  void initState() {
    super.initState();
    ReportProvider provider =
        Provider.of<ReportProvider>(context, listen: false);
    provider.getTrialBalanceReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Trial Balance Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Visibility(
                  visible: provider.tbRep.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '${provider.tbRep['legalName']} \n${provider.tbRep['compAdd']} ${provider.tbRep['compAdd1']} \n${provider.tbRep['compCity'] ?? ""}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      DataTable(
                        columns: const [
                          DataColumn(
                              label: Text("Account Group",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("Description",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("Debit Amount",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("Credit Amount",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: provider.rows,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )),
      );
    });
  }
}
