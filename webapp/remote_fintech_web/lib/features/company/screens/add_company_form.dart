import 'dart:convert';

import 'package:fintech_new_web/features/company/provider/add_company_provider.dart';
import 'package:fintech_new_web/features/network/service/network_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../camera/widgets/camera_widget.dart';
import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../home.dart';
import '../../utility/global_variables.dart';

class AddCompanyForm extends StatefulWidget {
  static String routeName = "/addCompany";
  final String editing;
  const AddCompanyForm({super.key, required this.editing});

  @override
  State<AddCompanyForm> createState() => _AddCompanyFormState();
}

class _AddCompanyFormState extends State<AddCompanyForm> {
  @override
  void initState() {
    super.initState();
    CompanyProvider provider =
        Provider.of<CompanyProvider>(context, listen: false);
    if(widget.editing == 'true') {
      provider.initEditWidget();
    } else {
    provider.initWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<CompanyProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: CommonAppbar(title: widget.editing == 'true' ? 'Update Company' : 'Add Company')),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: kIsWeb
                  ? GlobalVariables.deviceWidth / 2.0
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
                            suffix: provider.viewDoc(GlobalVariables.requestBody[CompanyProvider.featureName]['compMediaPath'], 'Media Path'),
                            prefix: SizedBox(
                              width: 500,
                              child: CameraWidget(
                                  setImagePath: provider.setMediaPath,
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
                              "Media Path",
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
                            suffix: provider.viewDoc(GlobalVariables.requestBody[CompanyProvider.featureName]['compLogo'], 'Logo'),
                            prefix: SizedBox(
                              width: 500,
                              child: CameraWidget(
                                  setImagePath: provider.setLogo,
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
                              "Logo",
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
                            suffix: provider.viewDoc(GlobalVariables.requestBody[CompanyProvider.featureName]['compBrandLogo'], 'Brand Logo'),
                            prefix: SizedBox(
                              width: 500,
                              child: CameraWidget(
                                  setImagePath: provider.setBrandLogo,
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
                              "Brand Logo",
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
                            suffix: provider.viewDoc(GlobalVariables.requestBody[CompanyProvider.featureName]['compDocLogo'], 'Doc Logo'),
                            prefix: SizedBox(
                              width: 500,
                              child: CameraWidget(
                                  setImagePath: provider.setDocLogo,
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
                              "Doc Logo",
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
                            suffix: provider.viewDoc(GlobalVariables.requestBody[CompanyProvider.featureName]['compMedia'], 'Media'),
                            prefix: SizedBox(
                              width: 500,
                              child: CameraWidget(
                                  setImagePath: provider.setCompMedia,
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
                              "Media",
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
                            suffix: provider.viewDoc(GlobalVariables.requestBody[CompanyProvider.featureName]['signImage'], 'Sign'),
                            prefix: SizedBox(
                              width: 500,
                              child: CameraWidget(
                                  setImagePath: provider.setSignImage,
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
                              "Sign Image",
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
                            NetworkService networkService = NetworkService();
                            if (formKey.currentState!.validate()) {
                              bool confirmation =
                                  await showConfirmationDialogue(
                                      context,
                                      "Do you want to submit the records?",
                                      "SUBMIT",
                                      "CANCEL");
                              if (confirmation) {
                                http.StreamedResponse result = widget.editing == 'true' ?
                                await provider.processUpdateFormInfo() :
                                await provider.processFormInfo();
                                var message = jsonDecode(
                                    await result.stream.bytesToString());
                                if (result.statusCode == 200) {
                                  if(widget.editing == 'true') {
                                    context.pop();
                                  } else {
                                    context.pushReplacementNamed(AddCompanyForm.routeName);
                                  }
                                  provider.getCompanyReport();
                                } else if (result.statusCode == 400) {
                                  networkService.logError({
                                    "errorCode" : message['errorCode'] ?? "",
                                    "errorMsg" : message['message'] ?? "",
                                    "endpoint" : "/create-company/",
                                    "featureName" : CompanyProvider.featureName
                                  });
                                  await showAlertDialog(
                                      context,
                                      message['message'].toString(),
                                      "Continue",
                                      false);
                                } else if (result.statusCode == 500) {
                                  networkService.logError({
                                    "errorCode" : message['errorCode'] ?? "",
                                    "errorMsg" : message['message'] ?? "",
                                    "endpoint" : "/create-company/",
                                    "featureName" : CompanyProvider.featureName
                                  });
                                  await showAlertDialog(context,
                                      message['message'], "Continue", false);
                                } else {
                                  networkService.logError({
                                    "errorCode" : message['errorCode'] ?? "",
                                    "errorMsg" : message['message'] ?? "",
                                    "endpoint" : "/create-company/",
                                    "featureName" : CompanyProvider.featureName
                                  });
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
