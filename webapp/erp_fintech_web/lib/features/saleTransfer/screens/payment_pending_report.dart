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
    provider.getBillPendingReport();
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
                child: DataTable(
                  columnSpacing: 20,
                  columns: [
                    const DataColumn(label: Text("Tran Id")),
                    const DataColumn(label: Text("Date")),
                    const DataColumn(label: Text("Voucher\nType")),
                    const DataColumn(label: Text("Bill No.")),
                    const DataColumn(label: Text("Bill Date")),
                    const DataColumn(label: Text("Days")),
                    const DataColumn(label: Text("Amount")),
                    const DataColumn(label: Text("Pay\nAmount")),
                    const DataColumn(label: Text("Balance\nAmount")),
                    const DataColumn(label: Text("Balance\nTotal")),
                    DataColumn(label: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      onPressed: () async {
                        downloadJsonToExcel(provider.paymentPendingExport,
                            "payment_pending_export");
                      },
                      child: const Text(
                        'Export',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    )),
                  ],
                  rows: provider.paymentPending.map((data) {
                    return DataRow(cells: [
                      DataCell(Text('${data['transId'] ?? ""}')),
                      DataCell(Text('${data['dDate'] ?? ""}')),
                      DataCell(Text('${data['vtype'] ?? ""}',
                          style: data['vtype'] == 'Total' || data['vtype'] == 'Grand Total'
                              ? const TextStyle(fontWeight: FontWeight.bold)
                              : null)),
                      DataCell(Text('${data['billNo'] ?? ""}')),
                      DataCell(Text('${data['billDate'] ?? ""}')),
                      DataCell(Text('${data['tdays'] ?? ""}')),
                      DataCell(Align(
                        alignment: Alignment.centerRight,
                        child: Text('${data['amount'] ?? ""}',
                            style: data['vtype'] == 'Total' || data['vtype'] == 'Grand Total'
                                ? const TextStyle(fontWeight: FontWeight.bold)
                                : null),
                      )),
                      DataCell(Align(
                        alignment: Alignment.centerRight,
                        child: Text('${data['payamount'] ?? ""}',
                            style: data['vtype'] == 'Total' || data['vtype'] == 'Grand Total'
                                ? const TextStyle(fontWeight: FontWeight.bold)
                                : null),
                      )),
                      DataCell(Align(
                        alignment: Alignment.centerRight,
                        child: Text('${data['bamount'] ?? ""}',
                            style: data['vtype'] == 'Total' || data['vtype'] == 'Grand Total'
                                ? const TextStyle(fontWeight: FontWeight.bold)
                                : null),
                      )),
                      DataCell(Align(alignment: Alignment.centerRight,child: Text('${data['run'] ?? ""}'))),
                      const DataCell(SizedBox())
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
