import 'dart:convert';

import 'package:fintech_new_web/features/billReceipt/provider/bill_receipt_provider.dart';
import 'package:fintech_new_web/features/billReceipt/screen/hyperlink.dart';
import 'package:fintech_new_web/features/gr/screen/gr_details.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../inward/screens/inward.dart';

class BillReceipt extends StatefulWidget {
  static String routeName = "/bill-receipt";

  const BillReceipt({super.key});

  @override
  State<BillReceipt> createState() => _BillReceiptState();
}

class _BillReceiptState extends State<BillReceipt> {
  @override
  void initState() {
    BillReceiptProvider provider =
        Provider.of<BillReceiptProvider>(context, listen: false);
    provider.getPostedBillReceipt();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BillReceiptProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Bill Receipt')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Bill Receipt Id")),
                    DataColumn(label: Text("Action")),
                    DataColumn(label: Text("Bill Receipt Type")),
                    DataColumn(label: Text("Description")),
                    DataColumn(label: Text("Business Partner")),
                    DataColumn(label: Text("Bill No.")),
                    DataColumn(label: Text("Bill Date")),
                    DataColumn(label: Text("Bill Amount")),
                    DataColumn(label: Text("Carrier Type")),
                    DataColumn(label: Text("Carrier Description")),
                    DataColumn(label: Text("Mode Of Transport")),
                    DataColumn(label: Text("Transport Description")),
                    DataColumn(label: Text("Carrier Name")),
                    DataColumn(label: Text("Vehicle No")),
                    DataColumn(label: Text("Docket / GR No.")),
                    DataColumn(label: Text("Docket / GR Date")),
                    DataColumn(label: Text("No. Of Packet")),
                    DataColumn(label: Text("Action"))
                  ],
                  rows: provider.billReceiptList.map((data) {
                    return DataRow(cells: [
                      DataCell(Hyperlink(
                          text: data['brId'].toString(),
                          url:
                              data['docImage'] != null || data['docImage'] != ""
                                  ? data['docImage']
                                  : "")),
                      DataCell(ElevatedButton(
                          onPressed: () {
                            if(data['bt'] != 'G') {
                              context.pushNamed(InwardDetails.routeName, queryParameters: {
                                "grDetails" : jsonEncode(data)
                              });
                            } else {
                              context.pushNamed(GrDetails.routeName,
                                  queryParameters: {
                                    "brDetails": jsonEncode(data)
                                  });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor("#0038a8"),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5), // Square shape
                            ),
                            padding: EdgeInsets
                                .zero, // Remove internal padding to make it square
                            minimumSize: const Size(
                                80, 50), // Width and height for the button
                          ),
                          child: Text(
                             data['bt'] != 'G' ? "Post Bill" :  "Post GR",
                            style: const TextStyle(color: Colors.white),
                          ))),
                      DataCell(Text('${data['bt']}')),
                      DataCell(Text(data['btDescription'] ?? "-")),
                      DataCell(Text(data['bpName'] ?? "-")),
                      DataCell(Text(data['billNo'] ?? "-")),
                      DataCell(Text(data['billDate'] ?? "-")),
                      DataCell(Text(data['billAmount'] ?? "-")),
                      DataCell(Text(data['crtp'] ?? "-")),
                      DataCell(Text(data['crtpDescription'] ?? "-")),
                      DataCell(Text(data['transmode'] ?? "-")),
                      DataCell(Text(data['transDescription'] ?? "-")),
                      DataCell(Text(data['carrierName'] ?? "-")),
                      DataCell(Text(data['vehicleNo'] ?? "-")),
                      DataCell(Text(data['dcgrNo'] ?? "-")),
                      DataCell(Text(data['dcgrDate'] ?? "-")),
                      DataCell(Text('${data['nopkt'] ?? "0"}')),
                      DataCell(ElevatedButton(
                          onPressed: () async {
                            bool confirm =
                                await _showConfirmationDialog(context);
                            if (confirm) {
                              bool result =
                                  await provider.deleteBr(data["brId"]);
                              if (result) {
                                provider.getPostedBillReceipt();
                              } else {
                                AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text(
                                      'Cannot Delete select Bill Receipt'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('ok'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(true); // Return true
                                      },
                                    ),
                                  ],
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5), // Square shape
                            ),
                            padding: EdgeInsets
                                .zero, // Remove internal padding to make it square
                            minimumSize: const Size(
                                80, 50), // Width and height for the button
                          ),
                          child: const Text(
                            "Delete BR",
                            style: TextStyle(color: Colors.white),
                          ))),
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
