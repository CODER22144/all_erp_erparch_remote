import 'dart:convert';

import 'package:fintech_new_web/features/salesOrder/provider/sales_order_provider.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../common/widgets/comman_appbar.dart';

class OrderBalanceReport extends StatefulWidget {
  static String routeName = "OrderBalanceReport";

  const OrderBalanceReport({super.key});

  @override
  State<OrderBalanceReport> createState() => _OrderBalanceReportState();
}

class _OrderBalanceReportState extends State<OrderBalanceReport> {
  @override
  void initState() {
    super.initState();
    SalesOrderProvider provider =
    Provider.of<SalesOrderProvider>(context, listen: false);
    provider.getOrderBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SalesOrderProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Order Balance Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        const DataColumn(label: Text("Material No.")),
                        const DataColumn(label: Text("Ord. Qty")),
                        const DataColumn(label: Text("Pack Qty")),
                        const DataColumn(label: Text("Balance Qty")),
                        DataColumn(label: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                          onPressed: () async {
                            downloadJsonToExcel(provider.orderBalance, "order_balance_export");
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
                      rows: provider.orderBalance.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['icode'] ?? ""}')),
                          DataCell(Align(alignment: Alignment.centerRight,child: Text('${data['qty'] ?? ""}'))),
                          DataCell(Align(alignment: Alignment.centerRight,child: Text('${data['packQty'] ?? ""}'))),
                          DataCell(Align(alignment: Alignment.centerRight,child: Text('${data['bqty'] ?? ""}'))),
                          const DataCell(SizedBox()),
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
