import 'dart:convert';

import 'package:fintech_new_web/features/ledgerCodes/provider/ledger_codes_provider.dart';
import 'package:fintech_new_web/features/ledgerCodes/screen/ledger_codes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';

class GetLedgerCodes extends StatefulWidget {
  static String routeName = 'edit-ledger';
  final bool delete;
  const GetLedgerCodes({super.key, required this.delete});

  @override
  State<GetLedgerCodes> createState() => _GetLedgerCodesState();
}

class _GetLedgerCodesState extends State<GetLedgerCodes> {
  TextEditingController partyCodeController = TextEditingController();

  @override
  void initState() {
    LedgerCodesProvider provider =
        Provider.of<LedgerCodesProvider>(context, listen: false);
    provider.getPartyCodes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LedgerCodesProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: CommonAppbar(
                title: widget.delete ? "Delete Ledger" : 'Update Ledger')),
        body: SingleChildScrollView(
          child: Center(
            child: Visibility(
              visible: provider.partyCodes.isNotEmpty,
              child: Container(
                width: kIsWeb
                    ? GlobalVariables.deviceWidth / 2.0
                    : GlobalVariables.deviceWidth,
                padding: const EdgeInsets.all(10),
                child: Form(
                  // key: formKey,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: SearchableDropdown<String>(
                                isEnabled: true,
                                backgroundDecoration: (child) => Container(
                                  height: 40,
                                  margin: EdgeInsets.zero,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.black, width: 0.5),
                                  ),
                                  child: child,
                                ),
                                items: provider.partyCodes,
                                onChanged: (value) {
                                  setState(() {
                                    partyCodeController.text = value!;
                                  });
                                },
                                hasTrailingClearIcon: false,
                              )),
                          Positioned(
                            left: 15,
                            top: 1,
                            child: Container(
                              color: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: const Wrap(
                                children: [
                                  Text(
                                    "Party Code",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "*",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor("#0B6EFE"),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
                          onPressed: () async {
                            if (widget.delete) {
                              Map<String, dynamic> ledger = await provider
                                  .getByIdPartyCode(partyCodeController.text);

                              _showTablePopup(context, ledger);
                            } else {
                              context.pushNamed(LedgerCodes.routeName,
                                  queryParameters: {
                                    "editing": 'true',
                                    "partyCode": partyCodeController.text
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
        ),
      );
    });
  }

  void _showTablePopup(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Ledger',
              style: TextStyle(fontWeight: FontWeight.w500)),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DataTable(columns: const [
                    DataColumn(label: Text('Ledger Code')),
                    DataColumn(label: Text('Ledger Name')),
                    DataColumn(label: Text('Ledger Type')),
                    DataColumn(label: Text('Acc. Group')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('')),
                  ], rows: [
                    DataRow(cells: [
                      DataCell(Text('${data['lcode'] ?? "-"}')),
                      DataCell(Text('${data['lname'] ?? "-"}')),
                      DataCell(Text('${data['ltype'] ?? "-"}')),
                      DataCell(Text('${data['agCode'] ?? "-"}')),
                      DataCell(Text('${data['lstatus'] ?? "-"}')),
                      DataCell(ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                        onPressed: () async {
                          bool confirmation = await showConfirmationDialogue(
                              context,
                              "Are you sure you want to delete this ledger?",
                              "SUBMIT",
                              "CANCEL");
                          if (confirmation) {
                            NetworkService networkService = NetworkService();
                            http.StreamedResponse response =
                                await networkService.post(
                                    "/delete-ledger-codes/",
                                    {"lcode": '${data['lcode']}'});
                            if (response.statusCode == 204) {
                              context.pushReplacementNamed(
                                  GetLedgerCodes.routeName,
                                  extra: true);
                            } else if (response.statusCode == 400) {
                              var message = jsonDecode(
                                  await response.stream.bytesToString());
                              await showAlertDialog(
                                  context,
                                  message['message'].toString(),
                                  "Continue",
                                  false);
                            } else if (response.statusCode == 500) {
                              var message = jsonDecode(
                                  await response.stream.bytesToString());
                              await showAlertDialog(context, message['message'],
                                  "Continue", false);
                            } else {
                              var message = jsonDecode(
                                  await response.stream.bytesToString());
                              await showAlertDialog(context, message['message'],
                                  "Continue", false);
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
                    ]),
                  ]),
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
