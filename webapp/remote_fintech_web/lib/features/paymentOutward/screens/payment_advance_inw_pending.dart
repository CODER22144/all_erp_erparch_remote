import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../provider/payment_outward_provider.dart';

class PaymentAdvanceInwPending extends StatefulWidget {
  static String routeName = "/PaymentAdvInPending";

  const PaymentAdvanceInwPending({super.key});

  @override
  State<PaymentAdvanceInwPending> createState() =>
      _PaymentAdvanceInwPendingState();
}

class _PaymentAdvanceInwPendingState extends State<PaymentAdvanceInwPending> {
  @override
  void initState() {
    super.initState();
    PaymentOutwardProvider provider =
        Provider.of<PaymentOutwardProvider>(context, listen: false);
    provider.getPendingPaymentInAdvance();
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
              child: const CommonAppbar(title: 'Payment Inward Advance Post')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DataTable(
                      columnSpacing: 30,
                      columns: const [
                        DataColumn(
                            label: Text("Pay ID",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Date",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Party Code",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Legal Name",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("City",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("State",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Amount",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Adjusted Amount",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Unadjusted Amount",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Ref No.",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Ref Date",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Narration",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: provider.paymentInAdvance.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['payId'] ?? "-"}')),
                          DataCell(Text('${data['Dt'] ?? "-"}')),
                          DataCell(Text('${data['lcode'] ?? "-"}')),
                          DataCell(Text('${data['lname'] ?? "-"}')),
                          DataCell(Text('${data['city'] ?? "-"}')),
                          DataCell(Text('${data['StName'] ?? "-"}')),
                          DataCell(Text('${data['amount'] ?? "-"}')),
                          DataCell(Text('${data['adjAmount'] ?? "-"}')),
                          DataCell(Text('${data['unadjusted'] ?? "-"}')),
                          DataCell(Text('${data['refNo'] ?? "-"}')),
                          DataCell(Text('${data['refDate'] ?? "-"}')),
                          DataCell(Text('${data['narration'] ?? "-"}')),
                        ]);
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1),
                        ),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(200, 50),
                      ),
                      onPressed: () async {
                        bool confirmation = await showConfirmationDialogue(
                            context,
                            "Do you want to submit the records?",
                            "SUBMIT",
                            "CANCEL");
                        if (confirmation) {
                          http.StreamedResponse result =
                              await provider.addPaymentInClear();
                          var message =
                              jsonDecode(await result.stream.bytesToString());
                          if (result.statusCode == 200) {
                            await showAlertDialog(
                                context, "Post success", "Continue", false);
                            provider.getPendingPaymentInAdvance();
                          } else if (result.statusCode == 400) {
                            await showAlertDialog(
                                context,
                                message['message'].toString(),
                                "Continue",
                                false);
                          } else if (result.statusCode == 500) {
                            await showAlertDialog(
                                context, message['message'], "Continue", false);
                          } else {
                            await showAlertDialog(
                                context, message['message'], "Continue", false);
                          }
                        }
                      },
                      child: const Text(
                        'Post',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
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
