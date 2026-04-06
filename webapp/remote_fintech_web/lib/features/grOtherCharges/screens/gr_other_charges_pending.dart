import 'dart:convert';

import 'package:fintech_new_web/features/grOtherCharges/provider/gr_other_charges_provider.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';

class GrOtherChargesPending extends StatefulWidget {
  static String routeName = "GrOtherChargesPending";

  const GrOtherChargesPending({super.key});

  @override
  State<GrOtherChargesPending> createState() => _GrOtherChargesPendingState();
}

class _GrOtherChargesPendingState extends State<GrOtherChargesPending> {
  @override
  void initState() {
    GrOtherChargesProvider provider =
        Provider.of<GrOtherChargesProvider>(context, listen: false);
    provider.getGrOtherChargesPending();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GrOtherChargesProvider>(
        builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'GR Other Charges Pending')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Visibility(
                visible: provider.grOtherChargesPending.isNotEmpty,
                child: DataTable(
                  columnSpacing: 25,
                  columns: const [
                    DataColumn(label: Text("GR No.")),
                    DataColumn(label: Text("Trans Date")),
                    DataColumn(label: Text("Party Name")),
                    DataColumn(label: Text("Bill No.")),
                    DataColumn(label: Text("Bill Date")),
                    DataColumn(label: Text("Charge Name")),
                    DataColumn(label: Text("Hsn Code")),
                    DataColumn(label: Text("Gst Tax Rate")),
                    DataColumn(label: Text("Gst Amount")),
                    DataColumn(label: Text("Amount")),
                    DataColumn(label: Text("Approved By")),
                    DataColumn(label: Text("")),
                  ],
                  rows: provider.grOtherChargesPending.map((data) {
                    return DataRow(cells: [
                      DataCell(Text('${data['grno'] ?? "-"}')),
                      DataCell(Text('${data['dtranDate'] ?? "-"}')),
                      DataCell(Text('${data['bpName'] ?? "-"}')),
                      DataCell(Text('${data['billNo'] ?? "-"}')),
                      DataCell(Text('${data['dbillDate'] ?? "-"}')),
                      DataCell(Text('${data['chargeName'] ?? "-"}')),
                      DataCell(Text('${data['hsnCode'] ?? "-"}')),
                      DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['gstTaxRate']}')))),
                      DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['gstAmount']}')))),
                      DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['amount']}')))),
                      DataCell(Text('${data['approvedBy'] ?? "-"}')),
                      DataCell(ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                        onPressed: () async {
                          bool confirmation = await showConfirmationDialogue(
                              context,
                              "Do you want to Approve Charges for GR No : ${data['grno'] ?? "-"}?",
                              "SUBMIT",
                              "CANCEL");
                          if (confirmation) {
                            NetworkService networkService = NetworkService();
                            http.StreamedResponse response =
                                await networkService.post(
                                    "/approve-gr-other-charges/",
                                    {"grno": '${data['grno'] ?? "-"}'});
                            if (response.statusCode == 200) {
                              provider.getGrOtherChargesPending();
                            } else if (response.statusCode == 400) {
                              var message = jsonDecode(
                                  await response.stream.bytesToString());
                              await showAlertDialog(
                                  context,
                                  message['message'].toString(),
                                  "Continue",
                                  false);
                            } else {
                              var message = jsonDecode(
                                  await response.stream.bytesToString());
                              await showAlertDialog(context, message['message'],
                                  "Continue", false);
                            }
                          }
                        },
                        child: const Text(
                          'Approve',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                      )),
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
}
