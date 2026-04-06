import 'dart:convert';

import 'package:fintech_new_web/features/bpBreakup/provider/bp_breakup_provider.dart';
import 'package:fintech_new_web/features/bpBreakup/screens/bp_breakup.dart';
import 'package:fintech_new_web/features/exportOrder/provider/export_order_provider.dart';
import 'package:fintech_new_web/features/exportOrder/screens/add_export_order.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';

class GetExportOrder extends StatefulWidget {
  static String routeName = 'GetExportOrder';
  final bool delete;
  const GetExportOrder({super.key, required this.delete});

  @override
  State<GetExportOrder> createState() => _GetExportOrderState();
}

class _GetExportOrderState extends State<GetExportOrder> {
  late ExportOrderProvider provider;

  @override
  void initState() {
    super.initState();
    provider =
        Provider.of<ExportOrderProvider>(context, listen: false);
    provider.editController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExportOrderProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: PreferredSize(
                preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                child: CommonAppbar(title: widget.delete ? "Delete Export Order" : "Update Export Order")),
            body: SingleChildScrollView(
              child: Center(
                child: Container(
                  width: kIsWeb
                      ? GlobalVariables.deviceWidth / 2.0
                      : GlobalVariables.deviceWidth,
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    // key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                            readOnly: false,
                            controller: provider.editController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                              ),
                              label: RichText(
                                text: const TextSpan(
                                  text: "Order Id",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  children: [
                                    TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ],
                                ),
                              ),
                            ),
                            validator: (String? val) {
                              if ((val == null || val.isEmpty)) {
                                return 'This field is Mandatory';
                              }
                            },
                            maxLines: 1,
                          ),
                        ),


                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10, top: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#0B6EFE"),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                            onPressed: () async {
                              if(widget.delete) {
                                NetworkService networkService = NetworkService();
                                http.StreamedResponse response = await networkService.post("/get-export-order/" , {"orderId" : provider.editController.text});
                                if(response.statusCode == 200) {
                                  _showTablePopup(context, jsonDecode(await response.stream.bytesToString()));
                                }
                              } else {
                                context.pushNamed(AddExportOrder.routeName, queryParameters: {
                                  "editing" : "true"
                                });
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
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _showTablePopup(BuildContext context, List<dynamic> orderBalance) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Business Partner Breakup',
              style: TextStyle(fontWeight: FontWeight.w500)),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('Order Id')),
                      DataColumn(label: Text('Currency')),
                      DataColumn(label: Text('Con. Rate')),
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Terms Of Delivery')),
                      DataColumn(label: Text('Lut No.')),
                      DataColumn(label: Text('Pre Carriage Mode')),
                      DataColumn(label: Text('Place Of Receipt')),
                      DataColumn(label: Text('Port Of Loading')),
                      DataColumn(label: Text('Port Of Discharge')),
                      DataColumn(label: Text('Final Destination')),
                      DataColumn(label: Text('Cost')),
                      DataColumn(label: Text('Insurance')),
                      DataColumn(label: Text('Freight')),
                      DataColumn(label: Text('No. of Packet')),
                      DataColumn(label: Text('GWT')),
                      DataColumn(label: Text('NWT')),
                      DataColumn(label: Text('')),
                    ],
                    rows: orderBalance.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['orderId'] ?? "-"}')),
                        DataCell(Text('${data['curCode'] ?? "-"}')),
                        DataCell(Text('${data['conRate'] ?? "-"}')),
                        DataCell(Text('${data['goodsDescription'] ?? "-"}')),
                        DataCell(Text('${data['termOfDelivery'] ?? "-"}')),
                        DataCell(Text('${data['lutno'] ?? "-"}')),
                        DataCell(Text('${data['preCarriageMode'] ?? "-"}')),
                        DataCell(Text('${data['placeOfReceipt'] ?? "-"}')),
                        DataCell(Text('${data['portOfLoading'] ?? "-"}')),
                        DataCell(Text('${data['portOfDischarge'] ?? "-"}')),
                        DataCell(Text('${data['finalDestination'] ?? "-"}')),
                        DataCell(Text('${data['cost'] ?? "-"}')),
                        DataCell(Text('${data['insurance'] ?? "-"}')),
                        DataCell(Text('${data['freight'] ?? "-"}')),
                        DataCell(Text('${data['pkt'] ?? "-"}')),
                        DataCell(Text('${data['gwt'] ?? "-"}')),
                        DataCell(Text('${data['nwt'] ?? "-"}')),
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
                                "Are you sure you want to delete this order: ${data['orderId']}?",
                                "SUBMIT",
                                "CANCEL");
                            if(confirmation) {
                              NetworkService networkService = NetworkService();
                              http.StreamedResponse response = await networkService.post("/delete-export-order/", {"orderId" : '${data['orderId']}'});
                              if(response.statusCode == 204) {
                                context.pushReplacementNamed(GetExportOrder.routeName, extra: true);
                              } else {
                                var message = jsonDecode(await response.stream.bytesToString());
                                networkService.logError({
                                  "errorCode" : message['errorCode'] ?? "",
                                  "errorMsg" : message['message'] ?? "",
                                  "endpoint" : "/delete-exp-order/",
                                  "featureName" : null,
                                  "payload" : {"orderId" : '${data['orderId']}'}
                                });
                                await showAlertDialog(context,
                                    message['message'], "Continue", false);
                              }
                            }
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.white),
                          ),
                        )),
                      ]);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // Navigator.pop(context, false);
                    Navigator.of(context, rootNavigator: true).pop(false);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 5),
                    width: GlobalVariables.deviceWidth * 0.15,
                    height: GlobalVariables.deviceHeight * 0.05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: HexColor("#e0e0e0"),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          offset: Offset(
                            2,
                            3,
                          ),
                        )
                      ],
                    ),
                    child: const Text("CLOSE",
                        style: TextStyle(fontSize: 11, color: Colors.black)),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
