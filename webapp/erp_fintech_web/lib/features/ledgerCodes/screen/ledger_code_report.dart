import 'package:fintech_new_web/features/dlChallan/provider/dl_challan_provider.dart';
import 'package:fintech_new_web/features/jobWorkOut/provider/job_work_out_provider.dart';
import 'package:fintech_new_web/features/ledgerCodes/provider/ledger_codes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';

class LedgerCodeReport extends StatefulWidget {
  static String routeName = "LedgerCodeReport";

  const LedgerCodeReport({super.key});

  @override
  State<LedgerCodeReport> createState() => _LedgerCodeReportState();
}

class _LedgerCodeReportState extends State<LedgerCodeReport> {
  @override
  void initState() {
    super.initState();
    LedgerCodesProvider provider =
        Provider.of<LedgerCodesProvider>(context, listen: false);
    provider.getLedgerReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LedgerCodesProvider>(builder: (context, provider, child) {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextField(
                        onChanged: (value) {
                          provider.search(
                              value, ["lcode", "lName", "agCode", "lTitle"]);
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ),
                    DataTable(
                      columns: const [
                        DataColumn(label: Text("Code")),
                        DataColumn(label: Text("Name")),
                        DataColumn(label: Text("CR/DR Code")),
                        DataColumn(label: Text("Acc. Group")),
                        DataColumn(label: Text("Type")),
                        DataColumn(label: Text("Supply Type")),
                        DataColumn(label: Text("Supplier Type")),
                        DataColumn(label: Text("TCS")),
                        DataColumn(label: Text("Tds Code")),
                        DataColumn(label: Text("Nature Of Payment")),
                        DataColumn(label: Text("Rate Of Tds")),
                        DataColumn(label: Text("Reverse Charge")),
                        DataColumn(label: Text("Status")),
                        DataColumn(label: Text("Remark")),
                      ],
                      rows: provider.ledgerReportSearched.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['lcode'] ?? "-"}')),
                          DataCell(Text(
                              '${data['lTitle'] ?? "-"} ${data['lName'] ?? "-"}')),
                          DataCell(Text('${data['crdrCode'] ?? "-"}')),
                          DataCell(Text('${data['agCode'] ?? "-"}')),
                          DataCell(Text('${data['TypeName'] ?? "-"}')),
                          DataCell(Text('${data['slDescription'] ?? "-"}')),
                          DataCell(Text('${data['stName'] ?? "-"}')),
                          DataCell(Text('${data['tcs'] ?? "-"}')),
                          DataCell(Text('${data['tdsCode'] ?? "-"}')),
                          DataCell(Text('${data['NofPayment'] ?? "-"}')),
                          DataCell(Text('${data['rtds'] ?? "-"}')),
                          DataCell(Text('${data['rc'] ?? "-"}')),
                          DataCell(Text('${data['lStatus'] ?? "-"}')),
                          DataCell(Text('${data['lRemark'] ?? "-"}')),
                        ]);
                      }).toList(),
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
