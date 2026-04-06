// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:fintech_new_web/features/common/widgets/pop_ups.dart';
import 'package:fintech_new_web/features/productBreakupTechDetails/provider/product_breakup_tech_details_provider.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' as exc;
import 'package:url_launcher/url_launcher.dart';

import '../../camera/widgets/camera_widget.dart';
import '../../common/widgets/comman_appbar.dart';

class AddProductBreakupTechDetails extends StatefulWidget {
  static String routeName = "/addProductBreakupTechDetails";
  final String? editing;
  const AddProductBreakupTechDetails({super.key, this.editing});

  @override
  State<AddProductBreakupTechDetails> createState() =>
      _AddProductBreakupTechDetailsState();
}

class _AddProductBreakupTechDetailsState
    extends State<AddProductBreakupTechDetails> {
  bool manualOrder = true;
  bool autoOrder = false;
  bool isFileUploaded = false;

  List<Map<String, dynamic>> jsonData = [];

  @override
  void initState() {
    super.initState();
    ProductBreakupTechDetailsProvider provider =
        Provider.of<ProductBreakupTechDetailsProvider>(context, listen: false);
    // if (widget.editing == "true") {
    //   provider.initEditWidget();
    // } else {
    //   provider.initWidget();
    // }
    provider.initWidget();
  }

  Future<void> _importExcel() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        // Use the bytes directly if the path is null
        final bytes = result.files.single.bytes ??
            File(result.files.single.path!).readAsBytesSync();
        var excel = exc.Excel.decodeBytes(bytes);

        var sheet = excel.tables.values.first;

        if (sheet != null) {
          // Get the first row as headers
          List<String> headers = sheet.rows.first
              .map((cell) => cell?.value?.toString() ?? '')
              .toList();

          // Iterate over remaining rows and map them to headers
          for (int i = 1; i < sheet.rows.length; i++) {
            var row = sheet.rows[i];
            Map<String, dynamic> rowMap = {};

            for (int j = 0; j < headers.length; j++) {
              if (j < row.length) {
                rowMap[headers[j]] = row[j]?.value.toString();
              } else {
                rowMap[headers[j]] = null; // Handle missing columns
              }
            }
            setState(() {
              isFileUploaded = true;
              jsonData.add(rowMap);
            });
          }
          GlobalVariables
                  .requestBody[ProductBreakupTechDetailsProvider.featureName] =
              jsonData;
        }
      } else {
        showAlertDialog(context, "File selection canceled", "OKAY", false);
      }
    } catch (e) {
      showAlertDialog(context, "Unable to access file.", "OKAY", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<ProductBreakupTechDetailsProvider>(
        builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child:
                const CommonAppbar(title: 'Add Product Breakup Tech Details')),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Visibility(
                    //   visible: manualOrder,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(top: 8, right: 10),
                    //     child: ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: HexColor("#1B7B00"),
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius:
                    //               BorderRadius.circular(1), // Square shape
                    //         ),
                    //         padding: EdgeInsets.zero,
                    //         // Remove internal padding to make it square
                    //         minimumSize: const Size(
                    //             200, 50), // Width and height for the button
                    //       ),
                    //       child: const Text(
                    //         "Import Voucher",
                    //         style: TextStyle(
                    //             color: Colors.white,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //       onPressed: () {
                    //         setState(() {
                    //           manualOrder = false;
                    //           autoOrder = true;
                    //         });
                    //       },
                    //     ),
                    //   ),
                    // ),
                    // Visibility(
                    //   visible: autoOrder,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(top: 8, right: 10),
                    //     child: ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: HexColor("#31007B"),
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius:
                    //               BorderRadius.circular(1), // Square shape
                    //         ),
                    //         padding: EdgeInsets.zero,
                    //         // Remove internal padding to make it square
                    //         minimumSize: const Size(
                    //             250, 50), // Width and height for the button
                    //       ),
                    //       onPressed: () {
                    //         setState(() {
                    //           manualOrder = true;
                    //           autoOrder = false;
                    //           isFileUploaded = false;
                    //         });
                    //       },
                    //       child: const Text(
                    //         "Manually Create Voucher",
                    //         style: TextStyle(
                    //             color: Colors.white,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    // InkWell(
                    //   child: Visibility(
                    //     visible: autoOrder,
                    //     child: const Text(
                    //       "Click to View file format for Import",
                    //       style: TextStyle(
                    //           color: Colors.blueAccent,
                    //           fontWeight: FontWeight.w500),
                    //     ),
                    //   ),
                    //   onTap: () async {
                    //     final Uri uri = Uri.parse(
                    //         "https://docs.google.com/spreadsheets/d/1l_7RqPwDZh1HPOYVDacMXOJMDksXz9-9Rnd20Zkx4kc/edit?usp=sharing");
                    //     if (await canLaunchUrl(uri)) {
                    //       await launchUrl(uri,
                    //           mode: LaunchMode.inAppBrowserView);
                    //     } else {
                    //       throw 'Could not launch';
                    //     }
                    //   },
                    // ),
                    // Visibility(
                    //   visible: autoOrder,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(top: 8, right: 10),
                    //     child: ElevatedButton(
                    //       onPressed: _importExcel,
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: HexColor("#006B7B"),
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius:
                    //               BorderRadius.circular(1), // Square shape
                    //         ),
                    //         padding: EdgeInsets.zero,
                    //         // Remove internal padding to make it square
                    //         minimumSize: const Size(
                    //             150, 50), // Width and height for the button
                    //       ),
                    //       child: const Text(
                    //         'Choose File',
                    //         style: TextStyle(
                    //             color: Colors.white,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Visibility(
                    //   visible: isFileUploaded,
                    //   child: const Padding(
                    //     padding: EdgeInsets.only(top: 8, right: 10),
                    //     child: Text(
                    //       "File Uploaded Successfully",
                    //       style: TextStyle(
                    //           fontStyle: FontStyle.italic,
                    //           fontSize: 14,
                    //           color: Colors.green),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 20),
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
                        visible: provider.widgetList.isNotEmpty,
                        child: TextFormField(
                          readOnly: true,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            // suffix: widget.suffixWidget,
                            prefix: CameraWidget(
                                setImagePath:
                                provider.setPic,
                                showCamera: !kIsWeb),
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelBehavior:
                            FloatingLabelBehavior.always,
                            border: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey, width: 2),
                            ),
                            label: const Text(
                              "Picture",
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
                            prefix: CameraWidget(
                                setImagePath:
                                provider.setDrawing,
                                showCamera: !kIsWeb),
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelBehavior:
                            FloatingLabelBehavior.always,
                            border: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey, width: 2),
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
                            prefix: CameraWidget(
                                setImagePath:
                                provider.setAsDrawing,
                                showCamera: !kIsWeb),
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelBehavior:
                            FloatingLabelBehavior.always,
                            border: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey, width: 2),
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
                            prefix: CameraWidget(
                                setImagePath:
                                provider.setQc,
                                showCamera: !kIsWeb),
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelBehavior:
                            FloatingLabelBehavior.always,
                            border: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey, width: 2),
                            ),
                            label: const Text(
                              "QC",
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
                            prefix: CameraWidget(
                                setImagePath:
                                provider.setCp,
                                showCamera: !kIsWeb),
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelBehavior:
                            FloatingLabelBehavior.always,
                            border: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey, width: 2),
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
                            prefix: CameraWidget(
                                setImagePath:
                                provider.setFmea,
                                showCamera: !kIsWeb),
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelBehavior:
                            FloatingLabelBehavior.always,
                            border: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey, width: 2),
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
                            prefix: CameraWidget(
                                setImagePath:
                                provider.setPfd,
                                showCamera: !kIsWeb),
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelBehavior:
                            FloatingLabelBehavior.always,
                            border: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey, width: 2),
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
                            prefix: CameraWidget(
                                setImagePath:
                                provider.setCcr,
                                showCamera: !kIsWeb),
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelBehavior:
                            FloatingLabelBehavior.always,
                            border: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey, width: 2),
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
                                    await provider.processFormInfo(manualOrder);
                                var message = jsonDecode(
                                    await result.stream.bytesToString());
                                if (result.statusCode == 200) {
                                  context.pushReplacementNamed(
                                      AddProductBreakupTechDetails.routeName);
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
