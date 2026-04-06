import 'dart:convert';

import 'package:fintech_new_web/features/billReceipt/screen/hyperlink.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../provider/product_breakup_provider.dart';
import 'create_product_breakup_details.dart';
import 'create_product_breakup_processing.dart';

class ProductBreakupDetailsTable extends StatefulWidget {
  static String routeName = "ProductBreakupDetailsTable";

  const ProductBreakupDetailsTable({super.key});

  @override
  State<ProductBreakupDetailsTable> createState() => _ProductBreakupDetailsTableState();
}

class _ProductBreakupDetailsTableState extends State<ProductBreakupDetailsTable> {
  @override
  void initState() {
    super.initState();
    ProductBreakupProvider provider =
    Provider.of<ProductBreakupProvider>(context, listen: false);
    provider.getProductBreakupByMatno();
    provider.getUnits();
    provider.getRmType();
    provider.getWorkProcess();
    provider.getAllResources();
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
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: provider.productBreakupMap.isNotEmpty,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text("Material No.")),
                              DataColumn(label: Text("Short Description")),
                              DataColumn(label: Text("Long Description")),
                              DataColumn(label: Text("List Rate")),
                              DataColumn(label: Text("Mrp")),
                              DataColumn(label: Text("Oem Rate")), // BUTTON
                              DataColumn(label: Text("Standard Pack")),
                              DataColumn(label: Text("Master Pack")),
                              DataColumn(label: Text("Jambo Pack")),
                              DataColumn(label: Text("Revision No.")),
                              DataColumn(label: Text("Gross Weight")),
                              DataColumn(label: Text("Net Weight")),
                              DataColumn(label: Text("Processing")),
                              DataColumn(label: Text("Rejection")),
                              DataColumn(label: Text("Icc")),
                              DataColumn(label: Text("Overhead")),
                              DataColumn(label: Text("Profit")),
                              DataColumn(label: Text("Status")),
                              DataColumn(label: Text("Remark")),
                              DataColumn(label: Text("")),
                              DataColumn(label: Text("")),
                              DataColumn(label: Text("")),
                            ],
                            rows: [
                              DataRow(cells: [
                                DataCell(Text('${provider.productBreakupMap['matno'] ?? ""}')),
                                DataCell(Text('${provider.productBreakupMap['sDescription'] ?? ""}')),
                                DataCell(Text('${provider.productBreakupMap['lDescription'] ?? ""}')),
                                DataCell(Text('${provider.productBreakupMap['listRate'] ?? ""}')),
                                DataCell(Text('${provider.productBreakupMap['mrp'] ?? ""}')),
                                DataCell(Text('${provider.productBreakupMap['oemRate'] ?? ""}')),
                                DataCell(Text('${provider.productBreakupMap['stdPack'] ?? ""}')),
                                DataCell(Text('${provider.productBreakupMap['mstPack'] ?? ""}')),
                                DataCell(Text('${provider.productBreakupMap['jamboPack'] ?? ""}')),
                                DataCell(Text('${provider.productBreakupMap['revisionNo'] ?? ""}')),
                                DataCell(Text('${provider.productBreakupMap['grossWeight'] ?? ""}')),
                                DataCell(Text('${provider.productBreakupMap['netWeight'] ?? ""}')),
                                DataCell(Text('${provider.productBreakupMap['processing'] ?? ""}')),
                                DataCell(Text('${provider.productBreakupMap['rejection'] ?? ""}')),
                                DataCell(Text('${provider.productBreakupMap['icc'] ?? ""}')),
                                DataCell(Text('${provider.productBreakupMap['overhead'] ?? ""}')),
                                DataCell(Text('${provider.productBreakupMap['profit'] ?? ""}')),
                                DataCell(Text('${provider.productBreakupMap['csId'] ?? ""}')),
                                DataCell(Text('${provider.productBreakupMap['remarks'] ?? ""}')),
                                DataCell(Container(
                                  margin: const EdgeInsets.all(5),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        provider.setMaterial('${provider.productBreakupMap['matno'] ?? ""}');
                                        context.pushNamed(CreateProductBreakupDetails.routeName);
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
                                        provider.setMaterial('${provider.productBreakupMap['matno'] ?? ""}');
                                        context.pushNamed(CreateProductBreakupProcessing.routeName);
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
                                            "Do you want to delete whole Product Breakup?",
                                            "SUBMIT",
                                            "CANCEL");
                                        if (confirmation) {
                                          http.StreamedResponse result =
                                          await provider.deleteProductBreakup(provider.materialController.text);
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
