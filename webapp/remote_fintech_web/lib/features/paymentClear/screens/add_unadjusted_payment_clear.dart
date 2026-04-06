// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/paymentClear/provider/payment_clear_provider.dart';
import 'package:fintech_new_web/features/paymentClear/screens/unadjusted_payment_pending.dart';
import 'package:fintech_new_web/features/paymentInward/provider/unadjusted_payment_inward_provider.dart';
import 'package:fintech_new_web/features/paymentInward/screens/unadjusted_payment_inward.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';


import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';

class AddUnadjustedPaymentClear extends StatefulWidget {
  static String routeName = "/AddUnadjustedPaymentClear";
  final String details;
  const AddUnadjustedPaymentClear({super.key, required this.details});

  @override
  State<AddUnadjustedPaymentClear> createState() =>
      _AddUnadjustedPaymentClearState();
}

class _AddUnadjustedPaymentClearState extends State<AddUnadjustedPaymentClear> {
  @override
  void initState() {
    super.initState();
    PaymentClearProvider provider =
    Provider.of<PaymentClearProvider>(context, listen: false);
    provider.initClearWidget(widget.details);
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<PaymentClearProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: PreferredSize(
                preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                child: const CommonAppbar(title: 'Add Unadjusted Payment Clear')),
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
                                    http.StreamedResponse result =
                                    await provider.addUnadjustedPaymentClear();
                                    if (result.statusCode == 200) {
                                      context.pop();
                                      context
                                          .pushReplacementNamed(UnadjustedPaymentPending.routeName);
                                    } else if (result.statusCode == 400) {
                                      var message = jsonDecode(
                                          await result.stream.bytesToString());
                                      await showAlertDialog(
                                          context,
                                          message['message'].toString(),
                                          "Continue",
                                          false);
                                    } else if (result.statusCode == 500) {
                                      var message = jsonDecode(
                                          await result.stream.bytesToString());
                                      await showAlertDialog(context,
                                          message['message'], "Continue", false);
                                    } else {
                                      var message = jsonDecode(
                                          await result.stream.bytesToString());
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
