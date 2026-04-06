import 'package:fintech_new_web/features/financialCreditNote/provider/financial_crnote_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';

class FinancialCrnoteReport extends StatefulWidget {
  static String routeName = "FinancialCrnoteReport";

  const FinancialCrnoteReport({super.key});

  @override
  State<FinancialCrnoteReport> createState() => _FinancialCrnoteReportState();
}

class _FinancialCrnoteReportState extends State<FinancialCrnoteReport> {
  @override
  void initState() {
    FinancialCrnoteProvider provider =
        Provider.of<FinancialCrnoteProvider>(context, listen: false);
    provider.getFiacCrNoteReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FinancialCrnoteProvider>(
        builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Financial Credit Note Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: provider.fiacRep.isNotEmpty
                  ? DataTable(
                      columns: const [
                        DataColumn(label: Text("FCNS No.")),
                        DataColumn(label: Text("Date")),
                        DataColumn(label: Text("Ledger Code")),
                        DataColumn(label: Text("Partner Name")),
                        DataColumn(label: Text("GSTIN")),
                        DataColumn(label: Text("Debit Code")),
                        DataColumn(label: Text("Amount")),
                        DataColumn(label: Text("Tod Rate")),
                        DataColumn(label: Text("Total Amount")),
                      ],
                      rows: provider.rows,
                    )
                  : const SizedBox(),
            ),
          ),
        )),
      );
    });
  }
}
