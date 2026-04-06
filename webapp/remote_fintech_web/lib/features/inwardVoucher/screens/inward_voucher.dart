import 'dart:convert';

import 'package:fintech_new_web/features/inwardVoucher/provider/inward_voucher_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

import '../../camera/widgets/camera_widget.dart';
import '../../common/widgets/pop_ups.dart';
import '../../utility/global_variables.dart';
import '../../utility/services/import_widget.dart';
import 'create_inward_voucher.dart';

class InwardVoucher extends StatefulWidget {
  final TabController controller;
  const InwardVoucher({super.key, required this.controller});

  @override
  State<InwardVoucher> createState() => _InwardVoucherState();
}

class _InwardVoucherState extends State<InwardVoucher>
    with AutomaticKeepAliveClientMixin {
  var formKey = GlobalKey<FormState>();

  bool manualOrder = true;
  bool autoOrder = false;
  bool isFileUploaded = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<InwardVoucherProvider>(builder: (context, provider, child) {
      return SingleChildScrollView(
        child: Center(
          child: Container(
            width: kIsWeb
                ? GlobalVariables.deviceWidth / 2
                : GlobalVariables.deviceWidth,
            padding: const EdgeInsets.all(10),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: provider.widgetList.isNotEmpty,
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
                        feature: InwardVoucherProvider.featureNameSingle,
                        sampleFileUrl:
                            "https://docs.google.com/spreadsheets/d/1-vfzIV7KxSiUevY6GR4HzK-YFxmpizH3UGzw_aGCwnw/edit?usp=sharing",
                        isMaster: true,
                        text: "Import (Single)",
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
                      visible: provider.widgetList.isNotEmpty && manualOrder,
                      child: CameraWidget(
                          setImagePath: provider.setImagePath,
                          showCamera: !kIsWeb)),
                  Visibility(
                    visible: provider.widgetList.isNotEmpty && manualOrder,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            widget.controller.animateTo(1);
                          }
                        },
                        child: const Text('Next ->',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: autoOrder,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          minimumSize: const Size(200, 50),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1)))),
                      onPressed: () async {
                        {
                          http.StreamedResponse result =
                              await provider.processSingleImport();
                          var message =
                              jsonDecode(await result.stream.bytesToString());
                          if (result.statusCode == 200) {
                            context.pushReplacementNamed(
                                CreateInwardVoucher.routeName);
                          } else if (result.statusCode == 400) {
                            await showAlertDialog(
                                context,
                                message['message'].toString(),
                                "Continue",
                                false);
                          } else if (result.statusCode == 500) {
                            await showAlertDialog(
                                context, message['message'], "Continue", false);
                          } else {
                            await showAlertDialog(
                                context, message['message'], "Continue", false);
                          }
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
