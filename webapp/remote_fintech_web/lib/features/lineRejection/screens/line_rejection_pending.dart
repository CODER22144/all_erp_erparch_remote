import 'dart:convert';

import 'package:fintech_new_web/features/gr/provider/gr_provider.dart';
import 'package:fintech_new_web/features/lineRejection/provider/line_rejection_provider.dart';
import 'package:fintech_new_web/features/network/service/network_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';

class LineRejectionPending extends StatefulWidget {
  static String routeName = "LineRejectionPending";

  const LineRejectionPending({super.key});

  @override
  State<LineRejectionPending> createState() => _LineRejectionPendingState();
}

class _LineRejectionPendingState extends State<LineRejectionPending> {
  @override
  void initState() {
    LineRejectionProvider provider =
        Provider.of<LineRejectionProvider>(context, listen: false);
    provider.getLineRejectionPending();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LineRejectionProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Line Rejection Pending')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: provider.rejPending.isNotEmpty
                  ? DataTable(
                      columns: const [
                        DataColumn(label: Text("Trans Date")),
                        DataColumn(label: Text("Bp Code")),
                        DataColumn(label: Text("Bp Name")),
                        DataColumn(label: Text("City")),
                        DataColumn(label: Text("State")),
                        DataColumn(label: Text("Material")),
                        DataColumn(label: Text("Qty")),
                        DataColumn(label: Text("")),
                      ],
                      rows: provider.rejPending.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['dtDate'] ?? "-"}')),
                          DataCell(Text('${data['bpCode'] ?? "-"}')),
                          DataCell(Text('${data['bpName'] ?? "-"}')),
                          DataCell(Text('${data['bpCity'] ?? "-"}')),
                          DataCell(Text('${data['stateName'] ?? "-"}')),
                          DataCell(Text('${data['matno'] ?? "-"}')),
                          DataCell(Text('${data['qty'] ?? "-"}')),
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
                                      "Do you want to Delete Line Rejection?",
                                      "SUBMIT",
                                      "CANCEL");
                              if (confirmation) {
                                NetworkService networkService =
                                    NetworkService();
                                http.StreamedResponse response =
                                    await networkService.post(
                                        "/delete-line-rejection/",
                                        {"id": data['id']});
                                if (response.statusCode == 200) {
                                  provider.getLineRejectionPending();
                                } else {
                                  var message = jsonDecode(
                                      await response.stream.bytesToString());
                                  await showAlertDialog(context,
                                      message['message'], "Continue", false);
                                }
                              }
                            },
                            child: const Icon(Icons.delete_outline, color: Colors.white),
                          )),
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
