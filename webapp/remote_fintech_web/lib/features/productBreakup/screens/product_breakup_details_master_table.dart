import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../provider/product_breakup_provider.dart';

class ProductBreakupDetailsMasterTable extends StatefulWidget {
  static String routeName = "ProductBreakupDetailsMasterTable";
  const ProductBreakupDetailsMasterTable({super.key});

  @override
  State<ProductBreakupDetailsMasterTable> createState() =>
      _ProductBreakupDetailsMasterTableState();
}

class _ProductBreakupDetailsMasterTableState
    extends State<ProductBreakupDetailsMasterTable> {

  @override
  void initState() {
    super.initState();
    ProductBreakupProvider provider =
        Provider.of<ProductBreakupProvider>(context, listen: false);
    provider.getProductBreakupDetailsByMatno();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductBreakupProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
                preferredSize:
                    Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                child: const CommonAppbar(title: 'Product Breakup Details')),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Visibility(
                  visible: provider.productBreakupDetailsList.isNotEmpty,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("Material No.")),
                      DataColumn(label: Text("Part No.")),
                      DataColumn(label: Text("Quantity")),
                      DataColumn(label: Text("Part Length")),
                      DataColumn(label: Text("Unit")),
                      DataColumn(label: Text("Total No.")),
                      DataColumn(label: Text("Raw Material Type")),
                      DataColumn(label: Text("")),
                    ],
                    rows: provider.productBreakupDetailsList.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['matno'] ?? ""}')),
                        DataCell(Text('${data['partNo'] ?? ""}')),
                        DataCell(Text('${data['qty'] ?? ""}')),
                        DataCell(Text('${data['pLength'] ?? ""}')),
                        DataCell(Text('${data['unit'] ?? ""}')),
                        DataCell(Text('${data['tno'] ?? ""}')),
                        DataCell(Text('${data['rmType'] ?? ""}')),
                        DataCell(Container(
                          margin: const EdgeInsets.all(5),
                          child: ElevatedButton(
                              onPressed: () async {
                                bool confirmation = await showConfirmationDialogue(
                                    context,
                                    "Do you wish to delete Product Breakup Detail: ${data['pbdId']} ?",
                                    "SUBMIT",
                                    "CANCEL");
                                if (confirmation) {
                                  http.StreamedResponse result =
                                  await provider.deleteProductBreakupDetails('${data['pbdId'] ?? ""}');
                                  if (result.statusCode == 204) {
                                    provider.getProductBreakupDetailsByMatno();
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
                                "Delete Processing",
                                style: TextStyle(color: Colors.white),
                              )),
                        )),
                      ]);
                    }).toList(),
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
