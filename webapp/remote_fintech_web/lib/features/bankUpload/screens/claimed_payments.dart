import 'dart:convert';

import 'package:fintech_new_web/features/bankUpload/provider/bank_provider.dart';
import 'package:fintech_new_web/features/ledgerCodes/provider/ledger_codes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../utility/services/common_utility.dart';
import 'bank_update.dart';

class ClaimedPayments extends StatefulWidget {
  static String routeName = "ClaimedPayments";

  const ClaimedPayments({super.key});

  @override
  State<ClaimedPayments> createState() => _ClaimedPaymentsState();
}

class _ClaimedPaymentsState extends State<ClaimedPayments> {
  @override
  void initState() {
    super.initState();
    BankProvider provider =
    Provider.of<BankProvider>(context, listen: false);
    provider.getClaimedPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BankProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Payment Pending Post')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DataTable(
                          columnSpacing: 25,
                          columns: const [
                            DataColumn(label: Text("Trans. ID")),
                            DataColumn(label: Text("Trans. Date")),
                            DataColumn(label: Text("Description")),
                            DataColumn(label: Text("Reference Number")),
                            DataColumn(label: Text("Deposit")),
                          ],
                          rows: provider.claimedPayment.map((data) {
                            return DataRow(cells: [
                              DataCell(Text('${data['transId'] ?? "-"}')),
                              DataCell(Text('${data['dtransDate'] ?? "-"}')),
                              DataCell(SizedBox(width: 700,child: Text('${data['transDescription'] ?? "-"}', maxLines: 2))),
                              DataCell(Text('${data['refNumber'] ?? "-"}')),
                              DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['deposit'] ?? "-"}')))),
                            ]);
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1),
                            ),
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(200, 50),
                          ),
                          onPressed: () async {
                            bool confirmation = await showConfirmationDialogue(
                                context,
                                "Do you want to submit the records?",
                                "SUBMIT",
                                "CANCEL");
                            if (confirmation) {
                              http.StreamedResponse result =
                              await provider.postClaimedPayments();
                              var message =
                              jsonDecode(await result.stream.bytesToString());
                              if (result.statusCode == 200) {
                                await showAlertDialog(
                                    context, "Post success", "Continue", false);
                                provider.getClaimedPayments();
                              } else if (result.statusCode == 400) {
                                await showAlertDialog(
                                    context,
                                    message['message'].toString(),
                                    "Continue",
                                    false);
                              } else if (result.statusCode == 500) {
                                await showAlertDialog(
                                    context, message['message'], "Continue", false);
                              } else {
                                await showAlertDialog(
                                    context, message['message'], "Continue", false);
                              }
                            }
                          },
                          child: const Text(
                            'Post',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
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
