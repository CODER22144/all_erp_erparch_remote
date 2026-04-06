// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/auth/provider/auth_provider.dart';
import 'package:fintech_new_web/features/common/widgets/pop_ups.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/multi_select_widget.dart';

class AddCompanyGroup extends StatefulWidget {
  static String routeName = "AddCompanyGroup";
  const AddCompanyGroup({super.key});

  @override
  State<AddCompanyGroup> createState() => _AddCompanyGroupState();
}

class _AddCompanyGroupState extends State<AddCompanyGroup> {
  late AuthProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<AuthProvider>(context, listen: false);
    provider.initGroupWidget();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<AuthProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Add Company Group')),
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
                child: Visibility(
                  visible: provider.widgetList.isNotEmpty && provider.orgComp.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      MultiSelectCheckbox(
                          items: provider.orgComp,
                          onSelectionChanged: (value) {
                            GlobalVariables
                                    .requestBody[AuthProvider.groupFeatureName]
                                ['associated_companies'] = value;
                          },
                          idKey: 'cid',
                          descKey: 'company_name'),
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
                                      await provider.processGroupFormInfo();
                                  var message = jsonDecode(
                                      await result.stream.bytesToString());
                                  if (result.statusCode == 200) {
                                    context.pushReplacementNamed(
                                        AddCompanyGroup.routeName);
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
