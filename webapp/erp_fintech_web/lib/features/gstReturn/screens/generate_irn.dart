// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/gstReturn/provider/gst_return_provider.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../utility/services/common_utility.dart';

class GenerateIrn extends StatefulWidget {
  static String routeName = "/generateIrn";
  const GenerateIrn({super.key});

  @override
  State<GenerateIrn> createState() => _GenerateIrnState();
}

class _GenerateIrnState extends State<GenerateIrn> {
  bool isFileUploaded = false;

  Map<String, dynamic> jsonData = {};

  @override
  void initState() {
    super.initState();
    GstReturnProvider provider =
        Provider.of<GstReturnProvider>(context, listen: false);
    provider.initGst();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<GstReturnProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'GST Authorization')),
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
                        itemCount: provider.widgetList.length,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return provider.widgetList[index];
                        },
                      ),
                    ),
                    InkWell(
                        onTap: _importJson,
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: GlobalVariables.deviceWidth / 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const ElevatedButton(
                                        onPressed: null,
                                        child: Text(
                                          "Choose File",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20),
                                        )),
                                    isFileUploaded
                                        ? const Text(
                                            "File Uploaded Successfully",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 12,
                                                color: Colors.green),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
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
                          // onPressed: () async {
                          //   if (formKey.currentState!.validate()) {
                          //     provider.authorization();
                          //     http.StreamedResponse response =
                          //     await provider.generateIrn(jsonData);
                          //     if (response.statusCode == 200) {
                          //       var data = jsonDecode(
                          //           await response.stream.bytesToString());
                          //       String fileName = 'eway_irn.json';
                          //       String jsonString =
                          //       const JsonEncoder.withIndent("  ")
                          //           .convert(data);
                          //
                          //       if (kIsWeb) {
                          //         downloadJsonWeb(jsonString, fileName);
                          //       } else {
                          //         downloadForAndroid(
                          //             jsonString, fileName, context);
                          //       }
                          //
                          //       context.pushReplacementNamed(GenerateIrn.routeName);
                          //     }
                          //   }
                          // },
                          onPressed: () {},
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

  Future<void> _importJson() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        // Use `bytes` instead of path to read file content (works on Web too)
        Uint8List? fileBytes = result.files.single.bytes;

        if (fileBytes != null) {
          String jsonString = utf8.decode(fileBytes);
          setState(() {
            jsonData = jsonDecode(jsonString);
            isFileUploaded = true;
          });
        }
      } else {
        showAlertDialog(context, "File selection canceled", "OKAY", false);
      }
    } catch (e) {
      showAlertDialog(
          context, "Unable to access file.\n${e.toString()} ", "OKAY", false);
    }
  }
}
