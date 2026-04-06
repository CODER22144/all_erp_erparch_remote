import 'dart:convert';

import 'package:fintech_new_web/features/reOrderBalanceMaterial/provider/re_order_balance_material_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:hexcolor/hexcolor.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';

class ReOrderBalMatReport extends StatefulWidget {
  static String routeName = "ReOrderBalMatReport";

  const ReOrderBalMatReport({super.key});

  @override
  State<ReOrderBalMatReport> createState() => _ReOrderBalMatReportState();
}

class _ReOrderBalMatReportState extends State<ReOrderBalMatReport> {
  @override
  void initState() {
    ReOrderBalanceMaterialProvider provider =
    Provider.of<ReOrderBalanceMaterialProvider>(context, listen: false);
    provider.getMaterialReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReOrderBalanceMaterialProvider>(
        builder: (context, provider, child) {
          return Material(
            child: SafeArea(
                child: Scaffold(
                  appBar: PreferredSize(
                      preferredSize:
                      Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                      child: const CommonAppbar(title: 'Re-Order Balance Material Report')),
                  body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Visibility(
                        visible: provider.orderBalanceReport.isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DataTable(
                              columns: const [
                                DataColumn(label: Text("Order Id")),
                                DataColumn(label: Text("")),
                                DataColumn(label: Text("")),
                                DataColumn(label: Text("Order Date")),
                                DataColumn(label: Text("Party name")),
                                DataColumn(label: Text("City")),
                                DataColumn(label: Text("State")),
                              ],
                              rows: provider.orderBalanceReport.map((data) {
                                return DataRow(cells: [
                                  DataCell(Text('${data['orderId'] ?? "-"}')),
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
                                          "Do you want to Create Balance Order Against Order ID : ${data['orderId'] ?? "-"}?",
                                          "SUBMIT",
                                          "CANCEL");
                                      if(confirmation) {
                                        NetworkService networkService = NetworkService();
                                        http.StreamedResponse response = await networkService.post("/create-balance-order/", {"orderId" : '${data['orderId'] ?? "-"}'});
                                        if(response.statusCode == 200) {
                                          provider.getMaterialReport();
                                        } else {
                                          var message = jsonDecode(
                                              await response.stream.bytesToString());
                                          await showAlertDialog(context,
                                              message['message'], "Continue", false);
                                        }
                                      }
                                    },
                                    child: const Text(
                                      'ReOrder Balance',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white),
                                    ),
                                  )),
                                  DataCell(ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(5)))),
                                    onPressed: () async {
                                      var orderBalanceData = await provider.getOrderBalance('${data['orderId']}');
                                      _showTablePopup(context, orderBalanceData);
                                    },
                                    child: const Text(
                                      'Order Balance',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white),
                                    ),
                                  )),

                                  DataCell(Text('${data['dorderDate'] ?? "-"}')),
                                  DataCell(Text('${data['custName'] ?? "-"}')),
                                  DataCell(Text('${data['custCity'] ?? "-"}')),
                                  DataCell(Text('${data['custStateName'] ?? "-"}')),
                                ]);
                              }).toList(),
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

  void _showTablePopup(BuildContext context, List<dynamic> orderBalance) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Order Balance',
              style: TextStyle(fontWeight: FontWeight.w500)),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('Item Code')),
                      DataColumn(label: Text('Ordered Quantity')),
                      DataColumn(label: Text('Packed Quantity')),
                      DataColumn(label: Text('Balance Quantity'))
                    ],
                    rows: orderBalance.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['icode'] ?? "-"}')),
                        DataCell(Text('${data['qty'] ?? "-"}')),
                        DataCell(Text('${data['pqty'] ?? "-"}')),
                        DataCell(Text('${data['bqty'] ?? "-"}')),
                      ]);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // Navigator.pop(context, false);
                    Navigator.of(context, rootNavigator: true).pop(false);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 5),
                    width: GlobalVariables.deviceWidth * 0.15,
                    height: GlobalVariables.deviceHeight * 0.05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: HexColor("#e0e0e0"),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          offset: Offset(
                            2,
                            3,
                          ),
                        )
                      ],
                    ),
                    child: const Text("CLOSE",
                        style: TextStyle(fontSize: 11, color: Colors.black)),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
