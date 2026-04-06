import 'dart:convert';

import 'package:fintech_new_web/features/colorCode/provider/color_provider.dart';
import 'package:fintech_new_web/features/materialIncomingStandard/provider/material_incoming_standard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:hexcolor/hexcolor.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../utility/global_variables.dart';

class IncomingStandardReadingPost extends StatefulWidget {
  static String routeName = "incomingStandardReadingPost";
  final String matno;
  final String grdId;

  const IncomingStandardReadingPost(
      {super.key, required this.matno, required this.grdId});

  @override
  State<IncomingStandardReadingPost> createState() =>
      _IncomingStandardReadingPostState();
}

class _IncomingStandardReadingPostState
    extends State<IncomingStandardReadingPost> {
  Map<String, dynamic> readings = {};

  @override
  void initState() {
    MaterialIncomingStandardProvider provider =
        Provider.of<MaterialIncomingStandardProvider>(context, listen: false);
    provider.initReadingsWidget(widget.matno);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MaterialIncomingStandardProvider>(
        builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Post QC Pending')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: provider.materialIncStand.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DataTable(
                          columnSpacing: 20,
                          columns: [
                            const DataColumn(
                                label: Text("Serial No.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            const DataColumn(
                                label: Text("Test Type",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            const DataColumn(
                                label: Text("Standard Limit",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            const DataColumn(
                                label: Text("Lower Limit",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            const DataColumn(
                                label: Text("Higher Limit",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "*",
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                                text: "R1",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                            const DataColumn(
                                label: Text("R2",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            const DataColumn(
                                label: Text("R3",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            const DataColumn(
                                label: Text("R4",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            const DataColumn(
                                label: Text("R5",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            const DataColumn(
                                label: Text("R6",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            const DataColumn(
                                label: Text("R7",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            const DataColumn(
                                label: Text("R8",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            const DataColumn(
                                label: Text("R9",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            const DataColumn(
                                label: Text("R10",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: provider.materialIncStand.map((data) {
                            return DataRow(cells: [
                              DataCell(Text('${data['misSno'] ?? ""}')),
                              DataCell(Text('${data['testType'] ?? ""}')),
                              DataCell(Text('${data['sLimit'] ?? ""}')),
                              DataCell(Text('${data['lLimit'] ?? ""}')),
                              DataCell(Text('${data['hLimit'] ?? ""}')),
                              DataCell(Container(
                                width: 100,
                                margin: const EdgeInsets.all(3),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black45, width: 0.8),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black45, width: 1),
                                    ),
                                  ),
                                  validator: (String? val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Required';
                                    }
                                  },
                                  maxLines: null,
                                  onChanged: (value) {
                                    if (readings
                                        .containsKey('${data['misSno']}')) {
                                      readings['${data['misSno']}']['r1'] =
                                          value;
                                    } else {
                                      readings['${data['misSno']}'] = {
                                        "grdId": widget.grdId,
                                        "misId": data['misId'],
                                        "r1": value,
                                        "misSno" : data['misSno']
                                      };
                                    }
                                  },
                                ),
                              )),
                              DataCell(Container(
                                width: 100,
                                margin: const EdgeInsets.all(3),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black45, width: 0.8),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black45, width: 1),
                                    ),
                                  ),
                                  validator: (String? val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Required';
                                    }
                                  },
                                  maxLines: null,
                                  onChanged: (value) {
                                    if (readings
                                        .containsKey('${data['misSno']}')) {
                                      readings['${data['misSno']}']['r2'] =
                                          value;
                                    } else {
                                      readings['${data['misSno']}'] = {
                                        "grdId": widget.grdId,
                                        "misId": data['misId'],
                                        "r2": value,
                                        "misSno" : data['misSno']
                                      };
                                    }
                                  },
                                ),
                              )),
                              DataCell(Container(
                                width: 100,
                                margin: const EdgeInsets.all(3),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black45, width: 0.8),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black45, width: 1),
                                    ),
                                  ),
                                  validator: (String? val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Required';
                                    }
                                  },
                                  maxLines: null,
                                  onChanged: (value) {
                                    if (readings
                                        .containsKey('${data['misSno']}')) {
                                      readings['${data['misSno']}']['r3'] =
                                          value;
                                    } else {
                                      readings['${data['misSno']}'] = {
                                        "grdId": widget.grdId,
                                        "misId": data['misId'],
                                        "r3": value,
                                        "misSno" : data['misSno']
                                      };
                                    }
                                  },
                                ),
                              )),
                              DataCell(Container(
                                width: 100,
                                margin: const EdgeInsets.all(3),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black45, width: 0.8),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black45, width: 1),
                                    ),
                                  ),
                                  validator: (String? val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Required';
                                    }
                                  },
                                  maxLines: null,
                                  onChanged: (value) {
                                    if (readings
                                        .containsKey('${data['misSno']}')) {
                                      readings['${data['misSno']}']['r4'] =
                                          value;
                                    } else {
                                      readings['${data['misSno']}'] = {
                                        "grdId": widget.grdId,
                                        "misId": data['misId'],
                                        "r4": value,
                                        "misSno" : data['misSno']
                                      };
                                    }
                                  },
                                ),
                              )),
                              DataCell(Container(
                                width: 100,
                                margin: const EdgeInsets.all(3),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black45, width: 0.8),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black45, width: 1),
                                    ),
                                  ),
                                  validator: (String? val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Required';
                                    }
                                  },
                                  maxLines: null,
                                  onChanged: (value) {
                                    if (readings
                                        .containsKey('${data['misSno']}')) {
                                      readings['${data['misSno']}']['r5'] =
                                          value;
                                    } else {
                                      readings['${data['misSno']}'] = {
                                        "grdId": widget.grdId,
                                        "misId": data['misId'],
                                        "r5": value,
                                        "misSno" : data['misSno']
                                      };
                                    }
                                  },
                                ),
                              )),
                              DataCell(Container(
                                width: 100,
                                margin: const EdgeInsets.all(3),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black45, width: 0.8),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black45, width: 1),
                                    ),
                                  ),
                                  validator: (String? val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Required';
                                    }
                                  },
                                  maxLines: null,
                                  onChanged: (value) {
                                    if (readings
                                        .containsKey('${data['misSno']}')) {
                                      readings['${data['misSno']}']['r6'] =
                                          value;
                                    } else {
                                      readings['${data['misSno']}'] = {
                                        "grdId": widget.grdId,
                                        "misId": data['misId'],
                                        "r6": value,
                                        "misSno" : data['misSno']
                                      };
                                    }
                                  },
                                ),
                              )),
                              DataCell(Container(
                                width: 100,
                                margin: const EdgeInsets.all(3),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black45, width: 0.8),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black45, width: 1),
                                    ),
                                  ),
                                  validator: (String? val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Required';
                                    }
                                  },
                                  maxLines: null,
                                  onChanged: (value) {
                                    if (readings
                                        .containsKey('${data['misSno']}')) {
                                      readings['${data['misSno']}']['r7'] =
                                          value;
                                    } else {
                                      readings['${data['misSno']}'] = {
                                        "grdId": widget.grdId,
                                        "misId": data['misId'],
                                        "r7": value,
                                        "misSno" : data['misSno']
                                      };
                                    }
                                  },
                                ),
                              )),
                              DataCell(Container(
                                width: 100,
                                margin: const EdgeInsets.all(3),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black45, width: 0.8),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black45, width: 1),
                                    ),
                                  ),
                                  validator: (String? val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Required';
                                    }
                                  },
                                  maxLines: null,
                                  onChanged: (value) {
                                    if (readings
                                        .containsKey('${data['misSno']}')) {
                                      readings['${data['misSno']}']['r8'] =
                                          value;
                                    } else {
                                      readings['${data['misSno']}'] = {
                                        "grdId": widget.grdId,
                                        "misId": data['misId'],
                                        "r8": value,
                                        "misSno" : data['misSno']
                                      };
                                    }
                                  },
                                ),
                              )),
                              DataCell(Container(
                                width: 100,
                                margin: const EdgeInsets.all(3),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black45, width: 0.8),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black45, width: 1),
                                    ),
                                  ),
                                  validator: (String? val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Required';
                                    }
                                  },
                                  maxLines: null,
                                  onChanged: (value) {
                                    if (readings
                                        .containsKey('${data['misSno']}')) {
                                      readings['${data['misSno']}']['r9'] =
                                          value;
                                    } else {
                                      readings['${data['misSno']}'] = {
                                        "grdId": widget.grdId,
                                        "misId": data['misId'],
                                        "r9": value,
                                        "misSno" : data['misSno']
                                      };
                                    }
                                  },
                                ),
                              )),
                              DataCell(Container(
                                width: 100,
                                margin: const EdgeInsets.all(3),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black45, width: 0.8),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black45, width: 1),
                                    ),
                                  ),
                                  validator: (String? val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Required';
                                    }
                                  },
                                  maxLines: null,
                                  onChanged: (value) {
                                    if (readings
                                        .containsKey('${data['misSno']}')) {
                                      readings['${data['misSno']}']['r10'] =
                                          value;
                                    } else {
                                      readings['${data['misSno']}'] = {
                                        "grdId": widget.grdId,
                                        "misId": data['misId'],
                                        "r10": value,
                                        "misSno" : data['misSno']
                                      };
                                    }
                                  },
                                ),
                              )),
                            ]);
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 20),
                          child: Column(
                            children: List.generate(
                              provider.widgetList.length,
                              (index) => SizedBox(
                                width: 700,
                                child: provider.widgetList[index],
                              ),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 5, bottom: 5),
                        //   child: ListView.builder(
                        //     itemCount: provider.widgetList.length,
                        //     physics: const ClampingScrollPhysics(),
                        //     scrollDirection: Axis.vertical,
                        //     shrinkWrap: true,
                        //     itemBuilder: (context, index) {
                        //       return Container(
                        //         width: 700,
                        //         child: provider.widgetList[index],
                        //       );
                        //     },
                        //   ),
                        // ),
                        Visibility(
                          visible: provider.materialIncStand.isNotEmpty,
                          child: Container(
                            width: 500,
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor("#0B6EFE"),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5)))),
                              onPressed: () async {
                                bool confirmation =
                                    await showConfirmationDialogue(
                                        context,
                                        "Do you want to submit the records?",
                                        "SUBMIT",
                                        "CANCEL");
                                if (confirmation) {
                                  GlobalVariables.requestBody[
                                          MaterialIncomingStandardProvider
                                              .readingsFeature]['grdId'] =
                                      widget.grdId;
                                  http.StreamedResponse result = await provider
                                      .processReadingPost(readings);
                                  var message = jsonDecode(
                                      await result.stream.bytesToString());
                                  if (result.statusCode == 200) {
                                    context.pop();
                                    provider.getQcPending();
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
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  : const SizedBox(),
            ),
          ),
        )),
      );
    });
  }
}
