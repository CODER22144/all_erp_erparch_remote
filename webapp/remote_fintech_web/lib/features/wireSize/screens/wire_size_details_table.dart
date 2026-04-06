import 'dart:convert';

import 'package:fintech_new_web/features/billReceipt/screen/hyperlink.dart';
import 'package:fintech_new_web/features/wireSize/provider/wire_size_provider.dart';
import 'package:fintech_new_web/features/wireSize/screens/add_wire_size_details.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import 'edit_wire_size.dart';
import 'edit_wire_size_details.dart';

class WireSizeDetailsTable extends StatefulWidget {
  static String routeName = "wireSizeDetailsTable";

  const WireSizeDetailsTable({super.key});

  @override
  State<WireSizeDetailsTable> createState() => _WireSizeDetailsTableState();
}

class _WireSizeDetailsTableState extends State<WireSizeDetailsTable> {
  @override
  void initState() {
    super.initState();
    WireSizeProvider provider =
    Provider.of<WireSizeProvider>(context, listen: false);
    provider.getWireSizeDetailsByMatno();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WireSizeProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Wire Size Details')),
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
                          columns: const [
                            DataColumn(label: Text("Material No.")),
                            DataColumn(label: Text("Cost Status")),
                            DataColumn(label: Text("Material Drawing")),
                            DataColumn(label: Text("Joint Drawing")),
                            DataColumn(label: Text("")), // BUTTON
                            DataColumn(label: Text("")),
                            DataColumn(label: Text("")),
                          ],
                          rows: [
                            DataRow(cells: [
                              DataCell(Text('${provider.wireSizeDesc['matno'] ?? ""}')),
                              DataCell(Text('${provider.wireSizeDesc['csId'] ?? ""}')),
                              DataCell(Hyperlink(text: "${provider.wireSizeDesc['matDrawing'] ?? '-'}", url: provider.wireSizeDesc['matDrawing'] ?? "-")),
                              DataCell(Hyperlink(text: "${provider.wireSizeDesc['jointDrawing'] ?? '-'}", url: provider.wireSizeDesc['jointDrawing'] ?? "-")),
                              DataCell(Container(
                                margin: const EdgeInsets.all(5),
                                child: ElevatedButton(
                                    onPressed: () {
                                      context.pushNamed(AddWireSizeDetails.routeName);
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
                                          120, 50), // Width and height for the button
                                    ),
                                    child: const Text(
                                      "Add Wire Size Details",
                                      style: TextStyle(color: Colors.white),
                                    )),
                              )),
                              DataCell(Container(
                                margin: const EdgeInsets.all(5),
                                child: ElevatedButton(
                                    onPressed: () {
                                      context.pushNamed(EditWireSize.routeName, queryParameters: {
                                        "editData" : jsonEncode(provider.wireSizeDesc)
                                      });
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
                                          120, 50), // Width and height for the button
                                    ),
                                    child: const Text(
                                      "Edit Wire Size Master",
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
                                          "Do you want to delete whole wire size details?",
                                          "SUBMIT",
                                          "CANCEL");
                                      if (confirmation) {
                                        http.StreamedResponse result =
                                        await provider.deleteFullWireSizeDetails(provider.materialController.text);
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
                                      backgroundColor: HexColor("#183D41"),
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
                                      "Delete Whole Wire Size Record",
                                      style: TextStyle(color: Colors.white),
                                    )),
                              )),
                            ])
                          ],
                        ),

                        const SizedBox(height: 20),

                        DataTable(
                          columns: const [
                            DataColumn(label: Text("Wire Size")),
                            DataColumn(label: Text("Material No.")),
                            DataColumn(label: Text("Part No.")),
                            DataColumn(label: Text("Color")),
                            DataColumn(label: Text("Wire Length")),
                            DataColumn(label: Text("Left SL")),
                            DataColumn(label: Text("Left PL")),
                            DataColumn(label: Text("Right SL")),
                            DataColumn(label: Text("Right PL")),
                            DataColumn(label: Text("Left LT")),
                            DataColumn(label: Text("Right LT")),
                            DataColumn(label: Text("Left Cap")),
                            DataColumn(label: Text("Right Cap")),
                            DataColumn(label: Text("Left Sleeve")),
                            DataColumn(label: Text("Right Sleeve")),
                            DataColumn(label: Text("JWire no.")),
                            DataColumn(label: Text("JTL")),
                            DataColumn(label: Text("")), // BUTTON
                            DataColumn(label: Text("")),
                          ],
                          rows: provider.listWireSizeDetails.map((data) {
                            return DataRow(cells: [
                              DataCell(Text('${data['wireNo'] ?? ""}')),
                              DataCell(Text('${provider.wireSizeDesc['matno'] ?? ""}')),
                              DataCell(Text('${data['partNo'] ?? ""}')),
                              DataCell(Text('${data['colName'] ?? ""}')),
                              DataCell(Text('${data['wlength'] ?? ""}')),
                              DataCell(Text('${data['leftSL'] ?? ""}')),
                              DataCell(Text('${data['leftPL'] ?? ""}')),
                              DataCell(Text('${data['rightSL'] ?? ""}')),
                              DataCell(Text('${data['rightPL'] ?? ""}')),
                              DataCell(Text('${data['leftTL'] ?? ""}')),
                              DataCell(Text('${data['rightTL'] ?? ""}')),
                              DataCell(Text('${data['leftCap'] ?? ""}')),
                              DataCell(Text('${data['rightCap'] ?? ""}')),
                              DataCell(Text('${data['leftSleeve'] ?? ""}')),
                              DataCell(Text('${data['rightSleeve'] ?? ""}')),
                              DataCell(Text('${data['jWireNo'] ?? ""}')),
                              DataCell(Text('${data['jTL'] ?? ""}')),
                              DataCell(Container(
                                margin: const EdgeInsets.all(5),
                                child: ElevatedButton(
                                    onPressed: () {
                                      context.pushNamed(EditWireSizeDetails.routeName, queryParameters: {
                                        "editData" : jsonEncode(data)
                                      });
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
                                          100, 50), // Width and height for the button
                                    ),
                                    child: const Text(
                                      "Edit Wire Details",
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
                                          "Do you wish to delete Wire: ${data['wireNo']} ?",
                                          "SUBMIT",
                                          "CANCEL");
                                      if (confirmation) {
                                        http.StreamedResponse result =
                                        await provider.deleteSpecificWireSizeDetails(data['wireNo']);
                                        if (result.statusCode == 204) {
                                          provider.getWireSizeDetailsByMatno();
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
                                      backgroundColor: HexColor("#183D41"),
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
                                      "Delete Wire Details",
                                      style: TextStyle(color: Colors.white),
                                    )),
                              )),
                            ]);
                          }).toList(),
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
