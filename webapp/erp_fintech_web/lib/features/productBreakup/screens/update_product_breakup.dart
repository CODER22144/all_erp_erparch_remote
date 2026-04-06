// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/productBreakup/provider/product_breakup_provider.dart';
import 'package:fintech_new_web/features/productBreakup/screens/get_product_breakup.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';

class UpdateProductBreakup extends StatefulWidget {
  static String routeName = "UpdateProductBreakup";
  const UpdateProductBreakup({super.key});

  @override
  UpdateProductBreakupState createState() => UpdateProductBreakupState();
}

class UpdateProductBreakupState extends State<UpdateProductBreakup> {
  var formKey = GlobalKey<FormState>();
  late ProductBreakupProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<ProductBreakupProvider>(context, listen: false);

    provider.initEditWidget();
  }

  @override
  void dispose() {
    super.dispose();
    provider.resetEdit();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductBreakupProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: PreferredSize(
                preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                child: const CommonAppbar(
                    title: 'Update Product Breakup')),
            body: Center(
              child: SingleChildScrollView(
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
                            child: SizedBox(
                              width: double.infinity,
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
                                    http.StreamedResponse result = await provider.processUpdateFormInfo();
                                    var message = jsonDecode(
                                        await result.stream.bytesToString());
                                    if (result.statusCode == 200) {
                                      context.pop();
                                      context.pushReplacementNamed(GetProductBreakup.routeName);

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
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
