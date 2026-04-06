import 'package:fintech_new_web/features/orderApRequest/provider/order_ap_request_provider.dart';
import 'package:fintech_new_web/features/orderApRequest/screens/add_order_ap_request.dart';
import 'package:fintech_new_web/features/orderBilled/provider/order_billed_provider.dart';
import 'package:fintech_new_web/features/orderTransport/provider/order_transport_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import 'add_order_transport.dart';

class GetOrderTransportPending extends StatefulWidget {
  static String routeName = "/GetOrderTransportPending";

  const GetOrderTransportPending({super.key});

  @override
  State<GetOrderTransportPending> createState() =>
      _GetOrderTransportPendingState();
}

class _GetOrderTransportPendingState extends State<GetOrderTransportPending> {
  @override
  void initState() {
    OrderTransportProvider provider =
        Provider.of<OrderTransportProvider>(context, listen: false);
    provider.getOrderPending();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderTransportProvider>(
        builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Order Transport Pending')),
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
                                context.pushNamed(
                                    AddOrderTransport.routeName,
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
                                    200, 50), // Width and height for the button
                              ),
                              child: const Text(
                                "Post Order Transport",
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
