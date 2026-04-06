import 'package:fintech_new_web/features/JVoucher/provider/journal_voucher_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import 'package:http/http.dart' as http;

class JournalVoucherReport extends StatefulWidget {
  static String routeName = "journalVoucherReport";

  const JournalVoucherReport({super.key});

  @override
  State<JournalVoucherReport> createState() => _JournalVoucherReportState();
}

class _JournalVoucherReportState extends State<JournalVoucherReport> {

  @override
  void initState() {
    super.initState();
    JournalVoucherProvider provider =
    Provider.of<JournalVoucherProvider>(context, listen: false);
    provider.getJVoucherReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JournalVoucherProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Journal Voucher Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Transaction Date")),
                        DataColumn(label: Text("Debit Code")),
                        DataColumn(label: Text("Credit Code")),
                        DataColumn(label: Text("Naration")),
                        DataColumn(label: Text("Amount")),
                        DataColumn(label: Text("")),
                      ],
                      rows: provider.jVoucherReport.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['dDate'] ?? "-"}')),
                          DataCell(Text('${data['dbName'] ?? "-"}')),
                          DataCell(Text('${data['crName'] ?? "-"}')),
                          DataCell(Text('${data['naration'] ?? "-"}')),
                          DataCell(Text('${data['amount'] ?? "-"}')),
                          DataCell(ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                            onPressed: () async {
                              bool confirmation =
                              await showConfirmationDialogue(
                                  context,
                                  "Do you want to Delete Voucher : ${data['transId'] ?? "-"}?",
                                  "SUBMIT",
                                  "CANCEL");
                              if(confirmation) {
                                NetworkService networkService = NetworkService();
                                http.StreamedResponse response = await networkService.post("/delete-jvoucher/", {"transId" : '${data['transId'] ?? "-"}'});
                                if(response.statusCode == 204) {
                                  provider.getJVoucherReport();
                                }
                              }
                            },
                            child: const Text(
                              'Delete Voucher',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          )),
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
