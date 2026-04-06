import 'package:fintech_new_web/features/orderPackaging/provider/order_packaging_provider.dart';
import 'package:fintech_new_web/features/orderPackaging/screens/pack_order.dart';
import 'package:fintech_new_web/features/orderPacked/screens/add_order_packed.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';

class OrderPackagingPending extends StatefulWidget {
  static String routeName = "/orderPackagingPending";

  const OrderPackagingPending({super.key});

  @override
  State<OrderPackagingPending> createState() => _OrderPackagingPendingState();
}

class _OrderPackagingPendingState extends State<OrderPackagingPending> {
  @override
  void initState() {
    OrderPackagingProvider provider =
    Provider.of<OrderPackagingProvider>(context, listen: false);
    provider.getOrderPackagingPending();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderPackagingProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Pending Order Packages')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.orderPackagingPending.isNotEmpty ? DataTable(
                    columns: const [
                      DataColumn(label: Text("Order Id")),
                      DataColumn(label: Text("Order Date")),
                      DataColumn(label: Text("Business Partner")),
                      DataColumn(label: Text("City")),
                      DataColumn(label: Text("State")),
                      DataColumn(label: Text("Total Amount")),
                      DataColumn(label: Text("Post")),
                      DataColumn(label: Text("")),
                    ],
                    rows: provider.orderPackagingPending.map((data) {
                      return DataRow(cells: [
                        DataCell(InkWell(
                            onTap: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              var cid = prefs.getString("currentLoginCid");
                              final Uri uri = Uri.parse(
                                  "${NetworkService.baseUrl}/order-slip/${data['orderId']}/$cid/");
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                              } else {
                                throw 'Could not launch';
                              }
                            },
                            child: Text('${data['orderId'] ?? "-"}',
                                style: const TextStyle(
                                    color: Colors.blueAccent, fontWeight: FontWeight.w500)))),
                        DataCell(Text('${data['orderDate'] ?? "-"}')),
                        DataCell(Text('${data['custName'] ?? "-"}')),
                        DataCell(Text('${data['custCity'] ?? "-"}')),
                        DataCell(Text('${data['custStateName'] ?? "-"}')),
                        DataCell(Text('${data['sumtamount'] ?? "-"}')),
                        DataCell(ElevatedButton(
                            onPressed: () {
                              context.pushNamed(PackOrder.routeName, queryParameters: {"orderId" : "${data['orderId']}"});
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
                              "Pack Order",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ))),
                        DataCell(ElevatedButton(
                            onPressed: () {
                              context.pushNamed(AddOrderPacked.routeName, queryParameters: {"orderId" : "${data['orderId']}"});
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
                              "Packing Details",
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

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to proceed?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true
              },
            ),
          ],
        );
      },
    ) ??
        false; // Return false if dialog is dismissed by other means
  }
}
