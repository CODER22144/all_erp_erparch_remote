import 'dart:convert';

import 'package:fintech_new_web/features/paymentClear/screens/add_payment_clear.dart';
import 'package:fintech_new_web/features/paymentClear/screens/add_unadjusted_payment_clear.dart';
import 'package:fintech_new_web/features/saleTransfer/screens/add_sale_transfer_clear.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/comman_appbar.dart';
import '../provider/payment_clear_provider.dart';

class UnadjustedPaymentPending extends StatefulWidget {
  static String routeName = "unadjustedPaymentPending";

  const UnadjustedPaymentPending({super.key});

  @override
  State<UnadjustedPaymentPending> createState() =>
      _UnadjustedPaymentPendingState();
}

class _UnadjustedPaymentPendingState extends State<UnadjustedPaymentPending> {
  @override
  void initState() {
    PaymentClearProvider provider =
        Provider.of<PaymentClearProvider>(context, listen: false);
    provider.getUnadjustedPaymentPending();
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
              child: const CommonAppbar(title: 'Unadjusted Payment Pending')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: provider.paymentUnadjustedPending.isNotEmpty
                  ? DataTable(
                      columns: const [
                        DataColumn(label: Text("Doc No.")),
                        DataColumn(label: Text("Doc Date")),
                        DataColumn(label: Text("PType")),
                        DataColumn(label: Text("Party Code")),
                        DataColumn(label: Text("Party Name")),
                        DataColumn(label: Text("Amount")),
                        DataColumn(label: Text("Adjusted Amount")),
                        DataColumn(label: Text("Balance Amount")),
                        DataColumn(label: Text("")),
                      ],
                      rows: provider.paymentUnadjustedPending.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['docno'] ?? "-"}')),
                          DataCell(Text('${data['docDate'] ?? "-"}')),
                          DataCell(Text('${data['ptype'] ?? "-"}')),
                          DataCell(Text('${data['lcode'] ?? "-"}')),
                          DataCell(Text('${data['bpName'] ?? "-"}')),
                          DataCell(Text('${data['tamount'] ?? "-"}')),
                          DataCell(Text('${data['adjusted'] ?? "-"}')),
                          DataCell(Text('${data['bamount'] ?? "-"}')),
                          DataCell(ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)))),
                            onPressed: () async {
                              context.pushNamed(
                                  AddUnadjustedPaymentClear.routeName,
                                  queryParameters: {
                                    "details": jsonEncode(data)
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
                    )
                  : const SizedBox(),
            ),
          ),
        )),
      );
    });
  }
}
