import 'dart:convert';

import 'package:fintech_new_web/features/gr/provider/gr_provider.dart';
import 'package:http/http.dart' as http;
import 'package:fintech_new_web/features/network/service/network_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';

class GrRateDifferencePending extends StatefulWidget {
  static String routeName = "grRateDiff";

  const GrRateDifferencePending({super.key});

  @override
  State<GrRateDifferencePending> createState() => _GrRateDifferencePendingState();
}

class _GrRateDifferencePendingState extends State<GrRateDifferencePending> {
  @override
  void initState() {
    GrProvider provider =
    Provider.of<GrProvider>(context, listen: false);
    provider.getGrRateDifferencePending();
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
                  child: const CommonAppbar(title: 'GR Rate Difference Pending')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.grRateDiffPending.isNotEmpty ? DataTable(
                    columns: const [
                      DataColumn(label: Text("GR No.")),
                      DataColumn(label: Text("GR Date")),
                      DataColumn(label: Text("Material No.")),
                      DataColumn(label: Text("Quantity")),
                      DataColumn(label: Text("Business Partner Name")),
                      DataColumn(label: Text("City")),
                      DataColumn(label: Text("State")),
                      DataColumn(label: Text("Gr Rate")),
                      DataColumn(label: Text("Po Rate")),
                      DataColumn(label: Text("Rate Diff.")),
                      DataColumn(label: Text("Post")),
                    ],
                    rows: provider.grRateDiffPending.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['grno'] ?? "-"}')),
                        DataCell(Text('${data['grDate'] ?? "-"}')),
                        DataCell(Text('${data['matno'] ?? "-"}')),
                        DataCell(Text('${data['grQty'] ?? "-"}')),
                        DataCell(Text('${data['bpName'] ?? "-"}')),
                        DataCell(Text('${data['bpCity'] ?? "-"}')),
                        DataCell(Text('${data['stateName'] ?? "-"}')),
                        DataCell(Text('${data['grRate'] ?? "-"}')),
                        DataCell(Text('${data['poRate'] ?? "-"}')),
                        DataCell(Text('${data['rateDiff'] ?? "-"}')),
                        DataCell(ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                          onPressed: () async {
                            bool confirmation =
                            await showConfirmationDialogue(
                                context,
                                "Do you want to create Debit Note Against GR: ${data['grno'] ?? "-"}?",
                                "SUBMIT",
                                "CANCEL");
                            if(confirmation) {
                              NetworkService networkService = NetworkService();
                              http.StreamedResponse response = await networkService.post("/debit-note-rate-diff/", {"grno" : '${data['grno'] ?? "-"}'});
                              if(response.statusCode == 200) {
                                provider.getGrRateDifferencePending();
                              } else {
                                var message = jsonDecode(
                                    await response.stream.bytesToString());
                                await showAlertDialog(context,
                                    message['message'], "Continue", false);
                              }
                            }
                          },
                          child: const Text(
                            'Post Debit Note',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.white),
                          ),
                        )),
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
