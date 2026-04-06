import 'package:fintech_new_web/features/company/provider/add_company_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../camera/widgets/camera_widget.dart';
import '../../common/widgets/comman_appbar.dart';
import '../../utility/global_variables.dart';

class CompanyInfo extends StatefulWidget {
  static String routeName = "CompanyInfo";
  const CompanyInfo({super.key});

  @override
  State<CompanyInfo> createState() => _CompanyInfoState();
}

class _CompanyInfoState extends State<CompanyInfo> {
  @override
  void initState() {
    super.initState();
    CompanyProvider provider =
    Provider.of<CompanyProvider>(context, listen: false);
    provider.initEditWidget();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<CompanyProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Company Info')),
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
