// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/common/widgets/pop_ups.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../provider/gr_provider.dart';
import 'gr_report_screen.dart';

class GrMatEdit extends StatefulWidget {
  static String routeName = "GrMatEdit";
  final String grdId;
  const GrMatEdit({super.key, required this.grdId});

  @override
  State<GrMatEdit> createState() => _GrMatEditState();
}

class _GrMatEditState extends State<GrMatEdit> {
  late GrProvider provider;

  @override
  void initState() {
    super.initState();
    provider =
    Provider.of<GrProvider>(context, listen: false);
    provider.editRest();
    provider.initEdit(widget.grdId);
  }

  @override
  void dispose() {
    super.dispose();
    provider.editRest();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<GrProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: PreferredSize(
                preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                child: const CommonAppbar(title: 'Edit GR Details')),
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
                            itemCount: provider.editWidgetList.length,
                            physics: const ClampingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return provider.editWidgetList[index];
                            },
                          ),
                        ),
                        Visibility(
                          visible: provider.editWidgetList.isNotEmpty,
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
                                  http.StreamedResponse result = await provider.updateGr();
                                  if(result.statusCode == 200) {
                                    context.pop();
                                    context.pushReplacementNamed(GrReportScreen.routeName);
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
