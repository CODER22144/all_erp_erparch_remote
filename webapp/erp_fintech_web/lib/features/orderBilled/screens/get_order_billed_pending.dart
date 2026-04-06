import 'dart:convert';

import 'package:fintech_new_web/features/orderBilled/provider/order_billed_provider.dart';
import 'package:fintech_new_web/features/orderBilled/screens/upload_order_bill.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';

class GetOrderBilledPending extends StatefulWidget {
  static String routeName = "/GetOrderBilledPending";

  const GetOrderBilledPending({super.key});

  @override
  State<GetOrderBilledPending> createState() => _GetOrderBilledPendingState();
}

class _GetOrderBilledPendingState extends State<GetOrderBilledPending> {
  @override
  void initState() {
    OrderBilledProvider provider =
        Provider.of<OrderBilledProvider>(context, listen: false);
    provider.getOrderPending();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderBilledProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Order Billing Pending')),
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
                        DataColumn(label: Text("")),
                        DataColumn(label: Text("")),
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
                              onPressed: () async {
                                bool confirmation =
                                    await showConfirmationDialogue(
                                        context,
                                        "Do you want to submit the records?",
                                        "SUBMIT",
                                        "CANCEL");
                                if (confirmation) {
                                  http.StreamedResponse result = await provider
                                      .postOrderBill('${data['orderId']}');
                                  if (result.statusCode == 200) {
                                    provider.getOrderPending();
                                    await showAlertDialog(
                                        context,
                                        "Bill Generated Successfully",
                                        "Continue",
                                        false);
                                  } else if (result.statusCode == 400) {
                                    var message = jsonDecode(
                                        await result.stream.bytesToString());
                                    await showAlertDialog(
                                        context,
                                        message['message'].toString(),
                                        "Continue",
                                        false);
                                  } else if (result.statusCode == 500) {
                                    var message = jsonDecode(
                                        await result.stream.bytesToString());
                                    await showAlertDialog(context,
                                        message['message'], "Continue", false);
                                  } else {
                                    var message = jsonDecode(
                                        await result.stream.bytesToString());
                                    await showAlertDialog(context,
                                        message['message'], "Continue", false);
                                  }
                                }
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
                                "Order Bill",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ))),
                          DataCell(ElevatedButton(
                              onPressed: () {
                                context.pushNamed(UploadOrderBill.routeName,
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
                                "Billed Details",
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
