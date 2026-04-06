import 'dart:convert';

import 'package:fintech_new_web/features/materialAssembly/screens/get_material_assembly.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

import '../../camera/widgets/camera_widget.dart';
import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../provider/material_assembly_provider.dart';

class MaterialAssembly extends StatefulWidget {
  static String routeName = '/MaterialAssembly';
  final bool editing;
  const MaterialAssembly({super.key, required this.editing});

  @override
  State<MaterialAssembly> createState() => _MaterialAssemblyState();
}

class _MaterialAssemblyState extends State<MaterialAssembly> {
  var formKey = GlobalKey<FormState>();
  late MaterialAssemblyProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<MaterialAssemblyProvider>(context, listen: false);
    if (!widget.editing) {
      provider.initWidget();
    } else {
      provider.reset();
      provider.initEditWidget();
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
    return Consumer<MaterialAssemblyProvider>(
        builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: CommonAppbar(title: widget.editing ? "Update Material Assembly" : 'Add Material Assembly')),
        body: SingleChildScrollView(
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
                            prefix: CameraWidget(
                                setImagePath: provider.setPic,
                                showCamera: !kIsWeb),
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
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
                                setImagePath: provider.setDrawing,
                                showCamera: !kIsWeb),
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                            prefix: CameraWidget(
                                setImagePath: provider.setAsDrawing,
                                showCamera: !kIsWeb),
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                            ),
                            label: const Text(
                              "AS Drawing",
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
                              backgroundColor: Colors.blueAccent,
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
                                http.StreamedResponse result = widget.editing ? await provider.processUpdateFormInfo() : await provider.processFormInfo();
                                var message = jsonDecode(
                                    await result.stream.bytesToString());
                                if (result.statusCode == 200) {
                                  if(widget.editing) {
                                    context.pop();
                                    context.pushReplacementNamed(GetMaterialAssembly.routeName);
                                  } else {
                                    context.pushReplacementNamed(
                                        MaterialAssembly.routeName);
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
                            }
                          },
                          child: const Text('Submit',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ),
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
