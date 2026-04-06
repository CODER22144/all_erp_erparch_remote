// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/materialTechDetails/provider/material_tech_details_provider.dart';
import 'package:fintech_new_web/features/materialTechDetails/screens/get_material_tech_details.dart';
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

class AddMaterialTechDetails extends StatefulWidget {
  static String routeName = "/addMaterialTechDetails";
  final bool editing;
  const AddMaterialTechDetails({super.key, required this.editing});

  @override
  AddMaterialTechDetailsState createState() => AddMaterialTechDetailsState();
}

class AddMaterialTechDetailsState extends State<AddMaterialTechDetails> {
  var formKey = GlobalKey<FormState>();
  late MaterialTechDetailsProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<MaterialTechDetailsProvider>(context, listen: false);
    if (widget.editing) {
      provider.reset();
      provider.initEditWidget();
    } else {
      provider.initWidget();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.editing) {
      provider.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MaterialTechDetailsProvider>(
        builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: CommonAppbar(
                title: widget.editing
                    ? 'Update Material Tech Details'
                    : 'Add Material Tech Details')),
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
                                    setImagePath: provider.setDrawing,
                                    showCamera: !kIsWeb),
                              ),
                              suffix: widget.editing
                                  ? Visibility(
                                      visible: GlobalVariables.requestBody[
                                              MaterialTechDetailsProvider
                                                  .featureName]['drawing'] !=
                                          null,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            final Uri uri = Uri.parse(
                                                "${NetworkService.baseUrl}${GlobalVariables.requestBody[MaterialTechDetailsProvider.featureName]['drawing'] ?? ""}");
                                            if (await canLaunchUrl(uri)) {
                                              await launchUrl(uri,
                                                  mode: LaunchMode
                                                      .inAppBrowserView);
                                            } else {
                                              throw 'Could not launch url';
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                HexColor("#0038a8"),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                    )
                                  : null,
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
                                    setImagePath: provider.setImages,
                                    showCamera: !kIsWeb),
                              ),
                              suffix: widget.editing
                                  ? Visibility(
                                      visible: GlobalVariables.requestBody[
                                              MaterialTechDetailsProvider
                                                  .featureName]['images'] !=
                                          null,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            final Uri uri = Uri.parse(
                                                "${NetworkService.baseUrl}${GlobalVariables.requestBody[MaterialTechDetailsProvider.featureName]['images'] ?? ""}");
                                            if (await canLaunchUrl(uri)) {
                                              await launchUrl(uri,
                                                  mode: LaunchMode
                                                      .inAppBrowserView);
                                            } else {
                                              throw 'Could not launch url';
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                HexColor("#0038a8"),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      3), // Square shape
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 5),
                                          ),
                                          child: const Text(
                                            "View image",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    )
                                  : null,
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
                                "Images",
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
                              suffix: widget.editing
                                  ? Visibility(
                                      visible: GlobalVariables.requestBody[
                                              MaterialTechDetailsProvider
                                                  .featureName]['asdrawing'] !=
                                          null,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            final Uri uri = Uri.parse(
                                                "${NetworkService.baseUrl}${GlobalVariables.requestBody[MaterialTechDetailsProvider.featureName]['asdrawing'] ?? ""}");
                                            if (await canLaunchUrl(uri)) {
                                              await launchUrl(uri,
                                                  mode: LaunchMode
                                                      .inAppBrowserView);
                                            } else {
                                              throw 'Could not launch url';
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                HexColor("#0038a8"),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                    )
                                  : null,
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
                                "As Drawing",
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
                                    setImagePath: provider.setQcFormat,
                                    showCamera: !kIsWeb),
                              ),
                              suffix: widget.editing
                                  ? Visibility(
                                      visible: GlobalVariables.requestBody[
                                              MaterialTechDetailsProvider
                                                  .featureName]['qcformat'] !=
                                          null,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            final Uri uri = Uri.parse(
                                                "${NetworkService.baseUrl}${GlobalVariables.requestBody[MaterialTechDetailsProvider.featureName]['qcformat'] ?? ""}");
                                            if (await canLaunchUrl(uri)) {
                                              await launchUrl(uri,
                                                  mode: LaunchMode
                                                      .inAppBrowserView);
                                            } else {
                                              throw 'Could not launch url';
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                HexColor("#0038a8"),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      3), // Square shape
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 5),
                                          ),
                                          child: const Text(
                                            "View QC",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    )
                                  : null,
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
                                "QC Format",
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
                                    setImagePath: provider.setCp,
                                    showCamera: !kIsWeb),
                              ),
                              suffix: widget.editing
                                  ? Visibility(
                                      visible: GlobalVariables.requestBody[
                                              MaterialTechDetailsProvider
                                                  .featureName]['cp'] !=
                                          null,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            final Uri uri = Uri.parse(
                                                "${NetworkService.baseUrl}${GlobalVariables.requestBody[MaterialTechDetailsProvider.featureName]['cp'] ?? ""}");
                                            if (await canLaunchUrl(uri)) {
                                              await launchUrl(uri,
                                                  mode: LaunchMode
                                                      .inAppBrowserView);
                                            } else {
                                              throw 'Could not launch url';
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                HexColor("#0038a8"),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      3), // Square shape
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 5),
                                          ),
                                          child: const Text(
                                            "View CP",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    )
                                  : null,
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
                                "CP",
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
                                    setImagePath: provider.setFmea,
                                    showCamera: !kIsWeb),
                              ),
                              suffix: widget.editing
                                  ? Visibility(
                                      visible: GlobalVariables.requestBody[
                                              MaterialTechDetailsProvider
                                                  .featureName]['fmea'] !=
                                          null,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            final Uri uri = Uri.parse(
                                                "${NetworkService.baseUrl}${GlobalVariables.requestBody[MaterialTechDetailsProvider.featureName]['fmea'] ?? ""}");
                                            if (await canLaunchUrl(uri)) {
                                              await launchUrl(uri,
                                                  mode: LaunchMode
                                                      .inAppBrowserView);
                                            } else {
                                              throw 'Could not launch url';
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                HexColor("#0038a8"),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      3), // Square shape
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 5),
                                          ),
                                          child: const Text(
                                            "View FMEA",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    )
                                  : null,
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
                                "FMEA",
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
                                    setImagePath: provider.setPfd,
                                    showCamera: !kIsWeb),
                              ),
                              suffix: widget.editing
                                  ? Visibility(
                                      visible: GlobalVariables.requestBody[
                                              MaterialTechDetailsProvider
                                                  .featureName]['pfd'] !=
                                          null,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            final Uri uri = Uri.parse(
                                                "${NetworkService.baseUrl}${GlobalVariables.requestBody[MaterialTechDetailsProvider.featureName]['pfd'] ?? ""}");
                                            if (await canLaunchUrl(uri)) {
                                              await launchUrl(uri,
                                                  mode: LaunchMode
                                                      .inAppBrowserView);
                                            } else {
                                              throw 'Could not launch url';
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                HexColor("#0038a8"),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      3), // Square shape
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 5),
                                          ),
                                          child: const Text(
                                            "View PFD",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    )
                                  : null,
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
                                "PFD",
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
                                    setImagePath: provider.setCcr,
                                    showCamera: !kIsWeb),
                              ),
                              suffix: widget.editing
                                  ? Visibility(
                                visible: GlobalVariables.requestBody[
                                MaterialTechDetailsProvider
                                    .featureName]['ccr'] !=
                                    null,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      final Uri uri = Uri.parse(
                                          "${NetworkService.baseUrl}${GlobalVariables.requestBody[MaterialTechDetailsProvider.featureName]['ccr'] ?? ""}");
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri,
                                            mode: LaunchMode
                                                .inAppBrowserView);
                                      } else {
                                        throw 'Could not launch url';
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      HexColor("#0038a8"),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            3), // Square shape
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 5),
                                    ),
                                    child: const Text(
                                      "CCR",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                              )
                                  : null,
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
                                "CCR",
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
                                    setImagePath: provider.setVennDrawing,
                                    showCamera: !kIsWeb),
                              ),
                              suffix: widget.editing
                                  ? Visibility(
                                visible: GlobalVariables.requestBody[
                                MaterialTechDetailsProvider
                                    .featureName]['vendrawing'] !=
                                    null,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      final Uri uri = Uri.parse(
                                          "${NetworkService.baseUrl}${GlobalVariables.requestBody[MaterialTechDetailsProvider.featureName]['vendrawing'] ?? ""}");
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri,
                                            mode: LaunchMode
                                                .inAppBrowserView);
                                      } else {
                                        throw 'Could not launch url';
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      HexColor("#0038a8"),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            3), // Square shape
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 5),
                                    ),
                                    child: const Text(
                                      "Venn Drawing",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                              )
                                  : null,
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
                                "Ven Drawing",
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
                                http.StreamedResponse result = widget.editing
                                    ? await provider.processUpdateFormInfo()
                                    : await provider.processFormInfo();
                                var message = jsonDecode(
                                    await result.stream.bytesToString());
                                if (result.statusCode == 200) {
                                  if (widget.editing) {
                                    context.pop();
                                    context.pushReplacementNamed(
                                        GetMaterialTechDetails.routeName);
                                  } else {
                                    context.pushReplacementNamed(
                                        AddMaterialTechDetails.routeName);
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
