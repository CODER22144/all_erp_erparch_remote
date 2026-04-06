// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../utility/services/import_widget.dart';
import '../provider/dbnote_provider.dart';
import 'db_note.dart';
import 'db_note_row_fields.dart';

class DbNoteDetails extends StatefulWidget {
  static String routeName = "/DbNoteDetails";

  const DbNoteDetails({super.key});
  @override
  State<DbNoteDetails> createState() => DbNoteDetailsState();
}

class DbNoteDetailsState extends State<DbNoteDetails>
    with SingleTickerProviderStateMixin {
  List<List<String>> tableRows = [];
  var formKey = GlobalKey<FormState>();
  late TabController tabController;

  late DbNoteProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<DbNoteProvider>(context, listen: false);
    provider.initWidget();
    // Add one empty row at the beginning
    tableRows
        .add(['', '', '', '', '', '', '1', '0', '', '0', '0', '0', '0', '0', '0']);
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  // Function to add a new row
  void addRow() {
    setState(() {
      tableRows
          .add(['', '', '', '', '', '', '1', '0', '', '0', '0', '0', '0', '0', '0']);
    });
    provider.addRowController();
  }

  // Function to delete a row
  void deleteRow(int index) {
    setState(() {
      tableRows.removeAt(index);
    });
    provider.deleteRowController(index);
  }

  bool manualOrder = true;
  bool autoOrder = false;
  bool isFileUploaded = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<DbNoteProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Debit Note')),
        body: Center(
          child: Column(
            children: [
              TabBar(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  isScrollable: false,
                  tabs: const [
                    Tab(text: "Fixed/Master"),
                    Tab(text: "Items Details"),
                  ]),
              Expanded(
                  child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: tabController,
                      children: [
                    DbNote(controller: tabController),
                    SingleChildScrollView(
                      child: Center(
                        child: SizedBox(
                          width: kIsWeb
                              ? GlobalVariables.deviceWidth / 2
                              : GlobalVariables.deviceWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ImportWidget(
                                    toggleManual: () {
                                      setState(() {
                                        manualOrder = false;
                                        autoOrder = true;
                                      });
                                    },
                                    toggleAuto: () {
                                      setState(() {
                                        manualOrder = true;
                                        autoOrder = false;
                                        isFileUploaded = false;
                                      });
                                    },
                                    feature: DbNoteProvider.featureName,
                                    groupBy: 'No',
                                    sampleFileUrl: "https://docs.google.com/spreadsheets/d/145Q2_H7nc05LMOnU0OMJKKVYmikwZ2MXjMJ8E-TufFU/edit?usp=sharing",
                                    isMaster: false,
                                    masterDetailFeatureName: DbNoteProvider.masterDetailFeatureName,
                                    manualOrder: manualOrder,
                                    autoOrder: autoOrder,
                                    isFileUploaded: isFileUploaded),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: HexColor("#0B6EFE"),
                                      minimumSize: const Size(200, 50),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(1)))),
                                  onPressed: () async {
                                    http.StreamedResponse result =
                                        await provider
                                            .processFormInfo(tableRows, manualOrder);
                                    var message = jsonDecode(
                                        await result.stream.bytesToString());
                                    if (result.statusCode == 200) {
                                      context.pushReplacementNamed(
                                          DbNoteDetails.routeName);
                                    } else if (result.statusCode == 400) {
                                      await showAlertDialog(
                                          context,
                                          message['message'].toString(),
                                          "Continue",
                                          false);
                                    } else if (result.statusCode == 500) {
                                      await showAlertDialog(
                                          context,
                                          message['message'],
                                          "Continue",
                                          false);
                                    } else {
                                      await showAlertDialog(
                                          context,
                                          message['message'],
                                          "Continue",
                                          false);
                                    }
                                  },
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                              for (int i = 0; i < tableRows.length; i++)
                                Visibility(
                                  visible: manualOrder,
                                  child: DbNoteRowFields(
                                      hsnCode: provider.hsnCodes,
                                      index: i,
                                      tableRows: tableRows,
                                      materialUnit: provider.materialUnit,
                                      controllers: provider.rowControllers,
                                      deleteRow: deleteRow),
                                ),
                              Visibility(
                                visible: manualOrder,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: HexColor("#0B6EFE"),
                                        minimumSize: const Size(200, 50),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(1)))),
                                    onPressed: addRow,
                                    child: const Text('Add Row',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]))
            ],
          ),
        ),
      );
    });
  }
}
