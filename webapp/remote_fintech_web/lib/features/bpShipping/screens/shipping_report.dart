import 'dart:convert';

import 'package:fintech_new_web/features/bpShipping/provider/bp_shipping_provider.dart';
import 'package:fintech_new_web/features/bpShipping/screens/bp_shipping.dart';
import 'package:fintech_new_web/features/bpShipping/screens/shipping_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';

class ShippingReport extends StatefulWidget {
  static String routeName = "ShippingReport";

  const ShippingReport({super.key});

  @override
  State<ShippingReport> createState() => _ShippingReportState();
}

class _ShippingReportState extends State<ShippingReport> {
  @override
  void initState() {
    super.initState();
    BpShippingProvider provider =
        Provider.of<BpShippingProvider>(context, listen: false);
    provider.getShippingReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BpShippingProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Customer Shipping Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    DataTable(
                      columns: [
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        DataColumn(
                            label: Row(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5)),
                                  color: Colors.green),
                              child: IconButton(
                                icon: const Icon(Icons.add),
                                color: Colors.white,
                                tooltip: 'Add',
                                onPressed: () {
                                  context.pushNamed(BpShipping.routeName);
                                },
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                  color: Colors.blue),
                              child: IconButton(
                                icon: const Icon(Icons.exit_to_app_outlined),
                                color: Colors.white,
                                tooltip: 'Export',
                                onPressed: () {
                                  downloadJsonToExcel(provider.shippingReport,
                                      "custom_shipping_export");
                                },
                              ),
                            )
                          ],
                        )),
                      ],
                      rows: const [],
                    ),
                    DataTable(
                      columns: const [
                        DataColumn(label: Text("Shipping Code")),
                        DataColumn(label: Text("Party Code")),
                        DataColumn(label: Text("GSTIN")),
                        DataColumn(label: Text("Legal Name")),
                        DataColumn(label: Text("Shipping Address")),
                        DataColumn(label: Text("Location")),
                        DataColumn(label: Text("State")),
                        DataColumn(label: Text("Pincode")),
                        DataColumn(label: Text("Country")),
                        DataColumn(label: Text("Phone")),
                        DataColumn(label: Text("Actions")),
                      ],
                      rows: provider.shippingReport.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['shipCode'] ?? "-"}')),
                          DataCell(Text('${data['lcode'] ?? "-"}')),
                          DataCell(Text('${data['Gstin'] ?? "-"}')),
                          DataCell(Text('${data['LglNm'] ?? "-"}')),
                          DataCell(Text(
                              '${data['Addr1'] ?? "-"} ${data['Addr2'] ?? ""}')),
                          DataCell(Text('${data['Loc'] ?? "-"}')),
                          DataCell(Text('${data['stateName'] ?? "-"}')),
                          DataCell(Text('${data['Pin'] ?? "-"}')),
                          DataCell(Text('${data['countryName'] ?? "-"}')),
                          DataCell(Text('${data['Phone'] ?? "-"}')),
                          DataCell(Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5)),
                                      color: Colors.green),
                                  child: IconButton(
                                    icon: const Icon(Icons.info_outline),
                                    color: Colors.white,
                                    tooltip: 'Info',
                                    onPressed: () {
                                      provider.editController.text =
                                          '${data['shipCode']}';
                                      context.pushNamed(ShippingInfo.routeName);
                                    },
                                  ),
                                ),
                                Container(
                                  color: Colors.blue,
                                  child: IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: Colors.white,
                                    tooltip: 'Update',
                                    onPressed: () {
                                      provider.editController.text =
                                          '${data['shipCode']}';
                                      context.pushNamed(BpShipping.routeName,
                                          queryParameters: {"editing": 'true'});
                                    },
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5)),
                                      color: Colors.red),
                                  child: IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.white,
                                    tooltip: 'Delete',
                                    onPressed: () async {
                                      bool confirmation =
                                          await showConfirmationDialogue(
                                              context,
                                              "Are you sure you want to delete this ledger?",
                                              "SUBMIT",
                                              "CANCEL");
                                      if (confirmation) {
                                        NetworkService networkService =
                                            NetworkService();
                                        http.StreamedResponse response =
                                            await networkService.post(
                                                "/delete-bp-shipping/", {
                                          "shipCode": '${data['shipCode']}'
                                        });
                                        if (response.statusCode == 204) {
                                          provider.getShippingReport();
                                        } else if (response.statusCode == 400) {
                                          var message = jsonDecode(
                                              await response.stream
                                                  .bytesToString());
                                          await showAlertDialog(
                                              context,
                                              message['message'].toString(),
                                              "Continue",
                                              false);
                                        } else if (response.statusCode == 500) {
                                          var message = jsonDecode(
                                              await response.stream
                                                  .bytesToString());
                                          await showAlertDialog(
                                              context,
                                              message['message'],
                                              "Continue",
                                              false);
                                        } else {
                                          var message = jsonDecode(
                                              await response.stream
                                                  .bytesToString());
                                          await showAlertDialog(
                                              context,
                                              message['message'],
                                              "Continue",
                                              false);
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )),
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
}
