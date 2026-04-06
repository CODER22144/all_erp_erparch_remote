import 'dart:convert';

import 'package:fintech_new_web/features/bpBreakup/provider/bp_breakup_provider.dart';
import 'package:fintech_new_web/features/businessPartnerProcessing/provider/bp_processing_provider.dart';
import 'package:fintech_new_web/features/businessPartnerProcessing/screens/bp_processing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';

class GetBpProcessing extends StatefulWidget {
  static String routeName = 'editBpProcessing';
  final bool delete;
  const GetBpProcessing({super.key, required this.delete});

  @override
  State<GetBpProcessing> createState() => _GetBpProcessingState();
}

class _GetBpProcessingState extends State<GetBpProcessing> {
  late BpProcessingProvider provider;
  @override
  void initState() {
    super.initState();
    provider = Provider.of<BpProcessingProvider>(context, listen: false);
    provider.editController.clear();
    provider.editController2.clear();
    provider.getBpCodes();
  }

  bool isLoading = false;
  List<SearchableDropdownMenuItem<String>> materials = [];

  void getMaterialsByBpCode(String? bpCode) async {
    BpBreakupProvider prd = Provider.of<BpBreakupProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });

    provider.editController.text = bpCode!;
    var matDrop = await prd.getBpProcessing(bpCode);

    setState(() {
      materials = matDrop;
      isLoading= false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BpProcessingProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: PreferredSize(
                preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                child: CommonAppbar(title: widget.delete ? "Delete Business Partner Processing" : 'Get Business Partner Processing')),
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
                        Visibility(
                          visible: provider.bpCodes.isNotEmpty,
                          child: Stack(
                            children: [
                              Container(
                                color: Colors.white,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10),
                                child: SearchableDropdown<String>(
                                  isEnabled: true,
                                  backgroundDecoration: (child) =>
                                      Container(
                                        height: 40,
                                        margin: EdgeInsets.zero,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                          border: Border.all(
                                              color: Colors.black,
                                              width: 0.5),
                                        ),
                                        child: child,
                                      ),
                                  items: provider.bpCodes,
                                  onChanged: getMaterialsByBpCode,
                                  hasTrailingClearIcon: false,
                                ),
                              ),
                              Positioned(
                                left: 10,
                                top: 3,
                                child: Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2),
                                  child: const Wrap(
                                    children: [
                                      Text(
                                        "Business Partner",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "*",
                                        style: TextStyle(
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        if(isLoading)
                          const CircularProgressIndicator()
                        else
                          Visibility(
                            visible: provider.bpCodes.isNotEmpty,
                            child: Stack(
                              children: [
                                Container(
                                  color: Colors.white,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: SearchableDropdown<String>(
                                    isEnabled: true,
                                    backgroundDecoration: (child) =>
                                        Container(
                                          height: 40,
                                          margin: EdgeInsets.zero,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(5),
                                            border: Border.all(
                                                color: Colors.black,
                                                width: 0.5),
                                          ),
                                          child: child,
                                        ),
                                    items: materials,
                                    onChanged: (value) {
                                      setState(() {
                                        provider.editController2.text = value!;
                                      });
                                    },
                                    hasTrailingClearIcon: false,
                                  ),
                                ),
                                Positioned(
                                  left: 10,
                                  top: 3,
                                  child: Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    child: const Wrap(
                                      children: [
                                        Text(
                                          "Material no.",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "*",
                                          style: TextStyle(
                                              color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
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
                                http.StreamedResponse response = await networkService.post("/get-bp-processing/" , {"bpCode" : provider.editController.text, "pId" : provider.editController2.text});
                                if(response.statusCode == 200) {
                                  _showTablePopup(context, jsonDecode(await response.stream.bytesToString()));
                                }
                              } else {
                                context.pushNamed(BpProcessing.routeName,
                                    queryParameters: {"editing": 'true'});
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
          title: const Text('Delete Business Partner Processing',
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
                      DataColumn(label: Text('Business Partner')),
                      DataColumn(label: Text('Processing Item')),
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Rate')),
                      DataColumn(label: Text('')),
                    ],
                    rows: orderBalance.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['bpCode'] ?? "-"}')),
                        DataCell(Text('${data['pId'] ?? "-"}')),
                        DataCell(Text('${data['proDescription'] ?? "-"}')),
                        DataCell(Text('${data['proRate'] ?? "-"}')),
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
                                "Are you sure you want to delete this record?",
                                "SUBMIT",
                                "CANCEL");
                            if(confirmation) {
                              NetworkService networkService = NetworkService();
                              http.StreamedResponse response = await networkService.post("/delete-bp-processing/", {"bpCode" : '${data['bpCode']}', "pId" : '${data['pId']}'});
                              if(response.statusCode == 200) {
                                context.pushReplacementNamed(GetBpProcessing.routeName);
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
