import 'dart:convert';

import 'package:fintech_new_web/features/grQtyClear/provider/gr_qty_clear_provider.dart';
import 'package:fintech_new_web/features/grQtyClear/screens/add_gr_qty_clear.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class GrQtyClearPending extends StatefulWidget {
  static String routeName = "grQtyClear";

  const GrQtyClearPending({super.key});

  @override
  State<GrQtyClearPending> createState() => _GrQtyClearPendingState();
}

class _GrQtyClearPendingState extends State<GrQtyClearPending> {
  @override
  void initState() {
    GrQtyClearProvider provider =
    Provider.of<GrQtyClearProvider>(context, listen: false);
    provider.getGrQtyClearPending();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GrQtyClearProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'GR Qty Clear Pending')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.grQtyClearPending.isNotEmpty ? DataTable(
                    columns: const [
                      DataColumn(label: Text("Id")),
                      DataColumn(label: Text("GR No.")),
                      DataColumn(label: Text("GR Date")),
                      DataColumn(label: Text("Business Partner Name")),
                      DataColumn(label: Text("Material No.")),
                      DataColumn(label: Text("Quantity")),
                      DataColumn(label: Text("Post IQS")),
                    ],
                    rows: provider.grQtyClearPending.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['grdId'] ?? "-"}')),
                        DataCell(Text('${data['grno'] ?? "-"}')),
                        DataCell(Text('${data['grDate'] ?? "-"}')),
                        DataCell(Text('${data['bpName'] ?? "-"}')),
                        DataCell(Text('${data['matno'] ?? "-"}')),
                        DataCell(Text('${data['grQty'] ?? "-"}')),
                        DataCell(ElevatedButton(
                            onPressed: () {
                              context.pushNamed(AddGrQtyClear.routeName, queryParameters: {
                                "details" : jsonEncode(data)
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
                              "Post GR Qty Clear",
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
