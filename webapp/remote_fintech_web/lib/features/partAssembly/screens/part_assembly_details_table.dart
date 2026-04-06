import 'dart:convert';

import 'package:fintech_new_web/features/billReceipt/screen/hyperlink.dart';
import 'package:fintech_new_web/features/partAssembly/provider/part_assembly_provider.dart';
import 'package:fintech_new_web/features/partAssembly/screens/create_part_assembly_details.dart';
import 'package:fintech_new_web/features/partAssembly/screens/create_part_assembly_processing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';

class PartAssemblyDetailsTable extends StatefulWidget {
  static String routeName = "partAssemblyDetailsTable";

  const PartAssemblyDetailsTable({super.key});

  @override
  State<PartAssemblyDetailsTable> createState() => _PartAssemblyDetailsTableState();
}

class _PartAssemblyDetailsTableState extends State<PartAssemblyDetailsTable> {
  @override
  void initState() {
    super.initState();
    PartAssemblyProvider provider =
    Provider.of<PartAssemblyProvider>(context, listen: false);
    provider.getPartAssemblyByMatno();
    provider.getUnits();
    provider.getRmType();
    provider.getWorkProcess();
    provider.getAllResources();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartAssemblyProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Part Assembly Details')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: provider.partAssemblyMap.isNotEmpty,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text("Material No.")),
                              DataColumn(label: Text("Picture")),
                              DataColumn(label: Text("Drawing")),
                              DataColumn(label: Text("As Drawing")),
                              DataColumn(label: Text("Revision No")),
                              DataColumn(label: Text("Status")), // BUTTON
                              DataColumn(label: Text("")),
                              DataColumn(label: Text("")),
                              DataColumn(label: Text("")),
                            ],
                            rows: [
                              DataRow(cells: [
                                DataCell(Text('${provider.partAssemblyMap['matno'] ?? ""}')),
                                DataCell(Hyperlink(text: "${provider.partAssemblyMap['pic'] ?? '-'}", url: provider.partAssemblyMap['pic'] ?? "-")),
                                DataCell(Hyperlink(text: "${provider.partAssemblyMap['drawing'] ?? '-'}", url: provider.partAssemblyMap['drawing'] ?? "-")),
                                DataCell(Hyperlink(text: "${provider.partAssemblyMap['asdrawing'] ?? '-'}", url: provider.partAssemblyMap['asdrawing'] ?? "-")),
                                DataCell(Text('${provider.partAssemblyMap['revisionNo'] ?? ""}')),
                                DataCell(Text('${provider.partAssemblyMap['csId'] ?? ""}')),
                                DataCell(Container(
                                  margin: const EdgeInsets.all(5),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        provider.setMaterial('${provider.partAssemblyMap['matno'] ?? ""}');
                                        context.pushNamed(CreatePartAssemblyDetails.routeName);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: HexColor("#183D41"),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(1), // Square shape
                                        ),
                                        padding: EdgeInsets.zero,
                                        // Remove internal padding to make it square
                                        minimumSize: const Size(
                                            140, 50), // Width and height for the button
                                      ),
                                      child: const Text(
                                        "Add/Delete Part Details",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                )),
                                DataCell(Container(
                                  margin: const EdgeInsets.all(5),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        provider.setMaterial('${provider.partAssemblyMap['matno'] ?? ""}');
                                        context.pushNamed(CreatePartAssemblyProcessing.routeName);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: HexColor("#183D41"),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(1), // Square shape
                                        ),
                                        padding: EdgeInsets.zero,
                                        // Remove internal padding to make it square
                                        minimumSize: const Size(
                                            140, 50), // Width and height for the button
                                      ),
                                      child: const Text(
                                        "Add/Delete Processing Details",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                )),
                                DataCell(Container(
                                  margin: const EdgeInsets.all(5),
                                  child: ElevatedButton(
                                      onPressed: () async {

                                        bool confirmation =
                                        await showConfirmationDialogue(
                                            context,
                                            "Do you want to delete whole Part Assembly details?",
                                            "SUBMIT",
                                            "CANCEL");
                                        if (confirmation) {
                                          http.StreamedResponse result =
                                          await provider.deletePartAssembly(provider.materialController.text);
                                          if (result.statusCode == 204) {
                                            context.pop();
                                          } else if (result.statusCode == 400) {
                                            var message = jsonDecode(
                                                await result.stream.bytesToString());
                                            await showAlertDialog(
                                                context,
                                                message['message'].toString(),
                                                "Continue",
                                                false);
                                          } else if (result.statusCode == 500) {
                                            var message = jsonDecode(
                                                await result.stream.bytesToString());
                                            await showAlertDialog(context,
                                                message['message'], "Continue", false);
                                          } else {
                                            var message = jsonDecode(
                                                await result.stream.bytesToString());
                                            await showAlertDialog(context,
                                                message['message'], "Continue", false);
                                          }
                                        }

                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(1), // Square shape
                                        ),
                                        padding: EdgeInsets.zero,
                                        // Remove internal padding to make it square
                                        minimumSize: const Size(
                                            120, 50), // Width and height for the button
                                      ),
                                      child: const Text(
                                        "Delete Whole part",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                )),
                              ])
                            ],
                          ),
                        ),
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
