import 'dart:convert';

import 'package:fintech_new_web/features/orderApproval/provider/order_approval_provider.dart';
import 'package:fintech_new_web/features/orderApproval/screens/add_order_approval.dart';
import 'package:fintech_new_web/features/reqProduction/provider/req_production_provider.dart';
import 'package:fintech_new_web/features/reqProduction/screens/add_req_production.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class ReqProductionPending extends StatefulWidget {
  static String routeName = "reqProductionPending";

  const ReqProductionPending({super.key});

  @override
  State<ReqProductionPending> createState() => _ReqProductionPendingState();
}

class _ReqProductionPendingState extends State<ReqProductionPending> {
  @override
  void initState() {
    ReqProductionProvider provider =
    Provider.of<ReqProductionProvider>(context, listen: false);
    provider.getReqProductionPending();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReqProductionProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Pending Req. Production')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.reqPending.isNotEmpty ? DataTable(
                    columns: const [
                      DataColumn(label: Text("Requirement ID")),
                      DataColumn(label: Text("Date")),
                      DataColumn(label: Text("Material No.")),
                      DataColumn(label: Text("Required Quantity")),
                      DataColumn(label: Text("Production Quantity")),
                      DataColumn(label: Text("Rejection Quantity")),
                      DataColumn(label: Text("Balance Quantity")),
                      DataColumn(label: Text("")),
                    ],
                    rows: provider.reqPending.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['reqId'] ?? "-"}')),
                        DataCell(Text('${data['dtDate'] ?? "-"}')),
                        DataCell(Text('${data['matno'] ?? "-"}')),
                        DataCell(Text('${data['qty'] ?? "-"}')),
                        DataCell(Text('${data['prqty'] ?? "-"}')),
                        DataCell(Text('${data['reqty'] ?? "-"}')),
                        DataCell(Text('${data['blqty'] ?? "-"}')),
                        DataCell(ElevatedButton(
                            onPressed: () {
                              context.pushNamed(AddReqProduction.routeName, queryParameters: {"details" : jsonEncode(data)});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
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
                              "Add Production",
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
