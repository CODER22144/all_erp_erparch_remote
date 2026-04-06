import 'package:fintech_new_web/features/salesOrder/provider/sales_order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';

class SalesOrderShortQty extends StatefulWidget {
  static const String routeName = "/salesOrderShortQty";

  const SalesOrderShortQty({super.key});

  @override
  State<SalesOrderShortQty> createState() => _SalesOrderShortQtyState();
}

class _SalesOrderShortQtyState extends State<SalesOrderShortQty> {
  @override
  void initState() {
    super.initState();
    SalesOrderProvider provider =
        Provider.of<SalesOrderProvider>(context, listen: false);
    provider.getShortQty();
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
              child: const CommonAppbar(title: 'Sales Order Short Quantity')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                child: provider.shortQty.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                              onPressed: () async {
                                downloadJsonToExcel(provider.shortQty, "order_short_qty_export");
                              },
                              child: const Text(
                                'Export',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          DataTable(
                            columns: const [
                              DataColumn(label: Text("Mat No.")),
                              DataColumn(label: Text("Min. Level")),
                              DataColumn(label: Text("Ordered Qty")),
                              DataColumn(label: Text("Stock Qty")),
                              DataColumn(label: Text("Balance Qty")),
                            ],
                            rows: provider.shortQty.map((data) {
                              return DataRow(cells: [
                                DataCell(Text('${data['icode']}')),
                                DataCell(Align(
                                    alignment: Alignment.centerRight,
                                    child: Text('${data['mlevel']}'))),
                                DataCell(Align(
                                    alignment: Alignment.centerRight,
                                    child: Text('${data['ordqty']}'))),
                                DataCell(Align(
                                    alignment: Alignment.centerRight,
                                    child: Text('${data['stockqty']}'))),
                                DataCell(Align(
                                    alignment: Alignment.centerRight,
                                    child: Text('${data['bqty']}'))),
                              ]);
                            }).toList(),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ),
            ),
          ),
        )),
      );
    });
  }
}
