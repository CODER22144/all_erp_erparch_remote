// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/common/widgets/pop_ups.dart';
import 'package:fintech_new_web/features/receiptVoucher/provider/receipt_voucher_provider.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/services/import_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class CreateReceiptVoucher extends StatefulWidget {
  static String routeName = "/createReceiptVoucher";
  final String? editing;
  const CreateReceiptVoucher({super.key, this.editing});

  @override
  State<CreateReceiptVoucher> createState() => _CreateReceiptVoucherState();
}

class _CreateReceiptVoucherState extends State<CreateReceiptVoucher> {
  bool manualOrder = true;
  bool autoOrder = false;
  bool isFileUploaded = false;

  @override
  void initState() {
    super.initState();
    ReceiptVoucherProvider provider =
        Provider.of<ReceiptVoucherProvider>(context, listen: false);
    if (widget.editing == 'true') {
      provider.initEditWidget();
    } else {
      provider.initWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<ReceiptVoucherProvider>(
        builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: CommonAppbar(
                title: widget.editing == 'true'
                    ? 'Update Receipt Voucher'
                    : 'Create Receipt Voucher')),
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
                          feature: ReceiptVoucherProvider.featureName,
                          sampleFileUrl:
                              "https://docs.google.com/spreadsheets/d/1lLvbd9ichtexrP5PGqNfbiaa5PhQ93Sq3hINuQ9rsUw/edit?usp=sharing",
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
                                  if (widget.editing == 'true') {
                                    context.pop();
                                    provider.getPaymentVoucherReport();
                                  } else {
                                    context.pushReplacementNamed(
                                        CreateReceiptVoucher.routeName);
                                  }
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
