import 'dart:convert';

import 'package:fintech_new_web/features/sqlQuery/provider/query_provider.dart';
import 'package:fintech_new_web/features/sqlQuery/screens/query_conditions.dart';
import 'package:fintech_new_web/features/sqlQuery/screens/query_report.dart';
import 'package:fintech_new_web/features/utility/services/multi_checkbox_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../utility/global_variables.dart';
import '../../utility/services/common_utility.dart';

class SqlQuery extends StatefulWidget {
  static String routeName = '/query';
  const SqlQuery({super.key});

  @override
  State<SqlQuery> createState() => _SqlQueryState();
}

class _SqlQueryState extends State<SqlQuery> {
  late QueryProvider provider;
  int currentStep = 0;

  List<String> checkBoxItems = [];

  List<List<String>> tableRows = [];

  List<dynamic> exportData = [];

  void setCheckBoxItems(String tableName) async {
    List<dynamic> columns = await provider.getColumns(tableName);
    setState(() {
      checkBoxItems = List<String>.from(columns);
      checkBoxItems.insert(0, "All");
    });
  }

  @override
  void initState() {
    super.initState();
    provider = Provider.of<QueryProvider>(context, listen: false);
    provider.getOperators();
    tableRows.add(["","","","",""]);
  }

  void addRow() {
    setState(() {
      tableRows.add(['', '', '',"",""]);
    });
    // provider.addRowController();
  }

  // Function to delete a row
  void deleteRow(int index) {
    setState(() {
      tableRows.removeAt(index);
    });
    // provider.deleteRowController(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
          child: const CommonAppbar(title: 'Execute SQL')),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.white54)),
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
          width: kIsWeb
              ? GlobalVariables.deviceWidth / 2.0
              : GlobalVariables.deviceWidth,
          child: Stepper(
              currentStep: currentStep,
              onStepContinue: () async {
                final lastStep = currentStep == 2;

                if (lastStep) {
                  Map<String,dynamic> payload = {
                    "tableName" : provider.tableController.text,
                    "selectCols" : GlobalVariables.requestBody['selectCols'],
                  };

                  List<Map<String, dynamic>> conditions = [];
                  for (int i = 0; i < tableRows.length; i++) {
                    conditions.add({
                      "columnName": tableRows[i][0],
                      "operator": tableRows[i][1],
                      "type": tableRows[i][2],
                      "logic": tableRows[i][3],
                      "value": tableRows[i][4],
                    });
                  }
                  payload['conditions'] = conditions;
                  http.StreamedResponse response = await provider.executeBuildQuery(payload);

                  if(response.statusCode == 200) {
                    var data = jsonDecode(await response.stream.bytesToString());
                    context.pushNamed(QueryReport.routeName, queryParameters: {
                      "details" : jsonEncode(data)
                    });

                  } else {
                    showAlertDialog(
                        context, "Something Went Wrong", "OKAY", false);
                  }

                }

                if (!lastStep) {
                  setState(() {
                    currentStep += 1;
                  });
                }
              },
              onStepCancel: () {
                setState(() {
                  currentStep -= 1;
                });
              },
              controlsBuilder: (context, details) {
                final lastStep = currentStep == 2;
                return Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      ElevatedButton(
                          onPressed: details.onStepContinue,
                          style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.lightBlue),
                          ),
                          child: Text(lastStep ? "SAVE" : "NEXT",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                      const SizedBox(width: 10),
                      if (currentStep != 0)
                        ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  Colors.redAccent),
                            ),
                            onPressed: details.onStepCancel,
                            child: const Text("BACK",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)))
                    ],
                  ),
                );
              },
              steps: [
                Step(
                    state: currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                    isActive: currentStep == 0,
                    title: const Text("Table Name",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Focus(
                      onFocusChange: (hasFocus) {
                        if (!hasFocus) {
                          setCheckBoxItems(provider.tableController.text);
                        }
                      },
                      child: TextFormField(
                        controller: provider.tableController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: RichText(
                            text: const TextSpan(
                              text: "Table Name",
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
                            borderSide:
                                BorderSide(color: Colors.black, width: 0),
                          ),
                        ),
                      ),
                    )),
                Step(
                    state: currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                    isActive: currentStep == 1,
                    title: const Text("Select Columns",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    content: MultiCheckboxWidget(
                      items: checkBoxItems,
                      onSelectionChanged: (selectedList) {
                        print("Selected: $selectedList");
                      },
                    )),
                Step(
                    state: currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                    isActive: currentStep == 2,
                    title: const Text("Bank Details",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              minimumSize: const Size(200,50),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(1)))),
                          onPressed: addRow,
                          child: const Text('Add Row',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white)),
                        ),
                        const SizedBox(height: 10),
                        for (int i = 0; i < tableRows.length; i++)
                          QueryConditions(
                              types: provider.dataTypes,
                              operators: provider.operators,
                              index: i,
                              tableRows: tableRows,
                              deleteRow: deleteRow, controllers: []),
                      ],
                    ))
              ],
              type: StepperType.horizontal),
        ),
      ),
    );
  }
}
