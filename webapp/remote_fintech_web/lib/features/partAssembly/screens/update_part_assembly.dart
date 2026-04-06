// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/partAssembly/provider/part_assembly_provider.dart';
import 'package:fintech_new_web/features/partAssembly/screens/get_part_assembly.dart';
import 'package:fintech_new_web/features/productBreakup/screens/get_product_breakup.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../camera/widgets/camera_widget.dart';
import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';

class UpdatePartAssembly extends StatefulWidget {
  static String routeName = "UpdatePartAssembly";
  const UpdatePartAssembly({super.key});

  @override
  UpdatePartAssemblyState createState() => UpdatePartAssemblyState();
}

class UpdatePartAssemblyState extends State<UpdatePartAssembly> {
  var formKey = GlobalKey<FormState>();
  late PartAssemblyProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<PartAssemblyProvider>(context, listen: false);

    provider.initEditWidget();
  }

  @override
  void dispose() {
    super.dispose();
    provider.resetEdit();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartAssemblyProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Update Part Assembly')),
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
                          child: TextFormField(
                            readOnly: true,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              // suffix: widget.suffixWidget,
                              prefix: SizedBox(
                                width: 310,
                                child: CameraWidget(
                                    setImagePath: provider.setPic,
                                    showCamera: !kIsWeb),
                              ),
                              suffix: Visibility(
                                visible: GlobalVariables.requestBody[
                                            PartAssemblyProvider.featureName]
                                        ['pic'] !=
                                    null,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      final Uri uri = Uri.parse(
                                          "${NetworkService.baseUrl}${GlobalVariables.requestBody[PartAssemblyProvider.featureName]['pic'] ?? ""}");
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri,
                                            mode: LaunchMode.inAppBrowserView);
                                      } else {
                                        throw 'Could not launch url';
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: HexColor("#0038a8"),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            3), // Square shape
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 5),
                                    ),
                                    child: const Text(
                                      "View Pic",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),

                              filled: true,
                              fillColor: Colors.white,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2),
                              ),
                              label: const Text(
                                "Pic",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            maxLines: 1,
                          )),
                      const SizedBox(height: 10),
                      Visibility(
                          visible: provider.widgetList.isNotEmpty,
                          child: TextFormField(
                            readOnly: true,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              // suffix: widget.suffixWidget,
                              prefix: SizedBox(
                                width: 310,
                                child: CameraWidget(
                                    setImagePath: provider.setDrawing,
                                    showCamera: !kIsWeb),
                              ),
                              suffix: Visibility(
                                visible: GlobalVariables.requestBody[
                                            PartAssemblyProvider.featureName]
                                        ['drawing'] !=
                                    null,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      final Uri uri = Uri.parse(
                                          "${NetworkService.baseUrl}${GlobalVariables.requestBody[PartAssemblyProvider.featureName]['drawing'] ?? ""}");
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri,
                                            mode: LaunchMode.inAppBrowserView);
                                      } else {
                                        throw 'Could not launch url';
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: HexColor("#0038a8"),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            3), // Square shape
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 5),
                                    ),
                                    child: const Text(
                                      "View Drawing",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),

                              filled: true,
                              fillColor: Colors.white,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2),
                              ),
                              label: const Text(
                                "Drawing",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            maxLines: 1,
                          )),
                      const SizedBox(height: 10),
                      Visibility(
                          visible: provider.widgetList.isNotEmpty,
                          child: TextFormField(
                            readOnly: true,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              // suffix: widget.suffixWidget,
                              prefix: SizedBox(
                                width: 310,
                                child: CameraWidget(
                                    setImagePath: provider.setAsDrawing,
                                    showCamera: !kIsWeb),
                              ),
                              suffix: Visibility(
                                visible: GlobalVariables.requestBody[
                                            PartAssemblyProvider.featureName]
                                        ['asdrawing'] !=
                                    null,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      final Uri uri = Uri.parse(
                                          "${NetworkService.baseUrl}${GlobalVariables.requestBody[PartAssemblyProvider.featureName]['asdrawing'] ?? ""}");
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri,
                                            mode: LaunchMode.inAppBrowserView);
                                      } else {
                                        throw 'Could not launch url';
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: HexColor("#0038a8"),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            3), // Square shape
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 5),
                                    ),
                                    child: const Text(
                                      "View AsDrawing",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),

                              filled: true,
                              fillColor: Colors.white,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2),
                              ),
                              label: const Text(
                                "AsDrawing",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            maxLines: 1,
                          )),
                      const SizedBox(height: 10),
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
                                http.StreamedResponse result =
                                    await provider.processUpdateFormInfo();
                                var message = jsonDecode(
                                    await result.stream.bytesToString());
                                if (result.statusCode == 200) {
                                  context.pop();
                                  context.pushReplacementNamed(
                                      GetPartAssembly.routeName);
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
