import 'dart:convert';

import 'package:fintech_new_web/features/salesOrder/provider/sales_order_provider.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:hexcolor/hexcolor.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';

class SalesOrderReport extends StatefulWidget {
  static String routeName = "salesOrderReport";

  const SalesOrderReport({super.key});

  @override
  State<SalesOrderReport> createState() => _SalesOrderReportState();
}

class _SalesOrderReportState extends State<SalesOrderReport> {
  @override
  void initState() {
    super.initState();
    SalesOrderProvider provider =
        Provider.of<SalesOrderProvider>(context, listen: false);
    provider.getSalesOrderReport();
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
              child: const CommonAppbar(title: 'Order Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Order Id")),
                    DataColumn(label: Text("Status")),
                    DataColumn(label: Text("Clear")),
                    DataColumn(label: Text("Order Date")),
                    DataColumn(label: Text("Business Partner")),
                    DataColumn(label: Text("Partner Address")),
                    DataColumn(label: Text("Amount")),
                    DataColumn(label: Text("GST Amount")),
                    DataColumn(label: Text("Total Amount")),
                    DataColumn(label: Text("GR No.")),
                    DataColumn(label: Text("GR Date")),
                    DataColumn(label: Text("Carrier Name")),
                  ],
                  rows: provider.orderReport.map((data) {
                    var ot = {};
                    if(data['ot'] != null) {
                      ot = data['ot'][0] ?? {};
                    }
                    return DataRow(cells: [
                      DataCell(InkWell(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var cid = prefs.getString("currentLoginCid");
                            final Uri uri = Uri.parse(
                                "${NetworkService.baseUrl}/get-sales-order-pdf/${data['orderId']}/$cid/");
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.inAppBrowserView);
                            } else {
                              throw 'Could not launch';
                            }
                          },
                          child: Text('${data['orderId'] ?? "-"}',
                              style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500)))),
                      DataCell(ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                        onPressed: () async {
                          NetworkService networkService = NetworkService();
                          http.StreamedResponse response = await networkService
                              .post("/order-status/",
                                  {"orderId": '${data['orderId'] ?? "-"}'});
                          if (response.statusCode == 200) {
                            statusTablePopup(
                                context,
                                jsonDecode(
                                    await response.stream.bytesToString()));
                          }
                        },
                        child: const Text(
                          'Status',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                      )),
                      DataCell(ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                        onPressed: () async {
                          NetworkService networkService = NetworkService();
                          http.StreamedResponse response = await networkService
                              .post("/order-clear-value/",
                                  {"orderId": '${data['orderId'] ?? "-"}'});
                          if (response.statusCode == 200) {
                            orderClearTablePopup(
                                context,
                                jsonDecode(
                                    await response.stream.bytesToString()));
                          }
                        },
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                      )),
                      DataCell(Text('${data['orderDate'] ?? "-"}')),
                      DataCell(Text('${data['custName'] ?? "-"}')),
                      DataCell(Text(
                          '${data['custCity'] ?? "-"}, ${data['custStateName'] ?? "-"}')),
                      DataCell(Align(
                          alignment: Alignment.centerRight,
                          child: Text(parseDoubleUpto2Decimal(
                              '${data['sumamount']}')))),
                      DataCell(Align(
                          alignment: Alignment.centerRight,
                          child: Text(parseDoubleUpto2Decimal(
                              '${data['sumgstamount']}')))),
                      DataCell(Align(
                          alignment: Alignment.centerRight,
                          child: Text(parseDoubleUpto2Decimal(
                              '${data['sumtamount']}')))),
                      DataCell(InkWell(
                          child: Text('${ot['grno'] ?? "-"}',
                              style: TextStyle(
                                  color: ot['grUrl'] != null
                                      ? Colors.blue
                                      : Colors.black)),
                          onTap: () async {
                            final Uri uri = Uri.parse(
                                "${NetworkService.baseUrl}${ot['grUrl']}");
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.inAppBrowserView);
                            } else {
                              throw 'Could not launch';
                            }
                          })),
                      DataCell(Text('${ot['grDate'] ?? "-"}')),
                      DataCell(Text('${ot['carrierName'] ?? "-"}')),
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

  void statusTablePopup(BuildContext context, List<dynamic> orderStatusData) {
    var data = orderStatusData[0];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ORDER STATUS',
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
                      DataColumn(label: Text('Received')),
                      DataColumn(label: Text('Approval Request')),
                      DataColumn(label: Text('Approval')),
                      DataColumn(label: Text('Packing')),
                      DataColumn(label: Text('Packed')),
                      DataColumn(label: Text('Billed')),
                      DataColumn(label: Text('Dispatch')),
                      DataColumn(label: Text('Transport')),
                      DataColumn(label: Text('Delivery')),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Icon(
                            data['Received'] == 1 ? Icons.check : Icons.clear,
                            color: data['Received'] == 1
                                ? Colors.green
                                : Colors.red)),
                        DataCell(Icon(
                            data['ApRequest'] == 1 ? Icons.check : Icons.clear,
                            color: data['ApRequest'] == 1
                                ? Colors.green
                                : Colors.red)),
                        DataCell(Icon(
                            data['Approval'] == 1 ? Icons.check : Icons.clear,
                            color: data['Approval'] == 1
                                ? Colors.green
                                : Colors.red)),
                        DataCell(Icon(
                            data['Packing'] == 1 ? Icons.check : Icons.clear,
                            color: data['Packing'] == 1
                                ? Colors.green
                                : Colors.red)),
                        DataCell(Icon(
                            data['Packed'] == 1 ? Icons.check : Icons.clear,
                            color: data['Packed'] == 1
                                ? Colors.green
                                : Colors.red)),
                        DataCell(Icon(
                            data['Billed'] == 1 ? Icons.check : Icons.clear,
                            color: data['Billed'] == 1
                                ? Colors.green
                                : Colors.red)),
                        DataCell(Icon(
                            data['Dispatch'] == 1 ? Icons.check : Icons.clear,
                            color: data['Dispatch'] == 1
                                ? Colors.green
                                : Colors.red)),
                        DataCell(Icon(
                            data['Transport'] == 1 ? Icons.check : Icons.clear,
                            color: data['Transport'] == 1
                                ? Colors.green
                                : Colors.red)),
                        DataCell(Icon(
                            data['Delivery'] == 1 ? Icons.check : Icons.clear,
                            color: data['Delivery'] == 1
                                ? Colors.green
                                : Colors.red)),
                      ]),
                    ],
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
