import 'package:fintech_new_web/features/orderDelivery/provider/order_delivery_provider.dart';
import 'package:fintech_new_web/features/orderDelivery/screens/add_order_delivery.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/comman_appbar.dart';

class GetOrderDeliveryPending extends StatefulWidget {
  static String routeName = "/GetOrderDeliveryPending";

  const GetOrderDeliveryPending({super.key});

  @override
  State<GetOrderDeliveryPending> createState() =>
      _GetOrderDeliveryPendingState();
}

class _GetOrderDeliveryPendingState extends State<GetOrderDeliveryPending> {
  @override
  void initState() {
    OrderDeliveryProvider provider =
        Provider.of<OrderDeliveryProvider>(context, listen: false);
    provider.getOrderPending();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDeliveryProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Order Delivery Pending')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: provider.pendingReport.isNotEmpty
                  ? DataTable(
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
                                context.goNamed(AddOrderDelivery.routeName,
                                    queryParameters: {
                                      "orderId": "${data['orderId'] ?? ''}"
                                    });
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
                                "Bill Order",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ))),
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
