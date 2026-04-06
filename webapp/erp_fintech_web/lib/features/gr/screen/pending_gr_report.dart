import 'dart:convert';

import 'package:fintech_new_web/features/gr/provider/gr_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../billReceipt/screen/hyperlink.dart';
import '../../common/widgets/comman_appbar.dart';
import '../../inward/screens/inward.dart';

class PendingGrReport extends StatefulWidget {
  static String routeName = "/pendingGrRep";
  const PendingGrReport({super.key});

  @override
  State<PendingGrReport> createState() => _PendingGrReportState();
}

class _PendingGrReportState extends State<PendingGrReport> {

  @override
  void initState() {
    GrProvider provider =
    Provider.of<GrProvider>(context, listen: false);
    provider.getPendingGr();
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
                  child: const CommonAppbar(title: 'Pending GR Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: provider.grPending.isNotEmpty ? DataTable(
                      columns: const [
                        DataColumn(label: Text("GR No.")),
                        DataColumn(label: Text("GR Date")),
                        DataColumn(label: Text("Bill Receipt ID")),
                        DataColumn(label: Text("Post")),
                        DataColumn(label: Text("Business Partner")),
                        DataColumn(label: Text("Address")),
                        DataColumn(label: Text("Quantity")),
                        DataColumn(label: Text("Amount")),
                        DataColumn(label: Text("GST Amount")),
                        DataColumn(label: Text("Total Amount")),
                      ],
                      rows: provider.grPending.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['grno'] ?? "-"}')),
                          DataCell(Text('${data['dgrDate'] ?? "-"}')),
                          DataCell(Hyperlink(
                              text: data['brid'].toString(),
                              url: data['docImage'] ?? "")),
                          DataCell(ElevatedButton(
                              onPressed: () {
                                context.pushNamed(InwardDetails.routeName, queryParameters: {
                                  "grDetails" : jsonEncode(data),
                                  "disable" : "true"
                                });
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
                              child: const Text(
                                "Post GR",
                                style: TextStyle(color: Colors.white),
                              ))),
                          DataCell(Text('${data['bpName'] ?? "-"}')),
                          DataCell(Text('${data['bpCity'] ?? "-"} - ${data['stateName'] ?? "-"}')),
                          DataCell(Text('${data['sumgrQty'] ?? "0"}')),
                          DataCell(Text('${data['sumgrAmount'] ?? "0"}')),
                          DataCell(Text('${data['sumgstAmount'] ?? "0"}')),
                          DataCell(Text('${data['sumtAmount'] ?? "0"}')),
                        ]);
                      }).toList(),
                    ) : const SizedBox(),
                  ),
                ),
              ),
            )),
      );
    });
  }
}
