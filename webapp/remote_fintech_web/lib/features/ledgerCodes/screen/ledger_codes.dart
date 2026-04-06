// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:ui';

import 'package:fintech_new_web/features/camera/service/camera_service.dart';
import 'package:fintech_new_web/features/common/widgets/pop_ups.dart';
import 'package:fintech_new_web/features/network/service/network_service.dart';
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
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widgets/comman_appbar.dart';
import '../provider/ledger_codes_provider.dart';

class LedgerCodes extends StatefulWidget {
  static String routeName = "/ledgerCodes";
  final String? editing;
  final String partyCode;

  const LedgerCodes({super.key, this.editing, required this.partyCode});

  @override
  State<LedgerCodes> createState() => _LedgerCodesState();
}

class _LedgerCodesState extends State<LedgerCodes> {
  late LedgerCodesProvider provider;
  bool manualOrder = true;
  bool autoOrder = false;
  bool isFileUploaded = false;
  bool isLoading = false;

  double progress = 0;
  int records = 0;

  List<Map<String, dynamic>> jsonData = [];
  String? ipAddress;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<LedgerCodesProvider>(context, listen: false);
    if (widget.editing == "true") {
      provider.reset();
      provider.initEditWidget(widget.partyCode);
    } else {
      provider.initWidget(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<LedgerCodesProvider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: HexColor('#f9f9ff'),
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: CommonAppbar(
                title: widget.editing == "true"
                    ? 'Update Ledger Codes'
                    : "Add Ledger Codes")),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      border: provider.widgetList.isNotEmpty
                          ? Border.all(width: 1, color: Colors.black)
                          : null),
                  width: kIsWeb
                      ? GlobalVariables.deviceWidth / 2.0
                      : GlobalVariables.deviceWidth,
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: manualOrder,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, right: 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          1), // Square shape
                                    ),
                                    padding: EdgeInsets.zero,
                                    // Remove internal padding to make it square
                                    minimumSize: const Size(200,
                                        50), // Width and height for the button
                                  ),
                                  child: const Text(
                                    "Import",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      manualOrder = false;
                                      autoOrder = true;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Visibility(
                              visible: autoOrder,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, right: 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          1), // Square shape
                                    ),
                                    padding: EdgeInsets.zero,
                                    // Remove internal padding to make it square
                                    minimumSize: const Size(250,
                                        50), // Width and height for the button
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      manualOrder = true;
                                      autoOrder = false;
                                      isFileUploaded = false;
                                    });
                                  },
                                  child: const Text(
                                    "Manual",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Visibility(
                            visible: autoOrder,
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: InkWell(
                                child: const Text(
                                  "Click to View file format for Import",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w500),
                                ),
                                onTap: () async {
                                  final Uri uri = Uri.parse(
                                      "https://docs.google.com/spreadsheets/d/1titfEANgRet-KbLFuysYDbnJrxK1HNwLSTZOLYAtBXA/edit?usp=sharing");
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri,
                                        mode: LaunchMode.inAppBrowserView);
                                  } else {
                                    throw 'Could not launch';
                                  }
                                },
                              ),
                            )),
                        Row(
                          children: [
                            Visibility(
                              visible: autoOrder,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, right: 10),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    //pickFile();

                                    Camera camera = Camera();
                                    var blobPath = await camera.chooseFile(
                                      context,
                                    );

                                    if (blobPath != null) {
                                      provider.uploadExcel(
                                          blobPath.path, blobPath.name);

                                      setState(() {
                                        isFileUploaded = true;
                                      });

                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          1), // Square shape
                                    ),
                                    padding: EdgeInsets.zero,
                                    // Remove internal padding to make it square
                                    minimumSize: const Size(150,
                                        50), // Width and height for the button
                                  ),
                                  child: const Text(
                                    'Choose File',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 30),
                            // Progress Bar
                            Visibility(
                                    visible: isFileUploaded,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, right: 10),
                                      child: Text(
                                        "File Uploaded Successfully.",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: HexColor("#006400")),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: manualOrder,
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
                          visible: provider.visibility != 'O' &&
                              (provider.visibility != null &&
                                  provider.visibility != ""),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: ListView.builder(
                              itemCount: provider.optWidgetList1.length,
                              physics: const ClampingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return provider.optWidgetList1[index];
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: provider.visibility == 'V' ||
                              provider.visibility == 'B',
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: ListView.builder(
                              itemCount: provider.optWidgetList2.length,
                              physics: const ClampingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return provider.optWidgetList2[index];
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: provider.visibility == 'C' ||
                              provider.visibility == 'B',
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: ListView.builder(
                              itemCount: provider.optWidgetList3.length,
                              physics: const ClampingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return provider.optWidgetList3[index];
                              },
                            ),
                          ),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5)))),
                              onPressed: () async {
                                if (isLoading) {
                                  return;
                                }
                                if (formKey.currentState!.validate()) {
                                  bool confirmation =
                                      await showConfirmationDialogue(
                                          context,
                                          "Do you want to submit the records?",
                                          "SUBMIT",
                                          "CANCEL");
                                  if (confirmation) {


                                    if (autoOrder && widget.editing != "true") {
                                      setState(() {
                                        isLoading = true;
                                      });
                                    }

                                    http.StreamedResponse result =
                                        widget.editing == "true"
                                            ? await provider
                                                .processUpdateFormInfo()
                                            : await provider
                                                .processFormInfo(manualOrder);

                                    if (autoOrder && widget.editing != "true") {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                    var message = jsonDecode(
                                        await result.stream.bytesToString());
                                    if (result.statusCode == 200) {
                                      if (widget.editing == "true") {
                                        context.pop();
                                      } else {
                                        context.pushReplacementNamed(
                                            LedgerCodes.routeName);
                                      }
                                      provider.getLedgerReport();
                                    } else if (result.statusCode == 400) {
                                      await showAlertDialog(
                                          context,
                                          message['message'].toString(),
                                          "Continue",
                                          false);
                                    } else if (result.statusCode == 500) {
                                      await showAlertDialog(
                                          context,
                                          message['message'],
                                          "Continue",
                                          false);
                                    } else {
                                      await showAlertDialog(
                                          context,
                                          message['message'],
                                          "Continue",
                                          false);
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
            if (isLoading && autoOrder)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    color: Colors.black.withOpacity(0.2), // Dim effect
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const CircularProgressIndicator(
                          color: Colors.blueAccent,
                          strokeWidth: 4,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
