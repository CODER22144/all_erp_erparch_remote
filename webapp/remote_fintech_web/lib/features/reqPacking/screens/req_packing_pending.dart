import 'dart:convert';

import 'package:fintech_new_web/features/reqPacked/provider/req_packed_provider.dart';
import 'package:fintech_new_web/features/reqPacked/screens/add_req_packed.dart';
import 'package:fintech_new_web/features/reqPacking/provider/req_packing_provider.dart';
import 'package:fintech_new_web/features/reqPacking/screens/add_req_packing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class ReqPackingPending extends StatefulWidget {
  static String routeName = "reqPackingPending";

  const ReqPackingPending({super.key});

  @override
  State<ReqPackingPending> createState() => _ReqPackingPendingState();
}

class _ReqPackingPendingState extends State<ReqPackingPending> {
  @override
  void initState() {
    ReqPackingProvider provider =
    Provider.of<ReqPackingProvider>(context, listen: false);
    provider.getReqPackingPending();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReqPackingProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Pending Req. Packing')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.reqPending.isNotEmpty
                      ? DataTable(
                    columns: const [
                      DataColumn(label: Text("Date")),
                      DataColumn(label: Text("Material No.")),
                      DataColumn(label: Text("Production Quantity")),
                      DataColumn(label: Text("Clear Quantity")),
                      DataColumn(label: Text("Balance Quantity")),
                      DataColumn(label: Text("")),
                    ],
                    rows: provider.reqPending.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['dtDate'] ?? "-"}')),
                        DataCell(Text('${data['matno'] ?? "-"}')),
                        DataCell(Text('${data['prqty'] ?? "-"}')),
                        DataCell(Text('${data['clqty'] ?? "-"}')),
                        DataCell(Text('${data['blqty'] ?? "-"}')),
                        DataCell(ElevatedButton(
                            onPressed: () {
                              context.pushNamed(AddReqPacking.routeName,
                                  queryParameters: {
                                    "details": jsonEncode(data)
                                  });
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
                              "Add Packing",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ))),
                      ]);
                    }).toList(),
                  )
                      : const SizedBox(),
                ),
              ),
            )),
      );
    });
  }
}
