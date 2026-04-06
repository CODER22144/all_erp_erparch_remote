// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/businessPartnerOnBoard/provider/business_partner_on_board_provider.dart';
import 'package:fintech_new_web/features/businessPartnerOnBoard/screens/get_bp_on_board.dart';
import 'package:fintech_new_web/features/obMaterial/screens/get_ob_material.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';

class BusinessPartnerOnBoard extends StatefulWidget {
  static String routeName = "/BusinessPartnerOnBoard";
  final String? editing;
  const BusinessPartnerOnBoard({super.key, this.editing});

  @override
  State<BusinessPartnerOnBoard> createState() => _BusinessPartnerOnBoardState();
}

class _BusinessPartnerOnBoardState extends State<BusinessPartnerOnBoard> {
  late BusinessPartnerOnBoardProvider provider;

  bool manualOrder = true;
  bool autoOrder = false;
  bool isFileUploaded = false;

  List<Map<String, dynamic>> jsonData = [];

  @override
  void initState() {
    super.initState();
    provider = Provider.of<BusinessPartnerOnBoardProvider>(context, listen: false);
    if (widget.editing == "true") {
      provider.reset();
      provider.initEditWidget();
    } else {
      provider.initWidget();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.editing == "true") {
      provider.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<BusinessPartnerOnBoardProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Business Partner OnBoard')),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: provider.widgetList.isNotEmpty && manualOrder,
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
                                widget.editing == "true"
                                    ? await provider.processUpdateFormInfo()
                                    : await provider.processFormInfo();
                                var message = jsonDecode(
                                    await result.stream.bytesToString());
                                if (result.statusCode == 200) {
                                  if (widget.editing == "true") {
                                    context.pop();
                                    context.pushReplacementNamed(GetBpOnBoard.routeName);
                                  } else {
                                    context.pushReplacementNamed(
                                        BusinessPartnerOnBoard.routeName);
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
