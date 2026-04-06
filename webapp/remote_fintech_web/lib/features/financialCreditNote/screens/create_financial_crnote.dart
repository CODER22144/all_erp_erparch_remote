// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/businessPartner/provider/business_partner_provider.dart';
import 'package:fintech_new_web/features/common/widgets/pop_ups.dart';
import 'package:fintech_new_web/features/financialCreditNote/provider/financial_crnote_provider.dart';
import 'package:fintech_new_web/features/home.dart';
import 'package:fintech_new_web/features/inwardVoucher/provider/inward_voucher_provider.dart';
import 'package:fintech_new_web/features/materialIQS/provider/material_iqs_provider.dart';
import 'package:fintech_new_web/features/obalance/provider/oblance_provider.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../camera/widgets/camera_widget.dart';
import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/import_widget.dart';

class CreateFinancialCrnote extends StatefulWidget {
  static String routeName = "/createFinancialCrnote";
  final String editing;
  const CreateFinancialCrnote({super.key, required this.editing});

  @override
  State<CreateFinancialCrnote> createState() => _CreateFinancialCrnoteState();
}

class _CreateFinancialCrnoteState extends State<CreateFinancialCrnote> {
  @override
  void initState() {
    super.initState();
    FinancialCrnoteProvider provider =
        Provider.of<FinancialCrnoteProvider>(context, listen: false);
    if (widget.editing == 'true') {
      provider.initEditWidget();
    } else {
      provider.initWidget();
    }
  }

  bool manualOrder = true;
  bool autoOrder = false;
  bool isFileUploaded = false;

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<FinancialCrnoteProvider>(
        builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: CommonAppbar(
                title: widget.editing == 'true'
                    ? 'Update Financial Credit Note'
                    : 'Add Financial Credit Note')),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white54)),
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, right: 20, left: 20),
              width: kIsWeb
                  ? GlobalVariables.deviceWidth / 2.0
                  : GlobalVariables.deviceWidth,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: widget.editing != 'true',
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
                          feature: FinancialCrnoteProvider.featureName,
                          sampleFileUrl: "https://docs.google.com/spreadsheets/d/1O3zBmOfeorgBjpAXaQpVjhItg-uTKjux-XfEJ352xOw/edit?usp=sharing",
                          isMaster: true,
                          manualOrder: manualOrder,
                          autoOrder: autoOrder,
                          isFileUploaded: isFileUploaded),
                    ),
                    Visibility(
                      visible: manualOrder,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
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
                    ),
                    Visibility(
                      visible: provider.widgetList.isNotEmpty,
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
                                    widget.editing == 'true'
                                        ? await provider.processUpdateFormInfo()
                                        : await provider.processFormInfo(manualOrder);
                                var message = jsonDecode(
                                    await result.stream.bytesToString());
                                if (result.statusCode == 200) {
                                  if(widget.editing == 'true') {
                                    context.pop();
                                  } else {
                                    context.pushReplacementNamed(
                                        CreateFinancialCrnote.routeName);
                                  }
                                  provider.getFcnRep();
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
      );
    });
  }
}
