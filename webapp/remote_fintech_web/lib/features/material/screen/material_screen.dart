// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:fintech_new_web/features/material/provider/material_provider.dart';
import 'package:fintech_new_web/features/material/screen/get_material.dart';
import 'package:fintech_new_web/features/material/screen/material_report.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../camera/service/camera_service.dart';
import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';

class MaterialScreen extends StatefulWidget {
  static String routeName = "/material";
  final String? editing;
  const MaterialScreen({super.key, this.editing});

  @override
  State<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  late MaterialProvider provider;

  String blobPath = "";
  String blobName = "";

  bool manualOrder = true;
  bool autoOrder = false;
  bool isFileUploaded = false;
  bool isLoading = false;

  List<Map<String, dynamic>> jsonData = [];

  @override
  void initState() {
    super.initState();
    provider = Provider.of<MaterialProvider>(context, listen: false);
    if (widget.editing == "true") {
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
    return Consumer<MaterialProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Material')),
        body: Stack(
          children: [
            SingleChildScrollView(
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: manualOrder &&
                                  provider.widgetList.isNotEmpty &&
                                  widget.editing != "true",
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, right: 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
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
                                    "Import Materials",
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
                                    backgroundColor: HexColor("#31007B"),
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
                                    "Manually Add Materials",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                            visible: autoOrder,
                            child: InkWell(
                              child: const Text(
                                "Click to View file format for Import Materials",
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w500),
                              ),
                              onTap: () async {
                                final Uri uri = Uri.parse(
                                    "https://docs.google.com/spreadsheets/d/1asSmgwk8ErzhlnWIRIloLIYfLkSlRNSdNHAFWlvQp5s/edit?usp=sharing");
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri,
                                      mode: LaunchMode.inAppBrowserView);
                                } else {
                                  throw 'Could not launch';
                                }
                              },
                            )),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.start, // Space buttons evenly

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: autoOrder,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, right: 10),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Camera camera = Camera();
                                    var blob = await camera.chooseFile(
                                      context,
                                    );

                                    if (blob != null) {
                                      setState(() {
                                        blobPath = blob.path;
                                        blobName = blob.name;
                                        isFileUploaded = true;
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: HexColor("#006B7B"),
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
                            Visibility(
                              visible: isFileUploaded,
                              child: const Padding(
                                padding: EdgeInsets.only(top: 8, right: 10),
                                child: Text(
                                  "File Uploaded Successfully",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.green),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible:
                              provider.widgetList.isNotEmpty && manualOrder,
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5)))),
                              onPressed: () async {
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
                                    http.StreamedResponse result = widget
                                                .editing ==
                                            "true"
                                        ? await provider.processUpdateFormInfo()
                                        : manualOrder
                                            ? await provider
                                                .processFormInfo(manualOrder)
                                            : await provider.processFormInfo(
                                                manualOrder,
                                                path: blobPath,
                                                name: blobName);
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
                                            MaterialScreen.routeName);
                                      }
                                      provider.getMaterialReport();
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

  // Future<void> _importExcel() async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['xlsx', 'xls'],
  //     );
  //
  //     if (result != null) {
  //       // Use the bytes directly if the path is null
  //       final bytes = result.files.single.bytes ??
  //           File(result.files.single.path!).readAsBytesSync();
  //       var excel = Excel.decodeBytes(bytes);
  //
  //       var sheet = excel.tables.values.first;
  //
  //       if (sheet != null) {
  //         // Get the first row as headers
  //         List<String> headers = sheet.rows[1]
  //             .map((cell) => cell?.value?.toString() ?? '')
  //             .toList();
  //         jsonData.clear();
  //         // Iterate over remaining rows and map them to headers
  //         for (int i = 2; i < sheet.rows.length; i++) {
  //           var row = sheet.rows[i];
  //           Map<String, dynamic> rowMap = {};
  //
  //           for (int j = 0; j < headers.length; j++) {
  //             if (j < row.length) {
  //               rowMap[headers[j]] = row[j]?.value.toString();
  //             } else {
  //               rowMap[headers[j]] = null; // Handle missing columns
  //             }
  //           }
  //           setState(() {
  //             isFileUploaded = true;
  //             jsonData.add(rowMap);
  //           });
  //         }
  //         GlobalVariables.requestBody[MaterialProvider.featureName] = jsonData;
  //       }
  //     } else {
  //       showAlertDialog(context, "File selection canceled", "OKAY", false);
  //     }
  //   } catch (e) {
  //     showAlertDialog(context, "Unable to access file.", "OKAY", false);
  //   }
  // }
}
