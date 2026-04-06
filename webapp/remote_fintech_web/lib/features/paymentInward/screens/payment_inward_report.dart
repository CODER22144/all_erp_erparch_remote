import 'package:fintech_new_web/features/paymentInward/provider/payment_inward_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class PaymentInwardReport extends StatefulWidget {
  static String routeName = "PaymentInwardReport";

  const PaymentInwardReport({super.key});

  @override
  State<PaymentInwardReport> createState() => _PaymentInwardReportState();
}

class _PaymentInwardReportState extends State<PaymentInwardReport> {
  @override
  void initState() {
    super.initState();
    PaymentInwardProvider provider =
    Provider.of<PaymentInwardProvider>(context, listen: false);
    provider.getPaymentInwardReport();
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
                  child: const CommonAppbar(title: 'Inward Payment Report')),
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
