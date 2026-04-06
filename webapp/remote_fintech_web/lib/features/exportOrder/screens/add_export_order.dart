// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/common/widgets/pop_ups.dart';
import 'package:fintech_new_web/features/exportOrder/provider/export_order_provider.dart';
import 'package:fintech_new_web/features/exportOrder/screens/get_export_order.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class AddExportOrder extends StatefulWidget {
  static String routeName = "/addExportOrder";
  final String? editing;
  const AddExportOrder({super.key, this.editing});

  @override
  State<AddExportOrder> createState() => _AddExportOrderState();
}

class _AddExportOrderState extends State<AddExportOrder> {
  late ExportOrderProvider provider;

  @override
  void initState() {
    super.initState();
    provider =
        Provider.of<ExportOrderProvider>(context, listen: false);
    if (widget.editing == "true") {
      provider.initEditWidget();
    } else {
      provider.initWidget();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if(widget.editing == "true") {
      provider.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<ExportOrderProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: CommonAppbar(title: widget.editing != "true" ? 'Add Export Order' : "Update Export Order")),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white54)),
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, right: 20, left: 20),
              width: kIsWeb
                  ? GlobalVariables.deviceWidth / 1.8
                  : GlobalVariables.deviceWidth,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: provider.widgetList.isNotEmpty,
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
                      child: Row(
                        children: [
                          SizedBox(width: GlobalVariables.deviceWidth * 0.13),
                          Expanded(
                            child: Container(
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
                                        if(widget.editing == "true") {
                                          context.pop();
                                          context.pushReplacementNamed(GetExportOrder.routeName);
                                        } else {
                                          context.pushReplacementNamed(AddExportOrder.routeName);
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
                          ),
                        ],
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
