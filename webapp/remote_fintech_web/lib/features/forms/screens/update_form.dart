// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:fintech_new_web/features/common/widgets/pop_ups.dart';
import 'package:fintech_new_web/features/financialYear/provider/financial_year_provider.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' as exl;

import '../../common/widgets/comman_appbar.dart';
import '../provider/form_provider.dart';

class UpdateForm extends StatefulWidget {
  static String routeName = "updateForm";
  final String details;
  const UpdateForm({super.key, required this.details});

  @override
  State<UpdateForm> createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  late FormProvider provider;
  TextEditingController formId = TextEditingController();
  TextEditingController formDescription = TextEditingController();
  TextEditingController formData = TextEditingController();

  @override
  void initState() {
    super.initState();
    provider = Provider.of<FormProvider>(context, listen: false);
    var data = jsonDecode(widget.details);
    formId.text = data['form_id'];
    formDescription.text = data['form_description'];
    formData.text = data['form_data'];

    GlobalVariables.requestBody[FormProvider.featureName] = {};
    GlobalVariables.requestBody[FormProvider.featureName] = data;
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<FormProvider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: HexColor('#f9f9ff'),
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: "Json Form Entry")),
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 47,
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: TextFormField(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 13),
                        keyboardType: TextInputType.text,
                        controller: formId,
                        decoration: InputDecoration(
                          label: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                    text: "*",
                                    style: TextStyle(color: Colors.red))
                              ],
                              text: "Form ID",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black45, width: 0.8),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black45, width: 1),
                          ),
                        ),
                        validator: (String? val) {
                          if (val == null || val.isEmpty) {
                            return 'ID field is Mandatory';
                          }
                        },
                        maxLines: null,
                        onChanged: (value) {
                          GlobalVariables.requestBody[FormProvider.featureName]
                              ["form_id"] = value == "" ? null : value;
                        },
                      ),
                    ),
                    Container(
                      height: 47,
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: TextFormField(
                        controller: formDescription,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 13),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          label: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                    text: "*",
                                    style: TextStyle(color: Colors.red))
                              ],
                              text: "Form Description",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black45, width: 0.8),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black45, width: 1),
                          ),
                        ),
                        validator: (String? val) {
                          if (val == null || val.isEmpty) {
                            return 'Description field is Mandatory';
                          }
                        },
                        maxLines: null,
                        onChanged: (value) {
                          GlobalVariables.requestBody[FormProvider.featureName]
                              ["form_description"] = value == "" ? null : value;
                        },
                      ),
                    ),
                    TextFormField(
                      maxLines: null,
                      controller: formData,
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        label: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ],
                            text: "Form Data",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black45, width: 0.8),
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black45, width: 1),
                        ),
                      ),
                      validator: (String? val) {
                        if (val == null || val.isEmpty) {
                          return 'Form Json field is Mandatory';
                        }
                      },
                      onChanged: (value) {
                        GlobalVariables.requestBody[FormProvider.featureName]
                            ["form_data"] = value == "" ? null : value;
                      },
                    ),
                    Visibility(
                      visible: provider.widgetList.isNotEmpty,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10, top: 10),
                        width: double.infinity,
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
                                    await provider.processUpdateFormInfo();
                                var message = jsonDecode(
                                    await result.stream.bytesToString());
                                if (result.statusCode == 200) {
                                  context.pop();
                                  provider.getAllForms();
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
