import 'package:fintech_new_web/features/saleTransfer/provider/sale_transfer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';

class PaymentPendingReport extends StatefulWidget {
  static String routeName = "paymentPendingReport";

  const PaymentPendingReport({super.key});

  @override
  State<PaymentPendingReport> createState() => _PaymentPendingReportState();
}

class _PaymentPendingReportState extends State<PaymentPendingReport> {
  @override
  void initState() {
    super.initState();
    SaleTransferProvider provider =
        Provider.of<SaleTransferProvider>(context, listen: false);
    provider.getPaymentPendingReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SaleTransferProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Payment Pending')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        downloadJsonToExcel(
                            provider.paymentPending, "payment_pending_export");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1),
                        ),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(200, 50),
                      ),
                      child: const Text('Export',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                    const SizedBox(height: 10),
                    DataTable(
                      columnSpacing: 30,
                      columns: const [
                        DataColumn(
                            label: Text("ID",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Bill No.",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Bill Date",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("VT",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Days",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Amount",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Paid",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Balance",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Total Balance",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: provider.payRows,
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
