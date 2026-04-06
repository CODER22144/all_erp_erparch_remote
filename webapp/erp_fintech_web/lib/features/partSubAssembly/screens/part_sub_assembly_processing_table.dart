import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../provider/part_sub_assembly_provider.dart';

class PartSubAssemblyProcessingTable extends StatefulWidget {
  static String routeName = "PartSubAssemblyProcessingTable";
  const PartSubAssemblyProcessingTable({super.key});

  @override
  State<PartSubAssemblyProcessingTable> createState() => _PartSubAssemblyProcessingTableState();
}

class _PartSubAssemblyProcessingTableState extends State<PartSubAssemblyProcessingTable> {

  @override
  void initState() {
    super.initState();
    PartSubAssemblyProvider provider =
    Provider.of<PartSubAssemblyProvider>(context, listen: false);
    provider.getPartSubAssemblyProcessingByMatno();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<PartSubAssemblyProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
                preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                child: const CommonAppbar(title: 'Part Sub Assembly Processing Details')),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Visibility(
                  visible: provider.partSubAssemblyProcessingList.isNotEmpty,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("Material No.")),
                      DataColumn(label: Text("Work Process")),
                      DataColumn(label: Text("Order By")),
                      DataColumn(label: Text("Resource")),
                      DataColumn(label: Text("Quantity")),
                      DataColumn(label: Text("Day Production")),
                      DataColumn(label: Text("")),
                    ],
                    rows: provider.partSubAssemblyProcessingList.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['matno'] ?? ""}')),
                        DataCell(Text('${data['wpId'] ?? ""}')),
                        DataCell(Text('${data['orderBy'] ?? ""}')),
                        DataCell(Text('${data['rId'] ?? ""}')),
                        DataCell(Text('${data['rQty'] ?? ""}')),
                        DataCell(Text('${data['dayProduction'] ?? ""}')),
                        DataCell(Container(
                          margin: const EdgeInsets.all(5),
                          child: ElevatedButton(
                              onPressed: () async {

                                bool confirmation =
                                await showConfirmationDialogue(
                                    context,
                                    "Do you wish to delete Part Assembly Processing: ${data['psapId']} ?",
                                    "SUBMIT",
                                    "CANCEL");
                                if (confirmation) {
                                  http.StreamedResponse result =
                                  await provider.deletePartSubAssemblyProcessing('${data['psapId'] ?? ""}');
                                  if (result.statusCode == 204) {
                                    provider.getPartSubAssemblyProcessingByMatno();
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
                                    100, 50), // Width and height for the button
                              ),
                              child: const Text(
                                "Delete Part Processing",
                                style: TextStyle(color: Colors.white),
                              )),
                        )),
                      ]);}).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
