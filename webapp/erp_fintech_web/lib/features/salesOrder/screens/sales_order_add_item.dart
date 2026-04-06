import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../home.dart';
import '../../utility/global_variables.dart';
import '../provider/sales_order_provider.dart';

class SalesOrderAddItem extends StatefulWidget {
  static String routeName = "orderAddItem";
  final String orderId;
  final String custCode;
  const SalesOrderAddItem({super.key, required this.orderId, required this.custCode});

  @override
  State<SalesOrderAddItem> createState() => _SalesOrderAddItemState();
}

class _SalesOrderAddItemState extends State<SalesOrderAddItem> {
  List<List<String>> tableRows = [];

  @override
  void initState() {
    super.initState();
    tableRows.add(['', '']);
  }

  void addRow() {
    setState(() {
      tableRows.add(['', '']);
    });
  }

  // Function to delete a row
  void deleteRow(int index) {
    setState(() {
      tableRows.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Consumer<SalesOrderProvider>(builder: (context, provider, child) {
          return Scaffold(
            appBar: PreferredSize(
                preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                child: CommonAppbar(title: 'Append Item To Order : ${widget.orderId}')),
            body: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: kIsWeb
                      ? GlobalVariables.deviceWidth / 2
                      : GlobalVariables.deviceWidth,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      for (int index = 0; index < tableRows.length; index++)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8, left: 10),
                                  child: Text(
                                    "SNo. : ${index + 1}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8, right: 10),
                                  child: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      deleteRow(index);
                                    },
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                initialValue: tableRows[index][0],
                                onChanged: (value) {
                                  setState(() {
                                    tableRows[index][0] = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  label: RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "*",
                                          style: TextStyle(color: Colors.red),
                                        )
                                      ],
                                      text: "Item Code",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 0),
                                  ),
                                ),
                                validator: (String? val) {
                                  if (val == null || val.isEmpty) {
                                    return 'This field is Mandatory';
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (String? val) {
                                  if (val == null || val.isEmpty) {
                                    return 'This field is Mandatory';
                                  }
                                },
                                initialValue: tableRows[index][1],
                                onChanged: (value) {
                                  setState(() {
                                    tableRows[index][1] = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  label: RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "*",
                                          style: TextStyle(color: Colors.red),
                                        )
                                      ],
                                      text: "Quantity",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 0),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly, // Space buttons evenly
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor("#0B6EFE"),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)))),
                              onPressed: () async {
                                http.StreamedResponse result =
                                    await provider.appendItemInOrder(tableRows, widget.orderId, widget.custCode);
                                var message =
                                    jsonDecode(await result.stream.bytesToString());
                                if (result.statusCode == 200) {
                                  context.pop();
                                } else if (result.statusCode == 400) {
                                  await showAlertDialog(
                                      context,
                                      message['message'].toString(),
                                      "Continue",
                                      false);
                                } else if (result.statusCode == 500) {
                                  await showAlertDialog(
                                      context, message['message'], "Continue", false);
                                } else {
                                  await showAlertDialog(
                                      context, message['message'], "Continue", false);
                                }
                              },
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor("#0B6EFE"),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)))),
                              onPressed: addRow,
                              child: const Text('Add Row',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
