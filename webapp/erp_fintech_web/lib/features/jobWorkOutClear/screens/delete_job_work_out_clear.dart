import 'dart:convert';

import 'package:fintech_new_web/features/bpBreakup/provider/bp_breakup_provider.dart';
import 'package:fintech_new_web/features/jobWorkOutClear/provider/job_work_out_clear_provider.dart';
import 'package:fintech_new_web/features/materialAssembly/provider/material_assembly_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';
import '../../utility/services/common_utility.dart';

class DeleteJobWorkOutClear extends StatefulWidget {
  static String routeName = 'DeleteJobWorkOutClear';
  const DeleteJobWorkOutClear({super.key});

  @override
  State<DeleteJobWorkOutClear> createState() => _DeleteJobWorkOutClearState();
}

class _DeleteJobWorkOutClearState extends State<DeleteJobWorkOutClear> {
  @override
  void initState() {
    super.initState();
    JobWorkOutClearProvider provider =
        Provider.of<JobWorkOutClearProvider>(context, listen: false);
    provider.editingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobWorkOutClearProvider>(
        builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: "Delete Job Workout Clear")),
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
                        controller: provider.editingController,
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
                              text: "ID",
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
                      ),
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
                          NetworkService networkService = NetworkService();
                          http.StreamedResponse response = await networkService
                              .post("/get-jw-clear-report/",
                                  {"clId": provider.editingController.text});
                          if (response.statusCode == 200) {
                            _showTablePopup(
                                context,
                                jsonDecode(
                                    await response.stream.bytesToString()));
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

  void _showTablePopup(BuildContext context, List<dynamic> jwocRep) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Job Workout Clear',
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
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Date")),
                      DataColumn(label: Text("Doc No.")),
                      DataColumn(label: Text("Gr No.")),
                      DataColumn(label: Text("Bill No.")),
                      DataColumn(label: Text("Bill Date")),
                      DataColumn(label: Text("Material No.")),
                      DataColumn(label: Text("Qty")),
                      DataColumn(label: Text("Rate")),
                      DataColumn(label: Text("")),
                    ],
                    rows: jwocRep.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['clId'] ?? "-"}')),
                        DataCell(Text('${data['dt'] ?? "-"}')),
                        DataCell(Text('${data['docno'] ?? "-"}')),
                        DataCell(Text('${data['grno'] ?? "-"}')),
                        DataCell(Text('${data['billNo'] ?? "-"}')),
                        DataCell(Text('${data['billDate'] ?? "-"}')),
                        DataCell(Text('${data['matno'] ?? "-"}')),
                        DataCell(Align(
                            alignment: Alignment.centerRight,
                            child: Text(parseDoubleUpto2Decimal(
                                '${data['qty'] ?? "-"}')))),
                        DataCell(Align(
                            alignment: Alignment.centerRight,
                            child: Text(parseDoubleUpto2Decimal(
                                '${data['rate'] ?? "-"}')))),
                        DataCell(ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
                          onPressed: () async {
                            bool confirmation = await showConfirmationDialogue(
                                context,
                                "Are you sure you want to delete this record?",
                                "SUBMIT",
                                "CANCEL");
                            if (confirmation) {
                              NetworkService networkService = NetworkService();
                              http.StreamedResponse response =
                                  await networkService.post("/delete-jw-clear/",
                                      {"clId": '${data['clId']}'});
                              if (response.statusCode == 204) {
                                context.pushReplacementNamed(
                                    DeleteJobWorkOutClear.routeName);
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
