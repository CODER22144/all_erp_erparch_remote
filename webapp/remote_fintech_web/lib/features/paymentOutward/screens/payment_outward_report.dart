import 'dart:convert';

import 'package:fintech_new_web/features/paymentOutward/provider/payment_outward_provider.dart';
import 'package:fintech_new_web/features/paymentOutward/screens/add_payment_outward.dart';
import 'package:fintech_new_web/features/paymentOutward/screens/payment_outward_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';

class PaymentOutwardRep extends StatefulWidget {
  static String routeName = "PaymentOutwardRep";

  const PaymentOutwardRep({super.key});

  @override
  State<PaymentOutwardRep> createState() => _PaymentOutwardRepState();
}

class _PaymentOutwardRepState extends State<PaymentOutwardRep> {
  @override
  void initState() {
    super.initState();
    PaymentOutwardProvider provider =
        Provider.of<PaymentOutwardProvider>(context, listen: false);
    provider.getPaymentOutwardReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentOutwardProvider>(
        builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Payment Outward Report')),
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
                                  context
                                      .pushNamed(AddPaymentOutward.routeName);
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
                                  downloadJsonToExcel(provider.payOutRep,
                                      "payment_outward_export");
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
                        DataColumn(label: Text("PayID", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Date", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Party Code", style: TextStyle(fontWeight: FontWeight.bold))),
                        // DataColumn(label: Text("Party Name", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Credit Code", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("MOP", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Ref No.", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Ref Date", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Narration", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Adjusted Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Unadjusted Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Actions",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: provider.payOutRep.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['payId'] ?? "-"}')),
                          DataCell(Text('${data['dDt'] ?? "-"}')),
                          DataCell(Text('${data['lcode'] ?? "-"}')),
                          DataCell(Text('${data['crCode'] ?? "-"}')),
                          DataCell(Text('${data['amount'] ?? "-"}')),
                          DataCell(Text('${data['mop'] ?? "-"}')),
                          DataCell(Text('${data['refNo'] ?? "-"}')),
                          DataCell(Text('${data['refDate'] ?? "-"}')),
                          DataCell(Text('${data['narration'] ?? "-"}')),
                          DataCell(Text('${data['adjAmount'] ?? "-"}')),
                          DataCell(Text('${data['unadjusted'] ?? "-"}')),
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
                                      provider.editController.text = '${data['payId']}';
                                      context.pushNamed(PaymentOutwardInfo.routeName);
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
                                          '${data['payId']}';
                                      context.pushNamed(
                                          AddPaymentOutward.routeName,
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
                                              "Are you sure you want to delete this record?",
                                              "SUBMIT",
                                              "CANCEL");
                                      if (confirmation) {
                                        NetworkService networkService =
                                            NetworkService();
                                        http.StreamedResponse response =
                                            await networkService.post(
                                                "/delete-payment-outward/",
                                                {"payId": '${data['payId']}'});
                                        if (response.statusCode == 204) {
                                          provider.getPaymentOutwardReport();
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
