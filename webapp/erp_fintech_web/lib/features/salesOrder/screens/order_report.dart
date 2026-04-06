import 'package:fintech_new_web/features/common/widgets/pop_ups.dart';
import 'package:fintech_new_web/features/salesOrder/provider/sales_order_provider.dart';
import 'package:fintech_new_web/features/salesOrder/screens/sales_order_add_item.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/comman_appbar.dart';
import 'delete_order_material.dart';

class OrderReport extends StatefulWidget {
  static const String routeName = "orderReport";

  const OrderReport({super.key});

  @override
  State<OrderReport> createState() => _OrderReportState();
}

class _OrderReportState extends State<OrderReport> {
  @override
  void initState() {
    super.initState();
    SalesOrderProvider provider =
        Provider.of<SalesOrderProvider>(context, listen: false);
    provider.getAllOrder();
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
              child: const CommonAppbar(title: 'Sales Order')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                child: provider.orderList.isNotEmpty
                    ? DataTable(
                        columns: const [
                          DataColumn(label: Text("Order ID")),
                          DataColumn(label: Text("Order Date")),
                          DataColumn(label: Text("Business partner")),
                          DataColumn(label: Text("State")),
                          DataColumn(label: Text("Total Amount")),
                          DataColumn(label: Text("")),
                          DataColumn(label: Text("")),
                          DataColumn(label: Text("")),
                        ],
                        rows: provider.orderList.map((data) {
                          return DataRow(cells: [
                            DataCell(Text('${data['orderId']}')),
                            DataCell(Text('${data['orderDate']}')),
                            DataCell(Text(data['custName'])),
                            DataCell(Text(data['custStateName'])),
                            DataCell(Text(data['sumtamount'])),
                            DataCell(Container(
                              margin: const EdgeInsets.all(5),
                              child: ElevatedButton(
                                  onPressed: () {
                                    context.pushNamed(SalesOrderAddItem.routeName,
                                        queryParameters: {
                                          "orderId": '${data['orderId'] ?? ""}',
                                          "custCode": '${data['custCode'] ?? ""}'
                                        });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: HexColor("#183D41"),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(1), // Square shape
                                    ),
                                    padding: EdgeInsets.zero,
                                    // Remove internal padding to make it square
                                    minimumSize: const Size(
                                        80, 50), // Width and height for the button
                                  ),
                                  child: const Text(
                                    "Add Item",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            )),
                            DataCell(ElevatedButton(
                                onPressed: () {
                                  context.pushNamed(DeleteOrderMaterial.routeName,
                                      queryParameters: {
                                        "orderId": '${data['orderId'] ?? ""}'
                                      });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor("#BD1C1C"),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(1), // Square shape
                                  ),
                                  padding: EdgeInsets.zero,
                                  // Remove internal padding to make it square
                                  minimumSize: const Size(
                                      90, 50), // Width and height for the button
                                ),
                                child: const Text(
                                  "Delete Items",
                                  style: TextStyle(color: Colors.white),
                                ))),
                            DataCell(ElevatedButton(
                                onPressed: () async {
                                  bool confirmation =
                                      await showConfirmationDialogue(context, "This action will delete the whole order. Do you wish to proceed?", "CONFIRM", "CANCEL");
                                  if(confirmation) {
                                    provider.deleteWholeOrder('${data['orderId'] ?? ""}');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor("#BD1C1C"),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(1), // Square shape
                                  ),
                                  padding: EdgeInsets.zero,
                                  // Remove internal padding to make it square
                                  minimumSize: const Size(
                                      90, 50), // Width and height for the button
                                ),
                                child: const Text(
                                  "Delete Order",
                                  style: TextStyle(color: Colors.white),
                                ))),
                          ]);
                        }).toList(),
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
