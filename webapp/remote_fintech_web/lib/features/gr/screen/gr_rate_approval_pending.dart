import 'dart:convert';

import 'package:fintech_new_web/features/billReceipt/provider/bill_receipt_provider.dart';
import 'package:fintech_new_web/features/billReceipt/screen/hyperlink.dart';
import 'package:fintech_new_web/features/gr/provider/gr_provider.dart';
import 'package:fintech_new_web/features/gr/screen/add_gr_rate_approval.dart';
import 'package:fintech_new_web/features/gr/screen/gr_details.dart';
import 'package:fintech_new_web/features/grIqsRep/screens/add_gr_iqs_rep.dart';
import 'package:fintech_new_web/features/grQtyClear/provider/gr_qty_clear_provider.dart';
import 'package:fintech_new_web/features/grQtyClear/screens/add_gr_qty_clear.dart';
import 'package:fintech_new_web/features/network/service/network_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class GrRateApprovalPending extends StatefulWidget {
  static String routeName = "grRateApprovalPending";

  const GrRateApprovalPending({super.key});

  @override
  State<GrRateApprovalPending> createState() => _GrRateApprovalPendingState();
}

class _GrRateApprovalPendingState extends State<GrRateApprovalPending> {
  @override
  void initState() {
    GrProvider provider =
    Provider.of<GrProvider>(context, listen: false);
    provider.getGrRateApprovalPending();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GrProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'GR Rate Approval Pending')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.grRateApprovalPending.isNotEmpty ? DataTable(
                    columns: const [
                      DataColumn(label: Text("GR No.")),
                      DataColumn(label: Text("GR Date")),
                      DataColumn(label: Text("Bill No.")),
                      DataColumn(label: Text("Bill Date")),
                      DataColumn(label: Text("Business Partner Name")),
                      DataColumn(label: Text("Material No.")),
                      DataColumn(label: Text("Gr Quantity")),
                      DataColumn(label: Text("Gr Rate")),
                      DataColumn(label: Text("Po Rate")),
                      DataColumn(label: Text("Rate Diff.")),
                      DataColumn(label: Text("Rate Approval")),
                    ],
                    rows: provider.grRateApprovalPending.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['grno'] ?? "-"}')),
                        DataCell(Text('${data['grDate'] ?? "-"}')),
                        DataCell(Text('${data['billNo'] ?? "-"}')),
                        DataCell(Text('${data['billDate'] ?? "-"}')),
                        DataCell(Text('${data['bpName'] ?? "-"}')),
                        DataCell(Text('${data['matno'] ?? "-"}')),
                        DataCell(Text('${data['grQty'] ?? "-"}')),
                        DataCell(Text('${data['grRate'] ?? "-"}')),
                        DataCell(Text('${data['poRate'] ?? "-"}')),
                        DataCell(Text('${data['rateDiff'] ?? "-"}')),
                        DataCell(ElevatedButton(
                            onPressed: () {
                              context.pushNamed(AddGrRateApproval.routeName, queryParameters: {
                                "rateDetails" : jsonEncode(data)
                              });
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
                              "Approve Rate",
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
}
