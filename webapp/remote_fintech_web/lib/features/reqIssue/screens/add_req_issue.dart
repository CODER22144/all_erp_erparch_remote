// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:fintech_new_web/features/reqIssue/provider/req_issue_provider.dart';
import 'package:fintech_new_web/features/reqIssue/screens/req_issue_pending.dart';
import 'package:fintech_new_web/features/reqIssue/screens/req_issue_row_field.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';

class AddReqIssue extends StatefulWidget {
  static String routeName = "/AddReqIssue";
  final String reqId;

  const AddReqIssue({super.key, required this.reqId});

  @override
  AddReqIssueState createState() => AddReqIssueState();
}

class AddReqIssueState extends State<AddReqIssue> {
  List<List<String>> tableRows = [];
  var formKey = GlobalKey<FormState>();
  late ReqIssueProvider provider;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    provider =
        Provider.of<ReqIssueProvider>(context, listen: false);
    setState(() {
      loading = true;
    });
    provider.initWidget(widget.reqId);
    tableRows = provider.rowFields;
    setState(() {
      loading = false;
    });
  }

  // Function to delete a row
  void deleteRow(int index) {
    setState(() {
      tableRows.removeAt(index);
    });
    setState(() {
      loading = true;
    });
    provider.initAfterDelete(widget.reqId, index);
    tableRows = provider.rowFields;
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReqIssueProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Add Issue Req.')),
        body: SingleChildScrollView(
          child: Center(
            child: !loading ? Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white54)),
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, right: 20, left: 20),
              width: kIsWeb
                  ? GlobalVariables.deviceWidth / 2
                  : GlobalVariables.deviceWidth,
              child: Column(
                children: [
                  for (int i = 0; i < tableRows.length; i++)
                    ReqIssueRowField(
                        index: i, tableRows: tableRows, deleteRow: deleteRow, controllers: provider.rowControllers),
                  Visibility(
                    visible: provider.rowFields.isNotEmpty,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10, left: 8, right: 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor("#0B6EFE"),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)))),
                        onPressed: () async {
                            bool confirmation =
                            await showConfirmationDialogue(
                                context,
                                "Do you want to submit the records?",
                                "SUBMIT",
                                "CANCEL");
                            if (confirmation) {
                              http.StreamedResponse result = await provider.processFormInfo(tableRows);
                              var message = jsonDecode(
                                  await result.stream.bytesToString());
                              if (result.statusCode == 200) {
                                context.pop();
                                context.pushReplacementNamed(ReqIssuePending.routeName);
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
                  ),
                ],
              ),
            ) : const SpinKitFadingCircle(
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
      );
    });
  }
}
