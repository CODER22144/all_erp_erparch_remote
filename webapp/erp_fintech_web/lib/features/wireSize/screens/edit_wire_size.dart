// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:fintech_new_web/features/wireSize/provider/wire_size_provider.dart';
import 'package:fintech_new_web/features/wireSize/screens/wire_size_by_matno.dart';
import 'package:fintech_new_web/features/wireSize/screens/wire_size_row_field.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../camera/widgets/camera_widget.dart';
import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';

class EditWireSize extends StatefulWidget {
  static String routeName = "editWireSize";
  final String editData;

  const EditWireSize({super.key, required this.editData});

  @override
  EditWireSizeState createState() => EditWireSizeState();
}

class EditWireSizeState extends State<EditWireSize>
    with SingleTickerProviderStateMixin {
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WireSizeProvider provider =
    Provider.of<WireSizeProvider>(context, listen: false);
    provider.initMasterEditWidget(widget.editData);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WireSizeProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Wire Size Details')),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 5, bottom: 5),
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
                              suffix: provider.viewDrawing(jsonDecode(widget.editData)['matDrawing'] ?? "-"),
                              prefix: SizedBox(
                                width: 500,
                                child: CameraWidget(
                                    setImagePath: provider.setMaterialDrawing,
                                    showCamera: !kIsWeb),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey)),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey, width: 2),
                              ),
                              label: const Text(
                                "Material Drawing",
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
                              suffix: provider.viewDrawing(jsonDecode(widget.editData)['jointDrawing'] ?? "-"),
                              prefix: SizedBox(
                                width: 500,
                                child: CameraWidget(
                                    setImagePath: provider.setJointDrawing,
                                    showCamera: !kIsWeb),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey)),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey, width: 2),
                              ),
                              label: const Text(
                                "Joint Drawing",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            maxLines: 1,
                          )),
                      Visibility(
                        visible: provider.widgetList.isNotEmpty,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#0B6EFE"),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5)))),
                            onPressed: () async {
                              http.StreamedResponse result =
                              await provider.processMasterUpdateFormInfo();
                              var message = jsonDecode(
                                  await result.stream.bytesToString());
                              if (result.statusCode == 200) {
                                context.pop();
                                context.pushReplacementNamed(WireSizeByMatno.routeName);
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
