import 'dart:convert';

import 'package:fintech_new_web/features/bankUpload/provider/bank_provider.dart';
import 'package:fintech_new_web/features/ledgerCodes/provider/ledger_codes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';
import 'bank_update.dart';

class UnclaimedPayment extends StatefulWidget {
  static String routeName = "UnclaimedPayment";

  const UnclaimedPayment({super.key});

  @override
  State<UnclaimedPayment> createState() => _UnclaimedPaymentState();
}

class _UnclaimedPaymentState extends State<UnclaimedPayment> {
  @override
  void initState() {
    super.initState();
    BankProvider provider =
    Provider.of<BankProvider>(context, listen: false);
    provider.getUnclaimedPayments();
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
                  child: const CommonAppbar(title: 'Unclaimed Payments')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 25,
                      columns: const [
                        DataColumn(label: Text("Trans. ID")),
                        DataColumn(label: Text("Trans. Date")),
                        DataColumn(label: Text("Description")),
                        DataColumn(label: Text("Reference Number")),
                        DataColumn(label: Text("Deposit")),
                        DataColumn(label: Text(""))
                      ],
                      rows: provider.unClaimedPayment.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['transId'] ?? "-"}')),
                          DataCell(Text('${data['dtransDate'] ?? "-"}')),
                          DataCell(SizedBox(width: 700,child: Text('${data['transDescription'] ?? "-"}', maxLines: 2))),
                          DataCell(Text('${data['refNumber'] ?? "-"}')),
                          DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['deposit'] ?? "-"}')))),
                          DataCell(Visibility(
                            visible: parseEmptyStringToDouble('${data['deposit']}') > 0.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                minimumSize: const Size(150, 40),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(1)),
                                ),
                              ),
                              onPressed: () async {
                                context.pushNamed(BankUpdate.routeName,
                                    queryParameters: {"bankDetails": jsonEncode(data)});
                              },
                              child: const Text(
                                'Claim',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
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
