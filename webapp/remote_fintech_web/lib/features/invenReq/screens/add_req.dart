// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/invenReq/provider/inven_req_provider.dart';
import 'package:fintech_new_web/features/invenReq/screens/req_details_row_field.dart';
import 'package:fintech_new_web/features/jobWorkOut/provider/job_work_out_provider.dart';
import 'package:fintech_new_web/features/salesOrder/screens/sales_order_details_row_field.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';

class AddReq extends StatefulWidget {
  static String routeName = "/AddReq";

  const AddReq({super.key});
  @override
  AddReqState createState() => AddReqState();
}

class AddReqState extends State<AddReq> {
  var formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    InvenReqProvider provider =
    Provider.of<InvenReqProvider>(context, listen: false);
    provider.initWidget('A');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InvenReqProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Inventory Requirement - Auto')),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: kIsWeb
                  ? GlobalVariables.deviceWidth / 2
                  : GlobalVariables.deviceWidth,
              padding: const EdgeInsets.all(10),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 5, bottom: 5),
                      child: ListView.builder(
                        itemCount: provider.widgetList.length,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return provider.widgetList[index];
                        },
                      ),
                    ),
                    Visibility(
                      visible: provider.widgetList.isNotEmpty,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5)))),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              bool confirmation =
                              await showConfirmationDialogue(
                                  context,
                                  "Do you want to submit the records?",
                                  "SUBMIT",
                                  "CANCEL");
                              if (confirmation) {
                                http.StreamedResponse result =
                                await provider.addRequirement();
                                var message = jsonDecode(
                                    await result.stream
                                        .bytesToString());
                                if (result.statusCode == 200) {
                                  context.pushReplacementNamed(AddReq.routeName);
                                } else if (result.statusCode ==
                                    400) {
                                  await showAlertDialog(
                                      context,
                                      message['message'].toString(),
                                      "Continue",
                                      false);
                                } else if (result.statusCode ==
                                    500) {
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
                              }
                            }
                          },
                          child: const Text('Submit',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
