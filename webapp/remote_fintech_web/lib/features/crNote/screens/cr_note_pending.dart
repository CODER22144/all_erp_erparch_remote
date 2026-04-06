import 'dart:convert';

import 'package:fintech_new_web/features/dbNote/provider/dbnote_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../provider/cr_note_provider.dart';

class CrNotePending extends StatefulWidget {
  static String routeName = "CrNotePending";

  const CrNotePending({super.key});

  @override
  State<CrNotePending> createState() => _CrNotePendingState();
}

class _CrNotePendingState extends State<CrNotePending> {
  @override
  void initState() {
    super.initState();
    CrNoteProvider provider =
    Provider.of<CrNoteProvider>(context, listen: false);
    provider.getCrNotePostPending();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CrNoteProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Credit Note Post Pending')),
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
                                label: Text("Doc Id",
                                    style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("DBN No.",
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
                                label: Text("Loc",
                                    style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("State",
                                    style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("Total Value",
                                    style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("Adjusted Amount",
                                    style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("Unadjusted Amount",
                                    style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: provider.crNotePostPending.map((data) {
                            return DataRow(cells: [
                              DataCell(Text('${data['docId'] ?? "-"}')),
                              DataCell(Text('${data['No'] ?? "-"}')),
                              DataCell(Text('${data['Dt'] ?? "-"}')),
                              DataCell(Text('${data['lcode'] ?? "-"}')),
                              DataCell(Text('${data['LglNm'] ?? "-"}')),
                              DataCell(Text('${data['Loc'] ?? "-"}')),
                              DataCell(Text('${data['StName'] ?? ""}')),
                              DataCell(Text('${data['TotVal'] ?? ""}')),
                              DataCell(Text('${data['adjAmount'] ?? ""}')),
                              DataCell(Text('${data['unadjusted'] ?? ""}'))
                            ]);
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {

                            bool confirmation = await showConfirmationDialogue(
                                context,
                                "Do you want to submit the records?",
                                "SUBMIT",
                                "CANCEL");
                            if (confirmation) {
                              http.StreamedResponse result =
                              await provider.processClearFormInfo();
                              var message =
                              jsonDecode(await result.stream.bytesToString());
                              if (result.statusCode == 200) {
                                await showAlertDialog(
                                    context,
                                    "Post success",
                                    "Continue",
                                    false);
                                provider.getCrNotePostPending();
                              } else if (result.statusCode == 400) {
                                await showAlertDialog(
                                    context,
                                    message['message'].toString(),
                                    "Continue",
                                    false);
                              } else if (result.statusCode == 500) {
                                await showAlertDialog(context,
                                    message['message'], "Continue", false);
                              } else {
                                await showAlertDialog(context,
                                    message['message'], "Continue", false);
                              }

                            }
                          },
                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            Colors.blueAccent,
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                  1),
                            ),
                            padding: EdgeInsets.zero,
                            minimumSize:
                            const Size(200, 50),
                          ),
                          child: const Text('Post',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white)),
                        )
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
