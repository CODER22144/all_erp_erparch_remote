// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/businessPartner/provider/business_partner_provider.dart';
import 'package:fintech_new_web/features/common/widgets/pop_ups.dart';
import 'package:fintech_new_web/features/home.dart';
import 'package:fintech_new_web/features/inwardVoucher/provider/inward_voucher_provider.dart';
import 'package:fintech_new_web/features/materialIQS/provider/material_iqs_provider.dart';
import 'package:fintech_new_web/features/obalance/provider/oblance_provider.dart';
import 'package:fintech_new_web/features/purchaseTransfer/provider/purchase_transfer_provider.dart';
import 'package:fintech_new_web/features/receiptVoucher/provider/receipt_voucher_provider.dart';
import 'package:fintech_new_web/features/saleTransfer/provider/sale_transfer_provider.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../camera/widgets/camera_widget.dart';
import '../../common/widgets/comman_appbar.dart';

class AddPurchaseTransferClear extends StatefulWidget {
  static String routeName = "addPurchaseTransferClear";
  final String details;
  const AddPurchaseTransferClear({super.key, required this.details});

  @override
  State<AddPurchaseTransferClear> createState() => _AddPurchaseTransferClearState();
}

class _AddPurchaseTransferClearState extends State<AddPurchaseTransferClear> {
  @override
  void initState() {
    super.initState();
    PurchaseTransferProvider provider =
    Provider.of<PurchaseTransferProvider>(context, listen: false);
    provider.initClearWidget(widget.details);
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<PurchaseTransferProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Add Purchase Transfer Clear')),
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
                    Padding(
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
                                http.StreamedResponse result = await provider.addPurchaseTransferClear();
                                var message = jsonDecode(
                                    await result.stream.bytesToString());
                                if (result.statusCode == 200) {
                                  // TODO: REPOPULATE THE LIST WALA METHOD
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
      );
    });
  }
}
