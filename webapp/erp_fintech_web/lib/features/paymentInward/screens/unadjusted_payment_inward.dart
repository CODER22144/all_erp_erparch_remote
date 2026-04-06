import 'dart:convert';

import 'package:fintech_new_web/features/paymentInward/provider/payment_inward_provider.dart';
import 'package:fintech_new_web/features/paymentInward/screens/add_unadjusted_payment_inward_clear.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/comman_appbar.dart';

class UnadjustedPaymentInward extends StatefulWidget {
  static String routeName = "unadjustedPaymentInward";

  const UnadjustedPaymentInward({super.key});

  @override
  State<UnadjustedPaymentInward> createState() =>
      _UnadjustedPaymentInwardState();
}

class _UnadjustedPaymentInwardState extends State<UnadjustedPaymentInward> {
  @override
  void initState() {
    PaymentInwardProvider provider =
        Provider.of<PaymentInwardProvider>(context, listen: false);
    provider.getUnadjustedPaymentInward();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentInwardProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(
                  title: 'Unadjusted Payment Inward Pending')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: provider.unadjPaymentInward.isNotEmpty
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
                      rows: provider.unadjPaymentInward.map((data) {
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
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5)))),
                            onPressed: () async {
                              context.pushNamed(AddUnadjustedPaymentInwardClear.routeName, queryParameters: {
                                "details" : jsonEncode(data)
                              });
                            },
                            child: const Text(
                              'Adjust Payment',
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
