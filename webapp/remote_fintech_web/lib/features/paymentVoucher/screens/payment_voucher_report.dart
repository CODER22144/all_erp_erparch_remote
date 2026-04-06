import 'dart:convert';

import 'package:fintech_new_web/features/ledgerCodes/provider/ledger_codes_provider.dart';
import 'package:fintech_new_web/features/ledgerCodes/screen/ledger_codes.dart';
import 'package:fintech_new_web/features/ledgerCodes/screen/ledger_details_page.dart';
import 'package:fintech_new_web/features/paymentVoucher/provider/payment_voucher_provider.dart';
import 'package:fintech_new_web/features/paymentVoucher/screens/create_payment_voucher.dart';
import 'package:fintech_new_web/features/paymentVoucher/screens/payment_voucher_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';

class PaymentVoucherReport extends StatefulWidget {
  static String routeName = "PaymentVoucherReport";

  const PaymentVoucherReport({super.key});

  @override
  State<PaymentVoucherReport> createState() => _PaymentVoucherReportState();
}

class _PaymentVoucherReportState extends State<PaymentVoucherReport> {
  @override
  void initState() {
    super.initState();
    PaymentVoucherProvider provider =
        Provider.of<PaymentVoucherProvider>(context, listen: false);
    provider.getPaymentVoucherReport(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentVoucherProvider>(
        builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Payment Voucher Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    DataTable(
                      columns: [
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        DataColumn(
                            label: Row(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5)),
                                  color: Colors.green),
                              child: IconButton(
                                icon: const Icon(Icons.add),
                                color: Colors.white,
                                tooltip: 'Add',
                                onPressed: () {
                                  context.pushNamed(
                                      CreatePaymentVoucher.routeName);
                                },
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                  color: Colors.blue),
                              child: IconButton(
                                icon: const Icon(Icons.exit_to_app_outlined),
                                color: Colors.white,
                                tooltip: 'Export',
                                onPressed: () {
                                  downloadJsonToExcel(
                                      provider.paymentVoucherRep,
                                      "payment_voucher_export");
                                },
                              ),
                            )
                          ],
                        )),
                      ],
                      rows: const [],
                    ),
                    DataTable(
                      columnSpacing: 30,
                      columns: const [
                        DataColumn(label: Text("Voucher No. & Date", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Party Name", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Naration", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("HSN Code", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Ass Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("GST Rate", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("GST Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Mode Of Payment", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Pay. Ref No.", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Actions",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: provider.rows,
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
