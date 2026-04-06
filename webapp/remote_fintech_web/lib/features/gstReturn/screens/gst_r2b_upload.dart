import 'dart:convert';
import 'dart:typed_data';

import 'package:fintech_new_web/features/network/service/network_service.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../utility/global_variables.dart';

class GstR2bUpload extends StatefulWidget {
  static String routeName = "/GstR2bUpload";
  const GstR2bUpload({super.key});

  @override
  State<GstR2bUpload> createState() => _GstR2bUploadState();
}

class _GstR2bUploadState extends State<GstR2bUpload> {
  bool isFileUploaded = false;

  Map<String, dynamic> jsonData = {};

  Future<void> _importExcel() async {
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
      showAlertDialog(context, "Unable to access file.\n${e.toString()} ", "OKAY", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Gst R2B Upload')),
          body: InkWell(
              onTap: _importExcel,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: GlobalVariables.deviceWidth / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        child: const Text(
                          "Click to View file format for Import",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w500),
                        ),
                        onTap: () async {
                          final Uri uri = Uri.parse(
                              "https://docs.google.com/spreadsheets/d/1by6WbUta2EDAPzpmFiTqy_yKADPYgz_aTeSgwzhcKzo/edit?usp=sharing");
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.inAppBrowserView);
                          } else {
                            throw 'Could not launch';
                          }
                        },
                      ),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
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
                                "Do you want to upload the selected file?",
                                "SUBMIT",
                                "CANCEL");
                            if (confirmation) {
                              NetworkService networkService = NetworkService();
                              http.StreamedResponse response =
                              await networkService.post("/upload-gst-r2b/", jsonData);
                              if (response.statusCode == 200) {
                                context.pushReplacementNamed(GstR2bUpload.routeName);
                                showAlertDialog(
                                    context, "File Uploaded Successfully", "OKAY", false);
                              } else {
                                var errorMsg = jsonDecode(await response.stream.bytesToString());
                                await showAlertDialog(
                                    context, errorMsg['message'].toString(), "Continue", false);
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
                      )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
