import 'package:fintech_new_web/features/orderApproval/provider/order_approval_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';

class HoldDeniedOrderReport extends StatefulWidget {
  static String routeName = "/getHoldDeniedOrderReport";

  const HoldDeniedOrderReport({super.key});

  @override
  State<HoldDeniedOrderReport> createState() => _HoldDeniedOrderReportState();
}

class _HoldDeniedOrderReportState extends State<HoldDeniedOrderReport> {
  @override
  void initState() {
    OrderApprovalProvider provider =
    Provider.of<OrderApprovalProvider>(context, listen: false);
    provider.getOrderHoldDenied();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderApprovalProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Order Hold/Denied Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.holdOrderList.isNotEmpty ? DataTable(
                    columns: const [
                      DataColumn(label: Text("Order Id")),
                      DataColumn(label: Text("Order Date")),
                      DataColumn(label: Text("Business Partner")),
                      DataColumn(label: Text("City")),
                      DataColumn(label: Text("State")),
                      DataColumn(label: Text("Total Amount")),
                      DataColumn(label: Text("Status")),
                      DataColumn(label: Text("Approve Order")),
                      DataColumn(label: Text("Reject Order")),
                    ],
                    rows: provider.holdOrderList.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['orderId'] ?? "-"}')),
                        DataCell(Text('${data['orderDate'] ?? "-"}')),
                        DataCell(Text('${data['custName'] ?? "-"}')),
                        DataCell(Text('${data['custCity'] ?? "-"}')),
                        DataCell(Text('${data['custStateName'] ?? "-"}')),
                        DataCell(Text('${data['sumtamount'] ?? "-"}')),
                        DataCell(Text('${data['osid'] ?? "-"}')),
                        DataCell(ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                          onPressed: () async {
                            bool confirmation =
                            await showConfirmationDialogue(
                                context,
                                "Do you want to Approve Order No : ${data['orderId'] ?? "-"}?",
                                "SUBMIT",
                                "CANCEL");
                            if(confirmation) {
                              NetworkService networkService = NetworkService();
                              http.StreamedResponse response = await networkService.post("/approve-hold-denied-order/", {"orderId" : '${data['orderId'] ?? "-"}'});
                              if(response.statusCode == 200) {
                                provider.getOrderHoldDenied();
                              }
                            }
                          },
                          child: const Text(
                            'Approve Order',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.white),
                          ),
                        )),
                        DataCell(ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                          onPressed: () async {
                            bool confirmation =
                            await showConfirmationDialogue(
                                context,
                                "Do you want to Reject Order No : ${data['orderId'] ?? "-"}?",
                                "SUBMIT",
                                "CANCEL");
                            if(confirmation) {
                              NetworkService networkService = NetworkService();
                              http.StreamedResponse response = await networkService.post("/reject-hold-order/", {"orderId" : '${data['orderId'] ?? "-"}'});
                              if(response.statusCode == 200) {
                                provider.getOrderHoldDenied();
                              }
                            }
                          },
                          child: const Text(
                            'Reject Order',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.white),
                          ),
                        )),
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
