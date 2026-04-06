import 'package:fintech_new_web/features/ledger/provider/ledger_provider.dart';
import 'package:fintech_new_web/features/obalance/provider/oblance_provider.dart';
import 'package:fintech_new_web/features/salesOrder/provider/sales_order_provider.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class LedgerReport extends StatefulWidget {
  static String routeName = "LedgerReport";

  const LedgerReport({super.key});

  @override
  State<LedgerReport> createState() => _LedgerReportState();
}

class _LedgerReportState extends State<LedgerReport> {
  @override
  void initState() {
    super.initState();
    LedgerProvider provider =
    Provider.of<LedgerProvider>(context, listen: false);
    provider.getLedgerReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LedgerProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Ledger Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Visibility(
                      visible: provider.ledgerRep.isNotEmpty,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${provider.ledgerRep['Ledger'][0]['lcode']} : ${provider.ledgerRep['Ledger'][0]['lname']} \n${provider.ledgerRep['Ledger'][0]['city'] ?? ""}  ${provider.ledgerRep['Ledger'][0]['stateName'] ?? ""}', style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          )),

                          DataTable(
                            columns: const [
                              DataColumn(label: Text("Trans Date", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Narration", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Debit Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Credit Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Balance", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Balance Type", style: TextStyle(fontWeight: FontWeight.bold))),
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
