import 'package:fintech_new_web/features/payment/provider/payment_provider.dart';
import 'package:fintech_new_web/features/paymentInward/provider/payment_inward_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class PaymentOutwardReport extends StatefulWidget {
  static String routeName = "PaymentOutwardReport";

  const PaymentOutwardReport({super.key});

  @override
  State<PaymentOutwardReport> createState() => _PaymentOutwardReportState();
}

class _PaymentOutwardReportState extends State<PaymentOutwardReport> {
  @override
  void initState() {
    super.initState();
    PaymentProvider provider =
    Provider.of<PaymentProvider>(context, listen: false);
    provider.getOutwardPaymentReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Outward Payment Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Pay ID")),
                        DataColumn(label: Text("Trans Date")),
                        DataColumn(label: Text("Pay Type")),
                        DataColumn(label: Text("Trans Id")),
                        DataColumn(label: Text("Voucher Type")),
                        DataColumn(label: Text("Mode Of Payment")),
                        DataColumn(label: Text("Party Code")),
                        DataColumn(label: Text("Party Name")),
                        DataColumn(label: Text("CR/DR Code")),
                        DataColumn(label: Text("Amount")),
                        DataColumn(label: Text("Adjusted")),
                        DataColumn(label: Text("Unadjusted")),
                        DataColumn(label: Text("Narration")),
                      ],
                      rows: provider.rows,
                    ),
                  ),
                ),
              ),
            )),
      );
    });
  }
}
