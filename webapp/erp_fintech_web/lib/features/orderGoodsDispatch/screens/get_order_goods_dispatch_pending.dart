import 'package:fintech_new_web/features/orderApproval/provider/order_approval_provider.dart';
import 'package:fintech_new_web/features/orderApproval/screens/add_order_approval.dart';
import 'package:fintech_new_web/features/orderGoodsDispatch/provider/order_goods_dispatch_provider.dart';
import 'package:fintech_new_web/features/orderGoodsDispatch/screens/add_order_goods_dispatch.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class GetOrderGoodsDispatchPending extends StatefulWidget {
  static String routeName = "/GetOrderGoodsDispatchPending";

  const GetOrderGoodsDispatchPending({super.key});

  @override
  State<GetOrderGoodsDispatchPending> createState() => _GetOrderGoodsDispatchPendingState();
}

class _GetOrderGoodsDispatchPendingState extends State<GetOrderGoodsDispatchPending> {
  @override
  void initState() {
    OrderGoodsDispatchProvider provider =
    Provider.of<OrderGoodsDispatchProvider>(context, listen: false);
    provider.getOrderPending();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderGoodsDispatchProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Order Goods Dispatch Pending')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.pendingReport.isNotEmpty ? DataTable(
                    columns: const [
                      DataColumn(label: Text("Order Id")),
                      DataColumn(label: Text("Order Date")),
                      DataColumn(label: Text("Business Partner")),
                      DataColumn(label: Text("City")),
                      DataColumn(label: Text("State")),
                      DataColumn(label: Text("Total Amount")),
                      DataColumn(label: Text("Post")),
                    ],
                    rows: provider.pendingReport.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['orderId'] ?? "-"}')),
                        DataCell(Text('${data['orderDate'] ?? "-"}')),
                        DataCell(Text('${data['custName'] ?? "-"}')),
                        DataCell(Text('${data['custCity'] ?? "-"}')),
                        DataCell(Text('${data['custStateName'] ?? "-"}')),
                        DataCell(Text('${data['sumtamount'] ?? "-"}')),
                        DataCell(ElevatedButton(
                            onPressed: () {
                              context.pushNamed(AddOrderGoodsDispatch.routeName, queryParameters: {"orderId" : "${data['orderId']}"});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor("#04D900"),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(1), // Square shape
                              ),
                              padding: EdgeInsets.zero,
                              // Remove internal padding to make it square
                              minimumSize: const Size(
                                  150, 50), // Width and height for the button
                            ),
                            child: const Text(
                              "Dispatch Order",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ))),
                      ]);
                    }).toList(),
                  ) : const SizedBox(),
                ),
              ),
            )),
      );
    });
  }
}
