// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/gr/provider/gr_provider.dart';
import 'package:fintech_new_web/features/grOtherCharges/provider/gr_other_charges_provider.dart';
import 'package:fintech_new_web/features/grQtyClear/provider/gr_qty_clear_provider.dart';
import 'package:fintech_new_web/features/material/provider/material_provider.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../home.dart';

class AddGrRateApproval extends StatefulWidget {
  static String routeName = "/addGrRateApproval";
  final String rateDetails;
  const AddGrRateApproval({super.key, required this.rateDetails});

  @override
  State<AddGrRateApproval> createState() => _AddGrRateApprovalState();
}

class _AddGrRateApprovalState extends State<AddGrRateApproval> {
  @override
  void initState() {
    super.initState();
    GrProvider provider =
    Provider.of<GrProvider>(context, listen: false);
    provider.initRateApprovalForm(widget.rateDetails);
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<GrProvider>(builder: (context, provider, child) {
      return Material(
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'GR Rate Approval')),
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                width: kIsWeb
                    ? GlobalVariables.deviceWidth / 2.0
                    : GlobalVariables.deviceWidth,
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: ListView.builder(
                          itemCount: provider.rateDiffWidgetList.length,
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return provider.rateDiffWidgetList[index];
                          },
                        ),
                      ),
                      Visibility(
                        visible: provider.rateDiffWidgetList.isNotEmpty,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#0B6EFE"),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
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
                                  await provider.addGrRateApproval();
                                  var message = jsonDecode(
                                      await result.stream.bytesToString());
                                  if (result.statusCode == 200) {
                                    provider.getGrRateDifferencePending();
                                    context.pop();
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
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
