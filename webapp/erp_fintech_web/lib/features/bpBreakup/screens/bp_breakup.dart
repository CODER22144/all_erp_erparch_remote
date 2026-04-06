import 'dart:convert';

import 'package:fintech_new_web/features/bpBreakup/provider/bp_breakup_provider.dart';
import 'package:fintech_new_web/features/bpBreakup/screens/get_bp_breakup.dart';
import 'package:fintech_new_web/features/materialAssembly/screens/get_material_assembly.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../camera/widgets/camera_widget.dart';
import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';

class BpBreakup extends StatefulWidget {
  static String routeName = '/BpBreakup';
  final bool editing;
  const BpBreakup({super.key, required this.editing});

  @override
  State<BpBreakup> createState() => _BpBreakupState();
}

class _BpBreakupState extends State<BpBreakup> {
  var formKey = GlobalKey<FormState>();
  late BpBreakupProvider provider;

  List<SearchableDropdownMenuItem<String>> materials = [];


  String partnerCode = "";
  String matCode = "";

  @override
  void initState() {
    super.initState();
    provider = Provider.of<BpBreakupProvider>(context, listen: false);
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

  bool isLoading = false;

  void getMaterialsByBpCode(String? bpCode) async {
    setState(() {
      isLoading = true;
    });
    GlobalVariables.requestBody[BpBreakupProvider.featureName]['bpCode'] =
        bpCode;

    var matDrop = await provider.getMaterials(bpCode);

    setState(() {
      materials = matDrop;
      isLoading = false;
    });
    print(materials);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BpBreakupProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: CommonAppbar(
                title: widget.editing ? "Edit BP Breakup" : 'Add BP Breakup')),
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
                    Visibility(
                      visible: provider.widgetList.isNotEmpty,
                      child: Stack(
                        children: [
                          Container(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: SearchableDropdown<String>(
                              controller: widget.editing
                                  ? SearchableDropdownController(
                                      initialItem: SearchableDropdownMenuItem(
                                          label: "",
                                          child: Text(GlobalVariables
                                                      .requestBody[
                                                  BpBreakupProvider.featureName]
                                              ['bpCode'] ?? "")))
                                  : null,
                              isEnabled: true,
                              backgroundDecoration: (child) => Container(
                                height: 40,
                                margin: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Colors.black, width: 0.5),
                                ),
                                child: child,
                              ),
                              items: provider.bpCodes,
                              onChanged: getMaterialsByBpCode,
                              hasTrailingClearIcon: false,
                            ),
                          ),
                          Positioned(
                            left: 10,
                            top: 3,
                            child: Container(
                              color: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: const Wrap(
                                children: [
                                  Text(
                                    "Business Partner",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "*",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isLoading)
                      const CircularProgressIndicator()
                    else
                      Visibility(
                        visible: provider.widgetList.isNotEmpty,
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.white,
                              margin: const EdgeInsets.only(top: 10),
                              child: SearchableDropdown<String>(
                                controller: widget.editing
                                    ? SearchableDropdownController(
                                    initialItem: SearchableDropdownMenuItem(
                                        label: "",
                                        child: Text(GlobalVariables
                                            .requestBody[
                                        BpBreakupProvider.featureName]
                                        ['matno'] ?? "")))
                                    : null,
                                isEnabled: true,
                                backgroundDecoration: (child) => Container(
                                  height: 40,
                                  margin: EdgeInsets.zero,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.black, width: 0.5),
                                  ),
                                  child: child,
                                ),
                                items: materials,
                                onChanged: (value) {
                                  setState(() {
                                    GlobalVariables.requestBody[
                                            BpBreakupProvider.featureName]
                                        ['matno'] = value;
                                  });
                                },
                                hasTrailingClearIcon: false,
                              ),
                            ),
                            Positioned(
                              left: 10,
                              top: 3,
                              child: Container(
                                color: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: const Wrap(
                                  children: [
                                    Text(
                                      "Material no.",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "*",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                http.StreamedResponse result = widget.editing
                                    ? await provider.processUpdateFormInfo()
                                    : await provider.processFormInfo();
                                var message = jsonDecode(
                                    await result.stream.bytesToString());
                                if (result.statusCode == 200) {
                                  if (widget.editing) {
                                    context.pop();
                                    context.pushReplacementNamed(
                                        GetBpBreakup.routeName);
                                  } else {
                                    context.pushReplacementNamed(
                                        BpBreakup.routeName);
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
