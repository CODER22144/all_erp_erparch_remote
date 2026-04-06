// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:fintech_new_web/features/orderPackaging/provider/order_packaging_provider.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';
import '../../utility/services/common_utility.dart';

class PackOrder extends StatefulWidget {
  static String routeName = "packOrder";
  final String orderId;
  const PackOrder({super.key, required this.orderId});

  @override
  State<PackOrder> createState() => _PackOrderState();
}

class _PackOrderState extends State<PackOrder> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
    OrderPackagingProvider provider =
        Provider.of<OrderPackagingProvider>(context, listen: false);
    provider.initWidget(widget.orderId, context);
    provider.getOrderBalance(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<OrderPackagingProvider>(
        builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: CommonAppbar(title: 'Pack Order : ${widget.orderId}')),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: GlobalVariables.deviceWidth / 3,
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Visibility(
                        visible: provider.widgetList.isNotEmpty,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#0B6EFE"),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)))),
                            onPressed: () {
                              _showTablePopup(context, provider.orderBalance);
                            },
                            child: const Text(
                              'Order Balance',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Visibility(
                        visible: provider.widgetList.isNotEmpty,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#0B6EFE"),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)))),
                            onPressed: () {
                              _showPackedOrderTable(context, provider);
                            },
                            child: const Text(
                              'Packed Order',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Visibility(
                        visible: provider.widgetList.isNotEmpty,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#0B6EFE"),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)))),
                            onPressed: () async {
                              NetworkService networkService = NetworkService();
                              http.StreamedResponse response =
                                  await networkService.post(
                                      "/order-clear-value/",
                                      {"orderId": widget.orderId});
                              if (response.statusCode == 200) {
                                orderClearTablePopup(
                                    context,
                                    jsonDecode(
                                        await response.stream.bytesToString()));
                              }
                            },
                            child: const Text(
                              'Order Clear Value',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: ListView.builder(
                          itemCount: provider.widgetList.length,
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return provider.widgetList[index];
                          },
                        ),
                      ),
                      Visibility(
                        visible: provider.widgetList.isNotEmpty,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#0B6EFE"),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)))),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                http.StreamedResponse result =
                                    await provider.processFormInfo();
                                if (result.statusCode == 200) {
                                  context.pushReplacementNamed(PackOrder.routeName,
                                      queryParameters: {
                                        "orderId": widget.orderId
                                      });
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

                                setState(() {
                                  loading = false;
                                });
                              }
                            },
                            child: loading ? const SpinKitFadingCircle(
                              color: Colors.white,
                              size: 25,
                            ) : const Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _showPackedOrderTable(
      BuildContext context, OrderPackagingProvider provider) {
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
                      DataColumn(label: Text("Material No.")),
                      DataColumn(label: Text("Quantity")),
                      DataColumn(label: Text("Delete")),
                    ],
                    rows: provider.orderPackagingPosted.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['icode'] ?? "-"}')),
                        DataCell(Text('${data['qty'] ?? "-"}')),
                        DataCell(Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              bool confirmation =
                                  await showConfirmationDialogue(
                                      context,
                                      "Do you want to delete the records?",
                                      "SUBMIT",
                                      "CANCEL");
                              if (confirmation) {
                                http.StreamedResponse result =
                                    await provider.deleteOrderPackaging(
                                        '${data['opid'] ?? "-"}');
                                if (result.statusCode == 204) {
                                  provider.packedOrderInfo(widget.orderId);
                                  provider.getOrderBalance(widget.orderId);
                                  context.pop();
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
                          ),
                        )),
                      ]);
                    }).toList(),
                  )
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

  void orderClearTablePopup(BuildContext context, List<dynamic> orderData) {
    List<double> sums = [0, 0, 0, 0];
    List<DataRow> rows = [];
    for (var data in orderData) {
      sums[0] += parseEmptyStringToDouble(data['ordQty']);
      sums[1] += parseEmptyStringToDouble(data['ordTamount']);
      sums[2] += parseEmptyStringToDouble(data['pkdQty']);
      sums[3] += parseEmptyStringToDouble(data['pkdTamount']);

      rows.add(DataRow(cells: [
        DataCell(Text('${data['orderId'] ?? "-"}')),
        DataCell(Text('${data['icode'] ?? "-"}')),
        DataCell(Text('${data['ordQty'] ?? "-"}')),
        DataCell(Text('${data['ordTamount'] ?? "-"}')),
        DataCell(Text('${data['pkdQty'] ?? "-"}')),
        DataCell(Text('${data['pkdTamount'] ?? "-"}')),
      ]));
    }

    rows.add(DataRow(cells: [
      const DataCell(Text('')),
      const DataCell(
          Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text(parseDoubleUpto2Decimal(sums[0].toString()),
          style: const TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text(parseDoubleUpto2Decimal(sums[1].toString()),
          style: const TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text(parseDoubleUpto2Decimal(sums[2].toString()),
          style: const TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text(parseDoubleUpto2Decimal(sums[3].toString()),
          style: const TextStyle(fontWeight: FontWeight.bold))),
    ]));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ORDER CLEAR VALUE',
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
                      DataColumn(label: Text('Order ID')),
                      DataColumn(label: Text('Material No.')),
                      DataColumn(label: Text('Ord Qty')),
                      DataColumn(label: Text('Ord Amount')),
                      DataColumn(label: Text('Pkd Qty')),
                      DataColumn(label: Text('Pkd Amount')),
                    ],
                    rows: rows,
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
                      color: Colors.redAccent,
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
