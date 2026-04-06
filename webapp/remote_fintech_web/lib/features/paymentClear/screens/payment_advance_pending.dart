import 'dart:convert';

import 'package:fintech_new_web/features/paymentClear/screens/add_payment_clear.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/comman_appbar.dart';
import '../provider/payment_clear_provider.dart';

class PaymentAdvancePending extends StatefulWidget {
  static String routeName = "paymentAdvancePending";

  const PaymentAdvancePending({super.key});

  @override
  State<PaymentAdvancePending> createState() => _PaymentAdvancePendingState();
}

class _PaymentAdvancePendingState extends State<PaymentAdvancePending> {
  @override
  void initState() {
    PaymentClearProvider provider =
    Provider.of<PaymentClearProvider>(context, listen: false);
    provider.getPaymentAdvancePendingReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentClearProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Payment Advance Pending')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.paymentAdvancePending.isNotEmpty ? DataTable(
                    columns: const [
                      DataColumn(label: Text("Trans. Date")),
                      DataColumn(label: Text("Party Code")),
                      DataColumn(label: Text("Party Name")),
                      DataColumn(label: Text("Naration")),
                      DataColumn(label: Text("Amount")),
                      DataColumn(label: Text("Adjusted")),
                      DataColumn(label: Text("Unadjusted")),
                      DataColumn(label: Text("")),
                    ],
                    rows: provider.paymentAdvancePending.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['tdate'] ?? "-"}')),
                        DataCell(Text('${data['lcode'] ?? "-"}')),
                        DataCell(Text('${data['lName'] ?? "-"}')),
                        DataCell(Text('${data['naration'] ?? "-"}')),
                        DataCell(Text('${data['amount'] ?? "-"}')),
                        DataCell(Text('${data['adjusted'] ?? "-"}')),
                        DataCell(Text('${data['unadjusted'] ?? "-"}')),
                        DataCell(ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                          onPressed: () async {
                            context.pushNamed(AddPaymentClear.routeName, queryParameters: {
                              "details" : jsonEncode(data)
                            });
                          },
                          child: const Text(
                            'Adjust',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.white),
                          ),
                        )),
                      ]);
                    }).toList(),
                  ) : const SizedBox(),
                ),
              ),
            )),
      );
    });
  }
}
